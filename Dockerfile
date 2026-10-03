FROM node:24.21.0-bookworm AS builder
WORKDIR /app

RUN apt-get update -y && apt-get install -y \
    build-essential \
    g++ \
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
RUN quilt push -a 
RUN npm ci
