#!/bin/bash

curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/display_logo.sh | bash

# Сменные для цветов
YELLOW='\e[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# Установка Main
  echo -e "${YELLOW}Установка Main...${NC}"
  bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/main.sh)
  if [ $? -eq 0 ]; then
      echo -e "${GREEN}Main успешно установлен!${NC}"
  else
      echo -e "${RED}Ошибка при установке Main!${NC}"
  fi


 # Установка Ufw
  echo -e "${YELLOW}Установка Ufw...${NC}" 
  bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/ufw.sh)
  if [ $? -eq 0 ]; then
      echo -e "${GREEN}Ufw успешно установлено!${NC}"
  else
      echo -e "${RED}Ошибка при установке Ufw!${NC}"
  fi

# Установка Go
  echo -e "${YELLOW}Установка Go...${NC}"
  bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/go.sh)
  if [ $? -eq 0 ]; then
      echo -e "${GREEN}Go успешно установлен!${NC}"
  else
      echo -e "${RED}Ошибка при установке Go!${NC}"
  fi

echo -e "${YELLOW}Установка майнера Hemi!${NC}"

cd $HOME
wget https://github.com/hemilabs/heminetwork/releases/download/v0.7.0/heminetwork_v0.7.0_linux_amd64.tar.gz

tar -xvf heminetwork_v0.7.0_linux_amd64.tar.gz && rm heminetwork_v0.7.0_linux_amd64.tar.gz
mv heminetwork_v0.7.0_linux_amd64 heminetwork
rm -rf $HOME/heminetwork_v0.7.0_linux_amd64

echo -e "${YELLOW}Создание кошелька${NC}"

echo "Выберите создавать кошелек или нет 1-да, 2-нет"
read CREATE_WALLET

if [ "$CREATE_WALLET" -eq 1 ]; then
    cd $HOME/heminetwork
    ./keygen -secp256k1 -json -net="testnet" > $HOME/heminetwork/popm-address.json
    PRIVATE_KEY=$(cat $HOME/heminetwork/popm-address.json | jq ".private_key")
fi

echo -e "${YELLOW}Запуск майнера${NC}"

# Проверка, имеет ли переменная значение
if [ -z "$PRIVATE_KEY" ]; then
    echo "Введите приватный ключ для запуска майнера"
    read PRIVATE_KEY
fi

sudo tee /etc/systemd/system/hemi.service > /dev/null <<EOF
[Unit]
Description=Hemi miner
After=network.target

[Service]
User=$USER
Environment="POPM_BTC_PRIVKEY=$PRIVATE_KEY"
Environment="POPM_STATIC_FEE=2000"
Environment="POPM_BFG_URL=wss://testnet.rpc.hemi.network/v1/ws/public"
WorkingDirectory=$HOME/heminetwork
ExecStart=$HOME/heminetwork/popmd
Restart=on-failure
RestartSec=10
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl enable hemi &>/dev/null
sudo systemctl daemon-reload
sudo systemctl start hemi

sleep 15

echo "Ваш адрес кошелька. Для работы майнера вам необходимо запросить токены в дискорде"
PUBLIC_ADDRESS=$(journalctl -n 100 -u hemi -o cat | grep -oP '(?<=address )[^\s]+')
echo "$PUBLIC_ADDRESS"

echo -e "${GREEN}Hemi майнер успешно установлен и запущен${NC}"
