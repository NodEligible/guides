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

  echo -e "${YELLOW}Установка Rust...${NC}"
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    if [ $? -eq 0 ]; then
      echo -e "${GREEN}Rust успешно установлено!${NC}"
  else
      echo -e "${RED}Ошибка при установке Rust!${NC}"
  fi

  rustup target add riscv32i-unknown-none-elf
sudo apt install -y protobuf-compiler

# remove previous data
systemctl stop nexus &>/dev/null
systemctl disable nexus &>/dev/null
rm -rf $HOME/.nexus /etc/systemd/system/nexus.service 
source .profile

NEXUS_HOME="$HOME/.nexus"
mkdir -p "$NEXUS_HOME"

REPO_PATH="$NEXUS_HOME/network-api"
if [ -d "$REPO_PATH" ]; then
  echo "$REPO_PATH exists. Updating."
  (
    cd "$REPO_PATH" || exit
    git stash
    git fetch --tags
  )
else
  (
    cd "$NEXUS_HOME" || exit
    git clone https://github.com/nexus-xyz/network-api
  )
fi

(
  cd "$REPO_PATH" || exit
  git -c advice.detachedHead=false checkout "$(git rev-list --tags --max-count=1)"
)

cd "$REPO_PATH/clients/cli" 
cargo clean
RUST_BACKTRACE=1 cargo build --release

cp /root/.nexus/network-api/clients/cli/target/release/nexus-network /root/.nexus/nexus-network

lsb_release -a
rustc --version
cargo --version

echo -e "${GREEN}Установка завершена${NC}"
