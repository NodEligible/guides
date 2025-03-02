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

  echo -e "${YELLOW}Обновление пакетов...${NC}"
sudo apt update && sudo apt upgrade -y
sudo apt install -y python3-pip python3-dev python3-venv curl git
sudo apt install -y build-essential
pip3 install aiohttp
  if [ $? -eq 0 ]; then
      echo -e "${GREEN}Пакеты успешно обновлены!${NC}"
  else
      echo -e "${RED}Ошибка при обновлении пакетов!${NC}"
  fi

  echo -e "${YELLOW}Установка GaiaNet...${NC}"
  curl -sSfL 'https://github.com/GaiaNet-AI/gaianet-node/releases/latest/download/install.sh' | bash
  if [ $? -eq 0 ]; then
      echo -e "${GREEN}Установка завершена!${NC}"
  else
      echo -e "${RED}Ошибка при установке!${NC}"
  fi

sleep 2

echo "export PATH=\$PATH:$HOME/gaianet/bin" >> $HOME/.bashrc

sleep 2

echo -e "${YELLOW}Пред установка GaiaNet завершена!${NC}" 
echo -e "${YELLOW}1️⃣. Дальше закиньте в директорию /root/gaianet/ 3 файла config.json, deviceid.txt, nodeid.json и поочерёдно киньте команды ниже!${NC}"
echo -e "${YELLOW}--------------------------------------------------------------------------------------------------------------------------------${NC}"
echo -e "${YELLOW}2️⃣. source $HOME/.bashrc${NC}"
echo -e "${YELLOW}4️⃣. gaianet init${NC}"
echo -e "${YELLOW}4️⃣. gaianet start${NC}"
