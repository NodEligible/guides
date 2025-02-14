#!/bin/bash

curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/display_logo.sh | bash

YELLOW='\e[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${YELLOW}🔄 Обновление пакетов...${NC}"
sudo apt update
sudo apt install python3 python3-pip -y

echo -e "${YELLOW}Установка Gdown...${NC}"
pip install gdown

cd $HOME/multipleforlinux

# Отримання поточної версії
current_version=$(./multiple-cli --version)
echo -e "Текущая версия: $current_version"

# Отримання останньої версії
latest_version=$(curl -s https://mdeck-download.s3.us-east-1.amazonaws.com/client/linux/version.txt)
echo -e "Последняя версия: $latest_version"

if [[ "$current_version" != "$latest_version" ]]; then
    echo -e "Обновление multiple node"

    # Зупинка служби
    sudo systemctl stop multiple

    # Завантаження нового файлу
    gdown --id 1KRKoEyex7hyX5zXPDCJW_kP4G6XX5mNU -O multipleforlinux.tar

    # Розпакування архіву
    tar -xvf multipleforlinux.tar
    rm -rf multipleforlinux.tar

    chmod -R 777 multipleforlinux
    cd multipleforlinux
    chmod +x ./multiple-cli
    chmod +x ./multiple-node

    # Перезапуск служби
    sudo systemctl start multiple
    echo -e "${GREEN}Обновление завершено!${NC}"
else
    echo -e "${GREEN}У вас уже последняя версия.${NC}"
fi
