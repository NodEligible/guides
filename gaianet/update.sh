#!/bin/bash

curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/display_logo.sh | bash

YELLOW='\e[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

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

# Виводимо повідомлення про завершення
echo -e "${GREEN}Бекап сделан!${NC}"
