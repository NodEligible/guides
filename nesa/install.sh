#!/bin/bash

# Функция для отображения логотипа
logo() {
curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/display_logo.sh | bash
}

# Сменные для цветов
YELLOW='\e[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # Сброс цвета

echo -e "${YELLOW}Установка Docker...${NC}"
bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/docker.sh)

if [ $? -eq 0 ]; then
    echo -e "${GREEN}Docker успешно установлено!${NC}"
else
    echo -e "${RED}Ошибка при установке Docker!${NC}"
fi

echo -e "${YELLOW}Установка Main...${NC}"
bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/main.sh)

if [ $? -eq 0 ]; then
    echo -e "${GREEN}Main успешно установлено!${NC}"
else
    echo -e "${RED}Ошибка при установке Main!${NC}"
fi

echo -e "${YELLOW}Установка Ufw...${NC}"
bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/ufw.sh)

if [ $? -eq 0 ]; then
    echo -e "${GREEN}Ufw успешно установлено!${NC}"
else
    echo -e "${RED}Ошибка при установке Ufw!${NC}"
fi

echo -e "${YELLOW}Установка Go...${NC}"
bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/go.sh)

if [ $? -eq 0 ]; then
    echo -e "${GREEN}Go успешно установлено!${NC}"
else
    echo -e "${RED}Ошибка при установке Go!${NC}"
fi

echo -e "${YELLOW}Установка Nesa...${NC}"
bash <(curl -s https://raw.githubusercontent.com/nesaorg/bootstrap/master/bootstrap.sh)

if [ $? -eq 0 ]; then
    echo -e "${GREEN}Nesa успешно установлена и запущена!${NC}"
else
    echo -e "${RED}Ошибка при установке Nesa!${NC}"
fi
