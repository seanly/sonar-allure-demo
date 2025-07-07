# Makefile for SonarQube Allure Demo

.PHONY: help build run sonar clean tools

# Default target
help:
	@echo "Available targets:"
	@echo "  build    - Build the Docker image"
	@echo "  run      - Run the application container"
	@echo "  sonar    - Run SonarQube analysis via Docker"
	@echo "  tools    - Build tools image with JDK 8, JDK 11, and Trivy"
	@echo "  clean    - Clean up Docker containers and images"
	@echo "  all      - Build and run everything"

# Build the Docker image
build:
	@echo "🔧 Building Docker image..."
	@./scripts/build-and-run.sh

# Build tools image
tools:
	@echo "🛠️  Building tools image..."
	@docker build --target tools -t sonar-allure-demo:tools .

# Run the application container
run:
	@echo "🚀 Running application container..."
	@docker run --rm \
		-p 8080:8080 \
		-v "$(PWD)/allure-reports:/app/allure-report" \
		--name sonar-allure-demo-container \
		sonar-allure-demo:multi-jdk

# Run SonarQube analysis via Docker (includes Allure report generation)
sonar:
	@echo "🔍 Running Allure report generation and SonarQube analysis via Docker..."
	@./scripts/run-sonar.sh

# Clean up Docker resources
clean:
	@echo "🧹 Cleaning up Docker resources..."
	@docker stop sonar-allure-demo-container 2>/dev/null || true
	@docker rm sonar-allure-demo-container 2>/dev/null || true
	@docker rmi sonar-allure-demo:multi-jdk 2>/dev/null || true
	@docker rmi sonar-allure-demo:tools 2>/dev/null || true
	@echo "✅ Cleanup completed"

# Build and run everything
all: build run 