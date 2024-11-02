#!/bin/bash

function logo {
  curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/display_logo.sh | bash
}

cd $HOME/elixir/

docker kill elixir &>/dev/null
docker rm -f elixir &>/dev/null
docker pull elixirprotocol/validator:v3 --platform linux/amd64

docker run --env-file $HOME/elixir/.env --name elixir --platform linux/amd64 --restart always -p 17690:17690 elixirprotocol/validator:v3
