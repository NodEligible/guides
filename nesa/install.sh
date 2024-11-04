#!/bin/bash

# Функция для отображения логотипа
display_logo() {
curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/display_logo.sh | bash
}

# Отображение логотипа
display_logo

echo "${green}Установка Main${reset}"
bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/main.sh)

echo "${green}Установка Ufw${reset}"
bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/ufw.sh)

echo "${green}Установка Docker${reset}"
bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/docker.sh)

echo "${green}Установка Go${reset}"
bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/go.sh)

echo "${green}Установка Nesa${reset}"
