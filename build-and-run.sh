#!/bin/bash

# Build and run script for SonarQube Allure Demo
# Uses JDK 8 for compilation and JDK 11 for SonarQube scanning

set -e  # Exit on any error

echo "🔧 Using Maven wrapper for consistent builds..."
echo "🔒 Using Docker BuildKit secrets for secure settings.xml..."
echo "☕ Using JDK 8 for compilation and JDK 11 for SonarQube scanning..."

# Check if settings.xml exists in ~/.m2
SETTINGS_PATH="$HOME/.m2/settings.xml"
if [ ! -f "$SETTINGS_PATH" ]; then
    echo "❌ Error: $SETTINGS_PATH not found!"
    echo "Please ensure settings.xml exists in your Maven directory."
    exit 1
fi

echo "✅ Found settings.xml at $SETTINGS_PATH"
echo "🐳 Building Docker image with multi-stage approach..."

# Enable Docker BuildKit and build with secrets and cache
DOCKER_BUILDKIT=1 docker build \
    --secret id=maven_settings,src="$SETTINGS_PATH" \
    --build-arg BUILDKIT_INLINE_CACHE=1 \
    -t sonar-allure-demo:multi-jdk .

if [ $? -eq 0 ]; then
    echo "✅ Docker image built successfully!"
    echo "📊 SonarQube analysis completed with JDK 11"
    echo "📈 Allure reports generated with JDK 8"
    
    echo "🚀 Running container..."
    docker run --rm -p 8080:8080 \
        -v $(pwd)/allure-reports:/app/allure-report \
        --name sonar-allure-demo-container \
        sonar-allure-demo:multi-jdk
    
    echo "📊 Allure reports are available in ./allure-reports/"
    echo "🌐 You can view the report by opening ./allure-reports/index.html in your browser"
else
    echo "❌ Docker build failed!"
    exit 1
fi 