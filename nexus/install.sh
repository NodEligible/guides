#!/bin/bash

curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/display_logo.sh | bash

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

# Установка Rust
echo -e "${YELLOW}Установка Rust...${NC}"
bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/rust.sh)
  if [ $? -eq 0 ]; then
      echo -e "${GREEN}Rust успешно установлено!${NC}"
  else
      echo -e "${RED}Ошибка при установке Rust!${NC}"
  fi

NEXUS_HOME=$HOME/.nexus

git --version 2>&1 >/dev/null
GIT_IS_AVAILABLE=$?
if [ $GIT_IS_AVAILABLE != 0 ]; then
  echo Unable to find git. Please install it and try again.
  exit 1;
fi

PROVER_ID=$(cat $NEXUS_HOME/prover-id 2>/dev/null)
if [ -z "$NONINTERACTIVE" ] && [ "${#PROVER_ID}" -ne "28" ]; then
    read -p "Prover Id " PROVER_ID </dev/tty
    while [ ! ${#PROVER_ID} -eq "0" ]; do
        if [ ${#PROVER_ID} -eq "28" ]; then
            if [ -f "$NEXUS_HOME/prover-id" ]; then
                echo Copying $NEXUS_HOME/prover-id to $NEXUS_HOME/prover-id.bak
                cp $NEXUS_HOME/prover-id $NEXUS_HOME/prover-id.bak
            fi
            echo "$PROVER_ID" > $NEXUS_HOME/prover-id
            echo Prover id saved to $NEXUS_HOME/prover-id.
            break;
        else
            echo Unable to validate $PROVER_ID. Please make sure the full prover id is copied.
        fi
        read -p "Prover Id " PROVER_ID </dev/tty
    done
fi

REPO_PATH=$NEXUS_HOME/network-api
if [ -d "$REPO_PATH" ]; then
  echo "$REPO_PATH exists. Updating.";
  (cd $REPO_PATH && git stash save && git fetch --tags)
else
  mkdir -p $NEXUS_HOME
  (cd $NEXUS_HOME && git clone https://github.com/nexus-xyz/network-api)
fi
(cd $REPO_PATH && git -c advice.detachedHead=false checkout $(git rev-list --tags --max-count=1))

cat <<EOF | sudo tee /etc/systemd/system/nexus.service >/dev/null
[Unit]
Description=Nexus prover
After=network-online.target
StartLimitIntervalSec=0

[Service]
User=root
Restart=always
RestartSec=30
LimitNOFILE=65535
Type=simple
WorkingDirectory=$REPO_PATH/clients/cli
ExecStart=cargo run --release --bin prover -- beta.orchestrator.nexus.xyz
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable nexus
systemctl start nexus

echo -e "${GREEN}Установка завершена${NC}"
