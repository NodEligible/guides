#!/bin/bash

curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/display_logo.sh | bash

# Сменные для цветов
YELLOW='\e[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# Проверяем установлен ли вообще дилл и если да - стопаем сервисники удалем сам файл, стопаем нохап запуск
if [ -d "$HOME/dill" ]; then
    sudo systemctl stop dill 
    sudo systemctl disable dill 
    sudo systemctl daemon-reload 
    cd $HOME/dill
    bash stop_dill_node.sh
    rm -f /etc/systemd/system/dill.service
fi

cd $HOME

curl -sO https://raw.githubusercontent.com/DillLabs/launch-dill-node/main/upgrade.sh
chmod +x upgrade.sh
sed -i 's|\./start_dill_node\.sh| |' "$HOME/upgrade.sh"
./upgrade.sh &>/dev/null
rm -rf $HOME/upgrade.sh
