# Install K3d
echo "Installing K3d..."
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

# Verify installations
echo "Verifying installations..."
docker --version
kubectl version --client
k3d --version

echo "Installation complete!"
echo "Please log out and log back in for Docker group changes to take effect."