#!/bin/bash

curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/display_logo.sh | bash

YELLOW='\e[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# Установка Main
  echo -e "${YELLOW}Установка Main...${NC}"
  bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/main.sh)
  if [ $? -eq 0 ]; then
      echo -e "${GREEN}Main успешно установлен!${NC}"
  else
      echo -e "${RED}Ошибка при установке Main!${NC}"
  fi

# Установка Ufw
  echo -e "${YELLOW}Установка Ufw...${NC}" 
  bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/ufw.sh)
  if [ $? -eq 0 ]; then
      echo -e "${GREEN}Ufw успешно установлено!${NC}"
  else
      echo -e "${RED}Ошибка при установке Ufw!${NC}"
  fi

#!/bin/bash

set -e

PROTOC_VERSION=$(protoc --version 2>/dev/null | awk '{print $2}')
if [[ "$PROTOC_VERSION" != "3.21.12" ]]; then
    echo "Устанавливаем protoc версии 3.21.12"
    wget -q https://github.com/protocolbuffers/protobuf/releases/download/v21.12/protoc-21.12-linux-x86_64.zip
    unzip -q protoc-21.12-linux-x86_64.zip -d $HOME/.local
    rm protoc-21.12-linux-x86_64.zip
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
    export PATH="$HOME/.local/bin:$PATH"
fi

echo "Встановлення Rust..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"

rustup target add riscv32i-unknown-none-elf
sudo apt update && sudo apt install -y protobuf-compiler

# Видалення попередніх даних
systemctl stop nexus &>/dev/null || true
systemctl disable nexus &>/dev/null || true
rm -rf $HOME/.nexus /etc/systemd/system/nexus.service 
source ~/.profile

# Налаштування swap
SWAP_LOCATE=$(swapon --show | awk 'NR==2 {print $1}')
if [ -n "$SWAP_LOCATE" ]; then
    swapoff "$SWAP_LOCATE"
    rm "$SWAP_LOCATE"
fi

fallocate -l 6G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo '/swapfile none swap sw 0 0' | tee -a /etc/fstab
sysctl vm.swappiness=10
sysctl vm.vfs_cache_pressure=50
echo "vm.swappiness=10" >> /etc/sysctl.conf
echo "vm.vfs_cache_pressure=50" >> /etc/sysctl.conf

# Завантаження репозиторію
NEXUS_HOME="$HOME/.nexus"
mkdir -p "$NEXUS_HOME"

REPO_PATH="$NEXUS_HOME/network-api"
if [ -d "$REPO_PATH" ]; then
    echo "$REPO_PATH exists. Updating..."
    cd "$REPO_PATH" || exit 1
    git stash --include-untracked
    git pull
    git fetch --tags
else
    git clone https://github.com/nexus-xyz/network-api "$REPO_PATH"
fi

cd "$REPO_PATH" || exit 1
git -c advice.detachedHead=false checkout "$(git rev-list --tags --max-count=1)"

# Збірка Rust-клієнта
cd "$REPO_PATH/clients/cli"
cargo build --release || exit 1

if [ -f "target/release/nexus-network" ]; then
    cp target/release/nexus-network "$NEXUS_HOME/nexus-network"
else
    echo "Помилка: Файл target/release/nexus-network не знайдено!" >&2
    exit 1
fi

# Фінальні перевірки
lsb_release -a
rustc --version
cargo --version

echo -e "${GREEN}Установка завершена${NC}"
