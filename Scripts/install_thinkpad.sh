#!/usr/bin/env bash

# Source global functions for consistent logging
scrDir="$(dirname "$(realpath "$0")")"
if [ -f "${scrDir}/global_fn.sh" ]; then
  source "${scrDir}/global_fn.sh"
fi

print_log -b "[Hardware] " "Initiating :: " "ThinkPad T15g Gen 1 Optimization"

# 1. Link the think-power tool
# We use the relative path from the repo to ensure it works anywhere
repoDir="$(dirname "${scrDir}")"
sudo ln -sf "${repoDir}/Scripts/custom/think-power" /usr/local/bin/think-power
print_log -g "[Hardware] " "Link created :: " "/usr/local/bin/think-power"

# 2. Configure Sudoers (Auto-detect user)
REAL_USER=$(logname)
SUDO_CONF="/etc/sudoers.d/think-power"
if [ ! -f "$SUDO_CONF" ]; then
  echo "$REAL_USER ALL=(ALL) NOPASSWD: /usr/local/bin/think-power" | sudo tee "$SUDO_CONF" >/dev/null
  sudo chmod 440 "$SUDO_CONF"
  print_log -g "[Hardware] " "Sudoers configured :: " "NOPASSWD for $REAL_USER"
fi

# 3. Enable Kernel Modules
echo "think-lmi" | sudo tee /etc/modules-load.d/think-lmi.conf >/dev/null
echo "options thinkpad_acpi fan_control=1" | sudo tee /etc/modprobe.d/thinkpad_acpi.conf >/dev/null
print_log -g "[Hardware] " "Kernel modules :: " "Configured for fans and BIOS"
