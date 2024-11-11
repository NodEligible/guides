#!/bin/bash

curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/display_logo.sh | bash

YELLOW='\e[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m

echo -e "${YELLOW}Запуск установки ноды Rivalz...${NC}"

echo -e "${YELLOW}Обновление пакетов...${NC}"
sudo apt update && sudo apt upgrade -y
  if [ $? -eq 0 ]; then
      echo -e "${GREEN}Пакеты успешно обновлены!${NC}"
  else
      echo -e "${RED}Ошибка при обновлении пакетов!${NC}"
  fi

echo -e "${YELLOW}Установка утилиты screen...${NC}"
sudo apt-get install -y screen
  if [ $? -eq 0 ]; then
      echo -e "${GREEN}Screen успешно установлен!${NC}"
  else
      echo -e "${RED}Ошибка при установке Screen!${NC}"
  fi

echo -e "${YELLOW}Установка node.js...${NC}"
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs
  if [ $? -eq 0 ]; then
      echo -e "${GREEN}JS успешно установлен!${NC}"
  else
      echo -e "${RED}Ошибка при установке Js!${NC}"
  fi

echo -e "${YELLOW}Установка ноды Rivalz...${NC}"
npm i -g rivalz-node-cli
  if [ $? -eq 0 ]; then
      echo -e "${GREEN}Rivalz успешно установлен!${NC}"
  else
      echo -e "${RED}Ошибка при установке Rivalz!${NC}"
  fi

echo -e "${YELLOW}Определение пути к файлу${NC}"
FILE="/usr/lib/node_modules/rivalz-node-cli/node_modules/systeminformation/lib/filesystem.js"

echo -e "${YELLOW}Поиска пути к файлу${NC}"
  local search_path="$1"
  find "$search_path" -type f -name "filesystem.js" 2>/dev/null | grep "systeminformation/lib/filesystem.js" | head -n 1

echo -e "${YELLOW}Проверка наличия файла filesystem.js...${NC}"
if [ ! -f "$FILE" ]; then
  echo -e "${RED}Файл не найден по пути $FILE. Попытка найти файл...${NC}"
  FILE=$(find_file_path "/usr/lib")
  
  if [ -z "$FILE" ]; then
    FILE=$(find_file_path "/usr/local/lib")
  fi
  
  if [ -z "$FILE" ];then
    FILE=$(find_file_path "/opt")
  fi
  
  if [ -z "$FILE" ]; then
    # Проверка в пути ~/.nvm
    FILE=$(find_file_path "$HOME/.nvm")
  fi
  
  if [ -z "$FILE" ]; then
     echo -e "${RED}Ошибка: файл filesystem.js не найден. Убедитесь, что npm установлен и путь к файлу корректен.${NC}"
    exit 1
  fi

  echo -e "${GREEN}Файл найден по пути $FILE${NC}"
else
   echo -e "${GREEN}Файл не найден по пути $FILE${NC}"
fi

# Создание временного файла
TMP_FILE=$(mktemp)

# Определение оригинальной и новой строки
ORIGINAL_LINE="devices = outJSON.blockdevices.filter(item => { return (item.type === 'disk') && item.size > 0 && (item.model !== null || (item.mountpoint === null && item.label === null && item.fstype === null && item.parttype === null && item.path && item.path.indexOf('/ram') !== 0 && item.path.indexOf('/loop') !== 0 && item['disc-max'] && item['disc-max'] !== 0)); });"
NEW_LINE="devices = outJSON.blockdevices.filter(item => { return (item.type === 'disk') && item.size > 0 }).sort((a, b) => b.size - a.size);"

# Чтение файла построчно и замена строки
echo -e "${YELLOW}Замена строки в файле filesystem.js...${NC}"
while IFS= read -r line
do
  if [[ "$line" == *"$ORIGINAL_LINE"* ]]; then
    echo "$NEW_LINE" >> "$TMP_FILE"
  else
    echo "$line" >> "$TMP_FILE"
  fi
done < "$FILE"

# Замена оригинального файла измененным
mv "$TMP_FILE" "$FILE"

# Создание сессии screen и запуск ноды
echo -e "${GREEN}Создание screen сессии и запуск ноды Rivalz...${NC}"
screen -S rivalz -dm bash -c 'rivalz run'
screen -r rivalz
