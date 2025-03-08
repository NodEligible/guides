#!/bin/bash

curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/display_logo.sh | bash

# Сменные для цветов
YELLOW='\e[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # Сброс цвета

SERVER_IP=$(hostname -I | awk '{print $1}')

  echo -e "${YELLOW}Установка Docker...${NC}"
  bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/docker.sh)
  if [ $? -eq 0 ]; then
      echo -e "${GREEN}Docker успешно установлено!${NC}"
  else
      echo -e "${RED}Ошибка при установке Docker!${NC}"
      exit 1
  fi

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

echo -e "${YELLOW}Скачиваем image...${NC}" 
# Скачиваем image из Docker Hub
docker pull admier/brinxai_nodes-worker:latest

echo -e "${YELLOW}Копируем репозиторий...${NC}" 
# Копируем репозиторий и заходим в директорию
git clone https://github.com/admier1/BrinxAI-Worker-Nodes
mv BrinxAI-Worker-Nodes brinxai_worker
cd brinxai_worker

# Создаем .env файл
echo "Creating .env file"
cat <<EOF > .env
WORKER_PORT=5011
EOF

# Создаём docker-compose.yml
echo "Создаём docker-compose.yml"
cat <<EOF > docker-compose.yml
version: '3.8'

services:
  worker:
    image: admier/brinxai_nodes-worker:latest
    environment:
      - WORKER_PORT=\${WORKER_PORT:-5011}
    ports:
      - "\${WORKER_PORT:-5011}:\${WORKER_PORT:-5011}"
    volumes:
      - ./generated_images:/usr/src/app/generated_images
      - /var/run/docker.sock:/var/run/docker.sock
    networks:
      - brinxai-network

networks:
  brinxai-network:
    driver: bridge
    name: brinxai-network  # Явно задаем имя сети
EOF

# Запускаем контейнер
echo "Запускаем Worker Node"
docker compose up -d

echo -e "${YELLOW}IP вашего сервера:${NC} ${SERVER_IP} "
