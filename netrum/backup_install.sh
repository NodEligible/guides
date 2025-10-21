#!/bin/bash

curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/display_logo.sh | bash

# === Цвета ===
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${YELLOW}═══════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}     🚀 Востановление Netrum Lite Node CLI (v2.0.0)${NC}"
echo -e "${YELLOW}═══════════════════════════════════════════════════════${NC}"
sleep 1

# === Проверка прав ===
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}❌ Запусти скрипт от имени root (sudo su)${NC}"
  exit 1
fi

# === Обновление системы ===
echo -e "${YELLOW}📦 Обновление системы...${NC}"
apt update -y && apt upgrade -y

# === Установка зависимостей ===
echo -e "${YELLOW}🔧 Установка необходимых пакетов...${NC}"
apt install -y curl bc jq speedtest-cli ufw git

# === Установка Node.js v20 ===
echo -e "${YELLOW}🧩 Проверка версии Node.js...${NC}"
if ! command -v node >/dev/null 2>&1; then
  echo -e "${RED}Node.js не найден. Устанавливаем v20...${NC}"
  curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
  apt install -y nodejs
else
  NODE_VER=$(node -v | sed 's/v//')
  NODE_MAJOR=$(echo "$NODE_VER" | cut -d. -f1)
  if [ "$NODE_MAJOR" -lt 20 ]; then
    echo -e "${YELLOW}🔁 Обновляем Node.js до v20...${NC}"
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
    apt install -y nodejs
  fi
fi

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

echo -e "${YELLOW}────────────────────────────────────────────────────────────${NC}"
echo -e "${GREEN}📦  Этап восстановления Netrum Lite Node из резервной копии${NC}"
echo -e "${YELLOW}────────────────────────────────────────────────────────────${NC}"
echo
echo -e "${YELLOW}1️⃣  Загрузите файлы вашего бэкапа в каталог:${NC}"
echo -e "    ${CYAN}/root/netrum-lite-node/${NC}"
echo
echo -e "${YELLOW}2️⃣  Удалите папки, которые были созданы при установке:${NC}"
echo -e "    ${RED}data${NC}  и  ${RED}src${NC}"
echo
echo -e "${YELLOW}3️⃣  Скопируйте свои папки из бэкапа на их место:${NC}"
echo -e "    ${GREEN}/root/netrum-lite-node/data${NC}"
echo -e "    ${GREEN}/root/netrum-lite-node/src${NC}"
echo
echo -e "${YELLOW}⚠️  ВАЖНО:${NC}"
echo -e "   - Структура каталогов должна оставаться такой же, как в бэкапе."
echo -e "   - Не изменяйте имена папок и файлов внутри data и src."
echo -e "   - После копирования проверьте права доступа:"

read -p "➡️  Нажмите Enter, чтобы продолжить..."

# пускаєм синхронізацію
netrum-sync
sleep 3

cd

echo -e "${YELLOW}Создание systemd netrum-mining:${NC}"
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

[Install]
WantedBy=multi-user.target
EOF

# === Активация сервиса ===
systemctl daemon-reload
systemctl enable netrum-mining
systemctl start netrum-mining

echo -e "${GREEN}✅ Установка и запуск Netrum Lite Node завершены!${NC}"
echo -e "${YELLOW}──────────────────────────────────────────────${NC}"
echo -e "${GREEN}📄 Логи синка:${NC} journalctl -fu netrum-node.service"
echo -e "${GREEN}📄 Логи майнера:${NC} tail -n 10 /var/log/netrum_mining.log"
echo -e "${YELLOW}──────────────────────────────────────────────${NC}"
