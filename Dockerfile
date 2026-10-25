# syntax=docker/dockerfile:1

FROM node:24.21.0-trixie@sha256:1278a37eb510ec1606fba0e80f554bcc941ae0b44f35ae373c4822ae7717c64d AS builder

SHELL ["/bin/bash", "-c"]

WORKDIR /src

# Vendored from coder/code-server v4.139.1 (released 2026-09-26

ENV VERSION=4.139.1 \
    ELECTRON_SKIP_BINARY_DOWNLOAD=1 \
    PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1 \
    VSCODE_TARGET=linux-x64 \
    VSCODE_ARCH=x64

RUN apt-get update -y && apt-get install -y \
        build-essential \
        libx11-dev \
        libxkbfile-dev \
        libsecret-1-dev \
        libkrb5-dev \
        python-is-python3 \
        jq \
        rsync \
        git \
        quilt

COPY app /src/app/

WORKDIR /src/app

# VS Code source pinned to the commit code-server v4.139.1 uses
# (from: git ls-tree HEAD app/lib/vscode). Update when re-vendoring.
ARG VSCODE_COMMIT=04c0d99f4fb0d8afe6ce4f0c58e31e183ac3e4b1

RUN git init lib/vscode && \
    cd lib/vscode && \
    git fetch --depth 1 https://github.com/microsoft/vscode.git ${VSCODE_COMMIT} && \
    git checkout FETCH_HEAD

RUN quilt push -a 

# Install vscode build tools
RUN cd lib/vscode/build && npm ci

# Install VSCode dependencies
RUN --mount=type=secret,id=github_token,env=GITHUB_TOKEN \
        cd lib/vscode && \
        source ./build/azure-pipelines/linux/setup-env.sh && \
        node build/npm/preinstall.ts && \
        npm ci

RUN --mount=type=secret,id=github_token,env=GITHUB_TOKEN \
        NODE_OPTIONS="--max-old-space-size=8192" npm run build:vscode

# Code server's own dependencies, skip building vscode's
RUN SKIP_SUBMODULE_DEPS=1 npm ci 

RUN npm run build

RUN KEEP_MODULES=1 npm run release

FROM debian:13.7-slim@sha256:62bd423aeee912639ca8ee681c2b762cb3e25137e0a92b20be455898a9f034ad AS runtime

RUN apt-get update -y && apt-get install -y --no-install-recommends \
        libx11-6 \
        libxkbfile1 \
        libsecret-1-0 \
        libkrb5-3  \
        ca-certificates \
        git \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /src/app/release /usr/lib/code-server

RUN useradd -m -u 1000 coder && mkdir -p /home/coder/project && chown -R coder:coder /home/coder
USER coder
WORKDIR /home/coder

EXPOSE 8080

ENTRYPOINT [ "/usr/lib/code-server/bin/code-server", "--bind-addr", "0.0.0.0:8080" ]
CMD ["/home/coder/project"]