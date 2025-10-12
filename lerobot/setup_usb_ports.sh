#!/bin/bash

# Define the ID_SERIAL_SHORT values for each device
DEVICE1_ID_SERIAL_SHORT="5AAF270447" # left follower
DEVICE2_ID_SERIAL_SHORT="5AB0179027" # right follower
DEVICE3_ID_SERIAL_SHORT="5A7A015778" # left leader
DEVICE4_ID_SERIAL_SHORT="5AB0181062" # right leader

# Function to find the device path based on ID_SERIAL_SHORT
get_device_path_by_serial_short() {
    local serial_short=$1
    for dev in /dev/ttyACM*; do
        if udevadm info --query=all --name="$dev" | grep -q "ID_SERIAL_SHORT=$serial_short"; then
            echo "$dev"
            return 0
        fi
    done
    return 1
}

# Find device paths based on ID_SERIAL_SHORT before removing symlinks
DEVICE1_PATH=$(get_device_path_by_serial_short $DEVICE1_ID_SERIAL_SHORT)
DEVICE2_PATH=$(get_device_path_by_serial_short $DEVICE2_ID_SERIAL_SHORT)
DEVICE3_PATH=$(get_device_path_by_serial_short $DEVICE3_ID_SERIAL_SHORT)
DEVICE4_PATH=$(get_device_path_by_serial_short $DEVICE4_ID_SERIAL_SHORT)

# Check if the devices were found and create symlinks
if [ -n "$DEVICE1_PATH" ]; then
    sudo rm -f /dev/ttySLLF
    sudo ln -s "$DEVICE1_PATH" /dev/ttySLLF
else
    echo "Device with ID_SERIAL_SHORT $DEVICE1_ID_SERIAL_SHORT not found."
fi

if [ -n "$DEVICE2_PATH" ]; then
    sudo rm -f /dev/ttySLRF
    sudo ln -s "$DEVICE2_PATH" /dev/ttySLRF
else
    echo "Device with ID_SERIAL_SHORT $DEVICE2_ID_SERIAL_SHORT not found."
fi

if [ -n "$DEVICE3_PATH" ]; then
    sudo rm -f /dev/ttySLLL
    sudo ln -s "$DEVICE3_PATH" /dev/ttySLLL
else
    echo "Device with ID_SERIAL_SHORT $DEVICE3_ID_SERIAL_SHORT not found."
fi

if [ -n "$DEVICE4_PATH" ]; then
    sudo rm -f /dev/ttySLRL
    sudo ln -s "$DEVICE4_PATH" /dev/ttySLRL
else
    echo "Device with ID_SERIAL_SHORT $DEVICE4_ID_SERIAL_SHORT not found."
fi
    
# Verify symlinks
ls -l /dev/ttySLLF /dev/ttySLRF /dev/ttySLLL /dev/ttySLRL