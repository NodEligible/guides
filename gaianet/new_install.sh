#!/bin/bash

curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/display_logo.sh | bash

YELLOW='\e[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[38;5;81m'
NC='\033[0m'

#  Добавити команди на видалення
echo -e "${YELLOW} Удаляем ноду и сервис если есть...${NC}"
sudo systemctl stop gaianet-monitor 
sudo systemctl disable gaianet-monitor
systemctl daemon-reload
rm -f /root/gaianet_service
rm -f /etc/systemd/system/gaianet-monitor.service
gaianet stop
curl -sSfL 'https://github.com/GaiaNet-AI/gaianet-node/releases/latest/download/uninstall.sh' | bash
rm -rf ~/gaia.sh 
rm -rf ~/.wasmedge
rm -rf ~/.bash_profile.gaianet_backup
rm -rf ~/.bash_profile.wasmedge_backup
rm -rf ~/.bashrc.gaianet_backup
rm -rf ~/.bashrc.wasmedge_backup
rm -rf ~/.profile.wasmedge_backup

systemctl daemon-reload

echo -e "${YELLOW}Установка дополнительных програм скрыта...${NC}"
echo -e "${YELLOW}Установка Docker...${NC}"
bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/docker.sh) &>/dev/null


echo -e "${YELLOW}Обновление пакетов...${NC}"
sudo apt update -y &>/dev/null
sudo apt upgrade -y &>/dev/null
sudo apt install -y python3-pip python3-dev python3-venv curl git &>/dev/null
sudo apt install -y build-essential &>/dev/null
pip3 install aiohttp &>/dev/null

  echo -e "${YELLOW}Установка GaiaNet...${NC}"
  curl -sSfL 'https://github.com/GaiaNet-AI/gaianet-node/releases/latest/download/install.sh' | bash
  if [ $? -eq 0 ]; then
      echo -e "${GREEN}Установка завершена!${NC}"
  else
      echo -e "${RED}Ошибка при установке!${NC}"
  fi

sleep 2

echo "export PATH=\$PATH:$HOME/gaianet/bin" >> $HOME/.bashrc

sleep 3

ln -sf /root/gaianet/bin/gaianetup /usr/local/bin/gaianetup

source $HOME/.bashrc

if ! command -v gaianet &> /dev/null; then
    echo -e "${RED}❌ Ошибка: gaianet не найден! Путь $HOME/gaianet/bin не добавлен в PATH.${NC}"
    echo -e "${RED}------------------------------------------------------------------------${NC}"
    echo -e "${YELLOW}В случае ошибки выполняем следующие команды:${NC}"
    echo -e "1️⃣ . source $HOME/.bashrc"
    echo -e "2️⃣ . https://raw.githubusercontent.com/NodEligible/guides/main/gaianet/node-configs/qwen2-0.5b-instruct/config.json"
    echo -e "3️⃣ . gaianet start"
    echo -e "4️⃣ . bash <(curl -s https://raw.githubusercontent.com/NodEligible/monitoring/main/node_service/gaianet.sh)"
    echo -e "5️⃣ . sudo systemctl start gaianet-monitor"
    exit 1
fi


echo -e "${YELLOW}Инициализация конфигурации...${NC}"
gaianet init --config https://raw.githubusercontent.com/NodEligible/guides/main/gaianet/node-configs/qwen2-0.5b-instruct/config.json

gaianet start

echo -e "${YELLOW}Устанавливаем сервис...${NC}"
bash <(curl -s https://raw.githubusercontent.com/NodEligible/monitoring/main/node_service/gaianet.sh)

echo -e "${GREEN}Установка GaiaNet и сервиса для мониторинга завершена!${NC}"

