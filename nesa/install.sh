#!/bin/bash

# Загрузка и отображение логотипа
curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/display_logo.sh | bash


# Сменные для цветов
YELLOW='\e[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # Сброс цвета

# Установка curl
if ! command -v curl &> /dev/null; then
    echo -e "${YELLOW}Установка Curl...${NC}"
    if sudo apt update &> /dev/null && sudo apt install -y curl &> /dev/null; then
        echo -e "${GREEN}Curl успешно установлен!${NC}"
    else
        echo -e "${RED}Ошибка при установке Curl!${NC}"
        exit 1
    fi
else
    echo -e "${GREEN}Curl уже установлен.${NC}"
fi

# Установка Docker
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
if ! command -v main &> /dev/null; then
    echo -e "${YELLOW}Установка Main...${NC}"
    if bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/main.sh); then
        echo -e "${GREEN}Main успешно установлен!${NC}"
    else
        echo -e "${RED}Ошибка при установке Main!${NC}"
        exit 1
     fi
 else   
     echo -e "${GREEN}Main уже установлен.${NC}"
 fi
  
# Установка Ufw
if ! command -v ufw &> /dev/null; then
    echo -e "${YELLOW}Установка Ufw...${NC}"
    if bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/ufw.sh); then
         echo -e "${GREEN}Ufw успешно установлен!${NC}"
    else
        echo -e "${RED}Ошибка при установке Ufw!${NC}"
        exit 1
     fi
 else   
     echo -e "${GREEN}Ufw уже установлен.${NC}"
 fi

# Установка Go
if ! command -v go &> /dev/null; then
    echo -e "${YELLOW}Установка Go...${NC}"
    if bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/go.sh); then
         echo -e "${GREEN}Go успешно установлен!${NC}"
    else
        echo -e "${RED}Ошибка при установке Go!${NC}"
        exit 1
     fi
 else   
     echo -e "${GREEN}Go уже установлен.${NC}"
 fi

# Установка Nesa
echo -e "${YELLOW}Установка Nesa...${NC}"
bash <(curl -s https://raw.githubusercontent.com/nesaorg/bootstrap/master/bootstrap.sh)
echo -e "${GREEN}Nesa успешно установлена и запущена!${NC}"
