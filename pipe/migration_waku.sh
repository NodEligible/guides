#!/bin/bash

# Відображення логотипу
curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/display_logo.sh | bash

YELLOW='\e[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

cd $HOME/nwaku-compose

docker compose down

sed -i 's|127.0.0.1:8003:8003|127.0.0.1:8333:8003|' $HOME/nwaku-compose/docker-compose.yml
sed -i 's|- 80:80|- 1989:80|' $HOME/nwaku-compose/docker-compose.yml

docker compose up -d

echo -e "${GREEN}Миграция завершена!${NC}"
