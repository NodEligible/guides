#!/bin/bash
# ==========================================
# 🚀 Установка Netrum Lite Node CLI (v1.0)
# by NodEligible
# ==========================================

# === Цвета ===
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
CYAN='\033[0;36m'
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

# === Функція контролю етапів ===
pause_step() {
  echo -e "${CYAN}────────────────────────────────────────────${NC}"
  read -p "⏸️  Нажмите Enter, чтобы перейти к следующему шагу..."
  echo -e "${CYAN}────────────────────────────────────────────${NC}"
}

# === 1️⃣ Импорт кошелька ===
echo -e "${YELLOW}💰  Импорт существующего кошелька${NC}"
if ! netrum-import-wallet; then
  echo -e "${RED}❌ Ошибка при импорте кошелька.${NC}"
  exit 1
fi
pause_step

# === 2️⃣ Проверка кошелька ===
echo -e "${YELLOW}🔍 Проверяем кошелёк${NC}"
if ! netrum-wallet; then
  echo -e "${RED}❌ Кошелёк не найден или повреждён.${NC}"
  exit 1
fi
pause_step


# === 2️⃣ Проверка кошелька ===
echo -e "${YELLOW}📤  Выполняется экспорт приватного ключа${NC}"
if ! netrum-wallet-key; then
  echo -e "${RED}❌ Ошибка.${NC}"
  exit 1
fi
pause_step

# === 3️⃣ Создание Node ID ===
echo -e "${YELLOW}🆔 Создаём Node ID${NC}"
if ! netrum-node-id; then
  echo -e "${RED}❌ Не удалось создать Node ID.${NC}"
  exit 1
fi
pause_step

# === 4️⃣ Подпись узла ===
echo -e "${YELLOW}✍️  Подписываем сообщение ключом узла${NC}"
if ! netrum-node-sign; then
  echo -e "${RED}❌ Ошибка при подписи узла.${NC}"
  exit 1
fi
pause_step

# === 5️⃣ Регистрация ноды ===
echo -e "${YELLOW}🌐 Регистрируем ноду в сети (нужно немного BASE для газа)...${NC}"
if ! netrum-node-register; then
  echo -e "${RED}❌ Ошибка при регистрации ноды.${NC}"
  exit 1
fi
pause_step

# === 6️⃣ Запуск синхронизации ===
echo -e "${YELLOW}🔄 Запускаем синхронизацию${NC}"
if ! netrum-sync; then
  echo -e "${RED}❌ Ошибка при запуске синхронизации.${NC}"
  exit 1
fi
pause_step

# === 7️⃣ Активация майнинга ===
echo -e "${YELLOW}⚙️  Активируем майнинг и подписываем участие в сети${NC}"
echo -e "${YELLOW}⛏️  Этот процесс связывает ваш Node ID с контрактом вознаграждений.${NC}"
sleep 2

if ! netrum-mining; then
  echo -e "${RED}❌ Ошибка при активации майнинга или подписании узла.${NC}"
  echo -e "${YELLOW}💡 Проверьте, что ваш кошелёк имеет достаточно газа в сети Base.${NC}"
  echo -e "${YELLOW}💡 Также убедитесь, что регистрация ноды завершена без ошибок.${NC}"
  exit 1
fi

echo -e "${GREEN}✅ Майнинг успешно активирован!${NC}"

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

echo -e "${GREEN}✅ Установка и запуск Netrum Lite Node завершены!${NC}"
echo -e "${YELLOW}──────────────────────────────────────────────${NC}"
echo -e "${GREEN}📄 Логи синка:${NC} journalctl -fu netrum-node.service"
echo -e "${GREEN}📄 Логи майнера:${NC} tail -n 10 /var/log/netrum_mining.log"
echo -e "${YELLOW}──────────────────────────────────────────────${NC}"

echo -e "${YELLOW}──────────────────────${NC}"
echo -e "${GREEN}📦  Делаем бекап${NC}"
echo -e "${YELLOW}──────────────────────${NC}"
echo
echo -e "${YELLOW}📁  Сохраните две эти папки:${NC}"
echo -e "    ${CYAN}/root/netrum-lite-node/${NC}"
echo -e "    ├── ${GREEN}data${NC}  — содержит ваш кошелёк и ключи ноды"
echo -e "    └── ${GREEN}src${NC}   — хранит настройки и идентификатор узла"
echo
echo -e "${YELLOW}⚠️  Важно:${NC} без этих папок вы потеряете доступ к вашему кошельку и ноде!"

