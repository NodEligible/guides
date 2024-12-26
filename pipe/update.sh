#!/bin/bash

curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/display_logo.sh | bash

YELLOW='\e[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${YELLOW}Обновление PIPE${NC}"

echo "Введите PIPE URL: "
read PIPE

echo "Введите DCDND URL: "
read DCDND

if [[ -z "$PIPE" || -z "$DCDND" ]]; then
    echo "Ошибка: Введите оба URL."
    exit 1
fi

sudo systemctl stop dcdnd

sudo rm -f $HOME/opt/dcdn/pipe-tool
sudo rm -f $HOME/opt/dcdn/dcdnd


sudo curl -L "$PIPE" -o $HOME/opt/dcdn/pipe-tool
sudo curl -L "$DCDND" -o $HOME/opt/dcdn/dcdnd

sudo chmod +x $HOME/opt/dcdn/pipe-tool
sudo chmod +x $HOME/opt/dcdn/dcdnd


pipe-tool login --node-registry-url="https://rpc.pipedev.network"
pipe-tool generate-registration-token --node-registry-url="https://rpc.pipedev.network"

sudo systemctl daemon-reload
sudo systemctl start dcdnd

pipe-tool list-nodes --node-registry-url="https://rpc.pipedev.network"

echo -e "${GREEN}Обновление PIPE завершено!${NC}"
