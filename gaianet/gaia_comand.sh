# Зупиняємо та вимикаємо сервіс бота
sudo systemctl stop gaia-bot.service
sudo systemctl disable gaia-bot.service
sudo rm -f /etc/systemd/system/gaia-bot.service
sudo systemctl daemon-reload
rm -rf ~/gaia-bot


# Установка бота
bash <(curl -s https://raw.githubusercontent.com/NodEligible/guides/main/gaianet/gaia_bot.sh)

#Установка ноды
bash <(curl -s https://raw.githubusercontent.com/NodEligible/guides/main/gaianet/install.sh)
