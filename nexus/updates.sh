#!/bin/bash

curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/display_logo.sh | bash

YELLOW='\e[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${YELLOW}Обновление Nexus...${NC}"
systemctl stop nexus

cd $HOME/.nexus/network-api

git fetch
git -c advice.detachedHead=false checkout $(git rev-list --tags --max-count=1)

cd $HOME/.nexus/network-api/clients/cli
cargo build --release --bin prover

rm -rf $HOME/.nexus/network-api/clients/cli/prover
cp $HOME/.nexus/network-api/clients/cli/target/release/prover $HOME/.nexus/network-api/clients/cli/prover

systemctl start nexus
echo -e "${GREEN}Обновление Nexus завершено${NC}"
