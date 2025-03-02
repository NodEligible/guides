#!/bin/bash

curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/display_logo.sh | bash

YELLOW='\e[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

  echo -e "${YELLOW}Установка Docker...${NC}"
  bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/docker.sh)
  if [ $? -eq 0 ]; then
      echo -e "${GREEN}Docker успешно установлено!${NC}"
  else
      echo -e "${RED}Ошибка при установке Docker!${NC}"
  fi

source $HOME/.bashrc

sleep 5

if ! command -v gaianet &> /dev/null; then
    echo -e "${RED}❌ Ошибка: gaianet не найден! Путь $HOME/gaianet/bin не добавлен в PATH.${NC}"
    echo -e "${RED}------------------------------------------------------------------------${NC}"
    echo -e "${YELLOW}В случае ошибки выполняем следующие команды:${NC}"
    echo -e "1️⃣. source $HOME/.bashrc"
    echo -e "2️⃣. gaianet init --config https://raw.githubusercontent.com/GaiaNet-AI/node-configs/main/qwen2-0.5b-instruct/config.json"
    echo -e "3️⃣. gaianet start"
    exit 1
fi

echo -e "${YELLOW}Инициализация конфигурации...${NC}"
