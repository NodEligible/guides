#!/bin/bash

curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/display_logo.sh | bash

YELLOW='\e[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${YELLOW}Обновление Nexus...${NC}"
source /root/.bashrc

curl https://cli.nexus.xyz/ | sh
echo -e "${GREEN}Обновление Nexus завершено${NC}"
