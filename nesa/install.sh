#!/bin/bash


# Функция для отображения логотипа
display_logo() {
curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/display_logo.sh | bash
}

# Отображение логотипа
display_logo

# Функція для виведення тексту зеленим кольором
function green_text {
    # Перевіряємо, чи підтримує термінал кольори
    if tput setaf 1 &> /dev/null; then
        tput setaf 2  # Встановлюємо зелений колір
        echo "$1"     # Виводимо текст
        tput sgr0     # Скидаємо колір до початкового
    else
        echo "$1"     # Якщо кольори не підтримуються, виводимо текст звичайним
    fi
}

# Використання функції green_text для повідомлень
green_text "Установка Docker..."

# Оновлення репозиторіїв і встановлення Docker
sudo apt update -y
sudo apt install -y docker.io

# Перевірка статусу встановлення
if [ $? -eq 0 ]; then
    green_text "Docker успішно встановлено!"
else
    tput setaf 1  # Червоний колір для помилки
    echo "Помилка при встановленні Docker"
    tput sgr0     # Скидаємо колір до початкового
fi
