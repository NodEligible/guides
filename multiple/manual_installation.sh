#!/bin/bash

curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/display_logo.sh | bash

#!/bin/bash

YELLOW='\e[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${YELLOW}📥 Установка Main...${NC}"
bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/main.sh)
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Main успешно установлен!${NC}"
else
    echo -e "${RED}❌ Ошибка при установке Main!${NC}"
fi

echo -e "${YELLOW}📥 Установка Ufw...${NC}" 
bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/ufw.sh)
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Ufw успешно установлено!${NC}"
else
    echo -e "${RED}❌ Ошибка при установке Ufw!${NC}"
fi

echo -e "${YELLOW}🚀 Установка Multiple...${NC}"

# Завантаження файлу з Google Drive
wget --no-check-certificate 'https://docs.google.com/uc?export=download&id=1KRKoEyex7hyX5zXPDCJW_kP4G6XX5mNU' -O multipleforlinux.tar

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

# Викликаємо функції для отримання даних
get_identifier
get_pin

# Виконуємо команду
./multiple-cli bind --bandwidth-download 100 --identifier "$IDENTIFIER" --pin "$PIN" --storage 200 --bandwidth-upload 100

# Перевіряємо результат виконання
if [[ $? -ne 0 ]]; then
    echo -e "${RED}Ошибка: Не удалось выполнить привязку аккаунта.${NC}"
    exit 1
fi

echo -e "${GREEN}Установка завершена!${NC}"
