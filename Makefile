MKDOCS_IMAGE := ghcr.io/k8sgpt-ai/k8sgptdocs:dev
MKDOCS_PORT := 8000

.PHONY: mkdocs-serve
mkdocs-serve:
	docker build -t $(MKDOCS_IMAGE) -f docs/build/Dockerfile docs/build
	docker run --name mkdocs-serve --rm -v $(PWD):/docs -p $(MKDOCS_PORT):8000 $(MKDOCS_IMAGE)

.PHONY: typos
typos:
	which codespell || pip install codespell
	codespell -S _examples,.tfsec,.terraform,.git,go.sum --ignore-words .codespellignore -f

.PHONY: fix-typos
fix-typos:
	which codespell || pip install codespell
	codespell -S .terraform,go.sum --ignore-words .codespellignore -f -w -i1