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

# Видалення попередніх архівів
rm -f pop-v0.3.2-linux-x64.tar.gz pop-v0.3.2-linux-x64.tar.gz.* 2>/dev/null

# Завантаження з перезаписом
# wget -O pop-v0.3.2-linux-x64.tar.gz https://download.pipe.network/static/pop-v0.3.2-linux-x64.tar.gz
wget https://download.pipe.network/static/pop-v0.3.2-linux-x64.tar.gz
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ PIPE успешно загружен!${NC}"
else
    echo -e "${RED}❌ Ошибка при загрузке PIPE!${NC}"
    exit 1
fi

echo -e "${YELLOW}🔄 Обновляем PIPE_TESTNET...${NC}"

# Видалення старого бінарника
rm -f pop

# Розпакування архіву
tar -xvzf pop-v0.3.2-linux-x64.tar.gz
if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Ошибка при распаковке архива!${NC}"
    exit 1
fi

# Очищення архіву після розпакування
rm -f pop-v0.3.2-linux-x64.tar.gz pop-v0.3.2-linux-x64.tar.gz.*

# Надання прав на виконання
chmod +x pop

echo -e "${YELLOW}🚀 Запуск сервиса PIPE...${NC}"
systemctl start popcache.service
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Сервис PIPE успешно запущен!${NC}"
else
    echo -e "${RED}❌ Ошибка при запуске сервиса PIPE!${NC}"
fi

echo -e "${GREEN}✅ Обновление PIPE завершено!${NC}"
