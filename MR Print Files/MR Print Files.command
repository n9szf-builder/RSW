#!/bin/bash
# Double-click to start MR Print Files (Mac).
cd "$(dirname "$0")"
python3 "MR Print Files.py" || { echo; echo "Python 3 is needed - install it from python.org, then try again."; read -n 1 -s -r -p "Press any key to close."; }
