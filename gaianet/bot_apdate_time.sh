#!/bin/bash

curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/display_logo.sh | bash

YELLOW='\e[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${YELLOW}⏱ Введите TIME (в секундах мин от 1 до 60 сек): ${NC}"
read TIME

sudo systemctl stop gaia-bot.service
sleep 2

# Заміна значення змінної SLEEP_TIME
sed -i "s|SLEEP_TIME = .*|SLEEP_TIME = ${TIME}|" /root/gaia-bot/gaia_bot.py

sleep 2
systemctl daemon-reload
sudo systemctl start gaia-bot.service

echo -e "${GREEN}✅ Gaia Bot перезапущен с новым временем ожидания: ${TIME} сек.${NC}"
