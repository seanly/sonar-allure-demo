# Scripts Usage Guide

## Entry Scripts

### Basic Entry Script (`entry.sh`)
Simple entry point to execute individual commands locally.

```bash
# Usage
./scripts/entry.sh [COMMAND]

# Examples
./scripts/entry.sh test
./scripts/entry.sh package
./scripts/entry.sh allure
./scripts/entry.sh sonar
./scripts/entry.sh trivy
./scripts/entry.sh all
./scripts/entry.sh help
```

### Enhanced Entry Script (`entry-docker.sh`)
Advanced entry point that supports both local and Docker execution.

```bash
# Usage
./scripts/entry-docker.sh [COMMAND] [MODE]

# Local execution (default)
./scripts/entry-docker.sh test
./scripts/entry-docker.sh package --local

# Docker execution
./scripts/entry-docker.sh test --docker
./scripts/entry-docker.sh all --docker
```

## Available Commands

| Command | Description | Script |
|---------|-------------|--------|
| `test` | Run Maven tests | `run-test.sh` |
| `package` | Build Maven package | `run-package.sh` |
| `allure` | Generate Allure report | `run-allure.sh` |
| `sonar` | Run SonarQube analysis | `run-sonar-simple.sh` |
| `trivy` | Run Trivy security scan | `run-trivy.sh` |
| `all` | Run all steps in sequence | `run-all.sh` |

## Individual Scripts

All scripts can be run directly:

```bash
# Direct execution
./scripts/run-test.sh
./scripts/run-package.sh
./scripts/run-allure.sh
./scripts/run-sonar-simple.sh
./scripts/run-trivy.sh
./scripts/run-all.sh
```

## Docker Scripts

For Docker-based operations:

```bash
# Build and run with tools image
./scripts/build-with-tools.sh

# Build jar and runtime image
./scripts/build-jar-and-runtime.sh

# Run individual steps with Docker
./scripts/run-step.sh test
./scripts/run-step.sh package
./scripts/run-step.sh all
```

## Testing

Test if scripts are properly set up:

```bash
./scripts/test-local.sh
```

## Requirements

- Maven wrapper (`mvnw`) in project root
- `settings.xml` in `~/.m2/` (for Docker operations)
- Docker (for Docker-based operations) 