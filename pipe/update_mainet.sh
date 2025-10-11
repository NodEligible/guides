#!/bin/bash

curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/display_logo.sh | bash

YELLOW='\e[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

cd /opt/pipe || { echo -e "${RED}❌ Директория /opt/pipe не найдена"; exit 1; }


echo -e "${YELLOW}🛑 Остановка сервиса PIPE...${NC}"
systemctl stop pipe
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Сервис PIPE остановлен!${NC}"
else
    echo -e "${RED}❌ Ошибка при остановке сервиса PIPE!${NC}"
fi

sudo systemctl disable pipe
sudo systemctl daemon-reload

echo -e "${YELLOW}🔄 Обновляем PIPE_TESTNET...${NC}"

sudo curl -L https://pipe.network/p1-cdn/releases/latest/download/pop -o pop
# Перевірка чи pop дійсно викачався 
if [[ ! -f /opt/pipe/pop ]]; then
  echo -e "${RED}❌ Ошибка: не удалось скачать бинарный файл pop.${NC}"
  exit 1
else
  echo -e "${GREEN}✅ Файл pop успешно загружен!${NC}"
fi

sudo systemctl daemon-reload
sudo systemctl enable pipe

echo -e "${YELLOW}🚀 Запуск сервиса PIPE...${NC}"
sudo systemctl start pipe
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Сервис PIPE успешно запущен!${NC}"
else
    echo -e "${RED}❌ Ошибка при запуске сервиса PIPE!${NC}"
fi

echo -e "${GREEN}✅ Обновление PIPE завершено!${NC}"
