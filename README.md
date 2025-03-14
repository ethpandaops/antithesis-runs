# Antithesis Ethereum Package Github Runs

This repository contains GitHub Actions workflows for running Antithesis tests against the Ethereum Package using Kurtosis.

## Overview

The main workflow allows running Antithesis tests against different versions of the Ethereum Package with configurable parameters. It handles:

- Building and pushing config images that include the Ethereum Package and all dependant kurtosis packages
- Extracting required container images to be provided to the Antithesis runtime
- Running Antithesis tests with specified parameters
- Sending email notifications with results

## Usage

### Running Tests

1. Go to the "Actions" tab in GitHub
2. Select the "Antithesis exploration" workflow
3. Click "Run workflow"
4. Configure the following parameters:

- **Test name** - Name for the test run (default: "Kurtosis Ethereum Package")
- **Ethereum package repo** - Repository URL (default: ethpandaops/ethereum-package)
- **Ethereum package version** - Branch, tag or commit hash (default: main)
- **Ethereum package config file** - URL to config YAML (default: mix.yaml from main branch)
- **Duration** - Test duration in hours (default: 1.0)
- **Email** - Recipients for test results (separate multiple with semicolons)

### Cleanup

A scheduled cleanup workflow runs daily to remove old config images:

- Keeps minimum 10 latest versions
- Removes images older than 7 days
- Can be triggered manually if needed

## Development

### Prerequisites

- Docker
- Make
- Kurtosis CLI

### Local Testing

The following command will build the config image. The config imager included the ethereum package and all dependant packages. The antithesis runtime doesn't have internet access, so we need to build the config image locally with all required kurtosis packages, including the dependencies.

```bash
# Build the config image using a custom config file for the ethereum-package
export CONFIG_FILE=https://raw.githubusercontent.com/ethpandaops/ethereum-package/refs/heads/main/.github/tests/mix.yaml
make config-image
```

## License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](LICENSE) file for details.
