#!/bin/bash

# === Цвета ===
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'


echo -e "${GREEN}✅ Установка и запуск Netrum Lite Node завершены!${NC}"
echo -e "${YELLOW}──────────────────────────────────────────────${NC}"
echo -e "${GREEN}📄 Логи синка:${NC} journalctl -fu netrum-node.service"
echo -e "${GREEN}📄 Логи майнера:${NC} tail -n 10 /var/log/netrum_mining.log"
echo -e "${YELLOW}──────────────────────────────────────────────${NC}"

echo -e "${YELLOW}──────────────────────${NC}"
echo -e "${GREEN}📦  Делаем бекап${NC}"
echo -e "${YELLOW}──────────────────────${NC}"
echo
echo -e "${YELLOW}📁  Сохраните следующую папку${NC} data ${YELLOW}и отдельно файлы з папки${NC} src:"
echo -e "    ${CYAN}/root/netrum-lite-node/data${NC}                    — данные ноды (включает базу и ключи)"
echo -e "    ${CYAN}/root/netrum-lite-node/src/wallet/key.txt${NC}       — приватный ключ вашего кошелька"
echo -e "    ${CYAN}/root/netrum-lite-node/src/identity/node-id/basename.txt${NC} — имя идентификатора ноды"
echo -e "    ${CYAN}/root/netrum-lite-node/src/identity/node-id/id.txt${NC}       — уникальный ID вашей ноды"
echo
echo -e "${YELLOW}⚠️  Важно:${NC} без этих папок вы потеряете доступ к вашему кошельку и ноде!"
echo
echo
echo
echo -e "${YELLOW}────────────────────────────────────────────────────────────${NC}"
echo -e "${GREEN}📦  Этап восстановления Netrum Lite Node из резервной копии${NC}"
echo -e "${YELLOW}────────────────────────────────────────────────────────────${NC}"
echo
echo -e "${YELLOW}1️⃣  Загрузите файлы вашего бэкапа в каталог:${NC}"
echo -e "    ${CYAN}/root/netrum-lite-node/${NC}"
echo
echo -e "${YELLOW}2️⃣  Удалите папку data если она создалась при установке:${NC}"
echo -e "    ${RED}data${NC}"
echo
echo -e "${YELLOW}3️⃣  Скопируйте свою папку и файлы из бэкапа обратно в папку src:${NC}"
echo -e "    ${GREEN}/root/netrum-lite-node/data${NC}"
echo -e "    ${GREEN}/root/netrum-lite-node/src/wallet/key.txt${NC}"
echo -e "    ${GREEN}/root/netrum-lite-node/src/identity/node-id/basename.txt${NC}"
echo -e "    ${GREEN}/root/netrum-lite-node/src/identity/node-id/id.txt${NC}"
echo
echo -e "${YELLOW}⚠️  ВАЖНО:${NC}"
echo -e "   - Структура каталогов должна оставаться такой же, как в бэкапе."
echo -e "   - Не изменяйте имена папок и файлов внутри data и src."
echo -e "   - После копирования проверьте права доступа:"
