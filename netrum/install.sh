#!/bin/bash
# ==========================================
# 🚀 Установка Netrum Lite Node CLI (v1.0)
# by NodEligible
# ==========================================

# === Цвета ===
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${YELLOW}═══════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}     🚀 Установка Netrum Lite Node CLI (v2.0.0)${NC}"
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
cd /opt
if [ -d "/opt/netrum-lite-node" ]; then
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

# === Создание или импорт кошелька ===
echo -e "${YELLOW}💰 Хочешь создать новый кошелёк или импортировать существующий?${NC}"
echo -e "${GREEN}1${NC}) Создать новый"
echo -e "${GREEN}2${NC}) Импортировать (по приватному ключу)"
read -p "➡️ Выбор [1/2]: " WALLET_OPTION

if [ "$WALLET_OPTION" == "2" ]; then
  echo -e "${YELLOW}➡️ Импортируем кошелёк...${NC}"
  netrum-import-wallet
else
  echo -e "${YELLOW}➡️ Создаём новый кошелёк...${NC}"
  netrum-new-wallet
fi
# Тут створити таймер і попередження якщо створюєте новий кош то тре закинути туди ефір в бейсі на 6$ 


# Створюємо id файл
netrum-node-id
# Підписати повідомлення ключем вузла
netrum-node-sign

# === Регистрация ноды ===
echo -e "${YELLOW}🌐 Регистрируем ноду в сети (нужно немного BASE для газа)...${NC}"
netrum-node-register

# Запускаєм синхронізацію
netrum-sync
# Запускаєм майнінг
netrum-mining

exit 1

# === Создание systemd сервиса ===
SERVICE_FILE="/etc/systemd/system/netrum.service"
echo -e "${YELLOW}🛠 Создаём systemd сервис...${NC}"
cat <<EOF > $SERVICE_FILE
[Unit]
Description=Netrum Lite Node CLI
After=network.target

[Service]
User=root
WorkingDirectory=/opt/netrum-lite-node
ExecStart=/usr/bin/netrum-mining
Restart=always
RestartSec=10
StandardOutput=append:/var/log/netrum.log
StandardError=append:/var/log/netrum.log

[Install]
WantedBy=multi-user.target
EOF

# === Активация сервиса ===
systemctl daemon-reload
systemctl enable netrum
systemctl start netrum

echo -e "${GREEN}✅ Установка и запуск Netrum Lite Node завершены!${NC}"
echo -e "${YELLOW}──────────────────────────────────────────────${NC}"
echo -e "${GREEN}📍 Проверить статус:${NC}  systemctl status netrum"
echo -e "${GREEN}📄 Логи:${NC}          tail -f /var/log/netrum.log"
echo -e "${GREEN}💰 Клейм наград:${NC}  netrum-claim"
echo -e "${GREEN}🧩 Инфо о кошельке:${NC} netrum-wallet"
echo -e "${YELLOW}──────────────────────────────────────────────${NC}"
