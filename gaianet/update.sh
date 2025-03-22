#!/bin/bash

curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/display_logo.sh | bash

YELLOW='\e[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'


sudo systemctl stop gaia-bot.service

sleep 5

sed -i 's/await asyncio.sleep(1)/await asyncio.sleep(60)/g' /root/gaia-bot/gaia_bot.py

DATA_FILE="/root/gaianet_backup"

# 🔹 Перевіряємо, чи файл існує, якщо так — видаляємо перед скачуванням
if [[ -f "$DATA_FILE" || -f "$DATA_FILE".* ]]; then
    echo "⚠️ Файл $DATA_FILE вже існує. Видаляю..."
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
cp "$SOURCE_DIR/config.json" "$BACKUP_DIR/config.json"
cp "$SOURCE_DIR/nodeid.json" "$BACKUP_DIR/nodeid.json"
cp "$SOURCE_DIR/deviceid.txt" "$BACKUP_DIR/deviceid.txt"

echo -e "${GREEN}Бекап сделан!${NC}"

echo -e "${YELLOW}Обновляем GaiaNet...${NC}"
  curl -sSfL 'https://github.com/GaiaNet-AI/gaianet-node/releases/latest/download/install.sh' | bash
  if [ $? -eq 0 ]; then
      echo -e "${GREEN}Обновление завершено!${NC}"
  else
      echo -e "${RED}Ошибка при обновлении!${NC}"
  fi

sleep 3
# Удаляем новые файлы
rm -rf /root/gaianet/config.json
rm -rf /root/gaianet/nodeid.json
rm -rf /root/gaianet/deviceid.txt

sleep 3

cp "$BACKUP_DIR/config.json" "$SOURCE_DIR/config.json"
cp "$BACKUP_DIR/nodeid.json" "$SOURCE_DIR/nodeid.json"
cp "$BACKUP_DIR/deviceid.txt" "$SOURCE_DIR/deviceid.txt"

sleep 3

echo "export PATH=\$PATH:$HOME/gaianet/bin" >> $HOME/.bashrc

sleep 3

source $HOME/.bashrc

sleep 5

if ! command -v gaianet &> /dev/null; then
    rm -rf /root/gaianet_backup
    echo -e "${RED}❌ Ошибка: gaianet не найден! Путь $HOME/gaianet/bin не добавлен в PATH.${NC}"
    echo -e "${RED}------------------------------------------------------------------------${NC}"
    echo -e "${YELLOW}В случае ошибки выполняем следующие команды:${NC}"
    echo -e "1️⃣. source $HOME/.bashrc"
    echo -e "2️⃣. gaianet init"
    echo -e "3️⃣. gaianet start"
    echo -e "4️⃣. sudo systemctl start gaia-bot.service"
    exit 1
fi

# Удаляем бекап
rm -rf /root/gaianet_backup

echo -e "${YELLOW}Инициализация конфигурации...${NC}"
gaianet init

echo -e "${YELLOW}Старт${NC}"
gaianet start

sleep 10

systemctl daemon-reload
sudo systemctl start gaia-bot.service

echo -e "${GREEN}Обновление завершено!${NC}"
