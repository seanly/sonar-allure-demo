#!/bin/bash

# Script to run Trivy security scan
# This script can be run both in Docker containers and locally

set -e

# Default severity levels for Trivy scan
TRIVY_SEVERITY=${TRIVY_SEVERITY:-"CRITICAL,HIGH"}

echo "Running Trivy security scan with severity levels: $TRIVY_SEVERITY"

# Create directory for Trivy output if it doesn't exist
mkdir -p target

# Generate SBOM (Software Bill of Materials) if not exists
if [ ! -f "target/bom.json" ]; then
    echo "Generating SBOM (bom.json)..."
    if [ -f "./mvnw" ]; then
        ./mvnw org.cyclonedx:cyclonedx-maven-plugin:makeAggregateBom -Dcyclonedx.outputFormat=json -Dcyclonedx.outputName=bom
        echo "SBOM generated successfully."
    else
        echo "Warning: Maven wrapper (mvnw) not found, cannot generate SBOM"
    fi
fi

# Download the SonarQube template if not already present
if [ ! -f "/tmp/sonarqube.tpl" ]; then
    echo "Downloading SonarQube template..."
    wget -O /tmp/sonarqube.tpl https://proxy.opsbox.dev/https://raw.githubusercontent.com/mendhak/trivy-template-output-to-sonarqube/refs/heads/master/sonarqube.tpl
fi

# Run Trivy security scan with configurable severity levels and SonarQube template
if [ -f "target/bom.json" ]; then
    echo "Running Trivy scan on SBOM..."
    trivy sbom --skip-db-update --skip-java-db-update --offline-scan target/bom.json -s "$TRIVY_SEVERITY" --format template --template @/tmp/sonarqube.tpl -o target/trivy-report.json
    echo "Trivy scan completed successfully."
else
    echo "Warning: target/bom.json not found, creating empty report"
    echo '{"issues": []}' > target/trivy-report.json
fi

echo "Trivy security scan completed." 