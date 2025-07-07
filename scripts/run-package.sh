#!/bin/bash

# Script to run Maven package
# This script can be run both in Docker containers and locally

set -e

echo "Running Maven package..."

# Ensure mvnw is executable
chmod +x ./mvnw

# Run package with Maven
./mvnw clean package

echo "Package completed successfully." 