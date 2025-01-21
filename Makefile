# Variables
IMAGE_NAME = latex-docker
TAG = latest

# Default target
.PHONY: build
build:
	docker build -t $(IMAGE_NAME):$(TAG) .

# Clean dangling images
.PHONY: clean
clean:
	docker rmi $$(docker images -f "dangling=true" -q)

# Show help
.PHONY: help
help:
	@echo "Available targets:"
	@echo "  build  - Build Docker image (default)"
	@echo "  clean  - Remove dangling Docker images"
	@echo "  help   - Show this help message"
	@echo ""
	@echo "Variables:"
	@echo "  IMAGE_NAME = $(IMAGE_NAME)"
	@echo "  TAG       = $(TAG)"
