#!/bin/bash

curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/display_logo.sh | bash

YELLOW='\e[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[38;5;81m'
NC='\033[0m'

echo -e "${YELLOW}Останавливаем drosera${NC}"
sudo systemctl stop drosera
source /root/.profile
echo -e "${YELLOW}Обновляемм Drosera${NC}"
curl -s -L https://app.drosera.io/install | bash

sudo ln -sf /root/.drosera/bin/drosera-operator /usr/local/bin/drosera-operator

droseraup

if [ ! -f drosera.toml ]; then
  cd drosera
fi
echo -e "${YELLOW}Обновляем drosera_rpc${NC}"
sed -i 's|^drosera_rpc =.*|drosera_rpc = "https://relay.testnet.drosera.io"|' drosera.toml

# get private key to do drosera apply with it
SERVICE_FILE="/etc/systemd/system/drosera.service"
private_key=$(grep 'ExecStart=' "$SERVICE_FILE" | sed -n 's/.*--eth-private-key \([^ ]*\).*/\1/p')
echo "drosera apply --private-key="$private_key""

sudo systemctl start drosera
echo -e "${GREEN}Обновление завершено!${NC}"

