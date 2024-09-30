#!/bin/bash

# Функция для отображения логотипа
display_logo() {
  echo -e '\e[0;37m'
  echo "███╗   ██╗ ██████╗ ██████╗ ███████╗███╗   ██╗ ██████╗ ██╗███╗   ██╗███████╗"
  echo "████╗  ██║██╔═══██╗██╔══██╗██╔════╝████╗  ██║██╔════╝ ██║████╗  ██║██╔════╝"
  echo "██╔██╗ ██║██║   ██║██║  ██║█████╗  ██╔██╗ ██║██║  ███╗██║██╔██╗ ██║█████╗  "
  echo "██║╚██╗██║██║   ██║██║  ██║██╔══╝  ██║╚██╗██║██║   ██║██║██║╚██╗██║██╔══╝  "
  echo "██║ ╚████║╚██████╔╝██████╔╝███████╗██║ ╚████║╚██████╔╝██║██║ ╚████║███████╗"
  echo "╚═╝  ╚═══╝ ╚═════╝ ╚═════╝ ╚══════╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝╚═╝  ╚═══╝╚══════╝"                                                                        
  echo -e '\e[0m'

  echo -e "\nПідписуйтеся на канал Vitok про Bitok щоб бути в курсі самих актуальних нод - https://t.me/vitoooookBitok"
}

# Функция для логирования
log_message() {
  echo -e "\e[33m'$1'\e[0m"
}

# Отображение логотипа
display_logo

# Вывод надписи зеленым цветом
log_message 'Запуск установки ноды Rivalz...'

# Обновление пакетов
log_message 'Обновление пакетов...'
sudo apt update && sudo apt upgrade -y

# Установка утилиты screen
log_message 'Установка утилиты screen...'
sudo apt-get install -y screen

# Установка node.js
log_message 'Установка node.js...'
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs

# Установка ноды Rivalz
log_message 'Установка ноды Rivalz...'
npm i -g rivalz-node-cli

# Определение пути к файлу
FILE="/usr/lib/node_modules/rivalz-node-cli/node_modules/systeminformation/lib/filesystem.js"

# Функция для поиска пути к файлу
find_file_path() {
  local search_path="$1"
  find "$search_path" -type f -name "filesystem.js" 2>/dev/null | grep "systeminformation/lib/filesystem.js" | head -n 1
}

# Проверка наличия файла
log_message 'Проверка наличия файла filesystem.js...'
if [ ! -f "$FILE" ]; then
  log_message "Файл не найден по пути $FILE. Попытка найти файл..."
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
    log_message "Ошибка: файл filesystem.js не найден. Убедитесь, что npm установлен и путь к файлу корректен."
    exit 1
  fi

  log_message "Файл найден по пути $FILE"
else
  log_message "Файл найден по пути $FILE"
fi

# Создание временного файла
TMP_FILE=$(mktemp)

# Определение оригинальной и новой строки
ORIGINAL_LINE="devices = outJSON.blockdevices.filter(item => { return (item.type === 'disk') && item.size > 0 && (item.model !== null || (item.mountpoint === null && item.label === null && item.fstype === null && item.parttype === null && item.path && item.path.indexOf('/ram') !== 0 && item.path.indexOf('/loop') !== 0 && item['disc-max'] && item['disc-max'] !== 0)); });"
NEW_LINE="devices = outJSON.blockdevices.filter(item => { return (item.type === 'disk') && item.size > 0 }).sort((a, b) => b.size - a.size);"

# Чтение файла построчно и замена строки
log_message 'Замена строки в файле filesystem.js...'
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
log_message 'Создание screen сессии и запуск ноды Rivalz...'
screen -S rivalz -dm bash -c 'rivalz run'
screen -r rivalz
