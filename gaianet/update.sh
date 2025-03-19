#!/bin/bash

curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/display_logo.sh | bash

YELLOW='\e[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${YELLOW}Останавливаем GaiaNet...${NC}"
gaianet stop

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

sleep 2
# Удаляем новые файлы
rm -rf /root/gaianet/config.json
rm -rf /root/gaianet/nodeid.json
rm -rf /root/gaianet/deviceid.txt

sleep 2

cp "$BACKUP_DIR/config.json" "$SOURCE_DIR/config.json"
cp "$BACKUP_DIR/nodeid.json" "$SOURCE_DIR/nodeid.json"
cp "$BACKUP_DIR/deviceid.txt" "$SOURCE_DIR/deviceid.txt"

sleep 2

echo "export PATH=\$PATH:$HOME/gaianet/bin" >> $HOME/.bashrc

sleep 3

source $HOME/.bashrc

sleep 5

if ! command -v gaianet &> /dev/null; then
    echo -e "${RED}❌ Ошибка: gaianet не найден! Путь $HOME/gaianet/bin не добавлен в PATH.${NC}"
    echo -e "${RED}------------------------------------------------------------------------${NC}"
    echo -e "${YELLOW}В случае ошибки выполняем следующие команды:${NC}"
    echo -e "1️⃣. source $HOME/.bashrc"
    echo -e "2️⃣. gaianet init"
    echo -e "3️⃣. gaianet start"
    exit 1
fi

echo -e "${YELLOW}Инициализация конфигурации...${NC}"
gaianet init

echo -e "${YELLOW}Старт${NC}"
gaianet start

echo -e "${GREEN}Обновление завершено!${NC}"

