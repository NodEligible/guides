#!/bin/bash


# Функция для отображения логотипа
display_logo() {
curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/display_logo.sh | bash
}

# Отображение логотипа
display_logo

# Встановлюємо Docker
echo "${green}Установка Docker${reset}"
sudo apt update
sudo apt install -y docker.io
