#!/bin/bash

curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/display_logo.sh | bash

YELLOW='\e[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[38;5;81m'
NC='\033[0m'

echo -e "${YELLOW} Выберите модель для установки:${NC}"
echo -e "1) phi-3-mini-instruct-4k ${BLUE}(легкая, 2-3GB RAM, 1-2CPU)${NC}"
echo -e "2) qwen1.5-0.5b-instruct ${BLUE}(легкая, 4-6GB RAM, 2+CPU)${NC}"
echo -e "3) qwen2-0.5b-instruct ${GREEN}(баланс рекомендую ставить, 8–10GB RAM, 4+CPU)${NC}"
echo -e "4) mistral-0.3-7b-instruct ${YELLOW}(средне тяжелая, 12–14GB, 6+CPU)${NC}"
echo -e "5) llama-3.1-8b-instruct ${YELLOW}(тяжелая, 16-20GB RAM, 6+CPU)${NC}"

read -p "➜ Введите номер модели: " MODEL

case $MODEL in
  1) MODEL="phi-3-mini-instruct-4k" ;;
  2) MODEL="qwen1.5-0.5b-instruct" ;;
  3) MODEL="qwen2-0.5b-instruct" ;;
  4) MODEL="mistral-0.3-7b-instruct" ;;
  5) MODEL="llama-3.1-8b-instruct" ;;
  *) echo "❌ Неверный выбор. Выход."; exit 1 ;;
esac

echo -e "${GREEN}Будет установлена модель:${NC}$MODEL"

echo -e "${YELLOW} Удаляем ноду если есть...${NC}"
systemctl stop gaianet.service 
systemctl disable gaianet.service 
curl -sSfL 'https://github.com/GaiaNet-AI/gaianet-node/releases/latest/download/uninstall.sh' | bash
rm -f /etc/systemd/system/gaianet.service 
rm -rf ~/gaia.sh 
rm -rf ~/.wasmedge
rm -rf ~/.bash_profile.gaianet_backup
rm -rf ~/.bash_profile.wasmedge_backup
rm -rf ~/.bashrc.gaianet_backup
rm -rf ~/.bashrc.wasmedge_backup
rm -rf ~/.profile.wasmedge_backup

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

sleep 2

echo -e "${YELLOW}Перед установка GaiaNet завершена!${NC}" 
echo -e "${BLUE}Дальше зайдите в директорию${NC} /root/gaianet/ ${BLUE}и удалите 2 файла${NC} deviceid.txt, nodeid.json ${BLUE}и вместо них закиньте свои старые файлы и дале нажмите Ентер!${NC}"
echo -e "${YELLOW}-------------------------------------------------------------------------------------------------------------------------------------------------------------------${NC}"

read -p "➡️  Нажмите Enter, чтобы продолжить..."

source $HOME/.bashrc

echo -e "${YELLOW}Инициализация конфигурации...${NC}"
gaianet init --config https://raw.githubusercontent.com/NodEligible/guides/main/gaianet/node-configs/$MODEL/config.json

echo -e "${YELLOW}Создаем сервис...${NC}"
cat <<EOF> /etc/systemd/system/gaianet.service
[Unit]
Description=GaiaNet Node Service
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/root/gaianet
ExecStartPre=/root/gaianet/bin/gaianet stop
ExecStart=/root/gaianet/bin/gaianet start
Restart=on-failure
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable gaianet.service
systemctl start gaianet.service

echo -e "${GREEN}Установка GaiaNet завершена!${NC}"
echo -e "${YELLOW}Проверка логов запуска${NC}"
echo "journalctl -u gaianet.service -f"


