# Відображення логотипу
curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/display_logo.sh | bash

YELLOW='\e[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${YELLOW}Установка Docker...${NC}"
bash <(curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/docker.sh)
if [ $? -eq 0 ]; then
     echo -e "${GREEN}Docker успешно установлено!${NC}"
else
     echo -e "${RED}Ошибка при установке Docker!${NC}"
fi

update() {
    echo -e "${YELLOW}Обновление пакетов...${NC}"
    sudo apt update -y && sudo apt-get update
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Пакеты успешно обновлены!${NC}"
    else
        echo -e "${RED}Ошибка при обновлении пакетов!${NC}"
    fi
}
