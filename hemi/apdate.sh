#!/bin/bash

curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/display_logo.sh | bash

# Сменные для цветов
YELLOW='\e[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${YELLOW}Обновление Hemi...${NC}"

grep -qxF 'fs.inotify.max_user_watches=524288' /etc/sysctl.conf || echo 'fs.inotify.max_user_watches=524288' | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

systemctl stop hemi

cd $HOME

wget https://github.com/hemilabs/heminetwork/releases/download/v0.11.2/heminetwork_v0.11.2_linux_amd64.tar.gz

tar -xvf heminetwork_v0.11.2_linux_amd64.tar.gz && rm heminetwork_v0.11.2_linux_amd64.tar.gz
mv -f $HOME/heminetwork_v0.11.2_linux_amd64/* $HOME/heminetwork
rm -rf $HOME/heminetwork_v0.11.2_linux_amd64

sed -i "s|FEE=.*|FEE=1000\"|" /etc/systemd/system/hemi.service

sudo systemctl daemon-reload
sudo systemctl start hemi

echo -e "${GREEN}Hemi успешно обновлен!${NC}"
