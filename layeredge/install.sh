#!/bin/bash

curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/display_logo.sh | bash

YELLOW='\e[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${YELLOW}Установка Main...${NC}"
  bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/main.sh)
  if [ $? -eq 0 ]; then
      echo -e "${GREEN}Main успешно установлен!${NC}"
  else
      echo -e "${RED}Ошибка при установке Main!${NC}"
      exit 1
  fi

  echo -e "${YELLOW}Установка Ufw...${NC}" 
  bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/ufw.sh)
  if [ $? -eq 0 ]; then
      echo -e "${GREEN}Ufw успешно установлено!${NC}"
  else
      echo -e "${RED}Ошибка при установке Ufw!${NC}"
      exit 1
  fi

echo -e "${YELLOW}Удаляем Go...${NC}"
sudo rm -rf /usr/local/go
rm -rf ~/go ~/.cache/go-build ~/.config/go
sudo apt remove --purge -y golang-go
sudo apt autoremove -y
sudo snap remove go || true
sed -i '/\/usr\/local\/go\/bin/d' ~/.profile ~/.bashrc ~/.zshrc || true

echo -e "${YELLOW}Устанавливаем Go...${NC}"
wget https://golang.org/dl/go1.22.1.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.22.1.linux-amd64.tar.gz
rm go1.22.1.linux-amd64.tar.gz
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.profile
source ~/.bashrc
source ~/.profile
echo -e "${GREEN}Go установлена: $(go version)${NC}"

echo -e "${YELLOW}Удаляем Rust and Cargo...${NC}"
rustup self uninstall -y || true
rm -rf ~/.cargo ~/.rustup
sudo apt remove --purge -y rustc cargo
sudo apt autoremove -y
sed -i '/\.cargo\/bin/d' ~/.bashrc ~/.zshrc || true

echo -e "${YELLOW}Устанавливаем Rust и Cargo...${NC}"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source $HOME/.cargo/env
echo "Rust установлен: $(rustc --version)"
sleep 1
echo "Весь необходимый софт установлен"

function get_private_key() {
  while true; do
    read -p "Введите private key вашего кошелька (без 0х): " private_key_value

    if [[ $private_key_value == 0x* ]]; then
      echo "Error: Private key should not start with '0x'. Please try again."
    else
      echo "Private key accepted."
      break
    fi
  done
}

get_private_key

curl -L https://risczero.com/install | bash && rzup install
source ~/.bashrc
if [ -d "light-node" ]; then
  rm -rf "light-node"
fi
git clone https://github.com/Layer-Edge/light-node.git
cd light-node

cat > .env <<EOL
GRPC_URL=34.31.74.109:9090
CONTRACT_ADDR=cosmos1ufs3tlq4umljk0qfe8k5ya0x6hpavn897u2cnf9k0en9jr7qarqqt56709
ZK_PROVER_URL=http://127.0.0.1:3001
API_REQUEST_TIMEOUT=100
POINTS_API=http://127.0.0.1:8080
PRIVATE_KEY='${private_key_value}'
EOL

echo ".env файл создан"
cd risc0-merkle-service

if tmux has-session -t risc_service 2>/dev/null; then
    tmux kill-session -t risc_service
fi
tmux new-session -d -s risc_service "cargo build && cargo run"
echo "risc0 сервис запущен (tmux session risc_service)"

echo -e "${YELLOW}Начинаю билдить Go${NC}"
cd ..
go build
echo "Сбилдили light-node, запускаем как systemd сервис"

SERVICE_NAME="light-node"
EXECUTABLE_PATH="/root/light-node/light-node"
WORKING_DIR="/root/light-node/"
LOG_FILE="/var/log/light_node.log"
SERVICE_FILE="/etc/systemd/system/$SERVICE_NAME.service"

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root. Use sudo."
   exit 1
fi

cat <<EOF > $SERVICE_FILE
[Unit]
Description=Light Node Service
After=network.target

[Service]
ExecStart=$EXECUTABLE_PATH
Restart=always
RestartSec=60
User=root
WorkingDirectory=$WORKING_DIR
StandardOutput=append:$LOG_FILE
StandardError=append:$LOG_FILE
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF

chmod 644 $SERVICE_FILE

echo "Перезапускаем systemd"
systemctl daemon-reload
systemctl enable $SERVICE_NAME

echo "Стартуем сервис $SERVICE_NAME"
systemctl start $SERVICE_NAME

echo -e "${YELLOW}light-node запущена, ждем свой public key${NC}"

log_file="/var/log/light_node.log"

check_public_key() {
  parsed_key=$(tail -n 1000 "$log_file" | grep -oP 'Compressed Public Key: \K[0-9a-fA-F]+')

  if [[ -n "$parsed_key" ]]; then
    echo -e "${GREEN}Ваш Public Key:${NC} $parsed_key"
    return 0
  else
    return 1
  fi
}

while true; do
  if check_public_key; then
    break
  else
    echo -e "${YELLOW}Ждем Public Key...${NC}"  
    sleep 30
  fi
done
echo -e "${GREEN}Установка завершена!${NC}"
