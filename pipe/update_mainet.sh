#!/bin/bash
set -e

# Логотип
curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/display_logo.sh | bash

# Кольори
YELLOW='\e[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

cd /opt/pipe || { echo -e "${RED}❌ Директория /opt/pipe не найдена"; exit 1; }

echo -e "${YELLOW}🛑 Остановка сервиса PIPE...${NC}"
sudo systemctl stop pipe || echo -e "${RED}⚠️ Не удалось остановить сервис (возможно, он уже остановлен).${NC}"

sudo systemctl disable pipe || true
sudo systemctl daemon-reload

echo -e "${YELLOW}📦 Создание резервной копии данных ноды...${NC}"
BACKUP_DIR="/root/pipe_backup_$(date +"%Y%m%d_%H%M%S")"
mkdir -p "$BACKUP_DIR"

if [[ -f /opt/pipe/data/node_identity.key ]]; then
    cp /opt/pipe/data/node_identity.key "$BACKUP_DIR/"
    echo -e "${GREEN}✅ Файл node_identity.key сохранен в $BACKUP_DIR${NC}"
else
    echo -e "${RED}⚠️ Файл node_identity.key не найден!${NC}"
fi

if [[ -f /opt/pipe/data/node_state.json ]]; then
    cp /opt/pipe/data/node_state.json "$BACKUP_DIR/"
    echo -e "${GREEN}✅ Файл node_state.json сохранен в $BACKUP_DIR${NC}"
else
    echo -e "${RED}⚠️ Файл node_state.json не найден!${NC}"
fi

echo -e "${GREEN}📁 Резервная копия завершена. Каталог: $BACKUP_DIR${NC}"


echo -e "${YELLOW}🔄 Скачиваем последнюю версию PIPE...${NC}"
sudo curl -L https://pipe.network/p1-cdn/releases/latest/download/pop -o pop
# Перевірка чи pop дійсно викачався 
if [[ ! -f /opt/pipe/pop ]]; then
  echo -e "${RED}❌ Ошибка: не удалось скачать бинарный файл pop.${NC}"
  exit 1
else
  echo -e "${GREEN}✅ Файл pop успешно загружен!${NC}"
fi

sudo chmod +x pop

sudo systemctl daemon-reload
sudo systemctl enable pipe

echo -e "${YELLOW}🚀 Запуск сервиса PIPE...${NC}"
sudo systemctl start pipe && echo -e "${GREEN}✅ Сервис PIPE успешно запущен!${NC}" || echo -e "${RED}❌ Ошибка при запуске сервиса PIPE!${NC}"

echo -e "${GREEN}🎉 Обновление PIPE завершено успешно!${NC}"
