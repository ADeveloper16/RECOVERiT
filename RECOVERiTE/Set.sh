#!/bin/bash

clear
echo ""
echo "            RECOVERiTE - SET           "
echo ""
echo ""
echo "[*] Environment..."
sleep 1


if [ -f "./RECOVERiTE.sh" ]; then
    echo "[+] RECOVERiTE: GRANT PERMISSION..."
    chmod +x ./RECOVERiTE.sh
else
    echo "[-] RECOVERiTE: NOT FOUND."
    exit 1
fi


echo "[*] Checking system..."
if command -v adb &> /dev/null; then
    echo "[+] ADB: FOUND!"
else
    echo "[-] ADB: NOT FOUND."
    echo ""
fi
echo ""
echo ""
echo "             SETUP COMPLETE              "
echo ""
echo ""
read -p "Launch RECOVERiTE? (Y/n): " launch_now

if [[ "$launch_now" == "y" || "$launch_now" == "Y" ]]; then
    echo "[*] Launching..."
    sleep 0.5
    ./RECOVERiTE.sh
else
    echo "[+] Finished!"
    exit 0
fi
