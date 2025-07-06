# SonarQube + Allure Demo Project

This is a demonstration project that showcases the integration of SonarQube for code quality analysis and Allure for test reporting in a Java Maven project.

## Project Overview

This project demonstrates:
- **SonarQube Integration**: Code quality analysis and reporting
- **Allure Test Reporting**: Beautiful test reports with detailed test execution information
- **JUnit 5**: Modern Java testing framework
- **Maven**: Build automation and dependency management

## Prerequisites

- Java 17 or higher
- Maven 3.6 or higher
- SonarQube server running (default: http://localhost)
- Allure command line tool (optional, for local report generation)

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
# Run tests and generate Allure results
mvn test
```

### Generating Allure Reports

```bash
# Generate Allure HTML report
mvn allure:report
```

The report will be available at: `target/site/allure-maven-plugin/index.html`

### Running SonarQube Analysis

```bash
# Run SonarQube analysis with authentication token
mvn sonar:sonar -Dsonar.host.url=http://localhost -Dsonar.login=YOUR_TOKEN
```

Replace `YOUR_TOKEN` with your actual SonarQube authentication token.

### Complete Workflow

```bash
# 1. Clean and compile
mvn clean compile

# 2. Run tests
mvn test

# 3. Generate Allure report
mvn allure:report

# 4. Run SonarQube analysis
mvn sonar:sonar -Dsonar.host.url=http://localhost -Dsonar.login=YOUR_TOKEN
```

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