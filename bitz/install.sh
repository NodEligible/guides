#!/bin/bash

curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/display_logo.sh | bash

YELLOW='\e[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${YELLOW}Установка Main...${NC}"
bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/main.sh)
  if [ $? -eq 0 ]; then
      echo -e "${GREEN}Main успешно установлен!${NC}"
  else
      echo -e "${RED}Ошибка при установке Main!${NC}"
  fi

echo -e "${YELLOW}Установка Rust...${NC}"
bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/rust.sh)
  if [ $? -eq 0 ]; then
      echo -e "${GREEN}Rust успешно установлено!${NC}"
  else
      echo -e "${RED}Ошибка при установке Rust!${NC}"
  fi

echo -e "${YELLOW}Установка Solana CLI...${NC}"
curl --proto '=https' --tlsv1.2 -sSfL https://solana-install.solana.workers.dev | bash 

sleep 3

echo -e "${YELLOW}Проверка наличия команды 'solana'...${NC}"
if ! command -v solana &> /dev/null; then
    echo -e "${RED}❗ Команда 'solana' не найдена. Выполняю source ~/.profile...${NC}"
    source $HOME/.profile

    if ! command -v solana &> /dev/null; then
        echo -e "${RED}❌ После выполнения source ~/.profile команда 'solana' всё ещё недоступна.${NC}"
        echo -e "${RED}Убедитесь, что Solana установлена и добавлена в PATH.${NC}"
        exit 1
    else
        echo -e "${GREEN}✅ Solana найдена после source. Проверяем версию...${NC}"
        solana --version
    fi
else
    echo -e "${GREEN}✅ Команда 'solana' доступна. Версия:${NC}"
    solana --version
fi

sleep 3

echo -e "${YELLOW}Меняем RPC${NC}"
solana config set --url https://eclipse.helius-rpc.com/

sleep 3

echo -e "${YELLOW}Генерируете новый кошелек${NC}"
solana-keygen new

sleep 3

echo -e "${YELLOW}Ваш приватный ключ${NC}"
cat $HOME/.config/solana/id.json
















