#!/bin/bash

MonitorTime=5
NormalCpu=40
REFRESH_MODE="auto"


CpuUsage(){
top -bn1 | grep "Cpu(s)" | awk '{print int(100 - $8)}'


}

CpuInformation() {
    echo "|=================================================================================================|" | lolcat
    echo "                                     CPU information" | lolcat
    echo "CPU Usage : " | lolcat
   CpuUsage | lolcat
}

RamInformation() {
    echo "|=================================================================================================|" | lolcat
    echo "                                     RAM information" | lolcat
    free -h | lolcat
}

DiskInformation() {
    echo "|=================================================================================================|" | lolcat
    echo "                                     Disk information" | lolcat
    df -h / | lolcat
}
BatteryInformation(){
    echo "|=================================================================================================|" | lolcat
    echo "                                     Battery information" | lolcat
    acpi -b -i -e -t -k | lolcat
}
MonitorProcesses(){
    echo "|=================================================================================================|" | lolcat
    echo "                                     Monitor processes" | lolcat
    echo "===========================Top 5 Processes by CPU Usage============================================" | lolcat
    ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6 | lolcat
    echo "===========================Top 5 Processes by RAM Usage============================================" | lolcat
    ps -eo pid,comm,%mem --sort=-%mem | head -n 6 | lolcat
}
show_info() {
    while true; do
        clear
        figlet "System Resource Monitor" | lolcat
        echo "======================" | lolcat
        echo "| Made by Mahmoud Sakr |" | lolcat
        echo "======================" | lolcat 

        CpuInformation

        RamInformation

        DiskInformation

        BatteryInformation

        MonitorProcesses


        CpuNow=$(CpuUsage)


        if [ "$CpuNow" -gt "$NormalCpu" ]; then
            echo -e "\n WARNING: High CPU usage detected ($CpuNow%) — Please close some applications " | lolcat
        fi


        echo "====================================================================================================" | lolcat
        if [ "$REFRESH_MODE" = "manual" ]; then
            echo -e "\nPress ENTER to refresh <or> click  Ctrl+C to exit." | lolcat
            read -r
        else
            echo  "Next Refresh in: (click ctrl+C to exit.) " | lolcat
            for ((i=MonitorTime; i>0; i--)); do
            echo -ne "\r$i seconds remaining... " | lolcat
            sleep 1
        done
           echo -ne  "\r                     \r"
        fi

    done
}

main_menu() {
    while true; do
        CHOICE=$(whiptail --title "System Resource Monitor" --menu "Choose an option                    made by mahmoud sakr" 15 60 6 \
        "1" "Start Monitoring" \
        "2" "Set Refresh Mode (current: $REFRESH_MODE)" \
        "3" "Set Auto-Refresh Interval (current: ${INTERVAL}s)" \
        "4" "show the gui mode(gnome)"\
        "5" "Exit" 3>&1 1>&2 2>&3)

        case $CHOICE in
            1) show_info
                ;;
            2)
                REFRESH_MODE=$(whiptail --title "Refresh Mode" --menu "Select mode" 12 50 2 \
                "auto" "Auto-refresh " \
                "manual" "Manual-refresh " 3>&1 1>&2 2>&3)
                ;;
            3)
                MonitorTime=$(whiptail --inputbox "Enter refresh time (sec):" 10 40 "$MonitorTime" 3>&1 1>&2 2>&3)
                ;;
            4) gnome-system-monitor
                ;; 
            5) clear;
               exit 0
                ;;
            *) break
                ;;
        esac
    done
}

main_menu

