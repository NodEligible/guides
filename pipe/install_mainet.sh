#!/bin/bash
# ================================================
# 🚀 PipeCDN Node Mainnet Auto-Installer
# ================================================

YELLOW='\033[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# === 1. Перевірка ОС ===
if [[ $(lsb_release -is) != "Ubuntu" && $(lsb_release -is) != "Debian" ]]; then
  echo -e "${RED}❌ Поддерживаются только Ubuntu 22.04+ или Debian 11+.${NC}"
  exit 1
fi

# Запрос інфи
# =====================================================================
# Автовизначення локації
CITY=$(curl -s ipinfo.io/city)
COUNTRY=$(curl -s ipinfo.io/country)
DEFAULT_LOCATION="${CITY}, ${COUNTRY}"
read -rp "➡️ Локация (Enter = ${DEFAULT_LOCATION}): " NODE_LOCATION
NODE_LOCATION=${NODE_LOCATION:-$DEFAULT_LOCATION}
# =====================================================================
# Адрес кошелька
# === Перевірка Solana wallet адреси ===
while true; do
  read -rp "➡️ Введите Solana wallet address: " WALLET
  if [[ "$WALLET" =~ ^[1-9A-HJ-NP-Za-km-z]{32,44}$ ]]; then
    echo -e "✅ Адрес Solana правильный."
    break
  else
    echo -e "❌ Неверный формат! Публичный Solana-адрес должен состоять из 32–44 символов Base58 (без '0x')."
  fi
done
# Назва ноди
read -rp "➡️ Введите имя ноды (NODE_NAME): " NODE_NAME
# Пошта
read -rp "➡️ Введите email оператора: " NODE_EMAIL
# RAM кеш
read -rp "➡️ Размер RAM-кэша в MB (рекомендовано 512, Enter чтобы принять): " MEMORY_CACHE
if [[ -z "$MEMORY_CACHE" ]]; then
  MEMORY_CACHE=512
  echo -e "🟢 Используется значение по умолчанию: ${MEMORY_CACHE} MB"
else
  echo -e "✅ Установлено пользовательское значение: ${MEMORY_CACHE} MB"
fi

# Дисковий кеш
read -rp "➡️ Размер дискового кэша в GB (рекомендовано 100, Enter чтобы принять): " DISK_CACHE
if [[ -z "$DISK_CACHE" ]]; then
  DISK_CACHE=100
  echo -e "🟢 Используется значение по умолчанию: ${DISK_CACHE} GB"
else
  echo -e "✅ Установлено пользовательское значение: ${DISK_CACHE} GB"
fi
# =====================================================================
echo -e "${YELLOW}🔧 Начинаем установку PipeCDN Node...${NC}"
sleep 1

# === 2. Оновлення системи ===
echo -e "${YELLOW}📦 Обновление системы ...${NC}"
sudo apt update -y &>/dev/null
sudo apt upgrade -y &>/dev/null

bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/main.sh) &>/dev/null
bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/ufw.sh) &>/dev/null
sudo apt install gawk bison build-essential manpages-dev ca-certificates -y &>/dev/null

# === 3. Встановлення залежностей ===
sudo apt install -y &>/dev/null
curl lsof jq ufw &>/dev/null

# === 4. Створення директорії ===
echo -e "${YELLOW}📁 Создаем /opt/pipe ...${NC}"
sudo mkdir -p /opt/pipe && cd /opt/pipe || exit 1

# === 5. Завантаження останнього binary ===
echo -e "${YELLOW}⬇️ Загрузка последнего релиза pop...${NC}"
sudo curl -L https://pipe.network/p1-cdn/releases/latest/download/pop -o pop
# Перевірка чи pop дійсно викачався 
if [[ ! -f /opt/pipe/pop ]]; then
  echo -e "${RED}❌ Ошибка: не удалось скачать бинарный файл pop.${NC}"
  exit 1
else
  echo -e "${GREEN}✅ Файл pop успешно загружен!${NC}"
fi

sudo chmod +x pop

# === 6. Створення .env ===
echo -e "${YELLOW}🧾 Создаем .env файл...${NC}"

sudo tee /opt/pipe/.env > /dev/null <<EOF
# PipeCDN Node Configuration

NODE_SOLANA_PUBLIC_KEY=$WALLET
NODE_NAME=$NODE_NAME
NODE_EMAIL="$NODE_EMAIL"
NODE_LOCATION="$NODE_LOCATION"

MEMORY_CACHE_SIZE_MB=$MEMORY_CACHE
DISK_CACHE_SIZE_GB=$DISK_CACHE
DISK_CACHE_PATH=./cache

HTTP_PORT=80
HTTPS_PORT=443

UPNP_ENABLED=false
EOF

# === 7. Налаштування UFW ===
echo -e "${YELLOW}🧱 Открываем порты 80 і 443...${NC}"
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw reload

# === 8. Створення systemd сервісу ===
echo -e "${YELLOW}⚙️ Создание systemd сервиса...${NC}"

sudo tee /etc/systemd/system/pipe.service > /dev/null <<EOF
[Unit]
Description=Pipe Network POP Node
After=network-online.target
Wants=network-online.target

[Service]
WorkingDirectory=/opt/pipe
ExecStart=/bin/bash -c 'source /opt/pipe/.env && /opt/pipe/pop'
Restart=always
RestartSec=5
StandardOutput=journal
StandardError=journal
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

# === 9. Активація сервісу ===
echo -e "${YELLOW}🚀 Запуск сервиса Pipe...${NC}"
sudo systemctl daemon-reload
sudo systemctl enable pipe
sudo systemctl start pipe

sleep 2
if systemctl is-active --quiet pipe; then
  echo -e "${GREEN}✅ PipeCDN нода успешно запущена!${NC}"
else
  echo -e "${RED}❌ Ошибка при запуске сервиса! Проверьте логи: sudo journalctl -u pipe -f${NC}"
  exit 1
fi

# === 10. Перевірка статусу ===
echo -e "${YELLOW}🩺 Проверка состояния...${NC}"
sleep 3
curl -s http://localhost:8081/health || echo -e "${RED}❌ Не удалось подключиться к /health${NC}"

echo -e "${GREEN}🎉 Установка завершена!${NC}"
echo -e "${GREEN}Проверить логи: sudo journalctl -u pipe -f${NC}"
echo -e "${GREEN}Проверить статус: curl http://localhost:8081/health${NC}"
