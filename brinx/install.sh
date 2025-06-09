#!/bin/bash

curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/display_logo.sh | bash

# Сменные для цветов
YELLOW='\e[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[38;5;81m'
NC='\033[0m' # Сброс цвета
# ----------------------------------------------------------------------------------------------------------------
# Function to validate UUID format
validate_uuid() {
    local uuid=$1
    if [[ $uuid =~ ^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$ ]]; then
        return 0
    else
        return 1
    fi
}

# Prompt user for WORKER_PORT
echo -e "${BLUE}Введите порт для воркера (Enter - по умолчанию 5011): ${NC}"
read -p "➜ " USER_PORT
USER_PORT=${USER_PORT:-5011}

# Prompt user for node_UUID
while true; do
    echo -e "${BLUE}Введите UUID ноды (например 234efgr-546fg-65fhy-444g56-436545445)${NC}"
    read -p "➜ " NODE_UUID
    if validate_uuid "$NODE_UUID"; then
        echo -e "${GREEN}UUID принят.${NC}"
        break
    else
        echo -e "${RED}Неверный формат UUID. Введите UUID (например 234efgr-546fg-65fhy-444g56-436545445).${NC}"
    fi
done
# ----------------------------------------------------------------------------------------------------------------
  echo -e "${YELLOW}Установка Docker...${NC}"
  bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/docker.sh)
  if [ $? -eq 0 ]; then
      echo -e "${GREEN}Docker успешно установлено!${NC}"
  else
      echo -e "${RED}Ошибка при установке Docker!${NC}"
  fi

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

# Removing old installation if exists
echo -e "${YELLOW}Удаляем старый brinx.ai (если стоит и если увидите ошибки это норм значит у вас нет пред ведущих файлов ноды)${NC}"
docker stop brinxai_worker-worker-1
docker stop text-ui
docker stop stable-diffusion
docker stop rembg
docker stop upscaler
docker rm -f brinxai_worker-worker-1 text-ui stable-diffusion rembg upscaler
rm -rf $HOME/brinxai_worker
docker rmi -f admier/brinxai_nodes-worker
docker rmi -f admier/brinxai_nodes-text-ui
docker rmi -f admier/brinxai_nodes-stabled
docker rmi -f admier/brinxai_nodes-rembg
docker rmi -f admier/brinxai_nodes-upscaler

# Update package list and install dependencies
sudo apt-get install -y gnupg lsb-release

# Check if GPU is available
echo -e "${YELLOW}Проверяем сервер на наличие GPU${NC}"
GPU_AVAILABLE=false
if command -v nvidia-smi &> /dev/null; then
    echo -e "${GREEN}GPU найден${NC}"
    GPU_AVAILABLE=true
else
    echo -e "${YELLOW}GPU не найден.${NC}"
fi
# ---------------------------------------------------------------------------------
mkdir -p $HOME/brinxai_worker
cd $HOME/brinxai_worker

echo -e "${YELLOW}Создаем .env файл${NC}"
cat <<EOF > .env
WORKER_PORT=$USER_PORT
NODE_UUID=$NODE_UUID
USE_GPU=$GPU_AVAILABLE
CUDA_VISIBLE_DEVICES=""
EOF

# Create docker-compose.yml file
echo "Создаем docker-compose.yml"
if [ "$GPU_AVAILABLE" = true ]; then
    cat <<EOF > docker-compose.yml
services:
  brinxai_worker:
    image: admier/brinxai_nodes-worker:latest
    restart: unless-stopped
    environment:
      - WORKER_PORT=\${WORKER_PORT:-5011}
      - NODE_UUID=\${NODE_UUID}
      - USE_GPU=\${USE_GPU:-true}
      - CUDA_VISIBLE_DEVICES=\${CUDA_VISIBLE_DEVICES}
    ports:
      - "\${WORKER_PORT:-5011}:\${WORKER_PORT:-5011}"
    volumes:
      - ./generated_images:/usr/src/app/generated_images
      - /var/run/docker.sock:/var/run/docker.sock
    networks:
      - brinxai-network
    deploy:
      resources:
        reservations:
          devices:
            - capabilities: [gpu]
    runtime: nvidia

networks:
  brinxai-network:
    driver: bridge
    name: brinxai-network
EOF
else
    cat <<EOF > docker-compose.yml
services:
  brinxai_worker:
    image: admier/brinxai_nodes-worker:latest
    restart: unless-stopped
    environment:
      - WORKER_PORT=\${WORKER_PORT:-5011}
      - NODE_UUID=\${NODE_UUID}
      - USE_GPU=\${USE_GPU:-false}
      - CUDA_VISIBLE_DEVICES=\${CUDA_VISIBLE_DEVICES}
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
    name: brinxai-network
EOF
fi

docker compose down --remove-orphans

echo -e "${YELLOW}Скачиваем последнюю версию BrixAI${NC}"
docker pull admier/brinxai_nodes-worker:latest

echo -e "${YELLOW}Запускаем Docker контейнеры${NC}"
docker compose up -d

echo -e "${YELLOW}Проверяем контейнера${NC}"
sleep 4 # Wait for container to stabilize
docker ps -a --filter "name=brinxai_worker"

echo -e "${GREEN}Установка завершена!${NC}"
