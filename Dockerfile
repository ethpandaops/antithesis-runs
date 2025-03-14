FROM debian:stable-slim AS builder

RUN apt-get update && apt-get -y upgrade && apt-get install -y --no-install-recommends \
  libssl-dev \
  ca-certificates \
  jq \
  git \
  curl \
  make \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Ethereum package config file can either be a path to a local file or a URL
ARG ETHEREUM_PACKAGE_CONFIG_FILE=https://raw.githubusercontent.com/ethpandaops/ethereum-package/refs/heads/main/.github/tests/mix.yaml
ARG ETHEREUM_PACKAGE=https://github.com/ethpandaops/ethereum-package
ARG ETHEREUM_PACKAGE_BRANCH="main"
ARG PACKAGE_LIST

# Clone ethereum package first as it's our main package
RUN git clone --depth 1 --branch ${ETHEREUM_PACKAGE_BRANCH} "${ETHEREUM_PACKAGE}" /ethereum-package

COPY scripts /scripts

# Download the ethereum package config file
RUN ./scripts/download-package-config.sh ${ETHEREUM_PACKAGE_CONFIG_FILE} /ethereum-package/ethereum-package-config.yaml

# Clone all dependency packages
RUN for package in ${PACKAGE_LIST}; do \
    package_name=$(basename $package); \
    git clone --depth 1 "https://${package}.git" "/vendored-packages/${package_name}"; \
    done

# Add replace directives for all dependencies
RUN echo "replace:" >> /ethereum-package/kurtosis.yml && \
    for package in ${PACKAGE_LIST}; do \
    package_name=$(basename $package); \
    echo "  ${package}: ../vendored-packages/${package_name}" >> /ethereum-package/kurtosis.yml; \
    done

FROM debian:stable-slim

COPY --from=builder /ethereum-package /ethereum-package
# Copy all dependency packages
COPY --from=builder /vendored-packages /vendored-packages
