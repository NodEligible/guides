#!/bin/bash

# Відображення логотипу
curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/display_logo.sh | bash

YELLOW='\e[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# Оновлення системи
echo -e "${YELLOW}Обновление пакетов...${NC}"
sudo apt update && sudo apt upgrade -y
if [ $? -eq 0 ]; then
    echo -e "${GREEN}Пакеты успешно обновлены!${NC}"
else
    echo -e "${RED}Ошибка при обновлении пакетов!${NC}"
    exit 1
fi

echo -e "${YELLOW}Установка Docker...${NC}"
bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/docker.sh)
if [ $? -eq 0 ]; then
     echo -e "${GREEN}Docker успешно установлено!${NC}"
else
     echo -e "${RED}Ошибка при установке Docker!${NC}"
fi

echo -e "${YELLOW}Делаем бекап...${NC}"
DATA_FILE="/root/cysic_backup/keys"
SOURCE_DIR="/root/.cysic/keys"
BACKUP_DIR="/root/cysic_backup"

# Видаляємо попередній бекап (не обов'язково, можна пропустити)
if [[ -f "$DATA_FILE" ]]; then
    echo -e "${YELLOW}⚠️ Файл${NC} $DATA_FILE ${YELLOW}уже есть. Удаляю...${NC}"
    sudo rm -f "$DATA_FILE"
fi

# Створюємо директорію, якщо не існує
mkdir -p "$BACKUP_DIR"

# Знаходимо перший .key файл у директорії
KEY_FILE=$(find "$SOURCE_DIR" -type f -name "*.key" | head -n 1)

if [[ -f "$KEY_FILE" ]]; then
    cp "$KEY_FILE" "$BACKUP_DIR/"
    echo -e "${GREEN}Бекап сделан: $(basename "$KEY_FILE")${NC}"
else
    echo -e "${RED}Файл ключа (.key) не найден в $SOURCE_DIR!${NC}"
fi

# Отримуємо адресу для винагороди з конфігурації
CONFIG_FILE="/root/cysic-verifier/config.yaml"
if [[ -f "$CONFIG_FILE" ]]; then
    CLAIM_REWARD_ADDRESS=$(grep 'claim_reward_address:' "$CONFIG_FILE" | awk -F'"' '{print $2}')
    echo -e "${GREEN}Сохраняем адрес:${NC} $CLAIM_REWARD_ADDRESS"
fi


# Видалення старих каталогів і створення нових
echo -e "${YELLOW}Удаление старых каталогов и установка новых${NC}"
sudo systemctl stop cysic-verifier.service
pkill -f "./verifier"
rm -rf ~/cysic-verifier
rm -rf $HOME/.cysic
sudo systemctl disable cysic-verifier.service 
sudo rm /etc/systemd/system/cysic-verifier.service
sudo systemctl daemon-reload

sleep 3

cd ~
mkdir cysic-verifier
curl -L https://github.com/cysic-labs/cysic-phase3/releases/download/v1.0.0/verifier_linux >~/cysic-verifier/verifier
curl -L https://github.com/cysic-labs/cysic-phase3/releases/download/v1.0.0/libdarwin_verifier.so >~/cysic-verifier/libdarwin_verifier.so
curl -L https://github.com/cysic-labs/cysic-phase3/releases/download/v1.0.0/librsp.so >~/cysic-verifier/librsp.so
if [ $? -eq 0 ]; then
    echo -e "${GREEN}Каталоги созданы успешно!${NC}"
else
    echo -e "${RED}Ошибка при создании каталогов!${NC}"
    exit 1
fi

# Створення конфігураційного файлу
cat <<EOF > ~/cysic-verifier/config.yaml
# Not Change
chain:
  # Not Change
  # endpoint: "node-pre.prover.xyz:80"
  endpoint: "grpc-testnet.prover.xyz:80"
  # Not Change
  chain_id: "cysicmint_9001-1"
  # Not Change
  gas_coin: "CYS"
  # Not Change
  gas_price: 10
  # Modify Here：! Your Address (EVM) submitted to claim rewards
claim_reward_address: "$CLAIM_REWARD_ADDRESS"

server:
  # don't modify this
  cysic_endpoint: "https://ws-pre.prover.xyz"
EOF

# Налаштування виконуваного файлу та запуск
cd ~/cysic-verifier/
chmod +x ~/cysic-verifier/verifier

# Створення скрипта start.sh з підтримкою логів
cat <<EOF > ~/cysic-verifier/start.sh
#!/bin/bash

# Перевірка, чи існує файл logs.txt
if [ ! -f ~/cysic-verifier/logs.txt ]; then
    touch ~/cysic-verifier/logs.txt
    chmod 644 ~/cysic-verifier/logs.txt
fi

# Запуск verifier із записом логів
LD_LIBRARY_PATH=. CHAIN_ID=534352 ./verifier >> ~/cysic-verifier/logs.txt 2>&1
EOF

# Налаштування прав для виконання скрипта
chmod +x ~/cysic-verifier/start.sh

sleep 3

# Повертаємо резервну копію назад
KEY_FILE=$(find "$BACKUP_DIR" -type f -name "*.key" | head -n 1)

if [[ -f "$KEY_FILE" ]]; then
    mkdir -p "$SOURCE_DIR"
    cp "$KEY_FILE" "$SOURCE_DIR/"
    echo -e "${GREEN}Бекап восстановлен: $(basename "$KEY_FILE")${NC}"
else
    echo -e "${RED}Резервная копия не найдена. Пропуск восстановления.${NC}"
    exit 1
fi


# Створення скрипта управління
cat <<EOF > ~/cysic-verifier/manage_verifier.sh
#!/bin/bash

YELLOW='\e[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

case \$1 in
    start)
        echo -e "\${YELLOW}Старт cysic-verifier...\${NC}"
        cd /root/cysic-verifier && bash start.sh > /root/cysic-verifier/logs.txt 2>&1 &
        echo -e "\${GREEN}Cysic verifier запущен.${NC}"
        ;;
    stop)
        echo -e "\${YELLOW}Остановка cysic-verifier...\${NC}"
        pkill -f "./verifier"
        echo -e "\${GREEN}Cysic-verifier остановлен.${NC}"
        ;;
    status)
        echo -e "\${YELLOW}Проверка статуса cysic-verifier...\${NC}"
        ps aux | grep "./verifier" | grep -v "grep"
        ;;
    logs)
        echo -e "\${YELLOW}Проверка логов cysic-verifier...\${NC}"
        tail -f /root/cysic-verifier/logs.txt
        ;;
    restart)
        echo -e "\${YELLOW}Перезапуск cysic-verifier...\${NC}"
        pkill -f "./verifier"
        sleep 2
        cd /root/cysic-verifier && bash start.sh > /root/cysic-verifier/logs.txt 2>&1 &
        echo -e "\${GREEN}Cysic-verifier успешно перезапущен.${NC}"
        ;;
    *)
        echo "Usage: \$0 {start|stop|status|logs|restart}"
        ;;
esac
EOF
chmod +x ~/cysic-verifier/manage_verifier.sh

# Створення сервісного файлу
cat <<EOF | sudo tee /etc/systemd/system/cysic-verifier.service > /dev/null
[Unit]
Description=Cysic Verifier Node
After=network.target

[Service]
User=root
WorkingDirectory=/root/cysic-verifier
ExecStart=/bin/bash /root/cysic-verifier/start.sh
Restart=on-abort
RestartSec=10
Environment=LD_LIBRARY_PATH=.
Environment=CHAIN_ID=534352

[Install]
WantedBy=multi-user.target
EOF

# Увімкнення сервісу
sudo systemctl enable cysic-verifier.service 
sudo systemctl daemon-reload
sudo systemctl start cysic-verifier.service

# Удаляем бекап
rm -rf /root/cysic_backup

echo -e "${GREEN}Обновление ноды Cysic завершено🚀${NC}"
