#!/bin/bash
IMAGE_NAME="x86_64"
CONTAINER_NAME="x86_64"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

IMAGE_PLATFORM=$(docker inspect --format '{{.Os}}/{{.Architecture}}' "$IMAGE_NAME" 2>/dev/null)
if [ -z "$(docker images -q "$IMAGE_NAME" 2>/dev/null)" ] || [ "$IMAGE_PLATFORM" != "linux/amd64" ]; then
  echo "Image not found or wrong platform ($IMAGE_PLATFORM), building..."
  docker build --platform linux/amd64 -t "$IMAGE_NAME" "$SCRIPT_DIR" || { echo "Build failed, aborting."; exit 1; }
fi

if docker ps --format "{{.Names}}" | grep -q "^${CONTAINER_NAME}$"; then
  echo "Container already up, entering..."
  docker exec -it $CONTAINER_NAME bash
elif docker ps -a --format "{{.Names}}" | grep -q "^${CONTAINER_NAME}$"; then
  echo "Container stopped, starting..."
  docker start -ai $CONTAINER_NAME
else
  echo "Creating container..."
  mkdir -p "$HOME/app"
  docker run -it \
    --privileged \
    --platform linux/amd64 \
    --pull=never \
    --name x86_64 \
    --network host \
    -v "$HOME/app:/root/app" \
    x86_64 bash
fi
