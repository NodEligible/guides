#!/bin/bash

# Відображення логотипу
curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/display_logo.sh | bash

YELLOW='\e[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${YELLOW}Установка Docker...${NC}"
bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/docker.sh)
if [ $? -eq 0 ]; then
     echo -e "${GREEN}Docker успешно установлено!${NC}"
else
     echo -e "${RED}Ошибка при установке Docker!${NC}"
fi

echo -e "${YELLOW}Установка Sonaric...${NC}"
sh -c "$(curl -fsSL http://get.sonaric.xyz/scripts/install.sh)"
echo -e "${GREEN}Установка завершена!${NC}"
