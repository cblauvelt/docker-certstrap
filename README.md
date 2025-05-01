# Certstrap Docker Image

Creates a docker image that bundles **`certstrap`** on top of an **Ubuntu 24.04** base image with **OpenSSL 3** installed.

## Features

- **Ubuntu 24.04** final image
- **OpenSSL 3** installed for certificate operations
- **certstrap** compiled from source using Go (via a multi-stage build)
- Minimal final image footprint (no Go runtime)

## Prerequisites

- Docker installed on your system
- `git` (for retrieving the repository and computing the Git hash)
- Make (to run the provided Makefile targets)

## Building the Image

The repository includes a **Makefile** with the following targets:

- **`make build`**: Builds the Docker image and tags it as `cblauvelt/certstrap:test-<GIT_HASH>` where `<GIT_HASH>` is the short hash of the current commit.
- **`make test`**: Runs a container from the built image to verify `certstrap version` and `openssl version`.
- **`make all`** (default): Runs both **`make build`** and **`make test`**.
- **`make pull-rebuild`**: Pulls the latest `golang:latest` and `ubuntu:24.04` base images, then rebuilds.
- **`make clean`**: Cleans up any dangling Docker images.

### Build Steps

1. Clone this repository:

   ```bash
   git clone https://github.com/cblauvelt/certstrap.git
   cd certstrap
   ```

2. Build and test the image:

   ```bash
   make all
   ```

3. (Optional) Pull latest base images and rebuild:

   ```bash
   make pull-rebuild
   ```

4. Remove dangling images:

   ```bash
   make clean
   ```

## Using the Image

Once built, you can run the image to use **certstrap** and **OpenSSL**:

```bash
# Start an interactive shell in the container
docker run --rm -it cblauvelt/certstrap:test-<GIT_HASH> bash

# Inside the container
certstrap --help
openssl version
```

---

Feel free to customize the `Dockerfile` or **Makefile** as needed for your workflow!
