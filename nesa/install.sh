#!/bin/bash

# Загрузка и отображение логотипа
curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/display_logo.sh | bash


# Сменные для цветов
YELLOW='\e[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # Сброс цвета

# Установка curl
echo -e "${YELLOW}Установка Curl...${NC}"
   if sudo apt update && sudo apt install -y curl; then
       echo -e "${GREEN}Curl успешно установлен!${NC}"
else
    echo -e "${RED}Ошибка при установке Curl!${NC}"
fi
# Установка Docker
    echo -e "${YELLOW}Установка Docker...${NC}"
    if bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/docker.sh); then
        echo -e "${GREEN}Docker успешно установлен!${NC}"
    else
        echo -e "${RED}Ошибка при установке Docker!${NC}"
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
