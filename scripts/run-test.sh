#!/bin/bash

# Script to run Maven tests
# This script can be run both in Docker containers and locally

set -e

echo "Running Maven tests..."
which java

java -version

# Ensure mvnw is executable
chmod +x ./mvnw

# Run tests with Maven
./mvnw clean test

echo "Tests completed successfully." 