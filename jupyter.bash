#!/usr/bin/env bash

set -e

python3 -m venv './venv'

source './venv/bin/activate'

python3 -m pip install --upgrade pip
#python3 -m pip install --upgrade setuptools

python3 -m pip install --upgrade --requirement './requirements.txt'

exec jupyter notebook --no-browser --port 9999

# you might need to install
# sudo apt install python3-venv
