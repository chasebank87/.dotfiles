#!/bin/zsh

SUDO_PAM_FILE="/etc/pam.d/sudo"
LINE_TO_ADD="auth       sufficient     pam_watchid.so"

# Check if the file exists
if [[ ! -f "$SUDO_PAM_FILE" ]]; then
    echo "Error: $SUDO_PAM_FILE does not exist."
    exit 1
fi

# Check if the line already exists in the file
if grep -Fxq "$LINE_TO_ADD" "$SUDO_PAM_FILE"; then
    echo "The line already exists in $SUDO_PAM_FILE. No changes made."
else
    # Add the line to the end of the file
    echo "$LINE_TO_ADD" | sudo tee -a "$SUDO_PAM_FILE" > /dev/null
    echo "Line added successfully to $SUDO_PAM_FILE"
fi