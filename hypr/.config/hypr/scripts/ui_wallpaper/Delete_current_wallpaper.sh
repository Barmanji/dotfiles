#!/bin/bash


# Get the full path and name of the current wallpaper
currentImageFullPath=$(awww query | grep -oP 'image: \K.*')
currentImageNameOnly=$(basename "$currentImageFullPath")
PARENT_PID=$(ps -o ppid= -p $$)
echo "lund"$currentImageFullPath"lund"

# Show a preview of the image using Kitty's image display feature
kitty +kitten icat "$currentImageFullPath"

# Show the image that is going to be deleted
echo "Image: $currentImageNameOnly"

# Optional: Display a message for confirmation before proceeding
echo "Y: TerminalDeletion || N: Abort || F: FileManager deletion? (y/n/f)"
read user_input

if [[ "$user_input" == "y" || "$user_input" == "Y" ]]; then
    echo "Proceeding with deletion..."

    # Send notification

    # Delete the file (using -i for interactive confirmation)
    echo "Type: y for (yes) || n/<Enter> for (no)"
    rm -i "$currentImageFullPath"

    notify-send -e -u critical -i "Current Image is Deleted" & exec ~/.config/awww/awww.sh

    # Kill the terminal
elif [[ "$user_input" == "f" || "$user_input" == "F" ]]; then
    echo "Opening file manager (Nautilus)..."

    # Open the current image path in Nautilus
    nautilus "$currentImageFullPath" & exec ~/.config/awww/awww.sh

    # Wait for 2 seconds
    sleep 10

    # Kill the terminal
    kill -9 $PARENT_PID
else
    echo "Aborted. The image was not deleted."
    sleep 2
    # Kill the terminal
fi


# echo "Image: $currentImageNameOnly will be deleted!"


