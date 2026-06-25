# x86_64 Linux

Debian x86_64 container with common runtime dependencies for running x86_64 and x86 (i386) Linux applications.

## Build

- Build
```bash
podman build --cgroup-manager=cgroupfs --runtime=runc -t x86_64 .
# OR without steamcmd
podman build --cgroup-manager=cgroupfs --runtime=runc --build-arg INSTALL_STEAMCMD=false -t x86_64 .
```
- Save
```bash
podman save localhost/x86_64 --cgroup-manager=cgroupfs --runtime=runc -o x86_64.tar
```

## Usage
- Add image to podman (you need to have the x86_64.tar first from the build method or download in releases)
```bash
mkdir -p /tmp/podman-x86_64 && XDG_RUNTIME_DIR=/tmp/podman-x86_64 podman load -i x86_64.tar
```
- Open it
```bash
podman run -it --rm \
  -v ~/app:/root/app \
  localhost/x86_64:latest /bin/bash
```

## Notes

- Based on `debian:bookworm` (x86_64 native).
- Includes i386 multiarch support for running 32-bit Linux binaries.
- Includes common runtime libraries: SDL2, OpenAL, Mesa GL, GLib, Fontconfig.
