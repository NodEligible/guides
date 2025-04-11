#!/bin/bash

curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/display_logo.sh | bash

# Сменные для цветов
YELLOW='\e[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

  echo -e "${YELLOW}Установка Ufw...${NC}" 
  bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/ufw.sh)
  if [ $? -eq 0 ]; then
      echo -e "${GREEN}Ufw успешно установлено!${NC}"
  else
      echo -e "${RED}Ошибка при установке Ufw!${NC}"
      exit 1
  fi

      echo -e "${YELLOW}Установка Main...${NC}"
  bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/main.sh)
  if [ $? -eq 0 ]; then
      echo -e "${GREEN}Main успешно установлен!${NC}"
  else
      echo -e "${RED}Ошибка при установке Main!${NC}"
      exit 1
  fi

echo -e "${YELLOW}Остановка сервиса${NC}"
if [ -d "$HOME/dill" ]; then
    sudo systemctl stop dill 
    sudo systemctl disable dill 
    sudo systemctl daemon-reload 
    cd $HOME/dill
    bash stop_dill_node.sh
    rm -f /etc/systemd/system/dill.service
fi


echo -e "${YELLOW}Обновляем Dill${NC}"
cd $HOME

# Завантажуємо скрипт оновлення Dill
wget https://raw.githubusercontent.com/DillLabs/launch-dill-node/main/upgrade.sh -O $HOME/upgrade.sh
chmod +x upgrade.sh

# Видаляємо запуск 1_start_dill_node.sh, якщо він там є
sed -i '/1_launch_dill_node.sh/d' "$HOME/upgrade.sh"

# Запускаємо оновлення
bash ./upgrade.sh

# Прибираємо скрипт оновлення
rm -f $HOME/upgrade.sh

# Качаємо скрипт сервісника
cd $HOME/dill
curl -sO https://raw.githubusercontent.com/NodEligible/guides/main/dill/dill_service.sh
chmod +x dill_service.sh

# Міняємо дефолтні порти
sed -i 's|monitoring-port  9080 tcp|monitoring-port  8380 tcp|' "$HOME/dill/default_ports.txt"
sed -i 's|exec-http.port 8545 tcp|exec-http.port 8945 tcp|' "$HOME/dill/default_ports.txt"
sed -i 's|exec-port 30303 tcp|exec-port 30305 tcp|g; s|exec-port 30303 udp|exec-port 30305 udp|g' "$HOME/dill/default_ports.txt"

# Замінюємо старий запуск на виклик dill_service.sh з параметрами
sed -i 's|nohup \$PJROOT/\$NODE_BIN \$COMMON_FLAGS \$DISCOVERY_FLAGS \$VALIDATOR_FLAGS \$PORT_FLAGS > /dev/null 2>&1 &|\$PJROOT/dill_service.sh "\$PJROOT/\$NODE_BIN \$COMMON_FLAGS \$DISCOVERY_FLAGS \$VALIDATOR_FLAGS \$PORT_FLAGS"|' "root/dill/start_dill_node.sh"

# Перезапускаємо ноду через systemd
# 8. Перезапускаємо ноду через systemd
echo -e "${YELLOW}🔁 Перезапускаємо Dill через systemd...${NC}"
sudo systemctl daemon-reload

if sudo systemctl restart dill; then
  echo -e "${GREEN}✅ Dill нода успішно оновлена та перезапущена!${NC}"
else
  echo -e "${RED}❌ Помилка під час перезапуску Dill. Перевір: journalctl -u dill -e${NC}"
fi

echo -e "${GREEN}Обновление завершено!${NC}"
