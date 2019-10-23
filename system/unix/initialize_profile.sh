#!/bin/sh
# author:      Erik Sohns <eriksohns@123mail.org>
# this script initializes gdb and pretty printers for the project
# *NOTE*: it is neither portable nor particularly stable !
# parameters:   - (UNIX) platform [linux|solaris]
# return value: - 0 success, 1 failure

# sanity checks
command -v basename >/dev/null 2>&1 || { echo "basename is not installed, aborting" >&2; exit 1; }
command -v cp >/dev/null 2>&1 || { echo "cp is not installed, aborting" >&2; exit 1; }
command -v dirname >/dev/null 2>&1 || { echo "dirname is not installed, aborting" >&2; exit 1; }
command -v mkdir >/dev/null 2>&1 || { echo "mkdir is not installed, aborting" >&2; exit 1; }
command -v readlink >/dev/null 2>&1 || { echo "readlink is not installed, aborting" >&2; exit 1; }
#command -v shopt >/dev/null 2>&1 || { echo "shopt is not installed, aborting" >&2; exit 1; }

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

shopt -s nullglob
# shell
SCRIPTS=".bash_aliases
.bash_profile
.profile"
for script in ${SCRIPTS}
do
 SCRIPT_PATH="$(dirname $(readlink -f $0))/${script}"
 [ ! -r ${SCRIPT_PATH} ] && echo "ERROR: invalid script (was: \"${script}\"), aborting" && exit 1
 cp -f ${SCRIPT_PATH} ${HOME} >/dev/null 2>&1
 [ $? -ne 0 ] && echo "ERROR: failed to cp \"${SCRIPT_PATH}\" to \"${HOME}\": $?, aborting" && exit 1 
 echo "copied \"$(basename ${SCRIPT_PATH})\"..."
done

# development
# gdb
SCRIPTS_DIRECTORY="$(dirname $(readlink -f $0))/../../development/unix"
[ ! -d ${SCRIPTS_DIRECTORY} ] && echo "ERROR: invalid development script directory (was: \"${SCRIPTS_DIRECTORY}\"), aborting" && exit 1
SUBDIRECTORIES="gdb
ssh
prj"
for sub_directory in ${SUBDIRECTORIES}
do
 SCRIPT_DIRECTORY="${SCRIPTS_DIRECTORY}/${sub_directory}"
 [ ! -d ${SCRIPT_DIRECTORY} ] && echo "ERROR: invalid development script directory (was: \"${SCRIPT_DIRECTORY}\"), aborting" && exit 1
 INIT_SCRIPT="${SCRIPT_DIRECTORY}/initialize_${sub_directory}.sh"
 [ ! -x ${INIT_SCRIPT} ] && echo "ERROR: invalid initialization script (was: \"${INIT_SCRIPT}\"), aborting" && exit 1
# echo "processing \"${INIT_SCRIPT}\"..."
 ${INIT_SCRIPT}
 [ $? -ne 0 ] && echo "ERROR: failed to execute \"${INIT_SCRIPT}\": $?, aborting" && exit 1 
 echo "processed \"$(basename ${INIT_SCRIPT})\"..."
done

# software projects
DEFAULT_PROJECTS_DIRECTORY="$(dirname $(readlink -f $0))/../../.."
PROJECTS_DIRECTORY=${DEFAULT_PROJECTS_DIRECTORY}
# sanity check(s)
[ ! -d ${PROJECTS_DIRECTORY} ] && echo "ERROR: invalid projects directory (was: \"${PROJECTS_DIRECTORY}\"), aborting" && exit 1
export PROJECTS_DIRECTORY
echo "set projects directory: \"${PROJECTS_DIRECTORY}\""

