#!/bin/bash

curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/display_logo.sh | bash

YELLOW='\e[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${YELLOW}Установка дополнительных программ (Внимание установка скрыта поэтому процесс установки вы не увидите)...${NC}"
bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/main.sh) &>/dev/null

bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/ufw.sh) &>/dev/null

bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/rust.sh) &>/dev/null
echo -e "${GREEN}Установка доп программ завершена${NC}"
sleep 3
echo -e "${YELLOW}Продолжаем установку...${NC}"

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup target add riscv32i-unknown-none-elf

sudo apt install -y protobuf-compiler

curl https://cli.nexus.xyz/ | sh

source /root/.bashrc

# Get the major.minor version number of glibc from ldd
version_str=$(ldd --version | head -n1)
# Extract version number like "2.35" or "2.39"
version_num=$(echo "$version_str" | grep -oP '\d+\.\d+' | head -n1)
version_lt() {
    # Use sort -V (version sort)
    [ "$(printf '%s\n%s' "$1" "$2" | sort -V | head -n1)" != "$2" ]
}
REQUIRED_VERSION="2.39"

if version_lt "$version_num" "$REQUIRED_VERSION"; then
    echo -e "${YELLOW}Ставим $REQUIRED_VERSION. Просто ждите окончания установки.${NC}"
    curl -fsSL https://raw.githubusercontent.com/NodEligible/programs/main/glibc239.sh | bash &>/dev/null
fi

echo -e "${GREEN}Установка завершена. Дале продолжайте по гайду ${NC}"
