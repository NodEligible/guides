#!/usr/bin/env bash

curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/display_logo.sh | bash

#Удаляем папку если есть
rm -rf ~/my-drosera-trap

set -euo pipefail
IFS=$'\n\t'

YELLOW='\e[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[38;5;81m'
NC='\033[0m'


# --- Collect all user inputs at the start ---
read -p "👉 Введи свой Discord username (пример nodmaster — тот ник что снизу, где значок #): " DISCORD_NAME
if [ -z "$DISCORD_NAME" ]; then
  echo -e "${RED}❌ Discord username не может быть пустым!${NC}"
  exit 1
fi

read -p "👉 Введи TRAP_ADDRESS (из dashboard): " TRAP_ADDR
if [ -z "$TRAP_ADDR" ]; then
  echo -e "${RED}❌ Trap address не может быть пустым!${NC}"
  exit 1
fi

read -p "👉 Введи свой wallet address (0x...): " WALLET_ADDR
if [ -z "$WALLET_ADDR" ]; then
  echo -e "${RED}❌ Wallet address не может быть пустым!${NC}"
  exit 1
fi

read -s -p "👉 Введи приватный ключ от wallet address (без 0x...): " PRIVKEY
echo
if [ -z "$PRIVKEY" ]; then
  echo -e "${RED}❌ Приватный ключ не может быть пустым!${NC}"
  exit 1
fi
# remove 0x if user pasted with it
PRIVKEY=${PRIVKEY#0x}


echo -e "${YELLOW}🚀 Drosera Trap helper — Nodes Garden / Mintair Cadet Role${NC}"
echo

echo -e "${YELLOW}Установка дополнительных инструментов (если нужно)...${NC}" 
sudo apt-get update && sudo apt-get upgrade -y &>/dev/null

# --- Install Drosera ---
if ! command -v drosera >/dev/null 2>&1; then
  echo "⚙️ Installing Drosera CLI..."
  curl -L https://app.drosera.io/install | bash
  source ~/.bashrc
else
  echo "✅ Drosera already installed, updating..."
  droseraup || true
fi

# --- Install Foundry ---
if ! command -v forge >/dev/null 2>&1; then
  echo "⚙️ Installing Foundry..."
  curl -L https://foundry.paradigm.xyz | bash
  source ~/.bashrc
else
  echo "✅ Foundry already installed, updating..."
  foundryup || true
fi

# --- Install Bun ---
if ! command -v bun >/dev/null 2>&1; then
  echo "⚙️ Installing Bun..."
  curl -fsSL https://bun.sh/install | bash
  source ~/.bashrc
else
  echo "✅ Bun already installed, updating..."
  bun upgrade || true
fi

echo -e "${YELLOW}Инициализация ловушки...${NC}" 

# Create new trap project (skip if already exists)
if [ ! -d ~/my-drosera-trap ]; then
  mkdir -p ~/my-drosera-trap && cd ~/my-drosera-trap
  forge init -t drosera-network/trap-foundry-template
  bun install || true
else
  cd ~/my-drosera-trap
fi

# Create src/Trap.sol
cat > src/Trap.sol <<EOF
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ITrap} from "drosera-contracts/interfaces/ITrap.sol";

interface IMockResponse {
    function isActive() external view returns (bool);
}

contract Trap is ITrap {
    // Updated response contract address
    address public constant RESPONSE_CONTRACT = 0x25E2CeF36020A736CF8a4D2cAdD2EBE3940F4608;
    string constant discordName = "$DISCORD_NAME"; // Discord username

    function collect() external view returns (bytes memory) {
        bool active = IMockResponse(RESPONSE_CONTRACT).isActive();
        return abi.encode(active, discordName);
    }

    function shouldRespond(bytes[] calldata data) external pure returns (bool, bytes memory) {
        (bool active, string memory name) = abi.decode(data[0], (bool, string));
        if (!active || bytes(name).length == 0) {
            return (false, bytes(""));
        }
        return (true, abi.encode(name));
    }
}
EOF

echo -e "${GREEN}✅ src/Trap.sol создан${NC}"

# Create drosera.toml
cat > drosera.toml <<EOF
ethereum_rpc = "https://ethereum-hoodi-rpc.publicnode.com"
drosera_rpc = "https://relay.hoodi.drosera.io"
eth_chain_id = 560048
drosera_address = "0x91cB447BaFc6e0EA0F4Fe056F5a9b1F14bb06e5D"

[traps]

[traps.mytrap]
path = "out/Trap.sol/Trap.json"
response_contract = "0x25E2CeF36020A736CF8a4D2cAdD2EBE3940F4608"
response_function = "respondWithDiscordName(string)"
cooldown_period_blocks = 33
min_number_of_operators = 1
max_number_of_operators = 2
block_sample_size = 10
private_trap = true
whitelist = ["$WALLET_ADDR"]
address = "$TRAP_ADDR"
EOF

echo -e "${GREEN}✅ drosera.toml создан${NC}"

# Build and test
echo -e "${BLUE}▶️ forge build...${NC}"
forge build

echo -e "${BLUE}▶️ drosera dryrun...${NC}"
drosera dryrun || true

# Deploy (if private key provided)
if [ -n "$PRIVKEY" ]; then
  DROSERA_PRIVATE_KEY="$PRIVKEY" drosera apply
  echo -e "${GREEN}✅ Контракт задеплоен${NC}"
else
  echo -e "${RED}⏭️ Пропущен деплой (ключ не введен)${NC}"
fi

# -------------------------------------------------------------
delay_minutes=5
total_seconds=$((delay_minutes * 60))

echo -e "\n⏳ Ожидание $delay_minutes минут..."

for ((i=total_seconds; i>0; i--)); do
    printf "\r⏱️  Осталось: %02d:%02d " $((i/60)) $((i%60))
    sleep 1
done

echo -e "\n✅ Время вышло!"
read -p "➡️  Нажмите Enter, чтобы продолжить..."

# -------------------------------------------------------------

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
  echo -e "${RED}❌ Результат: $result — что-то не так, проверь whitelist/Trap.sol${NC}"
fi
  
echo -e "${GREEN}✅ Деплой завершен!${NC}"

service drosera restart


