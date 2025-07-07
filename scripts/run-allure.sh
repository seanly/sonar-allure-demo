#!/bin/bash

# Script to generate Allure report
# This script can be run both in Docker containers and locally

set -e

echo "Generating Allure report..."

# Ensure mvnw is executable
chmod +x ./mvnw

# Generate Allure report
./mvnw allure:report

echo "Allure report generated successfully." 