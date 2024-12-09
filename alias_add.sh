#!/bin/bash

mkdir -p -v "$HOME/bin"
chmod u+x ./history-md.sh
cp -v ./history-md.sh "$HOME/bin/"
echo 'alias add="history' '|' "$HOME/bin/history-md.sh\"" >> "$HOME"/.bashrc
echo -e "\nPlease run:\n  source ~/.bashrc\n\nor restart your terminal to activate the alias."
