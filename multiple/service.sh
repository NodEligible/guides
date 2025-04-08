#!/bin/bash

# Отображение логотипа
curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/display_logo.sh | bash

#!/bin/bash

# Цвета
YELLOW='\e[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

INSTALL_DIR="/root/multiple_service"
echo -e "${YELLOW}📁 Создание папки $INSTALL_DIR...${NC}"
mkdir -p "$INSTALL_DIR"

CONFIG_FILE="$INSTALL_DIR/multiple_config"
LOG_FILE="$INSTALL_DIR/monitor.log"

# Создаем лог-файл
mkdir -p "$(dirname "$LOG_FILE")"
touch "$LOG_FILE"
chmod 644 "$LOG_FILE"

# Запрос данных
echo -e "${YELLOW}🔹 Введите ваш IDENTIFIER:${NC}"
read -p "> " IDENTIFIER

echo -e "${YELLOW}🔹 Введите ваш PIN:${NC}"
read -p "> " PIN

if [[ -z "$IDENTIFIER" || -z "$PIN" ]]; then
    echo -e "${RED}❌ Ошибка: IDENTIFIER или PIN не могут быть пустыми!${NC}"
    exit 1
fi

# Сохраняем конфигурацию
echo -e "${YELLOW}💾 Сохраняем конфигурацию...${NC}"
echo "IDENTIFIER=$IDENTIFIER" | sudo tee "$CONFIG_FILE" > /dev/null
echo "PIN=$PIN" | sudo tee -a "$CONFIG_FILE" > /dev/null
sudo chmod 600 "$CONFIG_FILE"
echo -e "${GREEN}✅ Конфигурация сохранена в $CONFIG_FILE${NC}"

# Создание monitor.sh
echo -e "${YELLOW}📝 Создание файла мониторинга...${NC}"
cat <<'EOF' > "$INSTALL_DIR/monitor.sh"
#!/bin/bash

YELLOW='\e[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

LOG_FILE="/root/multiple_service/monitor.log"
CONFIG_FILE="/root/multiple_service/multiple_config"

# Загружаем конфиг
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
else
    echo -e "${RED}❌ Файл конфигурации не найден: $CONFIG_FILE${NC}"
    exit 1
fi

while true; do
    STATUS_OUTPUT=$(/root/multipleforlinux/multiple-cli status)
    if echo "$STATUS_OUTPUT" | grep -q " :False"; then
        echo -e "$({ date '+%Y-%m-%d %H:%M:%S'; }) ⛔️ ${RED} Узел не запущен. Выполнение команды bind...${NC}" | tee -a "$LOG_FILE"
        /root/multipleforlinux/multiple-cli bind --bandwidth-download 100 --identifier "$IDENTIFIER" --pin "$PIN" --storage 200 --bandwidth-upload 100
    else
        echo -e "$({ date '+%Y-%m-%d %H:%M:%S'; }) ✅ ${GREEN} Узел уже привязан. NodeRun: True, IsMain: True.${NC}" | tee -a "$LOG_FILE"
    fi
    sleep 300
done
EOF

chmod +x "$INSTALL_DIR/monitor.sh"

# Создание systemd-сервиса
echo -e "${YELLOW}⚙️ Создаём systemd-сервис...${NC}"
SERVICE_FILE="/etc/systemd/system/multiple-healthcheck.service"

sudo tee "$SERVICE_FILE" > /dev/null <<EOF
[Unit]
Description=Multiple Health Check Service
After=network.target

[Service]
User=root
ExecStart=/bin/bash $INSTALL_DIR/monitor.sh
Restart=always
RestartSec=10
StandardOutput=append:$INSTALL_DIR/service.log
StandardError=append:$INSTALL_DIR/service.log

[Install]
WantedBy=multi-user.target
EOF

# Запуск сервиса
echo -e "${YELLOW}🚀 Запускаем сервис multiple-healthcheck...${NC}"
sudo systemctl daemon-reload
sudo systemctl enable multiple-healthcheck
sudo systemctl start multiple-healthcheck

echo -e "${GREEN}✅ Установка завершена! Сервис запущен.${NC}"


