#!/bin/bash

curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/display_logo.sh | bash

YELLOW='\e[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${YELLOW}Обновление Nexus...${NC}"
source $HOME/.cargo/env

cd $HOME/.nexus/network-api
git stash
git fetch --tags
git -c advice.detachedHead=false checkout $(git rev-list --tags --max-count=1)

cd $HOME/.nexus/network-api/clients/cli && cargo run -r -- start --env beta
echo -e "${GREEN}Обновление Nexus завершено${NC}"
