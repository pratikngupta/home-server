#!/bin/bash

# Fancy Header
clear
echo "============================================="
echo "       🚀 Partition Automation Script        "
echo "           Developed by: Pratik             "
echo "       Purpose: Create and mount partitions "
echo "        Version: 2.1   Date: $(date '+%Y-%m-%d')"
echo "============================================="
echo

# Disclaimer and Confirmation
echo "⚠️ WARNING: This script modifies disk partitions."
echo "Improper use may result in data loss. Proceed only if"
echo "you understand the risks and have backups of your data."
echo
read -p "Do you wish to proceed? (yes/no): " confirm
if [[ "$confirm" != "yes" ]]; then
  echo "Aborting. No changes were made."
  exit 1
fi

# Function to get user input with a default value
get_input() {
  local prompt="$1"
  local default="$2"
  read -p "$prompt [$default]: " input
  echo "${input:-$default}"
}

# Check if running as root
if [ "$EUID" -ne 0 ]; then
  echo "❌ Please run as root (use sudo)"
  exit 1
fi

# Step 1: Display available drives and let user select
echo "🔍 Detecting available drives..."
lsblk -o NAME,SIZE,TYPE,MOUNTPOINT
echo
echo "Please select the disk you want to partition."
PS3="Enter the number corresponding to your choice: "

# Generate drive options from lsblk output
options=($(lsblk -dn -o NAME,TYPE | awk '$2=="disk" {print "/dev/"$1}'))
options+=("Cancel")

# Display the menu
select disk in "${options[@]}"; do
  case $disk in
    /dev/*)
      DISK="$disk"
      echo "📌 Selected disk: $DISK"
      break
      ;;
    "Cancel")
      echo "Aborting. No changes were made."
      exit 1
      ;;
    *)
      echo "❌ Invalid choice. Please try again."
      ;;
  esac
done

# Step 2: Gather additional user input
PART_SIZE=$(get_input "Enter the partition size (e.g., +200G)" "+200G")
FS_TYPE=$(get_input "Enter the file system type (e.g., ext4)" "ext4")
MOUNT_POINT=$(get_input "Enter the mount point (e.g., /mnt/new_partition)" "/mnt/new_partition")
CURRENT_USER=$(whoami)

# Step 3: Check disk size and use GPT if necessary
DISK_SIZE_BYTES=$(blockdev --getsize64 "$DISK")
DISK_SIZE_TIB=$(echo "$DISK_SIZE_BYTES / 2^40" | bc)

if (( DISK_SIZE_TIB > 2 )); then
  echo "🔄 Disk size is larger than 2 TiB. Using GPT partition table."
  parted --script $DISK mklabel gpt
else
  echo "🔄 Disk size is within 2 TiB. Using DOS partition table."
  parted --script $DISK mklabel msdos
fi

# Step 4: Create the new partition
echo "🔧 Creating a new partition of size $PART_SIZE on $DISK..."
parted --script $DISK mkpart primary $FS_TYPE 0% $PART_SIZE

# Get the name of the newly created partition
NEW_PART=$(lsblk -np $DISK | tail -n 1 | awk '{print $1}')

# Step 5: Format the new partition
echo "🛠 Formatting the new partition $NEW_PART with $FS_TYPE file system..."
mkfs.$FS_TYPE $NEW_PART

# Step 6: Create a mount point
echo "📂 Creating mount point at $MOUNT_POINT..."
mkdir -p $MOUNT_POINT

# Step 7: Get the UUID of the new partition
UUID=$(blkid -s UUID -o value $NEW_PART)
if [ -z "$UUID" ]; then
  echo "❌ Failed to get UUID for $NEW_PART"
  exit 1
fi

# Step 8: Backup and update /etc/fstab
echo "📄 Backing up and updating /etc/fstab..."
cp /etc/fstab /etc/fstab.bak
echo "UUID=$UUID $MOUNT_POINT $FS_TYPE defaults 0 2" >> /etc/fstab

# Step 9: Mount the new partition
echo "🔗 Mounting $NEW_PART..."
mount -a

# Step 10: Transfer ownership of the mount point folder to the current user
echo "👤 Transferring ownership of $MOUNT_POINT to user $CURRENT_USER..."
chown -R $CURRENT_USER:$CURRENT_USER $MOUNT_POINT

# Step 11: Verify the mount
if mountpoint -q $MOUNT_POINT; then
  echo "✅ Partition successfully created, formatted, mounted, and ownership transferred!"
  echo "🎉 New partition mounted at $MOUNT_POINT"
else
  echo "❌ Failed to mount the partition. Please check the configuration."
fi
