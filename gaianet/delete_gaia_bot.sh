# Зупиняємо та вимикаємо сервіс бота
sudo systemctl stop gaia-bot.service
sudo systemctl disable gaia-bot.service

# Видаляємо файл сервісу
sudo rm -f /etc/systemd/system/gaia-bot.service

# Перезапускаємо демон systemd, щоб прибрати сервіс
sudo systemctl daemon-reload

# Видаляємо папку з ботом і всі його файли
rm -rf ~/gaia-bot


