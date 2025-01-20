#!/bin/bash

# List available partitions using lsblk and format the output
partitions=$(lsblk -o NAME,SIZE,TYPE,MOUNTPOINT | awk '$3 == "part" {print NR") /dev/"$1, $2, $4}')

# Check if there are any partitions available
if [ -z "$partitions" ]; then
  echo "No partitions found."
  exit 1
fi

# Display the partitions to the user
echo "Available partitions:"
echo "$partitions"

# Prompt the user to select a partition
read -p "Enter the number corresponding to the partition to get its PARTUUID: " choice

# Validate the user's input
selected_partition=$(echo "$partitions" | awk -v choice="$choice" '$1 == choice")" {print $2}')
if [ -z "$selected_partition" ]; then
  echo "Invalid selection."
  exit 1
fi

# Retrieve the PARTUUID of the selected partition
partuuid=$(blkid -s UUID -o value "$selected_partition")

# Check if the PARTUUID was retrieved successfully
if [ -z "$partuuid" ]; then
  echo "Failed to retrieve UUID for $selected_partition."
  exit 1
fi

# Display the PARTUUID
echo "The UUID of $selected_partition is $partuuid."
