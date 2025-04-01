#!/bin/bash

curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/display_logo.sh | bash

YELLOW='\e[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${YELLOW}Установка бота...${NC}"

# 1. Обновление системы и установка необходимых пакетов
sudo apt update && sudo apt upgrade -y
sudo apt install -y python3 python3-venv python3-pip curl
            
# 2. Создание папки проекта
PROJECT_DIR="$HOME/hyperbolic"
mkdir -p "$PROJECT_DIR"
cd "$PROJECT_DIR" || exit 1
            
# 3. Создание виртуального окружения и установка зависимостей
python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip
pip install requests
deactivate
cd
            
# 4. Скачивание файла hyper_bot.py
BOT_URL="https://raw.githubusercontent.com/NodEligible/guides/main/hyperbolic/hyper_bot.py"
curl -fsSL -o hyperbolic/hyper_bot.py "$BOT_URL"

# 5. Запрос API-ключа и его замена в hyper_bot.py
echo -e "${YELLOW}Введите ваш API-ключ для Hyperbolic:${NC}"
read USER_API_KEY
# Заменяем $API_KEY (в строке) на введённое значение. Предполагается, что в файле строка выглядит как:
# HYPERBOLIC_API_KEY = "$API_KEY"
sed -i "s/HYPERBOLIC_API_KEY = \"\$API_KEY\"/HYPERBOLIC_API_KEY = \"$USER_API_KEY\"/" "$PROJECT_DIR/hyper_bot.py"

# 6. Скачивание файла questions.txt
QUESTIONS_URL="https://raw.githubusercontent.com/NodEligible/guides/main/hyperbolic/questions.txt"
curl -fsSL -o hyperbolic/questions.txt "$QUESTIONS_URL"

# 7. Создание systemd сервиса
# Определяем пользователя и домашнюю директорию
USERNAME=$(whoami)
HOME_DIR=$(eval echo ~$USERNAME)

sudo bash -c "cat <<EOT > /etc/systemd/system/hyper-bot.service
[Unit]
Description=Hyperbolic API Bot Service
After=network.target

[Service]
User=$USERNAME
WorkingDirectory=$HOME_DIR/hyperbolic
ExecStart=$HOME_DIR/hyperbolic/venv/bin/python $HOME_DIR/hyperbolic/hyper_bot.py
Restart=always
Environment=PATH=$HOME_DIR/hyperbolic/venv/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin

[Install]
WantedBy=multi-user.target
EOT"

# 8. Обновление конфигурации systemd и запуск сервиса
sudo systemctl daemon-reload
sudo systemctl restart systemd-journald
sudo systemctl enable hyper-bot.service
sudo systemctl start hyper-bot.service

echo -e "${GREEN}Бот Установлен!${NC}"


