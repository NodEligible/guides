#!/bin/bash

YELLOW='\e[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${YELLOW}📝 Создание systemd-сервиса...${NC}"

cat <<EOF | sudo tee /etc/systemd/system/dill.service > /dev/null
[Unit]
Description=Dill node (via nohup)
After=network-online.target

[Service]
User=root
WorkingDirectory=/root/dill
ExecStart=/bin/bash -c '/root/dill/start_dill_node.sh && tail -f /dev/null'
Restart=always
RestartSec=10
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl enable dill
sudo systemctl daemon-reload
sudo systemctl start dill

echo -e "${GREEN}✅ Установка завершена!${NC}"
