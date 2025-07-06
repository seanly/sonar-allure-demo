#!/bin/bash

# SonarQube analysis script using Docker
# Uses JDK 11 for SonarQube scanning

set -e  # Exit on any error

echo "🔍 SonarQube Analysis via Docker"
echo "☕ Using JDK 11 for SonarQube scanning..."

# Check if settings.xml exists in ~/.m2
SETTINGS_PATH="$HOME/.m2/settings.xml"
if [ ! -f "$SETTINGS_PATH" ]; then
    echo "❌ Error: $SETTINGS_PATH not found!"
    echo "Please ensure settings.xml exists in your Maven directory."
    exit 1
fi

echo "✅ Found settings.xml at $SETTINGS_PATH"
echo "🐳 Running Allure report generation and SonarQube analysis in Docker container..."

# Generate Allure report first, then run SonarQube analysis in Docker container
docker run --rm \
    -v "$(pwd):/workspace" \
    -v "$SETTINGS_PATH:/root/.m2/settings.xml" \
    -w /workspace \
    docker.opsbox.dev/eclipse-temurin:11-jdk \
    bash -c "apt-get update && apt-get install -y openjdk-8-jdk && chmod +x ./mvnw && ./mvnw allure:report && ./mvnw sonar:sonar -Dsonar.java.jdkHome=/usr/lib/openjdk-8"

if [ $? -eq 0 ]; then
    echo "✅ SonarQube analysis completed successfully!"
    echo "📊 Check your SonarQube server for the analysis results"
else
    echo "❌ SonarQube analysis failed!"
    exit 1
fi 