#!/bin/bash

curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/display_logo.sh | bash

YELLOW='\e[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${YELLOW}Остановка ноди${NC}"
pkill -f "./verifier"

sleep 2

echo -e "${YELLOW}Удаляем двоичный файл${NC}"
rm -rf /root/cysic-verifier/data/cysic-verifier.db

sleep 2

echo -e "${GREEN}Запуск ноди${NC}"
cd /root/cysic-verifier && bash start.sh > /root/cysic-verifier/logs.txt 2>&1 &

sleep 1

echo -e "${YELLOW}Проверка логов${NC}"
tail -f /root/cysic-verifier/logs.txt
