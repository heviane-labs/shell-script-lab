FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

# Avoid prompts from debconf
ENV DEBIAN_FRONTEND=noninteractive

# Install core tools, linters, formatters, and testing frameworks
RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    curl \
    git \
    jq \
    shellcheck \
    bats \
    file \
    tree \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install shfmt binary
RUN curl -sSLo /usr/local/bin/shfmt "https://github.com/mvdan/sh/releases/download/v3.8.0/shfmt_v3.8.0_linux_amd64" \
    && chmod +x /usr/local/bin/shfmt

# Set default user
USER vscode

# Set default working directory
WORKDIR /workspace

