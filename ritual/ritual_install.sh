#!/bin/bash

curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/display_logo.sh | bash

YELLOW='\e[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[38;5;81m'
NC='\033[0m'

request_param() {
    read -p "$1: " param
    echo $param
}

# Запрашиваем параметры у пользователя
echo -e "${YELLOW}Пожалуйста, введите следующие параметры для настройки ноды:${NC}"
RPC_URL=$(request_param "${BLUE}📡 Введите RPC URL${NC}")
PRIVATE_KEY=$(request_param "${BLUE}🔐 Введите ваш приватный ключ${NC} (начинающийся с 0x)")

if [[ "$PRIVATE_KEY" == 0x* ]]; then
    echo -e "${GREEN}Вы ввели приватный ключ верно!${NC}"
else
    echo -e "${RED}Приватный ключ введен не верно. Приватный ключ должен начинаться с${NC} 0x"
    exit 1
fi

REGISTRY_ADDRESS=0x3B1554f346DFe5c482Bb4BA31b880c1C18412170
IMAGE="ritualnetwork/infernet-node:1.4.0"

# Функции установки
update() {
    echo -e "${YELLOW}Обновление пакетов...${NC}"
    sudo apt update -y
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Пакеты успешно обновлены!${NC}"
    else
        echo -e "${RED}Ошибка при обновлении пакетов!${NC}"
        exit 1
    fi
}

install_main() {
    echo -e "${YELLOW}Установка Main...${NC}"
    bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/main.sh)
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Main успешно установлен!${NC}"
    else
        echo -e "${RED}Ошибка при установке Main!${NC}"
        exit 1
    fi
}

install_ufw() {
    echo -e "${YELLOW}Установка Ufw...${NC}"
    bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/ufw.sh)
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Ufw успешно установлен!${NC}"
    else
        echo -e "${RED}Ошибка при установке Ufw!${NC}"
        exit 1
    fi
}

install_docker() {
    echo -e "${YELLOW}Установка Docker...${NC}"
    bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/docker.sh)
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Docker успешно установлен!${NC}"
    else
        echo -e "${RED}Ошибка при установке Docker!${NC}"
        exit 1
    fi
}

# Вызовы функций
update
install_main
install_ufw
install_docker

echo -e "${GREEN}Все программы успешно установлены!${NC}"

# Клонирование репозитория
cd $HOME
git clone https://github.com/ritual-net/infernet-container-starter && cd infernet-container-starter
cp $HOME/infernet-container-starter/projects/hello-world/container/config.json $HOME/infernet-container-starter/deploy/config.json


# Конфигурация deploy/config.json
DEPLOY_JSON=$HOME/infernet-container-starter/deploy/config.json
sed -i 's|"rpc_url": "[^"]*"|"rpc_url": "'"$RPC_URL"'"|' "$DEPLOY_JSON"
sed -i 's|"private_key": "[^"]*"|"private_key": "'"$PRIVATE_KEY"'"|' "$DEPLOY_JSON"
sed -i 's|"registry_address": "[^"]*"|"registry_address": "'"$REGISTRY_ADDRESS"'"|' "$DEPLOY_JSON"
sed -i 's|"sleep": .*|"sleep": 3,|' "$DEPLOY_JSON"
sed -i 's|"batch_size": .*|"batch_size": 800,|' "$DEPLOY_JSON"
sed -i 's|"trail_head_blocks": .*|"trail_head_blocks": 3,|' "$DEPLOY_JSON"
sed -i 's|"sync_period": .*|"sync_period": 30|' "$DEPLOY_JSON"
sed -i 's|"starting_sub_id": .*|"starting_sub_id": 160000,|' "$DEPLOY_JSON"

# Конфигурация container/config.json
CONTAINER_JSON=$HOME/infernet-container-starter/projects/hello-world/container/config.json

sed -i 's|"rpc_url": "[^"]*"|"rpc_url": "'"$RPC_URL"'"|' "$CONTAINER_JSON"
sed -i 's|"private_key": "[^"]*"|"private_key": "'"$PRIVATE_KEY"'"|' "$CONTAINER_JSON"
sed -i 's|"registry_address": "[^"]*"|"registry_address": "'"$REGISTRY_ADDRESS"'"|' "$CONTAINER_JSON"
sed -i 's|"sleep": .*|"sleep": 3,|' "$CONTAINER_JSON"
sed -i 's|"batch_size": .*|"batch_size": 800,|' "$CONTAINER_JSON"
sed -i 's|"trail_head_blocks": .*|"trail_head_blocks": 3,|' "$CONTAINER_JSON"
sed -i 's|"sync_period": .*|"sync_period": 30|' "$CONTAINER_JSON"
sed -i 's|"starting_sub_id": .*|"starting_sub_id": 160000,|' "$CONTAINER_JSON"

# Конфигурация script/Deploy.s.sol
sed -i 's|address registry = .*|address registry = 0x3B1554f346DFe5c482Bb4BA31b880c1C18412170;|' "$HOME/infernet-container-starter/projects/hello-world/contracts/script/Deploy.s.sol"

# Конфигурация contracts/Makefile
MAKEFILE=$HOME/infernet-container-starter/projects/hello-world/contracts/Makefile
sed -i 's|sender := .*|sender := '"$PRIVATE_KEY"'|' "$MAKEFILE"
sed -i 's|RPC_URL := .*|RPC_URL := '"$RPC_URL"'|' "$MAKEFILE"

#Cтарт контейнеров для инициализации новой конфигурации
sed -i 's|ritualnetwork/infernet-node:.*|ritualnetwork/infernet-node:1.4.0|' $HOME/infernet-container-starter/deploy/docker-compose.yaml
sed -i 's|0.0.0.0:4000:4000|0.0.0.0:4321:4000|' $HOME/infernet-container-starter/deploy/docker-compose.yaml
sed -i 's|8545:3000|8845:3000|' $HOME/infernet-container-starter/deploy/docker-compose.yaml
sed -i 's|container_name: infernet-anvil|container_name: infernet-anvil\n    restart: on-failure|' $HOME/infernet-container-starter/deploy/docker-compose.yaml

docker compose -f $HOME/infernet-container-starter/deploy/docker-compose.yaml up -d

# Установка Foundry
echo -e "${YELLOW}Установка Foundry${NC}"

# Зупиняємо anvil, якщо він уже працює
pkill anvil
sleep 3

cd $HOME
mkdir -p foundry
cd foundry
curl -L https://foundry.paradigm.xyz | bash
echo 'export PATH="$PATH:$HOME/.foundry/bin"' >> $HOME/.bashrc
echo 'export PATH="$PATH:$HOME/.foundry/bin"' >> $HOME/.profile
source $HOME/.bashrc
source $HOME/.profile
$HOME/.foundry/bin/foundryup

# Перевіряємо, що forge встановлений
if ! command -v forge &> /dev/null; then
    echo -e "${RED}Ошибка: forge не найден!${NC}"
    echo -e "${YELLOW}------------------------------------------------------------------------------------${NC}"
    echo 'Если видите эту ☝️  ошибку, то бросьте команды на удаление и заново установите ноду!'
    echo -e "${YELLOW}------------------------------------------------------------------------------------${NC}"
    exit 1
fi

echo -e "${GREEN}Forge успешно установлен!${NC}"

# Установка зависимостей для контрактов
cd $HOME/infernet-container-starter/projects/hello-world/contracts/lib/
rm -r forge-std
rm -r infernet-sdk
forge install foundry-rs/forge-std
forge install ritual-net/infernet-sdk

# Deploy Consumer Contract
cd $HOME/infernet-container-starter
project=hello-world make deploy-contracts >> logs.txt
CONTRACT_ADDRESS=$(grep "Deployed SaysHello" logs.txt | awk '{print $NF}')
rm -rf logs.txt

if [ -z "$CONTRACT_ADDRESS" ]; then
  echo -e "${RED}Произошла ошибка: не удалось прочитать contractAddress из${NC} $CONTRACT_DATA_FILE"
  exit 1
fi

echo -e "${GREEN}Адрес вашего контракта:${NC} $CONTRACT_ADDRESS"
sed -i 's|0x13D69Cf7d6CE4218F646B759Dcf334D82c023d8e|'$CONTRACT_ADDRESS'|' "$HOME/infernet-container-starter/projects/hello-world/contracts/script/CallContract.s.sol"

# Call Consumer Contract
cd $HOME/infernet-container-starter
project=hello-world make call-contract

cd $HOME/infernet-container-starter/deploy

docker compose down
sleep 3
sudo rm -rf docker-compose.yaml
wget https://raw.githubusercontent.com/NodEligible/guides/refs/heads/main/ritual/docker-compose.yaml
docker compose up -d

docker rm -fv infernet-anvil  &>/dev/null

echo -e "${GREEN}Установка Ritua завершена!${NC}"
