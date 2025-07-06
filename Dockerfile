# Multi-stage build for Java Maven project
# Stage 1: Compile and test with JDK 8
FROM eclipse-temurin:8-jdk AS compiler

# Set working directory
WORKDIR /code

# Create Maven settings directory
RUN mkdir -p /root/.m2

# Copy entire project to /code
COPY ./ /code/

# Mount settings.xml as secret and Maven cache during build (requires BuildKit)
# syntax=docker/dockerfile:1.4
RUN --mount=type=secret,id=maven_settings,target=/root/.m2/settings.xml \
    --mount=type=cache,target=/root/.m2/repository \
    chmod +x /code/mvnw && \
    /code/mvnw clean test

# Stage 2: SonarQube scan with JDK 11
FROM eclipse-temurin:11-jdk AS sonar-scanner

# Set working directory
WORKDIR /code

# Create Maven settings directory
RUN mkdir -p /root/.m2

# Copy compiled classes and test results from compiler stage
COPY --from=compiler /code/target/classes/ /code/target/classes/
COPY --from=compiler /code/target/test-classes/ /code/target/test-classes/
COPY --from=compiler /code/target/surefire-reports/ /code/target/surefire-reports/
COPY --from=compiler /code/target/allure-results/ /code/target/allure-results/

# Copy source code and project files
COPY ./ /code/

# Run SonarQube scan with JDK 11
RUN --mount=type=secret,id=maven_settings,target=/root/.m2/settings.xml \
    --mount=type=cache,target=/root/.m2/repository \
    chmod +x /code/mvnw && \
    /code/mvnw sonar:sonar

# Stage 3: Generate Allure report with JDK 8
FROM eclipse-temurin:8-jdk AS allure-reporter

# Set working directory
WORKDIR /code

# Create Maven settings directory
RUN mkdir -p /root/.m2

# Copy project files and test results
COPY ./ /code/
COPY --from=compiler /code/target/allure-results/ /code/target/allure-results/

# Generate Allure report
RUN --mount=type=secret,id=maven_settings,target=/root/.m2/settings.xml \
    --mount=type=cache,target=/root/.m2/repository \
    chmod +x /code/mvnw && \
    /code/mvnw allure:report

# Stage 4: Runtime stage with Eclipse Temurin JRE 8
FROM eclipse-temurin:8-jre

# Install necessary packages for running the application
RUN apt-get update && \
    apt-get install -y curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy the built classes from compiler stage
COPY --from=compiler /code/target/classes/ /app/classes/
# Copy Allure report from allure-reporter stage
COPY --from=allure-reporter /code/target/site/allure-maven-plugin/ /app/allure-report/

# Create a simple script to run the application
RUN echo '#!/bin/bash\n\
echo "Starting Java Application..."\n\
java -cp /app/classes com.example.App\n\
echo "Application finished."\n\
echo "Allure report is available at /app/allure-report/index.html"' > /app/run.sh && \
chmod +x /app/run.sh

# Expose port (if needed for web applications)
EXPOSE 8080

# Default command to run the application
CMD ["/app/run.sh"] 