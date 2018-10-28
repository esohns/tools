#!/bin/sh
# author:      Erik Sohns <eriksohns@123mail.org>
# this script initializes ssh for the (github) projects
# *NOTE*: it is neither portable nor particularly stable !
# parameters:   - N/A
# return value: - 0 success, 1 failure

# sanity checks
command -v basename >/dev/null 2>&1 || { echo "basename is not installed, aborting" >&2; exit 1; }
command -v cat >/dev/null 2>&1 || { echo "cat is not installed, aborting" >&2; exit 1; }
command -v chmod >/dev/null 2>&1 || { echo "chmod is not installed, aborting" >&2; exit 1; }
command -v cp >/dev/null 2>&1 || { echo "cp is not installed, aborting" >&2; exit 1; }
command -v dirname >/dev/null 2>&1 || { echo "dirname is not installed, aborting" >&2; exit 1; }
command -v mkdir >/dev/null 2>&1 || { echo "mkdir is not installed, aborting" >&2; exit 1; }
command -v readlink >/dev/null 2>&1 || { echo "readlink is not installed, aborting" >&2; exit 1; }
#command -v test >/dev/null 2>&1 || { echo "test is not installed, aborting" >&2; exit 1; }

#DEFAULT_PLATFORM="linux"
#PLATFORM=${DEFAULT_PLATFORM}
#if [ $# -lt 1 ]; then
# echo "INFO: using default platform: \"${PLATFORM}\""
#else
# # parse any arguments
# if [ $# -ge 1 ]; then
#  PLATFORM="$1"
# fi
#fi
#echo "DEBUG: platform: \"${PLATFORM}\""

HOME_DIRECTORY=${HOME}

SSH_CONFIG_DIRECTORY="${HOME_DIRECTORY}/.ssh"
if [ ! -d ${SSH_CONFIG_DIRECTORY} ]; then
 mkdir ${SSH_CONFIG_DIRECTORY} >/dev/null 2>&1
 [ $? -ne 0 ] && echo "ERROR: failed to mkdir \"${SSH_CONFIG_DIRECTORY}\": $?, aborting" && exit 1 
 echo "created ${SSH_CONFIG_DIRECTORY}..."
fi

CONFIGURATION_FILES_DIRECTORY="$(dirname $(readlink -f $0))"
ID_RSA="${CONFIGURATION_FILES_DIRECTORY}/id_rsa"
ID_RSA_PUB="${CONFIGURATION_FILES_DIRECTORY}/id_rsa.pub"
KNOWN_HOSTS="${CONFIGURATION_FILES_DIRECTORY}/known_hosts"

# sanity check(s)
[ ! -d ${HOME_DIRECTORY} ] && echo "ERROR: invalid home directory (was: \"${HOME_DIRECTORY}\"), aborting" && exit 1
[ ! -d ${SSH_CONFIG_DIRECTORY} ] && echo "ERROR: invalid profile ssh configuration directory (was: \"${SSH_CONFIG_DIRECTORY}\"), aborting" && exit 1 
[ ! -d ${CONFIGURATION_FILES_DIRECTORY} ] && echo "ERROR: invalid ssh configuration files directory (was: \"${CONFIGURATION_FILES_DIRECTORY}\"), aborting" && exit 1
[ ! -r ${ID_RSA} ] && echo "ERROR: invalid id_rsa (was: \"${ID_RSA}\"), aborting" && exit 1
[ ! -r ${ID_RSA_PUB} ] && echo "ERROR: invalid id_rsa.pub (was: \"${ID_RSA_PUB}\"), aborting" && exit 1
[ ! -r ${KNOWN_HOSTS} ] && echo "ERROR: invalid known_hosts (was: \"${KNOWN_HOSTS}\"), aborting" && exit 1

cp -f ${ID_RSA} ${SSH_CONFIG_DIRECTORY} >/dev/null 2>&1
[ $? -ne 0 ] && echo "ERROR: failed to cp \"${ID_RSA}\" to \"${SSH_CONFIG_DIRECTORY}\": $?, aborting" && exit 1
echo "copied \"$(basename ${ID_RSA})\"..."
chmod 600 "${SSH_CONFIG_DIRECTORY}/$(basename ${ID_RSA})" >/dev/null 2>&1
[ $? -ne 0 ] && echo "ERROR: failed to chmod 600 \"${SSH_CONFIG_DIRECTORY}/$(basename ${ID_RSA})\": $?, aborting" && exit 1
cp -f ${ID_RSA_PUB} ${SSH_CONFIG_DIRECTORY} >/dev/null 2>&1
[ $? -ne 0 ] && echo "ERROR: failed to cp \"${ID_RSA_PUB}\" to \"${SSH_CONFIG_DIRECTORY}\": $?, aborting" && exit 1
echo "copied \"$(basename ${ID_RSA_PUB})\"..."
if [ -f "${SSH_CONFIG_DIRECTORY}/$(basename ${KNOWN_HOSTS})" ]; then
 cp -f "${SSH_CONFIG_DIRECTORY}/$(basename ${KNOWN_HOSTS})" "${SSH_CONFIG_DIRECTORY}/$(basename ${KNOWN_HOSTS}).bak" >/dev/null 2>&1
 [ $? -ne 0 ] && echo "ERROR: failed to backup \"${SSH_CONFIG_DIRECTORY}/$(basename ${KNOWN_HOSTS})\": $?, aborting" && exit 1
 echo "backed up \"${SSH_CONFIG_DIRECTORY}/$(basename ${KNOWN_HOSTS})\"..."
fi
cat "${KNOWN_HOSTS}" "${SSH_CONFIG_DIRECTORY}/$(basename ${KNOWN_HOSTS})" >> "${SSH_CONFIG_DIRECTORY}/$(basename ${KNOWN_HOSTS})" 2>/dev/null
#[ $? -ne 0 ] && echo "ERROR: failed to append \"${KNOWN_HOSTS}\" to \"${SSH_CONFIG_DIRECTORY}/$(basename ${KNOWN_HOSTS})\": $?, aborting" && exit 1 
echo "appended \"$(basename ${KNOWN_HOSTS})\"..."

