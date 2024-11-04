#!/bin/bash

# Функция для отображения логотипа
display_logo() {
curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/display_logo.sh | bash
}

# Отображение логотипа
display_logo

echo -e "\033[32mУстановка Main\033[0m"
bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/main.sh)

echo -e "\033[32mУстановка Ufw\033[0m"
bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/ufw.sh)

echo -e "\033[32mУстановка Docker\033[0m"
bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/docker.sh)

echo -e "\033[32mУстановка Go\033[0m"
bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/go.sh)

echo -e "\033[32mУстановка Nesa\033[0m"'
