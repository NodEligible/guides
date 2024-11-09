#!/bin/bash

# Функция для отображения логотипа
display_logo() {
curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/display_logo.sh | bash
}

# Отображение логотипа
display_logo

# Оголошення кольорів для використання в скрипті
YELLOW='\e[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # Сброс цвета

line_1() {
  echo -e "${YELLOW}-----------------------------------------------------------------------------${NC}"
}

line_2() {
  echo -e "${GREEN}-----------------------------------------------------------------------------${NC}"
}

# Встановлення інструментів
install_tools() {
  echo -e "${YELLOW}Установка Tools...${NC}" 
  sudo apt update && sudo apt install mc wget htop jq git -y
  if [ $? -eq 0 ]; then
      echo -e "${GREEN}Tools успешно установлено!${NC}"
  else
      echo -e "${RED}Ошибка при установке Tools!${NC}"
  fi
}

# Встановлення Docker
install_docker() {
  echo -e "${YELLOW}Установка Docker...${NC}"
  bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/docker.sh)
  if [ $? -eq 0 ]; then
      echo -e "${GREEN}Docker успешно установлено!${NC}"
  else
      echo -e "${RED}Ошибка при установке Docker!${NC}"
  fi
}

# Встановлення UFW
install_ufw() {
  echo -e "${YELLOW}Установка Ufw...${NC}" 
  bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/ufw.sh)
  if [ $? -eq 0 ]; then
      echo -e "${GREEN}Ufw успешно установлено!${NC}"
  else
      echo -e "${RED}Ошибка при установке Ufw!${NC}"
  fi
}

# Введення RPC URL
read_sepolia_rpc() {
  if [ -z "$RPC_URL" ]; then
    echo -e "Введите ваш RPC Sepolia https url. Пример url'a - https://sepolia.infura.io/v3/ТУТ_ВАШ_КЛЮЧ"
    line_1
    read -r RPC_URL
  fi
}

# Введення приватного ключа
read_private_key() {
  if [ -z "$WAKU_PRIVATE_KEY" ]; then
    echo -e "Введите ваш приватник от ETH кошелека на котором есть как минимум 0.1 ETH в сети Sepolia"
    line_1
    read -r WAKU_PRIVATE_KEY
  fi
}

# Введення пароля
read_pass() {
  if [ -z "$WAKU_PASS" ]; then
    echo -e "Введите(придумайте) пароль который будет использваться для сетапа ноды"
    line_1
    read -r WAKU_PASS
  fi
}

# Клонування репозиторію
git_clone() {
  git clone https://github.com/waku-org/nwaku-compose
}

# Налаштування середовища
setup_env() {
  cd nwaku-compose || exit
  cp .env.example .env

  sed -i "s|RLN_RELAY_ETH_CLIENT_ADDRESS=.*|RLN_RELAY_ETH_CLIENT_ADDRESS=$RPC_URL|" .env
  sed -i "s|ETH_TESTNET_KEY=.*|ETH_TESTNET_KEY=$WAKU_PRIVATE_KEY|" .env
  sed -i "s|RLN_RELAY_CRED_PASSWORD=.*|RLN_RELAY_CRED_PASSWORD=$WAKU_PASS|" .env
  sed -i "s|NWAKU_IMAGE=.*|NWAKU_IMAGE=wakuorg/nwaku:v0.33.0|" .env

  # Меняем стандартный порт графаны
  sed -i 's/0\.0\.0\.0:3000:3000/0.0.0.0:3004:3000/g' docker-compose.yml
  sed -i 's/127\.0\.0\.1:4000:4000/0.0.0.0:4044:4000/g' docker-compose.yml
  sed -i 's/:5432:5432/:5444:5432/g' docker-compose.yml

  bash register_rln.sh
}

# Запуск Docker контейнерів
docker_compose_up() {
  docker compose -f docker-compose.yml up -d
}

# Інформація про команди для користувача
echo_info() {
  echo -e "${GREEN}Для остановки ноды waku: ${NC}"
  echo -e "${YELLOW}   docker-compose -f $HOME/nwaku-compose/docker-compose.yml down${NC}"
  echo -e "${GREEN}Для запуска ноды и фармера waku: ${NC}"
  echo -e "${YELLOW}   docker-compose -f $HOME/nwaku-compose/docker-compose.yml up -d${NC}"
  echo -e "${GREEN}Для перезагрузки ноды waku: ${NC}"
  echo -e "${YELLOW}   docker-compose -f $HOME/nwaku-compose/docker-compose.yml restart${NC}"
  echo -e "${GREEN}Для проверки логов ноды выполняем команду: ${NC}"
  echo -e "${YELLOW}   docker-compose -f $HOME/nwaku-compose/docker-compose.yml logs -f --tail=100${NC}"
  
  ip_address=$(hostname -I | awk '{print $1}')
  echo -e "${GREEN}Для проверки дашборда графаны, перейдите по ссылке: ${NC}"
  echo -e "${RED}   http://$ip_address:3004/d/yns_4vFVk/nwaku-monitoring${NC}"
}

# Основний процес встановлення
main() {
  line_1
  read_sepolia_rpc
  line_2
  read_private_key
  line_2
  read_pass
  line_2
  git_clone
  setup_env
  line_1
  echo_info
  line_2
}

# Виконання основного процесу
main
