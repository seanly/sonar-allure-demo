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

trivy fs --scanners vuln --skip-db-update --skip-java-db-update . -s "$TRIVY_SEVERITY" --format sarif -o target/trivy-report.sarif
echo "Trivy scan completed successfully."

echo "Trivy security scan completed." 