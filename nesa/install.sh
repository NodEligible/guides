#!/bin/bash

# Функция для отображения логотипа
display_logo() {
curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/display_logo.sh | bash
}

# Функция для логирования
log_message() {
  echo -e "\e[33m'$1'\e[0m"
}

# Отображение логотипа
display_logo

log_message 'Установка Main'
curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/main.sh | bash &>/dev/null

log_message 'Установка Ufw'
curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/ufw.sh | bash &>/dev/null

log_message 'Установка Docker'
curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/docker.sh | bash &>/dev/null

log_message 'Установка Go'
curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/go.sh | bash &>/dev/null
