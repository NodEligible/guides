#!/bin/bash

curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/display_logo.sh | bash

YELLOW='\e[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

install_docker() {
  echo -e "${YELLOW}Установка Docker...${NC}"
  bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/docker.sh)
  if [ $? -eq 0 ]; then
      echo -e "${GREEN}Docker успешно установлено!${NC}"
  else
      echo -e "${RED}Ошибка при установке Docker!${NC}"
  fi
}

update() {
  echo -e "${YELLOW}Обновление пакетов...${NC}"
  sudo apt update -y && sudo apt-get update
  if [ $? -eq 0 ]; then
      echo -e "${GREEN}Пакеты успешно обновлены!${NC}"
  else
      echo -e "${RED}Ошибка при обновлении пакетов!${NC}"
  fi
}

install_gaianet() {
  echo -e "${YELLOW}Установка GaiaNet...${NC}"
  curl -sSfL 'https://github.com/GaiaNet-AI/gaianet-node/releases/latest/download/install.sh' | bash
  if [ $? -eq 0 ]; then
      echo -e "${GREEN}Установка завершена!${NC}"
  else
      echo -e "${RED}Ошибка при установке!${NC}"
  fi
}

initialization() {
  echo -e "${YELLOW}Инициализация конфигурации...${NC}"
  source ~/.bashrc
  gaianet init --config https://raw.githubusercontent.com/GaiaNet-AI/node-configs/main/qwen2-0.5b-instruct/config.json

  # Шлях до конфігураційного файлу
  CONFIG_FILE="/root/gaianet/config.json"

  if [ -f "$CONFIG_FILE" ]; then
      echo -e "${YELLOW}Обновление порта в конфигурационном файле...${NC}"

      # Використовуємо sed для заміни порту
      sed -i 's/"llamaedge_port": "8080"/"llamaedge_port": "8060"/' "$CONFIG_FILE"
      
      if [ $? -eq 0 ]; then
          echo -e "${GREEN}Порт успешно обновлен на 8060!${NC}"
      else
          echo -e "${RED}Ошибка при обновлении порта!${NC}"
      fi
  else
      echo -e "${RED}Файл конфигурации не найден!${NC}"
  fi

  if [ $? -eq 0 ]; then
      echo -e "${GREEN}Инициализация завершена!${NC}"
  else
      echo -e "${RED}Ошибка при инициализации!${NC}"
  fi
}


create_service() {
  echo -e "${YELLOW}Создание сервиса GaiaNet...${NC}"
  sudo tee /etc/systemd/system/gaianet.service > /dev/null <<EOF
[Unit]
Description=Gaianet Node Service
After=network.target

[Service]
Type=forking
RemainAfterExit=true
ExecStart=/root/gaianet/bin/gaianet start
ExecStop=/root/gaianet/bin/gaianet stop
ExecStopPost=/bin/sleep 20
Restart=always
RestartSec=5
User=root

[Install]
WantedBy=multi-user.target
EOF

  sudo systemctl daemon-reload
  sudo systemctl restart gaianet.service
  sudo systemctl enable gaianet.service

  if [ $? -eq 0 ]; then
      echo -e "${GREEN}Сервис GaiaNet успешно создан и запущен!${NC}"
  else
      echo -e "${RED}Ошибка при создании или запуске сервиса!${NC}"
  fi
}

# Основной процесс установки
update
install_docker
install_gaianet
initialization
create_service

echo -e "${GREEN}Установка ноди GaiaNet полностью завершена!${NC}"
