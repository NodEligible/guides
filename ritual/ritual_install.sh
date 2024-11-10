#!/bin/bash

# Загрузка логотипа
curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/display_logo.sh | bash

YELLOW='\e[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'
fmt='\033[0;32m'  # зеленый для успешного вывода
end='\033[0m'
err='\033[0;31m'  # красный для ошибок

# Функция для запроса параметра у пользователя
request_param() {
    read -p "$1: " param
    echo $param
}

# Запрашиваем параметры
echo "Пожалуйста, введите следующие параметры для настройки ноды:"
RPC_URL=$(request_param "Введите RPC URL")
PRIVATE_KEY=$(request_param "Введите ваш приватный ключ (начинающийся с 0x)")

if [[ "$PRIVATE_KEY" != 0x* ]]; then
    echo -e "${RED}Приватный ключ введен неверно. Должен начинаться с 0x${NC}"
    exit 1
fi

# Переменные для конфигурации
REGISTRY_ADDRESS=0x3B1554f346DFe5c482Bb4BA31b880c1C18412170
IMAGE="ritualnetwork/infernet-node:1.2.0"

# Функции установки
update() {
    echo -e "${YELLOW}Обновление пакетов...${NC}"
    sudo apt update -y
}

install_main() {
    echo -e "${YELLOW}Установка main...${NC}"
    bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/main.sh)
}

install_ufw() {
    echo -e "${YELLOW}Установка ufw...${NC}"
    bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/ufw.sh)
}

install_docker() {
    echo -e "${YELLOW}Установка Docker...${NC}"
    bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/docker.sh)
}

# Вызовы функций
update
install_main
install_ufw
install_docker

echo -e "${GREEN}Все необходимые программы успешно установлены!${NC}"

# Клонирование репозитория
echo -e "${YELLOW}Клонирование репозитория...${NC}"
cd $HOME
git clone https://github.com/ritual-net/infernet-container-starter && cd infernet-container-starter
cp projects/hello-world/container/config.json deploy/config.json
echo -e "${GREEN}Клонирование завершено!${NC}"

# Конфигурация файлов JSON
DEPLOY_JSON="deploy/config.json"
CONTAINER_JSON="projects/hello-world/container/config.json"

# Замена значений в JSON
for json_file in "$DEPLOY_JSON" "$CONTAINER_JSON"; do
  sed -i 's|"rpc_url": "[^"]*"|"rpc_url": "'"$RPC_URL"'"|' "$json_file"
  sed -i 's|"private_key": "[^"]*"|"private_key": "'"$PRIVATE_KEY"'"|' "$json_file"
  sed -i 's|"registry_address": "[^"]*"|"registry_address": "'"$REGISTRY_ADDRESS"'"|' "$json_file"
done

# Настройка Docker Compose
sed -i 's|ritualnetwork/infernet-node:1.0.0|ritualnetwork/infernet-node:1.2.0|' deploy/docker-compose.yaml
sed -i 's|container_name: infernet-anvil|container_name: infernet-anvil\n    restart: on-failure|' deploy/docker-compose.yaml

# Старт Docker Compose
docker compose -f deploy/docker-compose.yaml up -d

# Установка Foundry
mkdir -p foundry && cd foundry
curl -L https://foundry.paradigm.xyz | bash
source ~/.bashrc
echo 'export PATH="$PATH:/root/.foundry/bin"' >> ~/.profile
source ~/.profile
foundryup

# Установка зависимостей для контрактов
cd $HOME/infernet-container-starter/projects/hello-world/contracts/lib/
rm -r forge-std infernet-sdk
forge install --no-commit foundry-rs/forge-std ritual-net/infernet-sdk

# Развертывание контракта
cd $HOME/infernet-container-starter
project=hello-world make deploy-contracts >> logs.txt
CONTRACT_ADDRESS=$(grep "Deployed SaysHello" logs.txt | awk '{print $NF}')
rm logs.txt

if [ -z "$CONTRACT_ADDRESS" ]; then
  echo -e "${err}Ошибка: не удалось получить адрес контракта${end}"
  exit 1
fi

echo -e "${fmt}Адрес вашего контракта: $CONTRACT_ADDRESS${end}"
sed -i 's|0x13D69Cf7d6CE4218F646B759Dcf334D82c023d8e|'$CONTRACT_ADDRESS'|' projects/hello-world/contracts/script/CallContract.s.sol

# Вызов контракта
project=hello-world make call-contract

# Перезапуск Docker Compose с новой конфигурацией
cd deploy
docker compose down
sleep 3
sudo rm -rf docker-compose.yaml
wget https://raw.githubusercontent.com/NodEligible/guides/refs/heads/main/ritual/docker-compose.yaml
docker compose up -d
docker rm -fv infernet-anvil &>/dev/null
