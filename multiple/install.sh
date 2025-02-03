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
ARCH=$(uname -m)
if [[ "$ARCH" == "x86_64" ]]; then
    CLIENT_URL="https://cdn.app.multiple.cc/client/linux/x64/multipleforlinux.tar"
elif [[ "$ARCH" == "aarch64" ]]; then
    CLIENT_URL="https://cdn.app.multiple.cc/client/linux/arm64/multipleforlinux.tar"
else
    echo -e "Неподдерживаемая архитектура системы: $ARCH"
    exit 1
fi

wget $CLIENT_URL -O multipleforlinux.tar

tar -xvf multipleforlinux.tar
rm -rf multipleforlinux.tar

cd multipleforlinux
chmod +x ./multiple-cli
chmod +x ./multiple-node

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


