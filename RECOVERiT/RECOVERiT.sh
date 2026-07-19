#!/bin/bash

G="\033[0;32m"
W="\033[0;37m"
B="\033[0;34m"
R="\033[0;31m"
N="\033[0m"



echo -e "${G}Done!${N}"
sleep 0.4


while true; do
     clear
     echo -e "${G}┌───────────────────────────────────────┐"
     echo -e "${G}│${W}              RECOVERiT                ${G}│"
     echo -e "${G}└───────────────────────────────────────┘"
     echo -e "${W} Make Sure The Target Device Has Enabled 
 USB Debugging Before Starting"
     
     echo ""
     echo ""

if ! command -v adb &> /dev/null; then
    echo -e "${R}[-] ERROR: ADB is not installed on this Computer."
    echo -e "${R} ADB: open terminal run: sudo apt install adb."
    exit 1
fi
echo -e "${W}┌───────────────────────────────────────┐"
echo -e "${W}│${G}1) ${W}Check ADB Devices                   ${W}│"
echo -e "${W}│${G}2) ${W}Search a Package Name               ${W}│"
echo -e "${W}│${G}3) ${W}Disable Suggested Apps              ${W}│"
echo -e "${W}│${G}4) ${W}Exit the Utility                    ${W}│"
echo -e "${W}│${R}5) ${W}RECOVERY ${R}(EXPERIMENTAL)             ${W}│"
echo -e "${W}│${R}6) ${W}RECOVER DCIM ${R}(EXPERIMENTAL)         ${W}│"
echo -e "${W}└───────────────────────────────────────┘"
read -p "$(echo -e "${W} Select An Option [1-6]: ${W}")" choice
if [ -z "$choice" ]; then continue; fi
case $choice in
    1)
        echo "[*] Querying ADB devices..."
        adb devices
        read -p "Press [ENTER] to return menu" temp
        ;;
    2)
        read -p "Enter keyword to search packages on your Device: " keyword
        echo "[*] Searching packages containing '$keyword'..."
        adb shell pm list packages | grep "$keyword"
        read -p "Press [ENTER] to return menu" temp
        ;;
    3)
        echo "[*] Disabling Suggested Apps On Your Device"
        adb shell pm disable-user --user 0 com.samsung.android.bixby.agent
        adb shell pm disable-user --user 0 com.samsung.android.bixby.wakeup
        adb shell pm disable-user --user 0 com.samsung.android.app.spage
        adb shell pm disable-user --user 0 com.samsung.android.app.omcagent
        adb shell pm disable-user --user 0 com.samsung.android.smartsuggestions
        adb shell pm disable-user --user 0 com.samsung.android.net.wifi.wifiguider
        adb shell pm disable-user --user 0 com.samsung.android.app.camera.sticker.facearavatar.preload
        adb shell pm disable-user --user 0 com.samsung.android.rubin.app
        adb shell pm disable-user --user 0 com.microsoft.appmanager
        adb shell pm disable-user --user 0 com.samsung.android.mdx
        adb shell pm disable-user --user 0 com.facebook.system
        adb shell pm disable-user --user 0 com.facebook.appmanager
        adb shell pm disable-user --user 0 com.facebook.services
        adb shell pm disable-user --user 0 com.swiftkey.swiftkeyconfigurator
        adb shell pm disable-user --user 0 com.touchtype.swiftkey
        adb shell pm disable-user --user 0 com.samsung.android.aremoji
        adb shell pm disable-user --user 0 com.google.android.apps.tachyon
        read -p "Press [ENTER] to return menu" temp
        echo "[+] Success!"
        ;;
    4)
        echo "Exit Utility."
        exit 0
        ;;
    5)
      clear
        echo "┌───────────────────────────────────────┐"
        echo "│              RECOVERY MODE            │"
        echo "└───────────────────────────────────────┘"
        echo "[*] Checking Target device connection..."
        echo ""


        DEVICE_STATUS=$(adb devices | grep -v "List" | awk '{print $2}' | xargs)

        if [ -z "$DEVICE_STATUS" ]; then
            echo -e "${R}[-] NO TARGET DEVICES: No Device detected."
            echo "    Ensure your target device."
        elif [ "$DEVICE_STATUS" = "sideload" ]; then
            echo -e "${G}STATUS: Device is in ADB Sideload / 'Apply Update' Mode!"
        elif [ "$DEVICE_STATUS" = "recovery" ]; then
            echo -e "${R}UNKNOWN RECOVERY: Device is booted into a Custom Recovery (TWRP/OrangeFox)."
            echo "    To restore your frozen apps with zero data loss, navigate to:"
            echo "    Advanced -> Terminal inside TWRP/OrangeFox, and run this command line:"
            echo "    rm /data/system/users/0/package-restrictions.xml"
        else
            echo -e "${G}[+] System connection (Normal Mode). Injecting recovery payload..."
            LOG_FILE="~/OdinWorkspace/backups/disabled_packages.txt"
            if [ -f "$LOG_FILE" ]; then
                while IFS= read -r package; do
                    echo "[+] Restoring service: $package"
                    adb shell pm enable --user 0 "$package" &> /dev/null
                done < "$LOG_FILE"
                echo "[=========================================]"
                echo -e "${G}[+] SUCCESS: System services restored!"
            else
                echo -e "${R}[-] Backup file missing. ${G}RECOVERING SYSTEM APPS"
                       adb shell pm enable --user 0 android
                       adb shell pm enable --user 0 com.android.systemui
                       adb shell pm enable --user 0 com.android.settings
                       adb shell pm enable --user 0 com.google.android.ext.services
                       adb shell pm enable --user 0 com.google.android.ext.shared
                       adb shell pm enable --user 0 com.samsung.android.incallui
                       adb shell pm enable --user 0 com.android.certinstaller
                       adb shell pm enable --user 0 com.android.localtransport
                       adb shell pm enable --user 0 com.android.phone.auto_generated_rro_product_
                       adb shell pm enable --user 0 com.android.providers.downloads
                       adb shell pm enable --user 0 com.google.android.documentsui
                       adb shell pm enable --user 0 com.google.android.modulemetadata
                       adb shell pm enable --user 0 com.google.android.networkstack
                       adb shell pm enable --user 0 com.samsung.android.networkstack
                       adb shell pm enable --user 0 com.google.android.packageinstaller
                       adb shell pm enable --user 0 com.android.uwb.resources
                       adb shell pm enable --user 0 com.google.android.connectivity.resources
                       adb shell pm enable --user 0 com.android.shell
                       adb shell pm enable --user 0 com.android.keychain
                       adb shell pm enable --user 0 com.android.providers.settings
                       adb shell pm enable --user 0 com.google.android.permissioncontroller
                       adb shell pm enable --user 0 com.google.android.gms
                       adb shell pm enable --user 0 com.google.android.gsf
                       adb shell pm enable --user 0 com.sec.android.app.launcher
                    fi

               fi

                echo "[+] Assets recovered Successfully!" 
           
              read -p "$(echo -e "${W}Press [ENTER] to return menu${W}")" temp
              ;;
        
      6)
            clear
            echo "┌───────────────────────────────────────┐"
            echo "│          DCIM RECOVER UTILITY         │"
            echo "└───────────────────────────────────────┘"
            echo "[*] Checking storage path..."
            echo ""

            
            BACKUP_DIR="$HOME/PHONE/backups/Phone_Photos"
            mkdir -p "$BACKUP_DIR"

            echo "[*] Initializing media asset..."
            echo "    (To successfull do not unplug)"
            echo "──────────────────────────────────────"

           
            echo "[*] Copying Pictures To Computer..."
            adb pull /sdcard/DCIM/ "$BACKUP_DIR/"
            DCIM_STATUS=$?

           
            echo "[*] Copying Pictures To Computer..."
            adb pull /sdcard/Pictures/ "$BACKUP_DIR/"
            PICTURES_STATUS=$?

            echo "──────────────────────────────────────────"
            if [ $DCIM_STATUS -ne 0 ] || [ $PICTURES_STATUS -ne 0 ]; then
                echo "[-] ERROR: BACKUP FAIL"
                echo "    No Devices Found"
            else
                echo "[=========================================]"
                echo "[+] SUCCESS: Backup complete!"
                echo "    Your images restored in: $BACKUP_DIR"
            fi

                echo ""
            read -p "Press [Enter] to return menu..." temp
            ;;

*)
    echo -e "${R} [-] Invalid option [Selected]."
    sleep 0.5
    ;;
esac
done
