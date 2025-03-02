# Зупиняємо та вимикаємо сервіс бота
sudo systemctl stop gaia-bot.service
sudo systemctl disable gaia-bot.service
sudo rm -f /etc/systemd/system/gaia-bot.service
sudo systemctl daemon-reload
rm -rf ~/gaia-bot



bash <(curl -s https://raw.githubusercontent.com/NodEligible/guides/main/gaianet/gaia_bot.sh)

