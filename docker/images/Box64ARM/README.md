# Box64 ARM

Docker image with [BOX64](https://github.com/ptitSeb/box64) and [BOX86](https://github.com/ptitSeb/box86) compiled from source for running x86_64 and x86 binaries on ARM devices (e.g. Raspberry Pi, Oracle ARM, AWS Graviton).

## Build

- Build
```bash
docker build -t box64 .
```
- Save
```bash
docker save -o box64.tar box64
```

## Usage
- Add image to docker (you need to have the box64.tar first from the build method or download in releases)
```bash
docker load -i box64.tar
```
- Open it
```bash
docker run -it --rm \
  -v ~/Server:/server \
  box64:latest /bin/bash
```

## Notes

- BOX64 is compiled from source with `ARM_DYNAREC=ON` for best performance on ARM64.
- BOX86 is compiled from source (cross-compiled via `gcc-arm-linux-gnueabihf`) with `ARM_DYNAREC=ON` to support 32-bit x86 binaries on ARM64.
- The image is based on `debian:bookworm`.
