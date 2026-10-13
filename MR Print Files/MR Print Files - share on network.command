#!/bin/bash
# Double-click to start MR Print Files so other computers on the same network can use it (Mac).
# They browse to the address this window shows, e.g. http://192.168.1.50:8765
cd "$(dirname "$0")"
python3 "MR Print Files.py" --share || { echo; echo "Python 3 is needed - install it from python.org, then try again."; read -n 1 -s -r -p "Press any key to close."; }
