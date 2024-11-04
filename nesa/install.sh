#!/bin/bash

function colors {
  GREEN="\e[32m"
  NORMAL="\e[0m"
}
# Функция для отображения логотипа
display_logo() {
curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/display_logo.sh | bash
}

# Отображение логотипа
display_logo

echo -e "${GREEN}Установка Main${NORMA}"
bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/main.sh)

echo -e "${GREEN}Установка Ufw${NORMA}"
bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/ufw.sh)

echo -e "${GREEN}Установка Docker${NORMA}"
bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/docker.sh)

echo -e "${GREEN}Установка Go${NORMA}"
bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/go.sh)

echo -e "${GREEN}Установка Nesa${NORMA}"
