wallpaper_name=`ls -1 /Users/user/Pictures/Wallpapers/Collection | python -c "import sys; import random; print(random.choice(sys.stdin.readlines()).rstrip())"`
string=$(cat << EOF
repeat 9 times
    tell application "System Events" to tell every desktop to set picture to "/Users/user/Pictures/Wallpapers/Collection/$wallpaper_name"
    tell application "System Events" to keystroke (ASCII character 29) using {control down}
    delay 1
end
)
osascript -e "$string"
