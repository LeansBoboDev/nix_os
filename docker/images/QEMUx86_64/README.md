# x86_64 Linux

Debian x86_64 container with common runtime dependencies for running x86_64 and x86 (i386) Linux applications.

## Build

- Build
```bash
docker build --platform linux/amd64 -t x86_64 .
# OR without steamcmd
docker build --platform linux/amd64 --build-arg INSTALL_STEAMCMD=false -t x86_64 .
```
- Save
```bash
docker save -o x86_64.tar x86_64
```

## Usage
- Add image to docker (you need to have the x86_64.tar first from the build method or download in releases)
```bash
docker load -i x86_64.tar
```
- Open it
```bash
docker run -it --rm \
  -v ~/app:/root/app \
  x86_64:latest /bin/bash
```

## Running on ARM64 (QEMU emulation)

- Run the container with explicit platform
```bash
docker run -it --rm \
  --platform linux/amd64 \
  -v ~/app:/root/app \
  x86_64:latest /bin/bash
```

- Build for x86_64 from an ARM64 host
```bash
docker build --platform linux/amd64 -t x86_64 .
```

## Notes

- Based on `debian:bookworm` (x86_64 native).
- Includes i386 multiarch support for running 32-bit Linux binaries.
- Includes common runtime libraries: SDL2, OpenAL, Mesa GL, GLib, Fontconfig.
