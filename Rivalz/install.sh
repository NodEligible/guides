#!/bin/bash

# Display the logo (assuming it's needed)
curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/display_logo.sh | bash

# Color codes for output
YELLOW='\e[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${YELLOW}Запуск установки ноды Rivalz...${NC}"

# Updating packages
echo -e "${YELLOW}Обновление пакетов...${NC}"
sudo apt update && sudo apt upgrade -y
if [ $? -eq 0 ]; then
    echo -e "${GREEN}Пакеты успешно обновлены!${NC}"
else
    echo -e "${RED}Ошибка при обновлении пакетов!${NC}"
fi

# Installing screen utility
echo -e "${YELLOW}Установка утилиты screen...${NC}"
sudo apt-get install -y screen
if [ $? -eq 0 ]; then
    echo -e "${GREEN}Screen успешно установлен!${NC}"
else
    echo -e "${RED}Ошибка при установке Screen!${NC}"
fi

# Installing Node.js
echo -e "${YELLOW}Установка node.js...${NC}"
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs
if [ $? -eq 0 ]; then
    echo -e "${GREEN}JS успешно установлен!${NC}"
else
    echo -e "${RED}Ошибка при установке Js!${NC}"
fi

# Installing Rivalz node
echo -e "${YELLOW}Установка ноды Rivalz...${NC}"
npm i -g rivalz-node-cli
if [ $? -eq 0 ]; then
    echo -e "${GREEN}Rivalz успешно установлен!${NC}"
else
    echo -e "${RED}Ошибка при установке Rivalz!${NC}"
fi

# Define the path to filesystem.js
FILE="/usr/lib/node_modules/rivalz-node-cli/node_modules/systeminformation/lib/filesystem.js"

# Checking and finding filesystem.js if it’s not found
echo -e "${YELLOW}Проверка наличия файла filesystem.js...${NC}"
if [ ! -f "$FILE" ]; then
    echo -e "${RED}Файл не найден по пути $FILE. Попытка найти файл...${NC}"
    FILE=$(find /usr/lib /usr/local/lib /opt "$HOME/.nvm" -type f -name "filesystem.js" 2>/dev/null | grep "systeminformation/lib/filesystem.js" | head -n 1)
    if [ -z "$FILE" ]; then
        echo -e "${RED}Ошибка: файл filesystem.js не найден. Убедитесь, что npm установлен и путь к файлу корректен.${NC}"
        exit 1
    fi
    echo -e "${GREEN}Файл найден по пути $FILE${NC}"
else
    echo -e "${GREEN}Файл найден по пути $FILE${NC}"
fi

# Creating a temporary file for modifications
TMP_FILE=$(mktemp)

# Original and replacement line definitions
ORIGINAL_LINE="devices = outJSON.blockdevices.filter(item => { return (item.type === 'disk') && item.size > 0 && (item.model !== null || (item.mountpoint === null && item.label === null && item.fstype === null && item.parttype === null && item.path && item.path.indexOf('/ram') !== 0 && item.path.indexOf('/loop') !== 0 && item['disc-max'] && item['disc-max'] !== 0)); });"
NEW_LINE="devices = outJSON.blockdevices.filter(item => { return (item.type === 'disk') && item.size > 0 }).sort((a, b) => b.size - a.size);"

# Replacing line in filesystem.js
echo -e "${YELLOW}Замена строки в файле filesystem.js...${NC}"
while IFS= read -r line
do
    if [[ "$line" == *"$ORIGINAL_LINE"* ]]; then
        echo "$NEW_LINE" >> "$TMP_FILE"
    else
        echo "$line" >> "$TMP_FILE"
    fi
done < "$FILE"

# Overwrite the original file with the modified content
mv "$TMP_FILE" "$FILE"

# Creating screen session and running Rivalz node
echo -e "${GREEN}Создание screen сессии и запуск ноды Rivalz...${NC}"
screen -S rivalz -dm bash -c 'sleep 3; rivalz run'
screen -r rivalz

