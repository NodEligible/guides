#!/bin/bash

curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/display_logo.sh | bash

YELLOW='\e[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

cd /opt/popcache || { echo -e "${RED}❌ Директория /opt/popcache не найдена"; exit 1; }

echo -e "${YELLOW}🛑 Остановка сервиса PIPE...${NC}"
systemctl stop popcache.service
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Сервис PIPE остановлен!${NC}"
else
    echo -e "${RED}❌ Ошибка при остановке сервиса PIPE!${NC}"
fi

echo -e "${YELLOW}📥 Загрузка новой версии PIPE...${NC}"
wget https://download.pipe.network/static/pop-v0.3.1-linux-x64.tar.gz
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ PIPE успешно загружен!${NC}"
else
    echo -e "${RED}❌ Ошибка при загрузке PIPE!${NC}"
    exit 1
fi

echo -e "${YELLOW}🔄 Обновляем PIPE_TESTNET...${NC}"
rm -f pop
tar -xvzf pop-v0.3.1-linux-x64.tar.gz
rm -f pop-v0.3.1-linux-x64.tar.gz
chmod +x pop

echo -e "${YELLOW}🚀 Запуск сервиса PIPE...${NC}"
systemctl start popcache.service
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Сервис PIPE успешно запущен!${NC}"
else
    echo -e "${RED}❌ Ошибка при запуске сервиса PIPE!${NC}"
fi

echo -e "${GREEN}✅ Обновление PIPE завершено!${NC}"
