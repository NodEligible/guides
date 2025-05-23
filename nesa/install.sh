#!/bin/bash

# Загрузка и отображение логотипа
logo() {
curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/display_logo.sh | bash
}

# Сменные для цветов
YELLOW='\e[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # Сброс цвета

# Установка Docker
install_docker() {
  echo -e "${YELLOW}Установка Docker...${NC}"
  bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/docker.sh)
  if [ $? -eq 0 ]; then
      echo -e "${GREEN}Docker успешно установлено!${NC}"
  else
      echo -e "${RED}Ошибка при установке Docker!${NC}"
  fi
}

# Установка Main
install_main() {
  echo -e "${YELLOW}Установка Main...${NC}"
  bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/main.sh)
  if [ $? -eq 0 ]; then
      echo -e "${GREEN}Main успешно установлен!${NC}"
  else
      echo -e "${RED}Ошибка при установке Main!${NC}"
  fi
 }
  
# Установка Ufw
install_ufw() {
  echo -e "${YELLOW}Установка Ufw...${NC}" 
  bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/ufw.sh)
  if [ $? -eq 0 ]; then
      echo -e "${GREEN}Ufw успешно установлено!${NC}"
  else
      echo -e "${RED}Ошибка при установке Ufw!${NC}"
  fi
}

# Установка Go
install_go() {
   echo -e "${YELLOW}Установка Go...${NC}"
   bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/go.sh)
   if [ $? -eq 0 ]; then
       echo -e "${GREEN}Go успешно установлен!${NC}"
   else
       echo -e "${RED}Ошибка при установке Go!${NC}"
   fi
}    

# Установка Nesa
install_nesa() {
  echo -e "${YELLOW}Установка Nesa...${NC}"
  bash <(curl -s https://raw.githubusercontent.com/nesaorg/bootstrap/master/bootstrap.sh)
}

logo
install_docker
install_main
install_ufw
install_go
install_nesa
