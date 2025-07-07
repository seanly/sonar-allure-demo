#!/bin/bash

# Script to run all build, test, and analysis steps
# This script can be run both in Docker containers and locally

set -e

echo "Starting complete build and analysis pipeline..."

# Step 1: Run tests
echo "Step 1: Running tests..."
./scripts/run-test.sh

# Step 2: Build package
echo "Step 2: Building package..."
./scripts/run-package.sh

# Step 3: Run Trivy security scan
echo "Step 3: Running Trivy security scan..."
./scripts/run-trivy.sh

# Step 4: Generate Allure report
echo "Step 4: Generating Allure report..."
./scripts/run-allure.sh

# Step 5: Run SonarQube analysis
echo "Step 5: Running SonarQube analysis..."
./scripts/run-sonar.sh

echo "All steps completed successfully!" 