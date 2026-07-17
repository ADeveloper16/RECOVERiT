#!/bin/bash

clear
echo "========================================="
echo "       RECOVERiT SM - SETUP WIZARD       "
echo "========================================="
echo ""
echo "[*] Initializing environment setup..."
sleep 1

# 1. Give execution permissions to the main script
if [ -f "./RECOVERiT.sh" ]; then
    echo "[+] Found main script. Granting executable permissions..."
    chmod +x ./RECOVERiT.sh
else
    echo "[-] ERROR: 'recoverit.sh' not found in this folder!"
    echo "    Make sure setup.sh is in the same directory."
    exit 1
fi

# 2. Check if ADB is installed on their system
echo "[*] Checking system dependencies..."
if command -v adb &> /dev/null; then
    echo "[+] Android Debug Bridge (ADB) is already installed!"
else
    echo "[-] WARNING: ADB is not installed on this system."
    echo "    You will need ADB installed for the tool to work."
    # Optional: For Ubuntu/Debian users, you could offer to install it:
    # read -p "Would you like to install adb now? (y/n): " install_adb
    # if [[ "$install_adb" == "y" ]]; then sudo apt update && sudo apt install -y adb; fi
fi

echo ""
echo "========================================="
echo "        SETUP COMPLETE - READY TO RUN    "
echo "========================================="
echo ""
read -p "Would you like to launch RECOVERiT right now? (y/n): " launch_now

if [[ "$launch_now" == "y" || "$launch_now" == "Y" ]]; then
    echo "[*] Launching utility..."
    sleep 0.5
    ./RECOVERiT.sh
else
    echo "[+] Setup finished! You can run the tool anytime using: ./RECOVERiT.sh"
    exit 0
fi
