#!/bin/sh
# author:      Erik Sohns <eriksohns@123mail.org>
# this script installs the mount_ntfs_paritions service
# parameters:   - install|uninstall
# return value: - 0 success, 1 failure

# sanity checks
command -v exec >/dev/null 2>&1 || { echo "exec is not installed, aborting" >&2; exit 1; }
command -v test >/dev/null 2>&1 || { echo "test is not installed, aborting" >&2; exit 1; }
command -v sudo >/dev/null 2>&1 || { echo "sudo is not installed, aborting" >&2; exit 1; }
#command -v gksudo >/dev/null 2>&1 || { echo "gksudo is not installed, aborting" >&2; exit 1; }

# *NOTE*: regular users may not have the CAP_SETFCAP capability needed to modify
#         (executable) file capabilities --> run as root
# *TODO*: verify this programmatically
HAS_GKSUDO=0
test -x gksudo && { HAS_GKSUDO=1; }

if [ "${USER}" != "root" ]; then
 SUDO=sudo
 CMDLINE_ARGS="$@"
 if [ ${HAS_GKSUDO} -eq 1 ]; then
  SUDO=gksudo
  CMDLINE_ARGS="--disable-grab $0 $@"
 fi
# echo "invoking sudo $0 \"${CMDLINE_ARGS}\"..."
 exec ${SUDO} $0 ${CMDLINE_ARGS}
fi
#echo "starting..."

# sanity checks
command -v basename >/dev/null 2>&1 || { echo "basename is not installed, aborting" >&2; exit 1; }
command -v cp >/dev/null 2>&1 || { echo "cp is not supported, aborting" >&2; exit 1; }
command -v rm >/dev/null 2>&1 || { echo "rm is not supported, aborting" >&2; exit 1; }
#command -v readlink >/dev/null 2>&1 || { echo "readlink is not installed, aborting" >&2; exit 1; }
#command -v /sbin/insserv >/dev/null 2>&1 || { echo "insserv is not installed, aborting" >&2; exit 1; }
command -v systemctl >/dev/null 2>&1 || { echo "systemctl is not installed, aborting" >&2; exit 1; }
#command -v /sbin/service >/dev/null 2>&1 || { echo "service is not installed, aborting" >&2; exit 1; }

# sanity check(s)
SBIN_DIRECTORY="/sbin"
test -d ${SBIN_DIRECTORY} || { echo "ERROR: invalid sbin directory (was: \"${SBIN_DIRECTORY}\"), aborting"; exit 1; }
#INIT_DIRECTORY="/etc/init.d"
#[ ! -d ${INIT_DIRECTORY} ] && echo "ERROR: invalid init directory (was: \"${INIT_DIRECTORY}\"), aborting" && exit 1
SYSTEMD_DIRECTORY="/etc/systemd/system"
test -d ${SYSTEMD_DIRECTORY} && break || { echo "ERROR: invalid systemd directory (was: \"${SYSTEMD_DIRECTORY}\"), aborting"; exit 1; }
SCRIPTS_DIRECTORY="$(dirname $(readlink -f $0))"
test -d ${SCRIPTS_DIRECTORY} && break || { echo "ERROR: invalid scripts directory (was: \"${SCRIPTS_DIRECTORY}\"), aborting"; exit 1; }

case "$1" in
 install)
  SERVICE_SCRIPT_FILE="${SCRIPTS_DIRECTORY}/mount_ntfs_partitions.sh"
  test -r ${SERVICE_SCRIPT_FILE} || { echo "ERROR: invalid script file (was: \"${SERVICE_SCRIPT_FILE}\"), aborting"; exit 1; }
#  INIT_SERVICE_FILE="${SCRIPTS_DIRECTORY}/mount_ntfs_partitions.init"
#  [ ! -r ${INIT_SERVICE_FILE} ] && echo "ERROR: invalid (init) service file (was: \"${INIT_SERVICE_FILE}\"), aborting" && exit 1
  SYSTEMD_SERVICE_FILE="${SCRIPTS_DIRECTORY}/mount_ntfs_partitions.service"
  test -r ${SYSTEMD_SERVICE_FILE} || { echo "ERROR: invalid (systemd) service file (was: \"${SYSTEMD_SERVICE_FILE}\"), aborting"; exit 1; }

#  cp -f ${INIT_SERVICE_FILE} ${INIT_DIRECTORY} >/dev/null 2>&1
#  [ $? -ne 0 ] && echo "ERROR: failed to cp \"${INIT_SERVICE_FILE}\" to \"${INIT_DIRECTORY}\": $?, aborting" && exit 1 
#  echo "copied $(basename ${INIT_SERVICE_FILE}) (to: \"${INIT_DIRECTORY}\")"
  cp -f ${SERVICE_SCRIPT_FILE} ${SBIN_DIRECTORY} >/dev/null 2>&1
  test $? -eq 0 || { echo "ERROR: failed to cp \"${SERVICE_SCRIPT_FILE}\" to \"${SBIN_DIRECTORY}\": $?, aborting"; exit 1; }
  echo "copied $(basename ${SERVICE_SCRIPT_FILE}) (to: \"${SBIN_DIRECTORY}\")"
  cp -f ${SYSTEMD_SERVICE_FILE} ${SYSTEMD_DIRECTORY} >/dev/null 2>&1
  test $? -eq 0 || { echo "ERROR: failed to cp \"${SYSTEMD_SERVICE_FILE}\" to \"${SYSTEMD_DIRECTORY}\": $?, aborting"; exit 1; }
  echo "copied $(basename ${SYSTEMD_SERVICE_FILE}) (to: \"${SYSTEMD_DIRECTORY}\")"

#  insserv "${INIT_DIRECTORY}/mount_ntfs_partitions.init"
#  [ $? -ne 0 ] && echo "ERROR: failed to insserv \"${INIT_DIRECTORY}/mount_ntfs_partitions.init\": $?, aborting" && exit 1 
#  echo "installed mount_ntfs_partitions.init"  
  systemctl enable ${SYSTEMD_DIRECTORY}/mount_ntfs_partitions.service >/dev/null 2>&1
  test $? -eq 0 || { echo "ERROR: failed to systemctl enable \"mount_ntfs_partitions.service\": $?, aborting"; exit 1; }
  echo "enabled mount_ntfs_partitions.service"
# service mount_ntfs_partitions start
# [ $? -ne 0 ] && echo "ERROR: failed to start mount_ntfs_partitions service: $?, aborting" && exit 1 
# echo "started mount_ntfs_partitions service"
  ;;
 uninstall)
#  INIT_SERVICE_FILE="${INIT_DIRECTORY}/mount_ntfs_partitions.init"
#  [ ! -r ${INIT_SERVICE_FILE} ] && echo "ERROR: invalid init service file (was: \"${INIT_SERVICE_FILE}\"), aborting" && exit 1
  SYSTEMD_SERVICE_FILE="${SYSTEMD_DIRECTORY}/mount_ntfs_partitions.service"
  test -r ${SYSTEMD_SERVICE_FILE} || { echo "ERROR: invalid (systemd) service file (was: \"${SYSTEMD_SERVICE_FILE}\"), aborting"; exit 1; }
  SERVICE_SCRIPT_FILE="${SBIN_DIRECTORY}/mount_ntfs_partitions.sh"
  test -r ${SERVICE_SCRIPT_FILE} || { echo "ERROR: invalid service script file (was: \"${SERVICE_SCRIPT_FILE}\"), aborting"; exit 1; }

#  service mount_ntfs_partitions stop
#  if [ $? -ne 0 ]; then
#   echo "ERROR: failed to stop mount_ntfs_partitions service: $?, continuing"
#  else
#   echo "stopped mount_ntfs_partitions service"
#  fi
#  insserv -r "${INIT_DIRECTORY}/mount_ntfs_partitions.init"
#  if [ $? -ne 0 ]; then
#   echo "ERROR: failed to insserv -r \"${INIT_DIRECTORY}/mount_ntfs_partitions.init\": $?, continuing"
#  else
#   echo "uninstalled mount_ntfs_partitions.init"
#  fi
  systemctl disable mount_ntfs_partitions.service >/dev/null 2>&1
  test $? -eq 0 || { echo "ERROR: failed to systemctl disable \"mount_ntfs_partitions.service\": $?, aborting"; exit 1; }
  echo "disabled mount_ntfs_partitions.service"

#  rm -f ${INIT_SERVICE_FILE} >/dev/null 2>&1
#  [ $? -ne 0 ] && echo "ERROR: failed to rm \"${INIT_SERVICE_FILE}\": $?, aborting" && exit 1 
#  echo "deleted ${INIT_SERVICE_FILE}"
  rm -f ${SYSTEMD_SERVICE_FILE} >/dev/null 2>&1
  test $? -eq 0 || { echo "ERROR: failed to rm \"${SYSTEMD_SERVICE_FILE}\": $?, aborting" && exit 1; }
  echo "deleted ${SYSTEMD_SERVICE_FILE}"
  rm -f $SERVICE_SCRIPT_FILE >/dev/null 2>&1
  test $? -eq 0 || { echo "ERROR: failed to rm \"${SERVICE_SCRIPT_FILE}\": $?, aborting"; exit 1; }
  echo "deleted ${SERVICE_SCRIPT_FILE}"
  ;;
 *)
  echo "usage: $(basename $0) [install|uninstall]"
  exit 6
  ;;
esac

