#!/bin/bash

# Функция для отображения логотипа
display_logo() {
  echo -e '\e[0;37м'

  echo -e '███╗░░██╗░█████╗░██████╗░  ███████╗██╗░░░░░██╗░██████╗░██╗██████╗░██╗░░░░░███████╗'
  echo -e '████╗░██║██╔══██╗██╔══██╗  ██╔════╝██║░░░░░██║██╔════╝░██║██╔══██╗██║░░░░░██╔════╝'
  echo -e '██╔██╗██║██║░░██║██║░░██║  █████╗░░██║░░░░░██║██║░░██╗░██║██████╦╝██║░░░░░█████╗░░'
  echo -e '██║╚████║██║░░██║██║░░██║  ██╔══╝░░██║░░░░░██║██║░░╚██╗██║██╔══██╗██║░░░░░██╔══╝░░'
  echo -e '██║░╚███║╚█████╔╝██████╔╝  ███████╗███████╗██║╚██████╔╝██║██████╦╝███████╗███████╗'
  echo -e '╚═╝░░╚══╝░╚════╝░╚═════╝░  ╚══════╝╚══════╝╚═╝░╚═════╝░╚═╝╚═════╝░╚══════╝╚══════╝'
}

# Отображение логотипа
display_logo

cd $HOME/elixir/

docker kill elixir &>/dev/null
docker rm -f elixir &>/dev/null
docker pull elixirprotocol/validator:v3 --platform linux/amd64

docker run --env-file $HOME/elixir/.env --name elixir --platform linux/amd64 --restart always -p 17690:17690 elixirprotocol/validator:v3
