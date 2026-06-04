# Box64 ARM

Docker image with [BOX64](https://github.com/ptitSeb/box64) and [BOX86](https://github.com/ptitSeb/box86) compiled from source for running x86_64 and x86 binaries on ARM devices (e.g. Raspberry Pi, Oracle ARM, AWS Graviton).

## Build

- Build
```bash
podman build -t box64 .
```
- Save
```bash
podman save localhost/box64 -o box64.tar
```

## Notes

- BOX64 is compiled from source with `ARM_DYNAREC=ON` for best performance on ARM64.
- BOX86 is compiled from source (cross-compiled via `gcc-arm-linux-gnueabihf`) with `ARM_DYNAREC=ON` to support 32-bit x86 binaries on ARM64.
- The image is based on `debian:bookworm`.