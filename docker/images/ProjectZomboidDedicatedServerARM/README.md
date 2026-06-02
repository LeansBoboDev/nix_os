# Project Zomboid Dedicated Server ARM

Docker image with all dependencies and [BOX64](https://github.com/ptitSeb/box64) for running Project Zomboid Dedicated Server on ARM devices (e.g. Raspberry Pi, Oracle ARM, AWS Graviton).

## Build

- Build
```bash
podman build -t pz_ds_image .
```
- Save
```bash
podman save localhost/projectzomboid -o projectzomboid.tar
```

## Environment Variables

| Variable | Default | Description |
|---|---|---|
| `PZ_SERVER_PATH` | `$HOME/ProjectZomboidDedicatedServer` | Path where the server binary and files are located. |
| `PZ_DATA_PATH` | `$HOME/Zomboid` | Path where server data is stored (saves, config, mods, logs). |

### Volume mounts

| Container path | Purpose |
|---|---|
| `$PZ_SERVER_PATH` | Server installation directory (steamcmd output). |
| `$PZ_DATA_PATH` | Persistent data: saves, mods, server config (`servertest.ini`). |

### Ports

| Port | Protocol | Description |
|---|---|---|
| `16261` | UDP | Main game port (client connections). |
| `16262` | UDP | Direct connection / secondary game port. |

## Notes

- BOX64 is compiled from source with `ARM_DYNAREC=ON` for best performance on ARM64.
- BOX86 is compiled from source (cross-compiled via `gcc-arm-linux-gnueabihf`) with `ARM_DYNAREC=ON` to support 32-bit x86 binaries on ARM64.
- The image is based on `debian:bookworm`.
- The entrypoint creates `PZ_SERVER_PATH` and `PZ_DATA_PATH` directories automatically if they do not exist.