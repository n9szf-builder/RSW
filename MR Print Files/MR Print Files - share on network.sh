#!/bin/bash
# Start MR Print Files so other computers on the same network can use it (Linux).
# They browse to the address this window shows, e.g. http://192.168.1.50:8765
cd "$(dirname "$0")"
if ! command -v python3 >/dev/null 2>&1; then
  echo "Python 3 is needed. Install it with your package manager (Ubuntu / Debian: sudo apt install python3), then try again."
  read -n 1 -s -r -p "Press any key to close."; echo; exit 1
fi
python3 "MR Print Files.py" --share "$@"
