YELLOW='\e[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

if [ $# -ne 2 ]; then
    echo "Usage: bash <(curl -s https://raw.githubusercontent.com/NodEligible/guides/main/multiple/healthcheck.sh) <IDENTIFIER> <PIN>"
    exit 1
fi

IDENTIFIER="$1"
PIN="$2"

while true; do
STATUS_OUTPUT=$($HOME/multipleforlinux/multiple-cli status)
if echo "$STATUS_OUTPUT" | grep -q " :False"; then
    echo -e "\$(/usr/bin/date '+%Y-%m-%d %H:%M:%S') ⛔️ ${RED} Узел не запущен. Выполнение команды bind...${NC}" | tee -a "$LOG_FILE"
    $HOME/multipleforlinux/multiple-cli bind --bandwidth-download 100 --identifier "$IDENTIFIER" --pin "$PIN" --storage 200 --bandwidth-upload 100
else
    echo -e "\$(/usr/bin/date '+%Y-%m-%d %H:%M:%S') ✅ ${GREEN} Узел уже привязан. NodeRun: True, IsMain: True.${NC}" | tee -a "$LOG_FILE"
fi
    # Wait for 5 minutes before checking again
    sleep 300
done
