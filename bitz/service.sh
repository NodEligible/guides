#!/bin/bash

curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/display_logo.sh | bash

YELLOW='\e[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${YELLOW}📝 Создание systemd-сервиса...${NC}"

# Створюємо директорію для логів
mkdir -p $HOME/bitz_service

cat <<EOF | sudo tee /etc/systemd/system/bitz.service > /dev/null
[Unit]
Description=Bitz Collect Miner Service
After=network.target

[Service]
User=root
ExecStart=/root/.cargo/bin/bitz collect --cores 4
Restart=always
RestartSec=10
LimitNOFILE=65535
StandardOutput=append:$HOME/bitz_service/bitz.log
StandardError=append:$HOME/bitz_service/bitz.log

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl enable bitz
sudo systemctl daemon-reload
sudo systemctl start bitz

echo -e "${GREEN}✅ Установка завершена!${NC}"
