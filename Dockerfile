# Stage 1: builder with Go to compile certstrap
FROM golang:latest AS builder

# Set working directory
WORKDIR /go/src/app

# Enable Go modules and install certstrap
RUN go env -w GO111MODULE=on \
    && go install github.com/square/certstrap@latest


# Stage 2: final image with openssl and certstrap only
FROM ubuntu:24.04 AS final

ENV DEBIAN_FRONTEND=noninteractive

# Install openssl and certificates
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    openssl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Copy certstrap binary from builder stage into PATH
COPY --from=builder /go/bin/certstrap /usr/local/bin/certstrap

# Verify versions
RUN certstrap --version && openssl version

# Default to an interactive bash shell
CMD ["bash"]
