# Antithesis Ethereum Package Github Runs

This repository builds config images for running Antithesis tests against the Ethereum Package using Kurtosis. The config image includes the Ethereum Package and all dependant kurtosis packages, and the container images it needs are extracted for the Antithesis runtime.

There is no workflow that starts an Antithesis run. Build the config image locally (see Development) and start the run from Antithesis.

## Usage

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
