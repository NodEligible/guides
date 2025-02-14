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

    echo -e "Обновление multiple node"

    # Зупинка служби
    sudo systemctl stop multiple

    # Завантаження нового файлу
    gdown --id 1KRKoEyex7hyX5zXPDCJW_kP4G6XX5mNU -O multipleforlinux.tar

    # Розпакування архіву
    tar -xvf multipleforlinux.tar
    rm -rf multipleforlinux.tar

    # Оновлення прав
    chmod +x ./multiple-cli
    chmod +x ./multiple-node

    # Перезапуск служби
    sudo systemctl start multiple

    # Перевірка статусу служби
    sudo systemctl is-active --quiet multiple
    if [[ $? -ne 0 ]]; then
        echo -e "${RED}Ошибка: Служба multiple не запустилась! Проверьте логи.${NC}"
        exit 1
    fi

    echo -e "${GREEN}Обновление завершено!${NC}"
fi
