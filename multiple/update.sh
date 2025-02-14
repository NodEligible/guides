#!/bin/bash

curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/display_logo.sh | bash

YELLOW='\e[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

DATA_FILE="$HOME/.multiple_data" # Файл для збереження даних

echo -e "${YELLOW}🔄 Обновление пакетов...${NC}"
sudo apt update
sudo apt install python3 python3-pip -y

echo -e "${YELLOW}📥 Установка Gdown...${NC}"
pip install gdown

echo -e "${YELLOW}🚀 Обновление Multiple...${NC}"

# Видалення старої версії (якщо потрібно)
if [ -d "$HOME/multipleforlinux" ]; then
    echo -e "${YELLOW}Удаление старой версии Multiple...${NC}"
    sudo systemctl stop multiple
    rm -rf "$HOME/multipleforlinux"
fi

# Завантаження нового файлу
gdown --id 1KRKoEyex7hyX5zXPDCJW_kP4G6XX5mNU -O multipleforlinux.tar

# Розпакування архіву
tar -xvf multipleforlinux.tar
rm -rf multipleforlinux.tar

# Перехід у директорію
cd multipleforlinux
chmod +x ./multiple-cli
chmod +x ./multiple-node

# Додавання до PATH
echo "PATH=\$PATH:$(pwd)" >> $HOME/.bash_profile
source $HOME/.bash_profile

# Перезапуск служби
sudo tee /etc/systemd/system/multiple.service > /dev/null << EOF
[Unit]
Description=Multiple Network node client on a Linux Operating System
After=network-online.target

[Service]
User=$USER
ExecStart=$HOME/multipleforlinux/multiple-node
Restart=on-failure
RestartSec=10
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable multiple
sudo systemctl start multiple

# Завантаження даних з файлу
if [ -f "$DATA_FILE" ]; then
    source "$DATA_FILE"
    echo -e "${GREEN}✅ Данные успешно загружены из файла: Account ID: $IDENTIFIER, PIN: $PIN${NC}"
else
    echo -e "${YELLOW}🔗 Введите данные для Multiple...${NC}"
    
    # Функція для запиту Account ID
    get_identifier() {
        while [[ -z "$IDENTIFIER" ]]; do
            echo -e "${YELLOW}🔗 Введите ваш Account ID:${NC}"
            read IDENTIFIER
            if [[ -z "$IDENTIFIER" ]]; then
                echo -e "${RED}Ошибка: Account ID не может быть пустым. Попробуйте снова.${NC}"
            fi
        done
    }

    # Функція для запиту PIN
    get_pin() {
        while [[ -z "$PIN" ]]; do
            echo -e "${YELLOW}🔗 Установите ваш PIN:${NC}"
            read PIN
            if [[ -z "$PIN" ]]; then
                echo -e "${RED}Ошибка: PIN не может быть пустым. Попробуйте снова.${NC}"
            fi
        done
    }

    # Виклик функцій
    get_identifier
    get_pin

    # Збереження даних у файл
    echo "IDENTIFIER=$IDENTIFIER" > "$DATA_FILE"
    echo "PIN=$PIN" >> "$DATA_FILE"
    echo -e "${GREEN}✅ Данные сохранены в файл $DATA_FILE${NC}"
fi

# Виконуємо команду
./multiple-cli bind --bandwidth-download 100 --identifier "$IDENTIFIER" --pin "$PIN" --storage 200 --bandwidth-upload 100

# Перевіряємо результат виконання
if [[ $? -ne 0 ]]; then
    echo -e "${RED}Ошибка: Не удалось выполнить привязку аккаунта.${NC}"
    exit 1
fi

echo -e "${GREEN}Обновление завершено!${NC}"
