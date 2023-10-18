#!/bin/sh

# Configuration variables
maim_path="/usr/bin/maim"
save_path=$(xdg-user-dir PICTURES)
file_name="Screenshot_$(date +%Y-%m-%d).png"
notification_icon="$HOME/.config/leftwm/themes/Epitaph/assets/picture.svg"

message="Screenshots are saved in: $save_path"
prompt="󰄀 Take a screenshot:"

menu1="󰹑 Capture entire desktop"
menu2="󰩭 Capture a screen area"

menu3="󰹑 Capture entire desktop (After 5 seconds)"
menu4="󰩭 Capture a screen area (After 5 seconds)"

show_opts() {
    printf "%s\n%s\n%s\n%s" "$menu1" "$menu2" "$menu3" "$menu4" | rofi -dmenu -p "$prompt" -mesg "$message" -markup-rows
}

take_screenshot() {
    case "$1" in
        "$menu1")
            $maim_path -d 1 "$save_path/$file_name"
            ;;
        "$menu2")
            $maim_path -s "$save_path/$file_name"
            ;;
        "$menu3")
            $maim_path -d 5 "$save_path/$file_name"
            ;;
        "$menu4")
            $maim_path -s -d 5 "$save_path/$file_name"
            ;;
        *)
            exit 1
            ;;
    esac
dunstify -i "$notification_icon" -u normal -h string:x-dunst-stack-tag:screenshot "Screenshot saved" "Saved to: $save_path/$file_name"
}

option=$(show_opts)
take_screenshot "$option"

exit 0
