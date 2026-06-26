# x86_64 Linux

Debian x86_64 container with common runtime dependencies for running x86_64 and x86 (i386) Linux applications.

## Build

- Build
```bash
docker build -t x86_64 .
# OR without steamcmd
docker build --build-arg INSTALL_STEAMCMD=false -t x86_64 .
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

## Notes

- Based on `debian:bookworm` (x86_64 native).
- Includes i386 multiarch support for running 32-bit Linux binaries.
- Includes common runtime libraries: SDL2, OpenAL, Mesa GL, GLib, Fontconfig.
