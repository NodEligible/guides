#!/bin/bash

curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/display_logo.sh | bash

YELLOW='\e[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

install_docker() {
  echo -e "${YELLOW}Установка Docker...${NC}"
  bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/docker.sh)
  if [ $? -eq 0 ]; then
      echo -e "${GREEN}Docker успешно установлено!${NC}"
  else
      echo -e "${RED}Ошибка при установке Docker!${NC}"
  fi
}

update() {
  echo -e "${YELLOW}Обновление пакетов...${NC}"
  sudo apt update -y && sudo apt-get update
  if [ $? -eq 0 ]; then
      echo -e "${GREEN}Пакеты успешно обновлены!${NC}"
  else
      echo -e "${RED}Ошибка при обновлении пакетов!${NC}"
  fi
}

install_gaianet() {
  echo -e "${YELLOW}Установка GaiaNet...${NC}"
  curl -sSfL 'https://github.com/GaiaNet-AI/gaianet-node/releases/latest/download/install.sh' | bash
  if [ $? -eq 0 ]; then
      echo -e "${GREEN}Установка завершена!${NC}"
  else
      echo -e "${RED}Ошибка при установке!${NC}"
  fi
}

initialization() {
  echo -e "${YELLOW}Инициализация конфигурации...${NC}"
  source ~/.bashrc

  gaianet init --config https://raw.githubusercontent.com/GaiaNet-AI/node-configs/main/qwen2-0.5b-instruct/config.json
}

# Основной процесс установки
update
install_docker
install_gaianet
initialization

gaianet start

echo -e "${GREEN}Установка GaiaNet завершена!${NC}"
