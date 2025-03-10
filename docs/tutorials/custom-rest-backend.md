# Custom Rest Backend
This tutorial guides you through the process of integrating a custom backend with k8sgpt using RESTful API. This setup is particularly useful when you want to integrate Retrieval-Augmented Generation (RAG) or an AI Agent with k8sgpt.
In this tutorial, we will store a CNCF Q&A dataset for knowledge retrieval and  create a simple Retrieval-Augmented Generation (RAG) application and integrate it with k8sgpt. 

## API Specification
To ensure k8sgpt can interact with your custom backend, implement the following API endpoint using the OpenAPI schema:

### OpenAPI Specification
```yaml
openapi: 3.0.0
info:
  title: Custom REST Backend API
  version: 1.0.0
paths:
  /v1/completions:
    post:
      summary: Generate a text-based response from the custom backend
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: object
              properties:
                model:
                  type: string
                  description: The name of the model to use.
                prompt:
                  type: string
                  description: The textual prompt to send to the model.
                options:
                  type: object
                  additionalProperties:
                    type: string
                  description: Model-specific options, such as temperature.
              required:
                - model
                - prompt
      responses:
        "200":
          description: Successful response
          content:
            application/json:
              schema:
                type: object
                properties:
                  model:
                    type: string
                    description: The model name that generated the response.
                  created_at:
                    type: string
                    format: date-time
                    description: The timestamp of the response.
                  response:
                    type: string
                    description: The textual response itself.
                required:
                  - model
                  - created_at
                  - response
        "400":
          description: Bad Request
        "500":
          description: Internal Server Error
```
### Example Interaction

#### Request
```json
{
  "model": "gpt-4",
  "prompt": "Explain the process of photosynthesis.",
  "options": {
    "temperature": 0.7,
    "max_tokens": 150
  }
}
```

#### Response
```json
{
  "model": "gpt-4",
  "created_at": "2025-01-14T10:00:00Z",
  "response": "Photosynthesis is the process by which green plants and some other organisms use sunlight to synthesize foods with the help of chlorophyll."
}
```

### Implementation Notes

- **Endpoint Configuration**: Ensure the /v1/completions endpoint is reachable and adheres to the provided schema.

- **Error Handling**: Implement robust error handling to manage invalid requests or processing failures.

By following this specification, your custom REST service will seamlessly integrate with k8sgpt, enabling powerful and customizable AI-driven functionalities.
## Prerequisites

- [K8sGPT CLI](https://github.com/k8sgpt-ai/k8sgpt.git)
- [Golang](https://golang.org/doc/install) go1.22 or higher
- [langchaingo](https://github.com/tmc/langchaingo) library for building RAG applications
- [gin](https://github.com/gin-gonic/gin) for handling RESTful APIs in Go
- [Qdrant](https://github.com/qdrant/qdrant) vector database for storing and searching through knowledge bases
- [Ollama](https://github.com/ollama/ollama) service to run large language models

## Writing a simple RAG backend
### Setup
Let's create a new simple golang project.
```bash
mkdir -p custom-backend
cd custom-backend
go mod init github.com/<username>/custom-backend
```
Install necessary dependencies for the RAG application and RESTful API:

```bash
go get -u github.com/tmc/langchaingo
go get -u github.com/gin-gonic/gin
```
Once we have this structure let's create a simple main.go file with the following content:
```golang
// main.go
package main

import (
	"context"
	"fmt"
	"net/http"
	"net/url"
	"strings"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/tmc/langchaingo/embeddings"
	"github.com/tmc/langchaingo/llms"
	"github.com/tmc/langchaingo/llms/ollama"
	"github.com/tmc/langchaingo/vectorstores"
	"github.com/tmc/langchaingo/vectorstores/qdrant"
)

var (
	ollama_url = "http://localhost:11434"
	listenAddr = ":8090"
)

func main() {
	server := gin.Default()
	server.POST("/completion", func(c *gin.Context) {
		var req CustomRestRequest
		if err := c.ShouldBindJSON(&req); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}
		content, err := rag(ollama_url, req)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}
		resp := CustomRestResponse{
			Model:     req.Model,
			CreatedAt: time.Now(),
			Response:  content,
		}
		c.JSON(http.StatusOK, resp)
	})
	// start backend server
	err := server.Run(listenAddr)
	if err != nil {
		fmt.Println("Error: %w", err)
	}
}
```
This basic implementation sets up a RESTful API endpoint `/completion` that receives a `CustomRestRequest` from k8sgpt and return `CustomRestResponse`. The `rag` function handles the RAG logic. The structure of request and response is as follows:

```golang
type CustomRestRequest struct {
	Model string `json:"model"`

	// Prompt is the textual prompt to send to the model.
	Prompt string `json:"prompt"`

	// Options lists model-specific options. For example, temperature can be
	// set through this field, if the model supports it.
	Options map[string]interface{} `json:"options"`
}

type CustomRestResponse struct {
	// Model is the model name that generated the response.
	Model string `json:"model"`

	// CreatedAt is the timestamp of the response.
	CreatedAt time.Time `json:"created_at"`

	// Response is the textual response itself.
	Response string `json:"response"`
}
```

### Implementing a simple RAG
Now, we will build the RAG pipeline using `langchaingo`. The RAG application will query a knowledge base stored in `Qdrant` and use a large language model from `ollama` to generate responses.
First, ensure that you have `ollama` and `Qdrant` running locally.
```bash
# run Ollama
ollama run llama3.1

# run Qdrant
docker run -p 6333:6333 -p 6334:6334 \
    -v $(pwd)/qdrant_storage:/qdrant/storage:z \
    qdrant/qdrant

```
We can download the `CNCF Q&A dataset` from [huggingface](https://huggingface.co/datasets/Kubermatic/cncf-question-and-answer-dataset-for-llm-training), and then load it into `Qdrant` using Python scribt below. 
```python
from langchain.embeddings import OllamaEmbeddings
from langchain_community.document_loaders import CSVLoader
from langchain_qdrant import QdrantVectorStore

embeddings = OllamaEmbeddings(base_url="http://localhost:11434", model="llama3.1")
loader = CSVLoader(file_path='./cncf_qa.csv', csv_args={
    'delimiter': ',',
    'quotechar': '"',
    'fieldnames': ['Question', 'Answer', 'Project', 'Filename', 'Subcategory', 'Category']
})
data = loader.load()
qdrant = QdrantVectorStore.from_documents(
    data,
    embeddings,
    url="localhost:6333",
    prefer_grpc=False,
    collection_name="my_documents",
)

data = loader.load()
```
Next, implement the RAG pipeline logic.
```golang
func rag(serverURL string, req CustomRestRequest) (string, error) {
	model := req.Model
	llm, err := ollama.New(ollama.WithServerURL(serverURL), ollama.WithModel(model))
	if err != nil {
		return "", err
	}

	embedder, err := embeddings.NewEmbedder(llm)
	if err != nil {
		return "", err
	}

	url, err := url.Parse("http://localhost:6333")
	if err != nil {
		return "", err
	}

	// new a client of vector store
	store, err := qdrant.New(
		qdrant.WithURL(*url),
		qdrant.WithCollectionName("my_documents"),
		qdrant.WithEmbedder(embedder),
		qdrant.WithContentKey("page_content"),
	)
	if err != nil {
		return "Wi", err
	}

	optionsVector := []vectorstores.Option{
		vectorstores.WithScoreThreshold(0.6),
	}

	retriever := vectorstores.ToRetriever(store, 10, optionsVector...)
	errMessage := req.Options["message"].(string)
	// search local knowledge
	resDocs, err := retriever.GetRelevantDocuments(context.Background(), errMessage)
	if err != nil {
		return "", err
	}

	// get content
	x := make([]string, len(resDocs))
	for i, doc := range resDocs {
		x[i] = doc.PageContent
	}

	// generate content by LLM
	ragPromptTemplate := `Base on context: %s;
	Please generate a response to the following query and response doesn't include context, if context is empty, generate a response using the model's knowledge and capabilities: \n %s`
	prompt := fmt.Sprintf(ragPromptTemplate, strings.Join(x, "; "), req.Prompt)
	ctx := context.Background()
	completion, err := llms.GenerateFromSinglePrompt(ctx, llm, prompt)
	if err != nil {
		return "", err
	}
	fmt.Println("Error: "+errMessage, "Answer: "+completion)
	return completion, err
}
```

### Testing it out
To test this with K8sGPT we need to add a `customrest` AI backend configuration to point to this RAG service. We can do this by running the following command:
```bash
./k8sgpt auth add --backend customrest --baseurl http://localhost:8090/completion --model llama3.1
```
This will add the custom RAG service to the list of available backend in the K8sGPT CLI.
To explain the analysis results using the custom RAG pipeline we can run the following command:
```bash
./k8sgpt analyze --backend customrest --explain 
```

## What's next?
Now you've got the basics of how to write a custom AI backend, you can extend this to use private dataset for knowledge retrieval. You can also build more complex AI pipelines to explain the result obtained from `Analyzers` and provide more detailed recommendations.