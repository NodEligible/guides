#!/bin/bash

# === Цвета ===
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${YELLOW}🔄 Обновляем wrapper для команды pop...${NC}"
sleep 1

# --- Удаляем старый wrapper ---
if [ -f /usr/local/bin/pop ]; then
    echo -e "${YELLOW}🗑 Удаляем старый wrapper...${NC}"
    sudo rm -f /usr/local/bin/pop
    echo -e "${GREEN}✅ Старый wrapper удалён.${NC}"
else
    echo -e "${GREEN}ℹ️ Старый wrapper не найден, продолжаем установку.${NC}"
fi

# --- Устанавливаем новый wrapper ---
echo -e "${YELLOW}🔧 Устанавливаем новый wrapper...${NC}"

sudo tee /usr/local/bin/pop > /dev/null <<'EOF'
#!/bin/bash
# === Pipe POP wrapper with GLIBC 2.39 support ===
LD_PATH="/opt/glibc-build/glibc-2.39-install/lib"
POP_BIN="/opt/pipe/pop"
WORKDIR="/opt/pipe"

# Загружаем переменные окружения и экспортируем их
if [ -f "$WORKDIR/.env" ]; then
  set -o allexport
  source "$WORKDIR/.env"
  set +o allexport
fi

cd "$WORKDIR" || exit 1

"$LD_PATH/ld-linux-x86-64.so.2" \
  --library-path "$LD_PATH:/usr/lib/x86_64-linux-gnu/" \
  "$POP_BIN" "$@"
EOF

sudo chmod +x /usr/local/bin/pop

echo -e "${GREEN}🎉 Обновление завершено!${NC}"
echo -e "${GREEN}✅ Команда 'pop' теперь работает корректно с поддержкой GLIBC 2.39.${NC}"
echo -e "${YELLOW}💡 Пример: ${NC}pop status${YELLOW} или ${NC}pop earnings"
