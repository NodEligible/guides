#!/bin/bash

YELLOW='\e[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[38;5;81m'
NC='\033[0m'

echo -e "${YELLOW}Удаляем сервис${NC}"
sudo systemctl stop gaianet-monitor  &>/dev/null
sudo systemctl disable gaianet-monitor &>/dev/null
systemctl daemon-reload
rm -rf /root/gaianet_service &>/dev/null
rm -rf /etc/systemd/system/gaianet-monitor.service &>/dev/null

echo -e "${YELLOW}Удаляем ноду${NC}"
gaianet stop

sleep 2

curl -sSfL 'https://github.com/GaiaNet-AI/gaianet-node/releases/latest/download/uninstall.sh' | bash
rm -rf ~/gaia.sh 

rm -rf ~/.wasmedge

rm -rf ~/.bash_profile.gaianet_backup

rm -rf ~/.bash_profile.wasmedge_backup

rm -rf ~/.bashrc.gaianet_backup

rm -rf ~/.bashrc.wasmedge_backup

rm -rf ~/.profile.wasmedge_backup

systemctl daemon-reload
echo -e "${GREEN}Удаление завершено!${NC}"
