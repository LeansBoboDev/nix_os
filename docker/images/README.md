# Clean everything about docker
- docker system prune -a --volumes

# Remove a container
- docker ps -a
- > List the available containers
- docker rm <container_id>

# Remove an image
- docker images
- > List the available images
- docker rmi <image_id>

# Cleanup
- podman rm -a -f
- > All containers
- podman rmi -a -f
- > All images
- podman system prune -a -f
- > Generic data