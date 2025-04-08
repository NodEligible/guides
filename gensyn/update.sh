#!/bin/bash

curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/display_logo.sh | bash

YELLOW='\e[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${YELLOW}Останавливаем ноду и запускаем обновление...${NC}"
sudo systemctl stop gensyn.service
cd $HOME/rl-swarm
git pull

echo -e "${YELLOW}Запускаем ноду...${NC}"
sudo systemctl start gensyn.service
echo -e "${GREEN}Обновление завершено!${NC}"
