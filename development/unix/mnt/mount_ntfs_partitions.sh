#!/bin/sh
# author:      Erik Sohns <eriksohns@123mail.org>
# currently there is a *bug* in ntfs-3g that (auto-)mounts partitions in
# /etc/fstab with 'nosuid,nodev' options (try it, check with 'cat /proc/mounts').
# The problem does not occur when mounting paritions 'manually' (i.e. calling
# 'mount.ntfs' directly)
# --> use this script as a *workaround* to mount ntfs-3g partitions, copy/link
#     to '/etc/init.d' (YMMV) to load on startup
# return value: - 0 success, 1 failure

# sanity checks
command -v mount.ntfs >/dev/null 2>&1 || { echo "mount.ntfs is not installed, aborting" >&2; exit 1; }
command -v umount >/dev/null 2>&1 || { echo "umount is not installed, aborting" >&2; exit 1; }
# sanity checks
command -v echo >/dev/null 2>&1 || { echo "echo is not supported, aborting" >&2; exit 1; }
#command -v readlink >/dev/null 2>&1 || { echo "readlink is not installed, aborting" >&2; exit 1; }
command -v test >/dev/null 2>&1 || { echo "test is not supported, aborting" >&2; exit 1; }
#command -v tr >/dev/null 2>&1 || { echo "tr is not installed, aborting" >&2; exit 1; }

# sanity checks
DEV_ROOT="/dev"
test -d "${DEV_ROOT}" || { echo "ERROR: invalid root device file directory (was: \"${DEV_ROOT}\"), aborting"; exit 1; }
MOUNT_ROOT="/mnt"
test -d "${MOUNT_ROOT}" || { echo "ERROR: invalid root mount point (was: \"${MOUNT_ROOT}\"), aborting"; exit 1; }
MOUNT_OPTIONS="permissions,big_writes,dev,suid"

RC_STATUS=0
#declare -a DEVS=(sda1 sda3)
DEVS="sda1 sda3"
#declare -a MOUNT_POINTS=(win_c win_d)
MOUNT_POINTS="win_c win_d"
#declare -i i
i=1
#for DEV in "${DEVS[@]}"
for DEV in ${DEVS}
do
# echo "DEBUG: dev: \"${DEV}\""
 case "$1" in
  start)
   # sanity checks
   if [ ! -r "${DEV_ROOT}/${DEV}" ]; then
    echo "ERROR: invalid device file/partition (was: \"${DEV_ROOT}/${DEV}\"), continuing"
    RC_STATUS=1
    continue
   fi
   MOUNT_POINT=$(echo $MOUNT_POINTS | cut -d' ' -f$i)
#   MOUNT_POINT="${MOUNT_ROOT}/${MOUNT_POINTS[$i]}"
   MOUNT_POINT="${MOUNT_ROOT}/${MOUNT_POINT}"
   if [ ! -d "${MOUNT_POINT}" ]; then
    echo "ERROR: invalid mount point (was: \"${MOUNT_POINT}\"), continuing"
    RC_STATUS=1
    continue
   fi

   mount.ntfs -o ${MOUNT_OPTIONS} ${DEV_ROOT}/${DEV} ${MOUNT_POINT} >/dev/null 2>&1
   if [ $? -ne 0 ]; then
    echo "ERROR: failed to mount.ntfs \"${DEV_ROOT}/${DEV}\" at ${MOUNT_POINT}: $?, continuing"
    RC_STATUS=1
    continue
   fi
   echo "mounted ${DEV_ROOT}/${DEV} at ${MOUNT_POINT}"
   ;;
  stop)
   MOUNT_POINT=$(echo $MOUNT_POINTS | cut -d' ' -f$i)
#   MOUNT_POINT="${MOUNT_ROOT}/${MOUNT_POINTS[$i]}"
   test -d "${MOUNT_POINT}" || { echo "ERROR: invalid mount point (was: \"${MOUNT_POINT}\"), continuing"; RC_STATUS=1; continue; }

   umount ${MOUNT_POINT} >/dev/null 2>&1
   if [ $? -ne 0 ]; then
    echo "ERROR: failed to umount \"${MOUNT_POINT}\": $?, continuing"
    RC_STATUS=1
    continue
   fi
   echo "unmounted \"${MOUNT_POINT}\""
   ;;
  status)
   MOUNT_POINT=$(echo $MOUNT_POINTS | cut -d' ' -f$i)
#   MOUNT_POINT="${MOUNT_ROOT}/${MOUNT_POINTS[$i]}"
   test -d "${MOUNT_POINT}" || { echo "ERROR: invalid mount point (was: \"${MOUNT_POINT}\"), continuing"; exit 1; }

   # *TODO*: an empty mount point does not mean the partition has not (!) been
   #         mounted
   test -z "$(ls -A ${MOUNT_POINT})" && { RC_STATUS=1; }
   ;;
  *)
   echo "invalid command \"$1\""
   echo "usage: $(basename $0) [start|stop|status]"
   exit 6
   ;;
 esac
 i=$(($i+1))
done

exit $RC_STATUS

