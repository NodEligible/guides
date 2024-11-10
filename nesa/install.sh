#!/bin/bash

# Загрузка и отображение логотипа
curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/display_logo.sh | bash


# Сменные для цветов
YELLOW='\e[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # Сброс цвета

# Установка Docker
install_docker() {
  if command -v docker &> /dev/null; then
    echo -e "${GREEN}Docker уже установлен.${NC}"
  else
    echo -e "${YELLOW}Установка Docker...${NC}"
    bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/docker.sh)
    if [ $? -eq 0 ]; then
      echo -e "${GREEN}Docker успешно установлено!${NC}"
  else
     echo -e "${RED}Ошибка при установке Docker!${NC}"
     exit 1
    fi
  fi
}

# Установка Main
install_main() {
  if command -v main &> /dev/null; then
    echo -e "${GREEN}Main уже установлен.${NC}"
  else
    echo -e "${YELLOW}Установка Main...${NC}"
    bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/main.sh)
    if [ $? -eq 0 ]; then
      echo -e "${GREEN}Main успешно установлен!${NC}"
    else
      echo -e "${RED}Ошибка при установке Main!${NC}"
      exit 1
    fi
  fi
}

# Установка Ufw
install_ufw() {
  if command -v ufw &> /dev/null; then
    echo -e "${GREEN}Ufw уже установлен.${NC}"
else
  echo -e "${YELLOW}Установка Ufw...${NC}" 
  bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/ufw.sh)
  if [ $? -eq 0 ]; then
      echo -e "${GREEN}Ufw успешно установлено!${NC}"
  else
      echo -e "${RED}Ошибка при установке Ufw!${NC}"
     exit 1
    fi
  fi
}

# Установка Go
install_go() {
  if command -v go &> /dev/null; then
    echo -e "${GREEN}Go уже установлен.${NC}"
else
  echo -e "${YELLOW}Установка Go...${NC}" 
  bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/go.sh)
  if [ $? -eq 0 ]; then
      echo -e "${GREEN}Go успешно установлено!${NC}"
  else
      echo -e "${RED}Ошибка при установке Go!${NC}"
     exit 1
    fi
  fi
}    

# Установка Nesa
install_nesa() {
echo -e "${YELLOW}Установка Nesa...${NC}"
bash <(curl -s https://raw.githubusercontent.com/nesaorg/bootstrap/master/bootstrap.sh)
if [ $? -eq 0 ]; then
     echo -e "${GREEN}Nesa успешно установлена и запущена!${NC}"
else
   echo -e "${RED}Ошибка при установке Nesa!${NC}"
fi
}
