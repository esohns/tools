#!/bin/sh
# author:      Erik Sohns <eriksohns@123mail.org>
# this script recursively removes trailing whitespace from all source code files
# in a directory
# *NOTE*: it is neither portable nor particularly stable !
# parameters:   - $1 directory
# return value: - 0 success, 1 failure

DEFAULT_PROJECT_DIRECTORY="/mnt/win_d/projects"
PROJECT_DIRECTORY=${DEFAULT_PROJECT_DIRECTORY}
# sanity check(s)
[ ! -d ${PROJECT_DIRECTORY} ] && echo "ERROR: invalid project directory (was: \"${PROJECT_DIRECTORY}\"), aborting" && exit 1

DIRECTORY=${PROJECT_DIRECTORY}
if [ $# -lt 1 ]; then
 echo "INFO: using default directory: \"${DIRECTORY}\""
else
 # parse any arguments
 if [ $# -ge 1 ]; then
  DIRECTORY="$1"
 fi
fi

# sanity check(s)
[ ! -d ${DIRECTORY} ] && echo "ERROR: invalid directory (was: \"${DIRECTORY}\"), aborting" && exit 1
echo "INFO: scanning directory: \"${DIRECTORY}\""

FIND="/usr/bin/find"
[ ! -x "${FIND}" ] && echo "ERROR: find not installed, aborting" && exit 1
XARGS="/usr/bin/xargs"
[ ! -x "${XARGS}" ] && echo "ERROR: xargs not installed, aborting" && exit 1
TEE="/usr/bin/tee"
[ ! -x "${TEE}" ] && echo "ERROR: tee not installed, aborting" && exit 1
SED="/bin/sed"
[ ! -x "${SED}" ] && echo "ERROR: sed not installed, aborting" && exit 1
SED_SCRIPT="s/[ \t]*$//g"
echo "INFO: applying sed script: \"$SED_SCRIPT\""
EXTENSIONS="cpp inl h"
for EXTENSION in $EXTENSIONS
do
 PATTERN="*.${EXTENSION}"
# $FIND ${DIRECTORY} -name '${PATTERN}' -type f -print0 | ${XARGS} -n 1 -0 ${TEE} - | ${SED} -e '${SED_SCRIPT}' -i -s
 $FIND ${DIRECTORY} -name '${PATTERN}' -type f -exec ${SED} -e "${SED_SCRIPT}"s -i -s {} \;
 [ $? -ne 0 ] && echo "ERROR: failed to edit \"${PATTERN}\" (sed script was: \"${SED_SCRIPT}\"): $?, aborting" && exit 1
done

