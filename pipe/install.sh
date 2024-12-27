#!/bin/bash

curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/display_logo.sh | bash

YELLOW='\e[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${YELLOW}Обновление пакетов...${NC}"
sudo apt update -y

  echo -e "${YELLOW}Установка Main...${NC}"
  bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/main.sh)
  if [ $? -eq 0 ]; then
      echo -e "${GREEN}Main успешно установлен!${NC}"
  else
      echo -e "${RED}Ошибка при установке Main!${NC}"
  fi
  
  echo -e "${YELLOW}Установка Ufw...${NC}" 
  bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/ufw.sh)
  if [ $? -eq 0 ]; then
      echo -e "${GREEN}Ufw успешно установлено!${NC}"
  else
      echo -e "${RED}Ошибка при установке Ufw!${NC}"
  fi


echo -e "${YELLOW}Установка PIPE...${NC}"

printf '%*s\n' 80 '' | tr ' ' '-'
echo -e "${YELLOW}Авторизация и регистрация${NC}"
printf '%*s\n' 80 '' | tr ' ' '-' 

echo "Введите PIPE URL: "
read PIPE

echo "Введите DCDND URL: "
read DCDND

cd $HOME
sudo mkdir -p $HOME/opt/dcdn

sudo wget -O $HOME/opt/dcdn/pipe-tool "$PIPE"
sudo wget -O $HOME/opt/dcdn/dcdnd "$DCDND"

sudo chmod +x $HOME/opt/dcdn/pipe-tool
sudo chmod +x $HOME/opt/dcdn/dcdnd

sudo ln -s $HOME/opt/dcdn/pipe-tool /usr/local/bin/pipe-tool -f
sudo ln -s $HOME/opt/dcdn/dcdnd /usr/local/bin/dcdnd -f

sudo tee /etc/systemd/system/dcdnd.service > /dev/null << EOF
[Unit]
Description=DCDN Node Service
After=network.target
Wants=network-online.target

[Service]
ExecStart=$(which dcdnd) \
                --grpc-server-url=0.0.0.0:8002 \
                --http-server-url=0.0.0.0:8003 \
                --node-registry-url="https://rpc.pipedev.network" \
                --cache-max-capacity-mb=1024 \
                --credentials-dir=/root/.permissionless \
                --allow-origin=*

Restart=always
RestartSec=5

LimitNOFILE=65536
LimitNPROC=4096

StandardOutput=journal
StandardError=journal
SyslogIdentifier=dcdn-node

WorkingDirectory=$HOME/opt/dcdn

[Install]
WantedBy=multi-user.target
EOF

echo "Авторизация и регистрация токена"

pipe-tool login --node-registry-url="https://rpc.pipedev.network"
pipe-tool generate-registration-token --node-registry-url="https://rpc.pipedev.network"


sudo systemctl daemon-reload
sudo systemctl enable dcdnd
sudo systemctl restart dcdnd

pipe-tool generate-wallet --node-registry-url="https://rpc.pipedev.network" --key-path=$HOME/.permissionless/key.json
pipe-tool link-wallet --node-registry-url="https://rpc.pipedev.network" --key-path=$HOME/.permissionless/key.json

echo -e "${GREEN}Установка PIPE завершена🚀${NC}"
