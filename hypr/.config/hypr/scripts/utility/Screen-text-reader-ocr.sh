#!/usr/bin/env bash

# Dependencies: grim, slurp, tesseract, wl-clipboard, notify-send [sudo pacman -S --needed tesseract tesseract-data-eng grim slurp wl-clipboard]

# Configuration
TMP_DIR="/tmp/ocr-screenshots"
IMG_FILE="$TMP_DIR/screenshot.png"
TXT_FILE="$TMP_DIR/ocr-result"
LANGUAGE="eng"                            # Default OCR language
URGENCY_CRITICAL="critical"
URGENCY_NORMAL="normal"

# Create temporary directory
mkdir -p "$TMP_DIR"

# Handle script termination
cleanup() {
    rm -f "$IMG_FILE" "$TXT_FILE.txt"
}
trap cleanup EXIT

# Capture screenshot with error handling
if ! slurp_output=$(slurp 2>&1); then
    notify-send -u $URGENCY_CRITICAL "OCR Canceled" "Selection was canceled"
    exit 0
fi

if ! grim -g "$slurp_output" "$IMG_FILE"; then
    notify-send -u $URGENCY_CRITICAL "OCR Failed" "Failed to capture screenshot"
    exit 1
fi

# Perform OCR with language support
if ! tesseract -l $LANGUAGE "$IMG_FILE" "$TXT_FILE" 2> "$TMP_DIR/ocr-errors.log"; then
    notify-send -u $URGENCY_CRITICAL "OCR Error" "$(head -n 3 "$TMP_DIR/ocr-errors.log")"
    exit 1
fi

# Verify OCR results
if [[ ! -s "$TXT_FILE.txt" ]]; then
    notify-send -u $URGENCY_CRITICAL "OCR Failed" "No text detected in selected area"
    exit 1
fi

# Copy to clipboard and notify
wl-copy < "$TXT_FILE.txt"


notify-send -u $URGENCY_NORMAL "OCR Successful" \
"Text copied to clipboard!\n
Character count: $(wc -m < "$TXT_FILE.txt")"
