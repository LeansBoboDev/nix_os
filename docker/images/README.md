# Clean everthing about podman
- XDG_RUNTIME_DIR=/tmp/podman podman system prune -a --volumes

# Remove a container
- XDG_RUNTIME_DIR=/tmp/podman podman ps -a
- > List the available container
- XDG_RUNTIME_DIR=/tmp/podman podman rm <container_id>

# Remove an image
- XDG_RUNTIME_DIR=/tmp/podman podman images
- > List the available images
- XDG_RUNTIME_DIR=/tmp/podman podman rmi <image_id>