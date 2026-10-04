# syntax=docker/dockerfile:1

FROM node:24.21.0-bookworm AS builder

SHELL ["/bin/bash", "-c"]

WORKDIR /src

ENV VERSION=0.0.0 \
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

COPY . .

RUN git submodule update --init

WORKDIR /src/app

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

FROM debian:bookworm-slim AS runtime

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