#!/bin/bash

curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/display_logo.sh | bash

YELLOW='\e[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

cd $HOME/multipleforlinux

current_version=$(./multiple-cli --version)
echo -e  "Текущая версия: $current_version"

latest_version=$(curl -s https://mdeck-download.s3.us-east-1.amazonaws.com/client/linux/version.txt | cat)
echo -e  "Последняя версия: $latest_version"
sleep 2

if [[ "$current_version" =~ "$latest_version" ]];  then
    echo -e  "У вас и так уже последняя версия"
else
    echo -e  "Обновление multiple node"

    sudo systemctl stop multiple

    download_url=""
    get_arch=$(arch)
    if [[ $get_arch =~ "x86_64" ]];then download_url="https://mdeck-download.s3.us-east-1.amazonaws.com/client/linux/x64/multipleforlinux.tar"
    elif [[ $get_arch =~ "aarch64" ]];then download_url="https://mdeck-download.s3.us-east-1.amazonaws.com/client/linux/arm64/multipleforlinux.tar"
    else
        printf "Ваш сервер не подходит для запуска ноды"
        exit 0
    fi

    wget $download_url -O multipleforlinux.tar

    tar -xvf multipleforlinux.tar
    rm -rf multipleforlinux.tar

    chmod -R 777 multipleforlinux
    cd multipleforlinux
    chmod +x ./multiple-cli
    chmod +x ./multiple-node

    sudo systemctl start multiple
fi
