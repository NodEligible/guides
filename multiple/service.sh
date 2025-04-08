#!/bin/bash

# Отображение логотипа
curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/display_logo.sh | bash

# Цвета
YELLOW='\e[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

CONFIG_FILE="/root/multiple_service"

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

# Сохраняем данные в файл
echo -e "${YELLOW}💾 Сохраняем конфигурацию...${NC}"
echo "IDENTIFIER=$IDENTIFIER" | sudo tee $CONFIG_FILE > /dev/null
echo "PIN=$PIN" | sudo tee -a $CONFIG_FILE > /dev/null
sudo chmod 600 $CONFIG_FILE
echo -e "${GREEN}✅ Конфигурация сохранена в $CONFIG_FILE${NC}"

# Создаём systemd-сервис
SERVICE_FILE="/etc/systemd/system/multiple-healthcheck.service"

echo -e "${YELLOW}⚙️ Создаём systemd-сервис...${NC}"

echo "[Unit]
Description=Multiple Health Check Service
After=network.target

[Service]
User=$USER
EnvironmentFile=$CONFIG_FILE
ExecStart=/bin/bash -c 'bash <(curl -s https://raw.githubusercontent.com/NodEligible/guides/main/multiple/healthcheck.sh) \$IDENTIFIER \$PIN'
Restart=always
RestartSec=10
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target" | sudo tee $SERVICE_FILE > /dev/null

# Запускаем сервис
echo -e "${YELLOW}🚀 Запускаем сервис multiple-healthcheck...${NC}"
sudo systemctl daemon-reload
sudo systemctl enable multiple-healthcheck
sudo systemctl start multiple-healthcheck

echo -e "${GREEN}✅ Установка завершена! Сервис запущен.${NC}"

