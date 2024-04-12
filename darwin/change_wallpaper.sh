wallpaper_name=''
if [ "$1" = '' ]; then
    wallpaper_name=`ls -1 /Users/user/Pictures/Wallpapers/Collection | python -c "import sys; import random; print(random.choice(sys.stdin.readlines()).rstrip())"`
    echo Random wallpaper of the day: $wallpaper_name
else
    wallpaper_name=$(ls -1 $1 | sed 's|/Users/user/Pictures/Wallpapers/Collection/||')
fi

string=$(cat << EOF
repeat 9 times
    tell application "System Events" to tell every desktop to set picture to "/Users/user/Pictures/Wallpapers/Collection/$wallpaper_name"
    delay 0.3
    tell application "System Events" to tell every desktop to set picture to "/Users/user/Pictures/Wallpapers/Collection/$wallpaper_name"
    delay 0.3
    tell application "System Events" to keystroke (ASCII character 29) using {control down}
    delay 1
end
)
osascript -e "$string"
