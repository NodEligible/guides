sudo nano /etc/systemd/system/bitz.service
[Unit]
Description=Bitz Collect Miner Service
After=network.target

[Service]
User=YOUR_USER
WorkingDirectory=/home/YOUR_USER  # або шлях до папки з bitz
ExecStart=/usr/bin/env bitz collect --cores 8
Restart=always
RestartSec=10
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target

sudo systemctl enable bitz
sudo systemctl daemon-reload
sudo systemctl start bitz
