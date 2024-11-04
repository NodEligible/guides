#!/bin/bash

# Функция для отображения логотипа
display_logo() {
curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/display_logo.sh | bash
}

# Отображение логотипа
display_logo

printf "\033[32mУстановка Main\033[0m"
bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/main.sh)

printf "\033[32mУстановка Ufw\033[0m"
bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/ufw.sh)

printf "\033[32mУстановка Docker\033[0m"
bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/docker.sh)

printf "\033[32mУстановка Go\033[0m"
bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/go.sh)

printf "\033[32mУстановка Nesa\033[0m"'
