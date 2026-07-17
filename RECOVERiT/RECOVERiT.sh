#!/bin/bash

while true; do
     clear
     echo "========================================="
     echo "              RECOVERiT SM               "
     echo "========================================="
     echo " Ensure The Target Device Has Enabled USB
 Debugging or Wireless Debugging"
     
     echo " Only Samsung Utilities... For Now."
     echo ""

if ! command -v adb &> /dev/null; then
    echo "[-] Error: ADB is not installed on this Device."
    echo "    Run: sudo apt install adb"
    exit 1
fi
echo "========================================="
echo "1) Check Connected ADB Devices"
echo "2) Search for a Package Name"
echo "3) Disable Suggested Apps"
echo "4) Exit the Utility"
echo "5) EMERGENCY MODE (EXPERIMENTAL)"
echo "6) RECOVER (EXPERIMENTAL)"
echo "========================================="
read -p "Select Option [1-6]: " choice
if [ -z "$choice" ]; then continue; fi
case $choice in
    1)
        echo "[*] Querying ADB device list..."
        adb devices
        read -p "Press [ENTER] to return menu" temp
        ;;
    2)
        read -p "Enter keyword to search (e.g. samsung, google, windows): " keyword
        echo "[*] Searching for installed packages containing '$keyword'..."
        adb shell pm list packages | grep "$keyword"
        read -p "Press [ENTER]to return menu" temp
        ;;
    3)
        echo "[*] Freezing Suggested Apps"
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
        adb shell pm disable user --user 0 com.google.android.apps.tachyon
        read -p "Press [ENTER] to return menu" temp
        echo "[+] Done!"
        ;;
    4)
        echo "Exit optimization utility."
        exit 0
        ;;
    5)
      clear
        echo "========================================="
        echo "         EMERGENCY RECOVERY MODE         "
        echo "========================================="
        echo "[*] Checking Target device connection profile..."
        echo ""


        DEVICE_STATUS=$(adb devices | grep -v "List" | awk '{print $2}' | xargs)

        if [ -z "$DEVICE_STATUS" ]; then
            echo "[-] NO TARGET DEVICES: No Android device detected."
            echo "    Ensure your target phone is powered on,
    and in Recovery>Apply Updates From ADB"
        elif [ "$DEVICE_STATUS" = "sideload" ]; then
            echo "STATUS: Device is in ADB Sideload / 'Apply Update' Mode!"
            echo "    Your phone cannot process optimization tweaks in this state."
            echo "    Fix: Reboot your phone normally, unlock the screen, and run this option again."
        elif [ "$DEVICE_STATUS" = "recovery" ]; then
            echo "UNKNOWN RECOVERY: Device is booted into a Custom Recovery (TWRP/OrangeFox)."
            echo "    To restore your frozen apps with zero data loss, navigate to:"
            echo "    Advanced -> Terminal inside TWRP, and run this command line:"
            echo "    rm /data/system/users/0/package-restrictions.xml"
        else
            echo "[+] System connection confirmed (Normal Mode). Injecting recovery payload..."
            LOG_FILE="~/OdinWorkspace/backups/disabled_packages.txt"
            if [ -f "$LOG_FILE" ]; then
                while IFS= read -r package; do
                    echo "[+] Restoring service: $package"
                    adb shell pm enable --user 0 "$package" &> /dev/null
                done < "$LOG_FILE"
                echo "[=========================================]"
                echo "[+] SUCCESS: All system services restored safely!"
            else
                echo "[-] Backup file missing. RECOVERING NEEDED PACKAGES!"
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

                echo "[+] Primary assets recovered!" 
           
              read -p "Press [ENTER] to return menu" temp
              ;;
        
      6)
            clear
            echo "========================================="
            echo "          PHOTO RECOVER UTILITY          "
            echo "========================================="
            echo "[*] Checking storage path configurations..."
            echo ""

            
            BACKUP_DIR="$HOME/OdinWorkspace/backups/Phone_Photos"
            mkdir -p "$BACKUP_DIR"

            echo "[*] Initializing media asset pull loop..."
            echo "    (Do not unplug your USB cable!)"
            echo "----------------------------------------="

           
            echo "[*] Transferring DCIM folder content..."
            adb pull /sdcard/DCIM/ "$BACKUP_DIR/"
            DCIM_STATUS=$?

           
            echo "[*] Transferring Pictures folder content..."
            adb pull /sdcard/Pictures/ "$BACKUP_DIR/"
            PICTURES_STATUS=$?

            echo "------------------------------------------"
            if [ $DCIM_STATUS -ne 0 ] || [ $PICTURES_STATUS -ne 0 ]; then
                echo "[-] ERROR: BACKUP FAIL"
                echo "    No Devices Found"
                echo "    Falling Back"
            else
                echo "[=========================================]"
                echo "[+] SUCCESS: Backup complete!"
                echo "    Your images restored in: $BACKUP_DIR"
            fi

                echo ""
            read -p "Press [Enter] to return menu..." temp
            ;;

*)
    echo "[-] Invalid option selected."
    sleep 0.5
    ;;
esac
done
