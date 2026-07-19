#!/bin/bash

clear
echo "┌───────────────────────────────────────┐"
echo "│       RECOVERiT - SETUP WIZARD        │"
echo "└───────────────────────────────────────┘"
echo ""
echo "[*] Initializing environment..."
sleep 1


if [ -f "./RECOVERiT.sh" ]; then
    echo "[+] Found main script. Granting executable permissions..."
    chmod +x ./RECOVERiT.sh
else
    echo "[-] ERROR: 'RECOVERiT.sh' not found in this folder!"
    echo "    Make sure setup.sh is in the same directory."
    exit 1
fi


echo "[*] Checking system dependencies..."
if command -v adb &> /dev/null; then
    echo "[+] Android Debug Bridge (ADB) is already installed!"
else
    echo "[-] ERROR: ADB is not installed on this system."
    echo "    You will need ADB installed for the tool to work."
  

fi

echo ""
echo "┌───────────────────────────────────────┐"
echo "│            SETUP COMPLETE             │"
echo "└───────────────────────────────────────┘"
echo ""
read -p "Would you like to launch RECOVERiT right now? (Y/n): " launch_now
if [[ "$launch_now" == "y" || "$launch_now" == "Y" ]]; then
    echo "[*] Launching..."
    sleep 0.5
    ./RECOVERiT.sh
else
    echo "[+] Setup finished! You can run the utility anytime using: ./RECOVERiT.sh"
    exit 0
fi
