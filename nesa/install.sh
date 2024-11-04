#!/bin/bash

function colors {
  GREEN="\e[32m"
  YELLOW="\e[33m"
  RED="\e[39m"
  NORMAL="\e[0m"
}

# Функция для отображения логотипа
display_logo() {
curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/display_logo.sh | bash
}

# Отображение логотипа
display_logo

function install_Main {
echo -e "${YELLOW}Устанавливаем Main${NORMAL}"
        bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/main.sh)
        else
        echo -e "${GREEN}Докер уже установлен. Переходим на следующий шаг${NORMAL}"
}
