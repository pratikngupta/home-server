echo "Configure Nvidia for docker" | lolcat

echo "Add Nvidia's official GPG key:" | lolcat
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list \
  && \
    sudo apt-get update

echo "Install Nvidia Packages" | lolcat

sudo apt-get install -y nvidia-container-toolkit


echo "Nvidia Toolkit Installed" | lolcat
echo "Configure Docker to use Nvidia Toolkit" | lolcat

sudo nvidia-ctk runtime configure --runtime=docker

echo "Docker configured to use Nvidia Toolkit" | lolcat

echo "Restarting Docker" | lolcat
sudo systemctl restart docker

echo "Docker restarted" | lolcat

echo "Testing Nvidia Toolkit" | lolcat

sudo docker run --rm --runtime=nvidia --gpus all ubuntu nvidia-smi | lolcat

echo "Nvidia Toolkit Test Complete" | lolcat