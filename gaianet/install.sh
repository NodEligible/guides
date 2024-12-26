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

echo -e "${YELLOW}Установка автоматического общения с AI ботом${NC}"
install_dependencies() {
  echo -e "${YELLOW}Установка Python, nano и screen...${NC}"
  sudo apt update -y && sudo apt install python3-pip nano screen -y
  if [ $? -eq 0 ]; then
      echo -e "${GREEN}Python, nano и screen успешно установлены!${NC}"
  else
      echo -e "${RED}Ошибка при установке необходимых пакетов!${NC}"
      exit 1
  fi
}

install_python_libraries() {
  echo -e "${YELLOW}Установка необходимых библиотек Python...${NC}"
  pip install requests faker
  if [ $? -eq 0 ]; then
      echo -e "${GREEN}Библиотеки requests и faker успешно установлены!${NC}"
  else
      echo -e "${RED}Ошибка при установке библиотек Python!${NC}"
      exit 1
  fi
}

create_python_script() {
  echo -e "${YELLOW}Создание скрипта random_chat_with_faker.py...${NC}"
  read -p "Введите адрес вашего кошелька (без https://): " wallet_address

  if [ -z "$wallet_address" ]; then
      echo -e "${RED}Адрес кошелька не может быть пустым!${NC}"
      exit 1
  fi

  cat > ~/random_chat_with_faker.py <<EOL
import requests
import random
import logging
import time
from faker import Faker
from datetime import datetime

node_url = "https://${wallet_address}.us.gaianet.network/v1/chat/completions"

faker = Faker()

headers = {
    "accept": "application/json",
    "Content-Type": "application/json"
}

logging.basicConfig(filename='/root/chat_log.txt', level=logging.INFO, format='%(asctime)s - %(message)s')

def log_message(node, message):
    logging.info(f"{node}: {message}")

def send_message(node_url, message):
    try:
        response = requests.post(node_url, json=message, headers=headers)
        response.raise_for_status()
        return response.json()
    except requests.exceptions.RequestException as e:
        print(f"Failed to get response from API: {e}")
        return None

def extract_reply(response):
    if response and 'choices' in response:
        return response['choices'][0]['message']['content']
    return ""

while True:
    random_question = faker.sentence(nb_words=10)
    message = {
        "messages": [
            {"role": "system", "content": "You are a helpful assistant."},
            {"role": "user", "content": random_question}
        ]
    }

    question_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    response = send_message(node_url, message)
    reply = extract_reply(response)

    reply_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    log_message("Node replied", f"Q ({question_time}): {random_question} A ({reply_time}): {reply}")

    print(f"Q ({question_time}): {random_question}\nA ({reply_time}): {reply}")

    delay = random.randint(60, 180)
    time.sleep(delay)
EOL

  if [ $? -eq 0 ]; then
      echo -e "${GREEN}Скрипт random_chat_with_faker.py успешно создан!${NC}"
  else
      echo -e "${RED}Ошибка при создании скрипта!${NC}"
      exit 1
  fi
}

create_service() {
  echo -e "${YELLOW}Создание сервиса random_chat.service...${NC}"
  sudo tee /etc/systemd/system/random_chat.service > /dev/null <<EOF
[Unit]
Description=Random Chat with Faker Bot
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/python3 /root/random_chat_with_faker.py
Restart=always
RestartSec=10
User=root
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF

  if [ $? -eq 0 ]; then
      echo -e "${GREEN}Сервис random_chat.service успешно создан!${NC}"
  else
      echo -e "${RED}Ошибка при создании сервиса!${NC}"
      exit 1
  fi

  echo -e "${YELLOW}Перезагрузка systemd и запуск сервиса...${NC}"
  sudo systemctl daemon-reload
  sudo systemctl start random_chat.service
  sudo systemctl enable random_chat.service

  if [ $? -eq 0 ]; then
      echo -e "${GREEN}Сервис random_chat.service успешно запущен и включен!${NC}"
  else
      echo -e "${RED}Ошибка при запуске сервиса!${NC}"
      exit 1
  fi
}

main() {
  update
  install_docker
  install_gaianet
  initialization
  create_service
  install_dependencies
  install_python_libraries
  create_python_script
  create_service

  echo -e "${GREEN}Установка завершена! Логи доступны в systemd (journalctl -u random_chat.service).${NC}"
}

main

