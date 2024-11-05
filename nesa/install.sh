#!/bin/bash

# Сменные для цветов
YELLOW='\e[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # Сброс цвета



# Сообщение о начале установки
echo -e "${YELLOW}Установка Docker...${NC}"

# Установка Docker
bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/docker.sh)

# Проверка статуса установки
if [ $? -eq 0 ]; then
    echo -e "${GREEN}Docker успешно установлено!${NC}"
else
    echo -e "${RED}Ошибка при установке Docker!${NC}"
fi

# Сообщение о начале установки
echo -e "${YELLOW}Установка Docker...${NC}"
