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

function {
echo -e "${GREEN}Установка Main${NORMA}"
bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/main.sh)
}

function {
echo -e "${GREEN}Установка Ufw${NORMA}"
bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/ufw.sh)
}

function {
echo -e "${GREEN}Установка Docker${NORMA}"
bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/docker.sh)
}

function {
echo -e "${GREEN}Установка Go${NORMA}"
bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/go.sh)
}

function {
echo -e "${GREEN}Установка Nesa${NORMA}"
}
