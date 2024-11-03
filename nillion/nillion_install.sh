#!/bin/bash

# Функция для отображения логотипа
display_logo() {
curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/display_logo.sh | bash
}

# Отображение логотипа
display_logo

exists()
{
  command -v "$1" >/dev/null 2>&1
}
# Check if 'curl' is installed
if exists curl; then
  echo ""
else
  echo "Установка curl..."
  if ! sudo apt update && sudo apt install curl -y < "/dev/null"; then
    echo "Не удалось установить Curl. Выход."
    exit 1
  fi
fi
bash_profile=$HOME/.bash_profile
if [ -f "$bash_profile" ]; then
    source $HOME/.bash_profile

cd $HOME
sudo install -m 0755 -d /etc/apt/keyrings
sudo rm -f /etc/apt/keyrings/docker.gpg
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

sudo docker --version
sudo docker pull nillion/verifier:v1.0.1

mkdir -p $HOME/nillion/accuser
sudo docker run -v $HOME/nillion/accuser:/var/tmp nillion/verifier:v1.0.1 initialise
