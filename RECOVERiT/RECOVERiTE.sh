#!/bin/bash

while true; do
     clear
     echo ""
     echo "               RECOVERiTE                "
     echo ""
     echo " Ensure The Target Device Connected"
     
     echo ""
     echo ""

if ! command -v adb &> /dev/null; then
    echo "x ADB: NOT FOUND."
    echo ""
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
        echo "% ADB..."
        adb devices
        read -p "[ENTER=MENU]" temp
        ;;
    2)
        read -p "Search: " keyword
        echo "% Search... '$keyword'..."
        adb shell pm list packages | grep "$keyword"
        read -p "[ENTER=MENU]" temp
        ;;
    3)
        echo "% Disable"
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
        echo "+ Success"
        ;;
    4)
        echo "Exit."
        exit 0
        ;;
    5)
      clear
        echo ""
        echo "               RECOVERY                  "
        echo ""
        echo "% Target connection..."
        echo ""


        DEVICE_STATUS=$(adb devices | grep -v "List" | awk '{print $2}' | xargs)

        if [ -z "$DEVICE_STATUS" ]; then
            echo "x ADB: No Device."
            echo "    Ensure your target device"
        elif [ "$DEVICE_STATUS" = "sideload" ]; then
            echo "STATUS: Device in ADB Sideload."
            echo ""
            echo ""
        elif [ "$DEVICE_STATUS" = "recovery" ]; then
            echo "RECOVERY: Device has Custom Recovery (TWRP/OrangeFox)."
            echo "    rm /data/system/users/0/package-restrictions.xml"
        else
            echo "% Get iNFO..."
            LOG_FILE="~/OdinWorkspace/backups/disabled_packages.txt"
            if [ -f "$LOG_FILE" ]; then
                while IFS= read -r package; do
                    echo "+ Restoring: $package"
                    adb shell pm enable --user 0 "$package" &> /dev/null
                done < "$LOG_FILE"
                echo ""
                echo "+ SUCCESS: System restored!"
            else
                echo "x Missing. RECOVERING SYS APPS"
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
            echo "             DCIM RECOVER             "
            echo ""
            echo "% Storage path..."
            echo ""

            
            BACKUP_DIR="$HOME/PHONE/backups/Phone_Photos"
            mkdir -p "$BACKUP_DIR"

            echo "% Media asset..."
            echo ""
            echo ""

           
            echo "% Getting DCIM..."
            adb pull /sdcard/DCIM/ "$BACKUP_DIR/"
            DCIM_STATUS=$?

           
            echo "% Getting Pictures..."
            adb pull /sdcard/Pictures/ "$BACKUP_DIR/"
            PICTURES_STATUS=$?

            echo ""
            if [ $DCIM_STATUS -ne 0 ] || [ $PICTURES_STATUS -ne 0 ]; then
                echo "x BACKUP: FAIL"
                echo "    No Devices"
            else
                echo ""
                echo "+ BACKUP: Complete!"
                echo "    IMAGE: $BACKUP_DIR"
            fi

                echo ""
            read -p "[ENTER=MENU]" temp
            ;;

*)
    echo "% Invalid."
    sleep 0.5
    ;;
esac
done
