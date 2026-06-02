#!/bin/bash
IMAGE_NAME="localhost/projectzomboid"
CONTAINER_NAME="projectzomboid"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

if [ -z "$(podman images -q "$IMAGE_NAME" 2>/dev/null)" ]; then
  echo "Image not found, building..."
  podman build --cgroup-manager=cgroupfs -t "$IMAGE_NAME" "$SCRIPT_DIR" || { echo "Build failed, aborting."; exit 1; }
fi

if podman ps --format "{{.Names}}" | grep -q "^${CONTAINER_NAME}$"; then
  echo "Container already up, entering..."
  podman exec -it $CONTAINER_NAME bash
elif podman ps -a --format "{{.Names}}" | grep -q "^${CONTAINER_NAME}$"; then
  echo "Container stopped, starting..."
  podman start -ai $CONTAINER_NAME
else
  echo "Creating container..."
  mkdir -p "$HOME/ProjectZomboidDedicatedServer/Zomboid"
  podman run -it \
    --cgroup-manager=cgroupfs \
    --pull=never \
    --name projectzomboid \
    -v "$HOME/ProjectZomboidDedicatedServer:/root/ProjectZomboidDedicatedServer" \
    -v "$HOME/ProjectZomboidDedicatedServer/Zomboid:/root/Zomboid" \
    -v "$HOME/SteamCMD:/root/SteamCMD" \
    localhost/projectzomboid bash
fi