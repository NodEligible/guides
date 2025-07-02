#!/bin/bash

curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/display_logo.sh | bash

YELLOW='\e[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'


echo -e "${YELLOW} Выберите модель для установки:${NC}"
echo "1) phi-3-mini-instruct-4k (легкая, 2-3GB RAM, 1-2CPU)"
echo "2) qwen1.5-0.5b-instruct (легкая, 4-6GB RAM, 2+CPU)"
echo "3) qwen2-0.5b-instruct (баланс рекомендую ставить, 8–10GB RAM, 4+CPU)"
echo "4) mistral-0.3-7b-instruct (средне тяжелая, 12–14GB, 6+CPU)"
echo "5) llama-3.1-8b-instruct (тяжелая, 16-20GB RAM, 6+CPU)"

read -p "➜ Введите номер модели: " MODEL_CHOICE

case $MODEL_CHOICE in
  1) MODEL="phi-3-mini-instruct-4k" ;;
  2) MODEL="qwen1.5-0.5b-instruct" ;;
  3) MODEL="qwen2-0.5b-instruct" ;;
  4) MODEL="mistral-0.3-7b-instruct" ;;
  5) MODEL="llama-3.1-8b-instruct" ;;
  *) echo "❌ Неверный выбор. Выход."; exit 1 ;;
esac

echo -e "${YELLOW} Будет установлена модель:${NC}$MODEL"

echo -e "${YELLOW}Установка дополнительных пакетов скрыта...${NC}"
echo -e "${YELLOW}Установка Docker...${NC}"
bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/docker.sh) &>/dev/null


echo -e "${YELLOW}Обновление пакетов...${NC}"
sudo apt update && sudo apt upgrade -y &>/dev/null
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

sleep 2

# if ! command -v gaianet &> /dev/null; then
#     echo -e "${RED}❌ Ошибка: gaianet не найден! Путь $HOME/gaianet/bin не добавлен в PATH.${NC}"
#     echo -e "${RED}------------------------------------------------------------------------${NC}"
#     echo -e "${YELLOW}В случае ошибки выполняем следующие команды:${NC}"
#     echo -e "1️⃣ . source $HOME/.bashrc"
#     echo -e "2️⃣ . gaianet init --config https://raw.githubusercontent.com/GaiaNet-AI/node-configs/main/qwen2-0.5b-instruct/config.json"
#     echo -e "3️⃣ . gaianet start"
#     exit 1
# fi

echo -e "${YELLOW}Инициализация конфигурации...${NC}"
gaianet init --config "https://raw.githubusercontent.com/NodEligible/guides/main/gaianet/node-configs/$MODEL/config.json"

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
