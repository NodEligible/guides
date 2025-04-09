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
  fi

    echo -e "${YELLOW}Установка Ufw...${NC}" 
  bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/ufw.sh)
  if [ $? -eq 0 ]; then
      echo -e "${GREEN}Ufw успешно установлено!${NC}"
  else
      echo -e "${RED}Ошибка при установке Ufw!${NC}"
  fi

  # create bash_profile if it doesn't exist
[ -f ~/.bash_profile ] || touch ~/.bash_profile

# Ollama
echo "Ставим Ollama..."
curl -fsSL https://ollama.com/install.sh | sh &>/dev/null
echo "Установка Ollama завершена"
echo ""

echo "Ставим Dria..."
cd $HOME
curl -fsSL https://dria.co/launcher | bash &>/dev/null

# создаем сам сервис в системе
SERVICE_NAME="dria.service"
SERVICE_FILE="/etc/systemd/system/$SERVICE_NAME"
LOG_FILE="/var/log/dria.log"
ERROR_LOG_FILE="/var/log/dria_error.log"
HOME_DIR="$HOME"
WORK_DIR="$HOME_DIR/.dria/bin"
LAUNCHER="dkn-compute-launcher"
ENV_PATH="$HOME_DIR/.dria/dkn-compute-launcher/.env"

# удаляем сервис если уже стоит
if systemctl list-units --type=service --all | grep -q "$SERVICE_NAME"; then
    sudo systemctl stop "$SERVICE_NAME"
    sudo systemctl disable "$SERVICE_NAME"
    if [ -f "$SERVICE_FILE" ]; then
        sudo rm "$SERVICE_FILE"
    fi
    > "$ERROR_LOG_FILE"
    sudo systemctl daemon-reload
    echo "Существующий $SERVICE_NAME удален."
fi


# Create the systemd service file
cat <<EOF | sudo tee "$SERVICE_FILE" > /dev/null
[Unit]
Description=Dria Service
After=network.target

[Service]
User=root
WorkingDirectory=$WORK_DIR
ExecStartPre=/bin/bash -c "sed -i 's|^DKN_P2P_LISTEN_ADDR=.*|DKN_P2P_LISTEN_ADDR=/ip4/0.0.0.0/tcp/4002|' ${ENV_PATH}"
ExecStart=${WORK_DIR}/${LAUNCHER} start
Restart=always
RestartSec=5
StandardOutput=append:$LOG_FILE
StandardError=append:$ERROR_LOG_FILE

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd, enable and start the service
sudo systemctl daemon-reload
sudo systemctl enable dria.service
echo "Установка Dria завершена"
echo ""
source ~/.bash_profile
dkn-compute-launcher start
