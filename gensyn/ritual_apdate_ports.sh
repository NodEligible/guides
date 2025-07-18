#!/bin/bash

YELLOW='\e[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

IMAGE_NAME="ritualnetwork/hello-world-infernet:latest"
CONFIG_FILE="$HOME/infernet-container-starter/deploy/config.json"

# Get the container ID using the image
CONTAINER_ID=$(docker ps -a --filter "ancestor=$IMAGE_NAME" --format "{{.ID}}")

# Check if both the container exists and the config file exists
if [ -n "$CONTAINER_ID" ] && [ -f "$CONFIG_FILE" ]; then
    CONTAINER_NAME=$(docker inspect --format '{{.Name}}' "$CONTAINER_ID" | sed 's/^\/\?//')

    echo -e"${YELLOW}Контейнер найден, останавливаем и удаляем:${NC} $CONTAINER_NAME"
    
    docker stop "$CONTAINER_NAME"
    docker rm "$CONTAINER_NAME"
    
    echo -e"${YELLOW}Контейнер удален.${NC}"

    sed -i 's/3000/3009/g' "$CONFIG_FILE"
    echo -e "${GREEN}В файле${NC} $CONFIG_FILE: ${GREEN}заменили порт 3000 на 3009.${NC}"

    echo -e"${YELLOW}Запускаем контейнер назад.${NC}"
    docker run -d --name "$CONTAINER_NAME" --restart unless-stopped -v "$CONFIG_FILE:/app/config.json" ritualnetwork/hello-world-infernet:latest

    echo -e "${GREEN}Готово.${NC}"
fi
