#!/bin/bash

# Загрузка и отображение логотипа
if curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/display_logo.sh | bash; then
    echo -e "${GREEN}Логотип загружен!${NC}"
else
    echo -e "${RED}Не удалось загрузить логотип.${NC}"
fi

# Сменные для цветов
YELLOW='\e[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # Сброс цвета

# Установка curl, если он не установлен
if ! command -v curl &> /dev/null; then
    echo "Устанавливаем curl..."
    sudo apt update && sudo apt install -y curl
fi

# Проверка наличия Docker
if ! command -v docker &> /dev/null; then
    echo -e "${YELLOW}Установка Docker...${NC}"
    if bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/docker.sh); then
        echo -e "${GREEN}Docker успешно установлен!${NC}"
    else
        echo -e "${RED}Ошибка при установке Docker!${NC}"
        exit 1
    fi
else
    echo -e "${GREEN}Docker уже установлен.${NC}"
fi

# Установка Main
echo -e "${YELLOW}Установка Main...${NC}"
if bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/main.sh); then
    echo -e "${GREEN}Main успешно установлен!${NC}"
else
    echo -e "${RED}Ошибка при установке Main!${NC}"
fi

# Установка Ufw
echo -e "${YELLOW}Установка Ufw...${NC}"
if bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/ufw.sh); then
    echo -e "${GREEN}Ufw успешно установлен!${NC}"
else
    echo -e "${RED}Ошибка при установке Ufw!${NC}"
fi

# Установка Go
echo -e "${YELLOW}Установка Go...${NC}"
if bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/go.sh); then
    echo -e "${GREEN}Go успешно установлен!${NC}"
else
    echo -e "${RED}Ошибка при установке Go!${NC}"
fi

# Установка Nesa
echo -e "${YELLOW}Установка Nesa...${NC}"
if bash <(curl -s https://raw.githubusercontent.com/nesaorg/bootstrap/master/bootstrap.sh); then
    echo -e "${GREEN}Nesa успешно установлена и запущена!${NC}"
else
    echo -e "${RED}Ошибка при установке Nesa!${NC}"
fi
