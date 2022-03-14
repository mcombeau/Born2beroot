#!bin/bash

# Get boot time minutes and seconds
BOOT_MIN=$(uptime -s | cut -d ":" -f 2)
BOOT_SEC=$(uptime -s | cut -d ":" -f 3)

# Calculate number of seconds between the nearest 10th minute of the hour and boot time:
# Ex: if boot time was 11:43:36
# 43 % 10 = 3 minutes since 40th minute of the hour
# 3 * 60 = 180 seconds since 40th minute of the hour
# 180 + 36 = 216 seconds between nearest 10th minute of the hour and boot
DELAY=$(bc <<< $BOOT_MIN%10*60+$BOOT_SEC)

# Wait that number of seconds
sleep $DELAY
