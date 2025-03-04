#!/bin/bash

curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/display_logo.sh | bash

YELLOW='\e[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' 

echo -e "${YELLOW}Останавливаем Waku...${NC}"
docker-compose -f $HOME/nwaku-compose/docker-compose.yml down

echo -e "${YELLOW}Делаем замену порта...${NC}"
sed -i 's/0\.0\.0\.0:3000:3000/0.0.0.0:3004:3000/g' $HOME/nwaku-compose/docker-compose.yml

echo -e "${YELLOW}Запускаем Waku...${NC}"
docker-compose -f $HOME/nwaku-compose/docker-compose.yml up -d

echo -e "${GREEN}Миграция завершена!${NC}"

