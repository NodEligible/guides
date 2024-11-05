#!/bin/bash

# Змінні для кольорів
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # Скидання кольору

# Повідомлення про початок встановлення
echo -e "${GREEN}Установка Docker...${NC}"

# Оновлення репозиторіїв і встановлення Docker
sudo apt update -y
sudo apt install -y docker.io

# Перевірка статусу встановлення
if [ $? -eq 0 ]; then
    echo -e "${GREEN}Docker успішно встановлено!${NC}"
else
    echo -e "${RED}Помилка при встановленні Docker${NC}"
fi
