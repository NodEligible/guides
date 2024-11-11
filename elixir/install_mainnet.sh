#!/bin/bash

logo() {
  curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/display_logo.sh | bash
}

YELLOW='\e[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'


install_docker() {
    if ! type "docker" > /dev/null; then
        echo -e "${YELLOW}Установка Docker...${NC}"
        bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/docker.sh)
    else
        echo -e "${GREEN}Docker уже установлен!${NC}"
    fi
}

prepare_files() {
    echo -e "${YELLOW}Подготавливаем файлы конфига${NC}"
    if [ ! -d "$HOME/elixir" ]; then
        rm -rf $HOME/elixir
    fi

    docker rm -f ev &>/dev/null

    mkdir -p $HOME/elixir && cd $HOME/elixir

    STRATEGY_EXECUTOR_IP_ADDRESS=$(hostname -I | cut -d' ' -f1)
    read -p "Введите имя вашей ноды(это имя будет отображаться на дашбордах) " STRATEGY_EXECUTOR_DISPLAY_NAME
    read -p "Введите адрес кошелька(этот кошелек будет использоваться для ревардов) " STRATEGY_EXECUTOR_BENEFICIARY
    read -p "Введите приватный ключ с предыдущего пункта. Приватный ключ НЕ должен содержать приставку 0x " SIGNER_PRIVATE_KEY

    sudo tee $HOME/elixir/.env > /dev/null <<EOF
ENV=prod

STRATEGY_EXECUTOR_IP_ADDRESS=$STRATEGY_EXECUTOR_IP_ADDRESS
STRATEGY_EXECUTOR_DISPLAY_NAME=$STRATEGY_EXECUTOR_DISPLAY_NAME
STRATEGY_EXECUTOR_BENEFICIARY=$STRATEGY_EXECUTOR_BENEFICIARY
SIGNER_PRIVATE_KEY=$SIGNER_PRIVATE_KEY
EOF
}

run_docker() {
    echo -e "${YELLOW}Запускаем докер контейнер для валидатора${NC}"
    docker pull elixirprotocol/validator --platform linux/amd64
    if [ ! "$(docker ps -q -f name=^elixir$)" ]; then
        if [ "$(docker ps -aq -f status=exited -f name=^elixir$)" ]; then
            echo -e "${YELLOW}Докер контейнер уже существует в статусе exited. Удаляем его и запускаем заново${NC}"
            docker rm -f elixir &>/dev/null
        fi
    fi
    cd $HOME/elixir
    docker run --env-file $HOME/elixir/.env --name elixir --platform linux/amd64 --restart always -p 17690:17690 elixirprotocol/validator
  }

logo
prepare_files
install_docker
run_docker
