#!/bin/bash

# Enhanced entry script to execute run-xxx.sh scripts
# Supports both local execution and Docker container execution
# Usage: ./scripts/entry.sh [COMMAND] [--docker|--local]

set -e

# Get the command from first argument
COMMAND=${1:-help}
MODE=${2:---local}

# Function to show usage
show_usage() {
    echo "Usage: $0 [COMMAND] [MODE]"
    echo ""
    echo "Available commands:"
    echo "  test     - Run Maven tests"
    echo "  package  - Build Maven package"
    echo "  allure   - Generate Allure report"
    echo "  sonar    - Run SonarQube analysis"
    echo "  trivy    - Run Trivy security scan"
    echo "  all      - Run all steps in sequence"
    echo "  help     - Show this help message"
    echo ""
    echo "Available modes:"
    echo "  --local  - Run locally (default)"
    echo "  --docker - Run in Docker container"
    echo ""
    echo "Examples:"
    echo "  $0 test"
    echo "  $0 package --docker"
    echo "  $0 all --local"
}

# Function to execute script locally
execute_local() {
    local script_name="run-$1.sh"
    local script_path="./scripts/$script_name"
    
    if [ ! -f "$script_path" ]; then
        echo "❌ Error: Script $script_path not found!"
        echo "Available scripts:"
        ls -1 ./scripts/run-*.sh 2>/dev/null | sed 's|./scripts/run-||' | sed 's|.sh||' || echo "No run-*.sh scripts found"
        exit 1
    fi
    
    echo "🚀 Executing $script_name locally..."
    chmod +x "$script_path"
    "$script_path"
}

# Function to execute script in Docker
execute_docker() {
    local script_name="run-$1.sh"
    
    # Check if settings.xml exists in ~/.m2
    SETTINGS_PATH="$HOME/.m2/settings.xml"
    if [ ! -f "$SETTINGS_PATH" ]; then
        echo "❌ Error: $SETTINGS_PATH not found!"
        echo "Please ensure settings.xml exists in your Maven directory."
        exit 1
    fi
    
    echo "✅ Found settings.xml at $SETTINGS_PATH"
    echo "🔧 Building tools image..."
    
    # Build the tools image
    docker build --target tools -t sonar-allure-demo:tools .
    
    echo "🚀 Executing $script_name in Docker container..."
    
    # Run script in Docker container
    docker run --rm \
        -v "$(pwd):/code" \
        -v "$SETTINGS_PATH:/root/.m2/settings.xml" \
        -v "$HOME/.m2/repository:/root/.m2/repository" \
        -w /code \
        sonar-allure-demo:tools \
        bash -c "
            chmod +x scripts/*.sh && \
            ./scripts/$script_name
        "
}

# Main logic
case $COMMAND in
    "test")
        if [ "$MODE" = "--docker" ]; then
            execute_docker "test"
        else
            execute_local "test"
        fi
        ;;
    "package")
        if [ "$MODE" = "--docker" ]; then
            execute_docker "package"
        else
            execute_local "package"
        fi
        ;;
    "allure")
        if [ "$MODE" = "--docker" ]; then
            execute_docker "allure"
        else
            execute_local "allure"
        fi
        ;;
    "sonar")
        if [ "$MODE" = "--docker" ]; then
            execute_docker "sonar"
        else
            execute_local "sonar"
        fi
        ;;
    "trivy")
        if [ "$MODE" = "--docker" ]; then
            execute_docker "trivy"
        else
            execute_local "trivy"
        fi
        ;;
    "all")
        if [ "$MODE" = "--docker" ]; then
            execute_docker "all"
        else
            execute_local "all"
        fi
        ;;
    "help"|"-h"|"--help")
        show_usage
        ;;
    *)
        echo "❌ Unknown command: $COMMAND"
        echo ""
        show_usage
        exit 1
        ;;
esac

echo "✅ Command '$COMMAND' completed successfully!" 