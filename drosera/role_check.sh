#!/usr/bin/env bash

curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/display_logo.sh | bash

YELLOW='\e[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[38;5;81m'
NC='\033[0m'

echo
echo

read -p "👉 Введи свой wallet address (0x...): " WALLET_ADDR
if [ -z "$WALLET_ADDR" ]; then
  echo -e "${RED}❌ Wallet address не может быть пустым!${NC}"
  exit 1
fi

# Ensure cast is available
source ~/.bashrc || true
export PATH="$HOME/.foundry/bin:$PATH"

# Verify role
echo -e "${BLUE}▶️ Проверка isResponder...${NC}"
result=$(cast call 0x25E2CeF36020A736CF8a4D2cAdD2EBE3940F4608 \
  "isResponder(address)(bool)" \
  "$WALLET_ADDR" \
  --rpc-url https://ethereum-hoodi-rpc.publicnode.com 2>/dev/null || echo "false")

echo -e "Ответ контракта: $result"

if [[ "$result" == "true" ]]; then
  echo -e "${GREEN}✅ Результат: $result — роль скоро обновится!${NC}"
else
  echo -e "${RED}❌ Результат: $result — что-то не так${NC}"
fi
