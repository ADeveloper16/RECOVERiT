#!/bin/bash

while true; do
     clear
     echo ""
     echo "               RECOVERiTE                "
     echo ""
     echo " Ensure The Target Device Has Enabled USB
 Debugging"
     
     echo " Only Samsung... For Now."
     echo ""

if ! command -v adb &> /dev/null; then
    echo "[-] ADB: NOT FOUND."
    echo "    Run: sudo apt install adb"
    exit 1
fi
echo ""
echo "1) Check ADB"
echo "2) Search a Package"
echo "3) Disable Suggested Apps"
echo "4) Exit Utility"
echo "5) RECOVERY (EXPERIMENTAL)"
echo "6) RECOVER DCIM (EXPERIMENTAL)"
echo ""
read -p "[1-6]: " choice
if [ -z "$choice" ]; then continue; fi
case $choice in
    1)
        echo "[*] ADB devices..."
        adb devices
        read -p "[ENTER=MENU]" temp
        ;;
    2)
        read -p "Keyword to search: " keyword
        echo "[*] Search packages '$keyword'..."
        adb shell pm list packages | grep "$keyword"
        read -p "[ENTER=MENU]" temp
        ;;
    3)
        echo "[*] Disabling"
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
        read -p "[ENTER=MENU]" temp
        echo "[+] Success"
        ;;
    4)
        echo "Exit Utility."
        exit 0
        ;;
    5)
      clear
        echo ""
        echo "              RECOVERY MODE              "
        echo ""
        echo "[*] Checking Target connection profile..."
        echo ""


        DEVICE_STATUS=$(adb devices | grep -v "List" | awk '{print $2}' | xargs)

        if [ -z "$DEVICE_STATUS" ]; then
            echo "[-] NO TARGET DEVICES: No Device detected."
            echo "    Ensure your target device is powered on,
    and in Recovery->Apply Updates From ADB"
        elif [ "$DEVICE_STATUS" = "sideload" ]; then
            echo "STATUS: Device is in ADB Sideload / 'Apply Update' Mode!"
            echo "    Your phone cannot process optimization tweaks in this state."
            echo "    Fix: Reboot your phone normally, unlock the screen, and run this option again."
        elif [ "$DEVICE_STATUS" = "recovery" ]; then
            echo "UNKNOWN RECOVERY: Device is booted into a Custom Recovery (TWRP/OrangeFox)."
            echo "    To restore your frozen apps with zero data loss, navigate to:"
            echo "    Advanced -> Terminal inside TWRP/OrangeFox, and run this command line:"
            echo "    rm /data/system/users/0/package-restrictions.xml"
        else
            echo "[+] System connection (Normal Mode). Get iNFO..."
            LOG_FILE="~/OdinWorkspace/backups/disabled_packages.txt"
            if [ -f "$LOG_FILE" ]; then
                while IFS= read -r package; do
                    echo "[+] Restoring service: $package"
                    adb shell pm enable --user 0 "$package" &> /dev/null
                done < "$LOG_FILE"
                echo "[=========================================]"
                echo "[+] SUCCESS: System restored!"
            else
                echo "[-] Missing. RECOVERING SYS APPS"
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

                echo "+ Recovered!" 
           
              read -p "[ENTER=MENU]" temp
              ;;
        
      6)
            clear
            echo ""
            echo "           DCIM RECOVER UTILITY          "
            echo ""
            echo "[*] Check storage path..."
            echo ""

            
            BACKUP_DIR="$HOME/PHONE/backups/Phone_Photos"
            mkdir -p "$BACKUP_DIR"

            echo "[*] media asset..."
            echo "    (do not unplug)"
            echo ""

           
            echo "[*] Getting DCIM..."
            adb pull /sdcard/DCIM/ "$BACKUP_DIR/"
            DCIM_STATUS=$?

           
            echo "[*] Getting Pictures..."
            adb pull /sdcard/Pictures/ "$BACKUP_DIR/"
            PICTURES_STATUS=$?

            echo ""
            if [ $DCIM_STATUS -ne 0 ] || [ $PICTURES_STATUS -ne 0 ]; then
                echo "x BACKUP: FAIL"
                echo "    No Devices"
            else
                echo "[=========================================]"
                echo "+ BACKUP: Complete!"
                echo "    Images stored in: $BACKUP_DIR"
            fi

                echo ""
            read -p "[ENTER=MENU]" temp
            ;;

*)
    echo "[-] Invalid option."
    sleep 0.5
    ;;
esac
done
