#!/bin/bash

# Отображение логотипа
curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/display_logo.sh | bash

# Цвета
YELLOW='\e[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

INSTALL_DIR="/root/multiple_service"
echo -e "${YELLOW}📁 Создание папки $INSTALL_DIR...${NC}"
mkdir -p "$INSTALL_DIR"

CONFIG_FILE="/root/multiple_service/multiple_config"

# Запрос данных у пользователя
echo -e "${YELLOW}🔹 Введите ваш IDENTIFIER:${NC}"
read -p "> " IDENTIFIER
echo -e "${YELLOW}🔹 Введите ваш PIN:${NC}"
read -p "> " PIN

# Проверка на пустые значения
if [[ -z "$IDENTIFIER" || -z "$PIN" ]]; then
    echo -e "${RED}❌ Ошибка: IDENTIFIER или PIN не могут быть пустыми!${NC}"
    exit 1
fi

# Инфо: Сохраняем конфигурацию
echo -e "${YELLOW}💾 Сохраняем конфигурацию...${NC}"
sudo tee $CONFIG_FILE > /dev/null <<< "IDENTIFIER=$IDENTIFIER"
sudo tee -a $CONFIG_FILE > /dev/null <<< "PIN=$PIN"
sudo chmod 600 $CONFIG_FILE

# Инфо: Конфигурация сохранена
echo -e "${GREEN}✅ Конфигурация сохранена в $CONFIG_FILE${NC}"

# Инфо: Создаём systemd-сервис
echo -e "${YELLOW}⚙️ Создаём systemd-сервис...${NC}"
SERVICE_FILE="/etc/systemd/system/multiple-healthcheck.service"

sudo tee $SERVICE_FILE > /dev/null <<EOF
[Unit]
Description=Multiple Health Check Service
After=network.target

[Service]
User=root
EnvironmentFile=$CONFIG_FILE
ExecStart=/bin/bash -c 'bash <(curl -s https://raw.githubusercontent.com/NodEligible/guides/main/multiple/healthcheck.sh) \$IDENTIFIER \$PIN'
Restart=always
RestartSec=10
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF

# Инфо: Запуск сервиса
echo -e "${YELLOW}🚀 Запускаем сервис multiple-healthcheck...${NC}"
sudo systemctl daemon-reload
sudo systemctl enable multiple-healthcheck
sudo systemctl start multiple-healthcheck
echo -e "${GREEN}✅ Установка завершена! Сервис запущен.${NC}"

