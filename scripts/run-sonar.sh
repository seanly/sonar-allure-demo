#!/bin/bash

# SonarQube analysis script - Direct Maven execution
# Runs SonarQube analysis directly using local Maven

set -e  # Exit on any error

echo "🔍 SonarQube Analysis - Direct Maven Execution"
echo "🛠️  Running SonarQube analysis directly with Maven..."

# Check if mvnw exists
if [ ! -f "./mvnw" ]; then
    echo "❌ Error: mvnw not found in current directory!"
    echo "Please ensure you're running this script from the project root."
    exit 1
fi

echo "✅ Found mvnw in current directory"
echo "📊 Running Allure report generation and SonarQube analysis..."

# Set JAVA_HOME to JDK 11 for Maven execution
export JAVA_HOME=/usr/lib/openjdk-11
export PATH=$JAVA_HOME/bin:$PATH

echo "🔧 Using Java 11: $JAVA_HOME"

# Make mvnw executable
chmod +x ./mvnw

# Generate Allure report first, then run SonarQube analysis
./mvnw allure:report && \
./mvnw sonar:sonar \
    -Dsonar.java.jdkHome=/usr/lib/openjdk \
    -Dsonar.externalIssuesReportPaths=target/trivy-report.json

if [ $? -eq 0 ]; then
    echo "✅ SonarQube analysis completed successfully!"
    echo "📊 Check your SonarQube server for the analysis results"
else
    echo "❌ SonarQube analysis failed!"
    exit 1
fi