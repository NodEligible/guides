#!/bin/bash

YELLOW='\e[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

CONTAINER_NAME="hello-world"
CONFIG_FILE="$HOME/infernet-container-starter/deploy/config.json"
CONFIG_FILE_OWN="$HOME/infernet-container-starter/projects/hello-world/container/config.json"

if docker ps -a --filter "name=^/${CONTAINER_NAME}$" --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
  echo -e "${YELLOW}🛑 Останавливаем инфраструктуру Ritual...${NC}"
  docker compose -f "$HOME/infernet-container-starter/deploy/docker-compose.yaml" down

  if docker ps --filter "name=^/${CONTAINER_NAME}$" --filter "status=running" | grep -q "${CONTAINER_NAME}"; then
    echo -e "${YELLOW}⏹ Останавливаем контейнер ${CONTAINER_NAME}...${NC}"
    docker stop "$CONTAINER_NAME"
  fi

  echo -e "${YELLOW}🗑 Удаляем контейнер ${CONTAINER_NAME}...${NC}"
  docker rm "$CONTAINER_NAME"

  if [ -f "$CONFIG_FILE" ]; then
    echo -e "${YELLOW}🔧 Изменяем порт 3000 → 3009 в конфигурационных файлах...${NC}"
    sed -i 's/3000/3009/g' "$CONFIG_FILE"
    sed -i 's/3000/3009/g' "$CONFIG_FILE_OWN"

    echo -e "${GREEN}✅ Порт успешно изменён в файлах:${NC}"
    echo -e " - $CONFIG_FILE"
    echo -e " - $CONFIG_FILE_OWN"

    echo -e "${YELLOW}🚀 Запускаем инфраструктуру снова...${NC}"
    docker compose -f "$HOME/infernet-container-starter/deploy/docker-compose.yaml" up -d

    echo -e "${GREEN}✅ Готово. Инфраструктура работает на новом порту 3009.${NC}"
  else
    echo -e "${RED}❌ Файл конфигурации не найден: $CONFIG_FILE${NC}"
  fi
else
  echo -e "${RED}❌ Контейнер '${CONTAINER_NAME}' не найден. Ritual, возможно, не установлен или уже удалён.${NC}"
fi

