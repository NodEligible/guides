#!/bin/bash

curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/display_logo.sh | bash

YELLOW='\e[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${YELLOW}Останавливаем сервис...${NC}"
sudo systemctl stop gaianet-monitor

echo -e "${YELLOW}Останавливаем gaia-bot...${NC}"
sudo systemctl stop gaia-bot.service

sleep 2

DATA_FILE="/root/gaianet_backup"

# 🔹 Перевіряємо, чи файл існує, якщо так — видаляємо перед скачуванням
if [[ -f "$DATA_FILE" || -f "$DATA_FILE".* ]]; then
    echo "⚠️ Файл $DATA_FILE уже существует. Удаляю..."
    sudo rm -f "$DATA_FILE" "$DATA_FILE".*
fi

echo -e "${YELLOW}Останавливаем GaiaNet...${NC}"
gaianet stop

sleep 5
echo -e "${YELLOW}Делаем бекап GaiaNet...${NC}"

# Налаштування директорій
SOURCE_DIR="/root/gaianet"
BACKUP_DIR="/root/gaianet_backup"

# Перевіряємо, чи існує директорія для бекапу, якщо ні – створюємо її
mkdir -p "$BACKUP_DIR"

# Копіюємо потрібні файли
# cp "$SOURCE_DIR/config.json" "$BACKUP_DIR/config.json"
cp "$SOURCE_DIR/nodeid.json" "$BACKUP_DIR/nodeid.json"
cp "$SOURCE_DIR/deviceid.txt" "$BACKUP_DIR/deviceid.txt"

echo -e "${GREEN}Бекап сделан!${NC}"

# Удаляем гаю
curl -sSfL 'https://github.com/GaiaNet-AI/gaianet-node/releases/latest/download/uninstall.sh' | bash
rm -rf ~/gaia.sh 
rm -rf ~/.wasmedge
rm -rf ~/.bash_profile.gaianet_backup
rm -rf ~/.bash_profile.wasmedge_backup
rm -rf ~/.bashrc.gaianet_backup
rm -rf ~/.bashrc.wasmedge_backup
rm -rf ~/.profile.wasmedge_backup

systemctl daemon-reload


echo -e "${YELLOW}Обновляем GaiaNet...${NC}"
  curl -sSfL 'https://github.com/GaiaNet-AI/gaianet-node/releases/latest/download/install.sh' | bash
  if [ $? -eq 0 ]; then
      echo -e "${GREEN}Обновление завершено!${NC}"
  else
      echo -e "${RED}Ошибка при обновлении!${NC}"
  fi

sleep 3
# Удаляем новые файлы
# rm -rf /root/gaianet/config.json
rm -rf /root/gaianet/nodeid.json
rm -rf /root/gaianet/deviceid.txt

sleep 3

# cp "$BACKUP_DIR/config.json" "$SOURCE_DIR/config.json"
cp "$BACKUP_DIR/nodeid.json" "$SOURCE_DIR/nodeid.json"
cp "$BACKUP_DIR/deviceid.txt" "$SOURCE_DIR/deviceid.txt"

sleep 3

echo "export PATH=\$PATH:$HOME/gaianet/bin" >> $HOME/.bashrc

sleep 3

ln -sf /root/gaianet/bin/gaianetup /usr/local/bin/gaianetup

source $HOME/.bashrc

sleep 5

if ! command -v gaianet &> /dev/null; then
    echo -e "${RED}❌ Ошибка: gaianet не найден! Путь $HOME/gaianet/bin не добавлен в PATH.${NC}"
    echo -e "${RED}------------------------------------------------------------------------${NC}"
    echo -e "${YELLOW}В случае ошибки выполняем следующие команды:${NC}"
    echo -e "1️⃣ . source $HOME/.bashrc"
    echo -e "2️⃣ . https://raw.githubusercontent.com/NodEligible/guides/main/gaianet/node-configs/qwen2-0.5b-instruct/config.json"
    echo -e "3️⃣ . gaianet start"
    echo -e "4️⃣ . bash <(curl -s https://raw.githubusercontent.com/NodEligible/monitoring/main/node_service/gaianet.sh)"
    exit 1
fi

echo -e "${YELLOW}Инициализация конфигурации...${NC}"
gaianet init --config https://raw.githubusercontent.com/NodEligible/guides/main/gaianet/node-configs/qwen2-0.5b-instruct/config.json

echo -e "${YELLOW}Старт${NC}"
gaianet start

sleep 5

echo -e "${YELLOW}Запускаем сервис...${NC}"
sudo systemctl start gaianet-monitor

echo -e "${YELLOW}Запускаем gaia-bot${NC}"
sudo systemctl start gaia-bot.service

# Удаляем бекап
rm -rf /root/gaianet_backup

echo -e "${GREEN}Обновление завершено!${NC}"
echo -e "${GREEN}Текущая версия!${NC}"
gaianet --version

echo -e "📋${YELLOW} Для просмотра логов бота используйте команду:${NC}"
echo -e "sudo journalctl -u gaia-bot -f"

echo -e "${YELLOW}📋 Для просмотра логов сервиса используйте команду:${NC}"
echo -e "tail -n 100 -f ~/gaianet_service/monitor.log"
