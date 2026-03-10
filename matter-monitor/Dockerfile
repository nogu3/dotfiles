# Stage 1: Build Matter chip-tool
FROM ubuntu:22.04 AS matter-builder

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies for building Matter SDK
RUN apt-get update && apt-get install -y \
    git \
    gcc \
    g++ \
    pkg-config \
    libssl-dev \
    libdbus-1-dev \
    libglib2.0-dev \
    libavahi-client-dev \
    ninja-build \
    python3-venv \
    python3-dev \
    python3-pip \
    unzip \
    libgirepository1.0-dev \
    libcairo2-dev \
    libreadline-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt
# Clone Matter SDK (shallow clone for speed)
RUN git clone --depth 1 https://github.com/project-chip/connectedhomeip.git

WORKDIR /opt/connectedhomeip
# Initialize submodules and build chip-tool
RUN ./scripts/checkout_submodules.py --shallow --platform linux
RUN bash -c "source scripts/activate.sh && ./scripts/examples/gn_build_example.sh examples/chip-tool out/host"


# Stage 2: Rust Dev Environment
FROM rust:latest

ENV DEBIAN_FRONTEND=noninteractive

# Install runtime dependencies for chip-tool
RUN apt-get update && apt-get install -y \
    libavahi-client3 \
    libssl3 \
    libdbus-1-3 \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Copy chip-tool binary from Stage 1
COPY --from=matter-builder /opt/connectedhomeip/out/host/chip-tool /usr/local/bin/chip-tool

# Set working directory
WORKDIR /app
