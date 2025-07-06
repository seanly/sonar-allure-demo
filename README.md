# SonarQube + Allure Demo Project

This is a demonstration project that showcases the integration of SonarQube for code quality analysis and Allure for test reporting in a Java Maven project.

## Project Overview

This project demonstrates:
- **SonarQube Integration**: Code quality analysis and reporting
- **Allure Test Reporting**: Beautiful test reports with detailed test execution information
- **JUnit 5**: Modern Java testing framework
- **Maven**: Build automation and dependency management

## Prerequisites

- Java 8 or higher (configured for JDK 8, uses Eclipse Temurin)
- Maven 3.9.6 (included via Maven wrapper)
- SonarQube server running (default: http://localhost)
- Allure command line tool (optional, for local report generation)
- Docker (optional, for containerized builds)

## Project Structure

```
sonar-allure-demo/
├── src/
│   ├── main/java/com/example/
│   │   └── App.java
│   └── test/java/com/example/
│       └── AppTest.java
├── pom.xml
├── README.md
└── target/
    ├── allure-results/          # Allure test results
    ├── surefire-reports/        # Maven test reports
    └── site/allure-maven-plugin/ # Generated Allure reports
```

## Configuration

### SonarQube Configuration

The project is configured to use SonarQube with the following settings:
- **SonarQube URL**: http://localhost
- **Authentication**: Uses token-based authentication
- **Project Key**: com.example:sonar-allure-demo

### Allure Configuration

Allure is configured with:
- **Version**: 2.15.0
- **Results Directory**: target/allure-results
- **Report Directory**: target/site/allure-maven-plugin

## Usage

### Running Tests

```bash
# Run tests and generate Allure results (using Maven wrapper)
./mvnw test

# Or using system Maven
mvn test
```

### Generating Allure Reports

```bash
# Generate Allure HTML report (using Maven wrapper)
./mvnw allure:report

# Or using system Maven
mvn allure:report
```

The report will be available at: `target/site/allure-maven-plugin/index.html`

### Running SonarQube Analysis

```bash
# Run SonarQube analysis with authentication token
mvn sonar:sonar -Dsonar.host.url=http://localhost -Dsonar.login=YOUR_TOKEN

# Or using Docker (recommended) - includes Allure report generation
make sonar

# Or using the dedicated script - includes Allure report generation
./run-sonar.sh
```

**Note**: SonarQube analysis requires Allure reports to be generated first. The Docker-based commands automatically handle this dependency.

Replace `YOUR_TOKEN` with your actual SonarQube authentication token.

### Complete Workflow

```bash
# 1. Clean and compile (using Maven wrapper)
./mvnw clean compile

# 2. Run tests
./mvnw test

# 3. Generate Allure report
./mvnw allure:report

# 4. Run SonarQube analysis
./mvnw sonar:sonar -Dsonar.host.url=http://localhost -Dsonar.login=YOUR_TOKEN

# Alternative: Using system Maven
mvn clean compile test allure:report sonar:sonar -Dsonar.host.url=http://localhost -Dsonar.login=YOUR_TOKEN
```

## Makefile Support

The project includes a Makefile for easy management of common tasks:

```bash
# Show available commands
make help

# Build the Docker image
make build

# Run the application container
make run

# Run SonarQube analysis via Docker
make sonar

# Clean up Docker resources
make clean

# Build and run everything
make all
```

## Docker Support

### Building with Docker

The project includes Docker support with Eclipse Temurin JDK 8:

```bash
# Build and run using the provided script
./build-and-run.sh

# Or manually build and run
docker build -t sonar-allure-demo:eclipse-jdk8 .
docker run --rm -p 8080:8080 \
    -v $(pwd)/allure-reports:/app/allure-report \
    sonar-allure-demo:eclipse-jdk8

# Using Docker Compose
docker-compose up --build

# Build with Docker BuildKit secrets
./build-and-run.sh

# Or using Docker Compose with BuildKit secrets
docker-compose up --build
```

### Docker Features

- **Multi-stage build**: Optimized image size
- **Eclipse Temurin JDK 8**: Reliable and well-maintained JDK distribution
- **Maven Wrapper**: No Maven installation required, uses project's Maven wrapper
- **Allure Reports**: Mounted volume for easy access to test reports
- **Alpine Linux**: Lightweight runtime image
- **Faster builds**: No Maven download/installation during build
- **Docker Secrets**: Secure handling of Maven settings.xml in production
- **Maven Cache**: Persistent Maven repository cache for faster builds
- **SonarQube Docker**: Isolated SonarQube analysis in Docker container

### SonarQube Docker Analysis

The project provides a dedicated Docker-based SonarQube analysis that includes Allure report generation:

```bash
# Run Allure report generation and SonarQube analysis in Docker container
make sonar

# Or using the dedicated script
./run-sonar.sh
```

**Benefits of SonarQube Docker:**
- **Isolation**: SonarQube analysis runs in isolated container
- **Consistency**: Same environment across different machines
- **No Local Setup**: No need to install SonarQube scanner locally
- **JDK 11**: Uses JDK 11 specifically for SonarQube analysis
- **Settings Integration**: Automatically uses your Maven settings.xml
- **Allure Integration**: Automatically generates Allure reports before SonarQube analysis

### Security with Docker Secrets

For production deployments, the project supports Docker secrets for secure handling of sensitive configuration:

```bash
# Development (settings.xml copied into image)
docker build -t sonar-allure-demo:eclipse-jdk8 .

# Production (settings.xml as Docker secret)
docker build -f Dockerfile.prod -t sonar-allure-demo:prod .
docker run --secret maven_settings=settings.xml sonar-allure-demo:prod
```

**Benefits of Docker Secrets:**
- **Security**: Sensitive data not embedded in Docker images
- **Flexibility**: Different settings for different environments
- **Compliance**: Meets security requirements for production deployments
- **Audit Trail**: Secret access can be logged and monitored

**Benefits of Maven Cache:**
- **Faster Builds**: Dependencies cached between builds
- **Reduced Network**: Less dependency downloads
- **Consistent**: Same dependencies across builds
- **Efficient**: Leverages Docker BuildKit cache layers

## Dependencies

### Core Dependencies
- **JUnit Jupiter**: 5.10.2 - Modern Java testing framework
- **Allure JUnit5**: 2.15.0 - Allure integration for JUnit 5

### Maven Plugins
- **Maven Surefire Plugin**: 3.1.2 - Test execution
- **Allure Maven Plugin**: 2.11.2 - Allure report generation
- **SonarQube Maven Plugin**: 3.10.0.2594 - SonarQube integration

## Features

### Code Quality Analysis
- SonarQube integration for comprehensive code quality analysis
- Code coverage reporting
- Code duplication detection
- Security vulnerability scanning
- Code smell detection

### Test Reporting
- Allure integration for beautiful test reports
- Detailed test execution information
- Test step logging
- Screenshot and attachment support
- Historical test trend analysis

## Troubleshooting

### Common Issues

1. **SonarQube Connection Issues**
   - Ensure SonarQube server is running
   - Verify the correct URL and port
   - Check authentication token validity

2. **Allure Report Generation Issues**
   - Ensure tests have been run first (`mvn test`)
   - Check that Allure results directory exists
   - Verify Allure version compatibility

3. **Maven Build Issues**
   - Ensure Java 17+ is installed and configured
   - Check Maven version compatibility
   - Verify all dependencies are available

### Logs and Debugging

For detailed debugging information, run Maven with debug flags:
```bash
mvn clean test -X
mvn sonar:sonar -X -Dsonar.host.url=http://localhost -Dsonar.login=YOUR_TOKEN
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Run the complete workflow
6. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For issues and questions:
- Check the troubleshooting section above
- Review SonarQube and Allure documentation
- Create an issue in the project repository 