#!/bin/bash

curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/display_logo.sh | bash

# === Цвета ===
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${YELLOW}═══════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}     🔄 Обновление Netrum Lite Node CLI${NC}"
echo -e "${YELLOW}═══════════════════════════════════════════════════════${NC}"
sleep 1

BACKUP_DIR="/root/netrum_backup"
NODE_DIR="/root/netrum-lite-node"

echo -e "${YELLOW}📦 Проверка наличия папки бэкапа...${NC}"

if [ -d "$BACKUP_DIR" ]; then
  echo -e "${RED}⚠️ Папка ${BACKUP_DIR} уже существует. Удалите её или переименуйте перед созданием нового бэкапа.${NC}"
  exit 1
fi

echo -e "${YELLOW}🗂️ Создаю папку бэкапа...${NC}"
mkdir -p "$BACKUP_DIR"

echo -e "${YELLOW}📁 Копирую важные файлы...${NC}"
cp -r "$NODE_DIR/data" "$BACKUP_DIR/" 2>/dev/null
cp "$NODE_DIR/src/wallet/key.txt" "$BACKUP_DIR/" 2>/dev/null
cp "$NODE_DIR/src/identity/node-id/basename.txt" "$BACKUP_DIR/" 2>/dev/null
cp "$NODE_DIR/src/identity/node-id/id.txt" "$BACKUP_DIR/" 2>/dev/null

echo -e "${GREEN}✅ Бэкап успешно создан в ${BACKUP_DIR}${NC}"
sleep 3
echo -e "${YELLOW}🛑 Удаляем старые файлы если остались...${NC}"

systemctl stop netrum-mining &>/dev/null
systemctl disable netrum-mining &>/dev/null
systemctl daemon-reload
rm -rf /etc/systemd/system/netrum-mining.service

systemctl stop netrum-node &>/dev/null
systemctl disable netrum-node &>/dev/null
systemctl daemon-reload
rm -rf /root/netrum-lite-node
rm -rf /etc/systemd/system/netrum-node.service

# === Клонирование репозитория ===
cd /root
if [ -d "/root/netrum-lite-node" ]; then
  echo -e "${YELLOW}⚙️  Каталог уже существует, обновляем...${NC}"
  cd netrum-lite-node && git pull
else
  echo -e "${YELLOW}📥 Клонируем репозиторий...${NC}"
  git clone https://github.com/NetrumLabs/netrum-lite-node.git
  cd netrum-lite-node
fi

# === Установка npm-зависимостей ===
echo -e "${YELLOW}📦 Устанавливаем npm пакеты...${NC}"
npm install
npm link

sleep 3

echo -e "${YELLOW}📂 Проверяю наличие бэкапа...${NC}"

if [ ! -d "$BACKUP_DIR" ]; then
  echo -e "${RED}❌ Папка ${BACKUP_DIR} не найдена!${NC}"
  exit 1
fi

echo -e "${YELLOW}♻️ Восстанавливаю файлы на свои места...${NC}"
cp -r "$BACKUP_DIR/data" "$NODE_DIR/" 2>/dev/null
cp "$BACKUP_DIR/key.txt" "$NODE_DIR/src/wallet/" 2>/dev/null
cp "$BACKUP_DIR/basename.txt" "$NODE_DIR/src/identity/node-id/" 2>/dev/null
cp "$BACKUP_DIR/id.txt" "$NODE_DIR/src/identity/node-id/" 2>/dev/null

echo -e "${GREEN}✅ Восстановление завершено!${NC}"

sleep 3

# === Проверка кошелька ===
echo -e "${YELLOW}🔍 Проверяем кошелёк${NC}"
if ! netrum-wallet; then
  echo -e "${RED}❌ Кошелёк не найден или повреждён.${NC}"
  exit 1
fi

# пускаєм синхронізацію
netrum-sync
sleep 3

cd

# === Создание systemd сервиса ===
SERVICE_FILE="/etc/systemd/system/netrum-mining.service"
echo -e "${YELLOW}🛠 Создаём systemd сервис для майнинга...${NC}"
cat <<EOF > $SERVICE_FILE
[Unit]
Description=Netrum Lite Node - Mining Service
After=network.target

[Service]
User=root
WorkingDirectory=/root/netrum-lite-node
ExecStart=/usr/bin/node /root/netrum-lite-node/src/system/mining/live-log.js
Restart=always
RestartSec=10
StandardOutput=append:/var/log/netrum_mining.log
StandardError=append:/var/log/netrum_mining.log
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

# === Активация сервиса ===
systemctl daemon-reload
systemctl enable netrum-mining
systemctl start netrum-mining

echo -e "${GREEN}✅ Обновление Netrum Lite Node завершено!${NC}"
echo -e "${YELLOW}──────────────────────────────────────────────${NC}"
echo -e "${GREEN}📄 Логи синка:${NC} journalctl -fu netrum-node.service"
echo -e "${GREEN}📄 Логи майнера:${NC} tail -n 10 /var/log/netrum_mining.log"
echo -e "${YELLOW}──────────────────────────────────────────────${NC}"
