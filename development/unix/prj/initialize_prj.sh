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

# sanity check(s)
PROJECTS_DIRECTORY="$(dirname $(readlink -f $0))/../../../.."
[ ! -d ${PROJECTS_DIRECTORY} ] && echo "ERROR: invalid projects directory (was: \"${PROJECTS_DIRECTORY}\"), aborting" && exit 1
#echo "PROJECTS_DIRECTORY=\"$PROJECTS_DIRECTORY\""

shopt -s nullglob
# shell
SCRIPTS="ACE.ld.conf"
for script in ${SCRIPTS}
do
 SCRIPT_PATH="$(dirname $(readlink -f $0))/${script}"
 [ ! -r ${SCRIPT_PATH} ] && echo "ERROR: invalid script (was: \"${script}\"), aborting" && exit 1
 sudo cp -f ${SCRIPT_PATH} /etc/ld.so.conf.d/ >/dev/null 2>&1
 [ $? -ne 0 ] && echo "ERROR: failed to cp \"${SCRIPT_PATH}\" to \"${HOME}\": $?, aborting" && exit 1 
 echo "copied \"$(basename ${SCRIPT_PATH})\"..."
done

#shopt -s nullglob
PROJECTS="Common
ACEStream
ACENetwork"
for project in ${PROJECTS}
do
 PROJECT_PATH="${PROJECTS_DIRECTORY}/${project}"
 [ ! -d ${PROJECT_PATH} ] && echo "ERROR: invalid project directory (was: \"${PROJECT_PATH}\"), aborting" && exit 1
 SCRIPTS_PATH="${PROJECT_PATH}/scripts"
 [ ! -d ${SCRIPTS_PATH} ] && echo "ERROR: invalid scripts directory (was: \"${SCRIPTS_PATH}\"), aborting" && exit 1
 INIT_SCRIPT="${SCRIPTS_PATH}/initialize_prj.sh"
 [ ! -x ${INIT_SCRIPT} ] && echo "ERROR: invalid initialization script (was: \"${INIT_SCRIPT}\"), aborting" && exit 1
 ${INIT_SCRIPT}
[ $? -ne 0 ] && echo "ERROR: failed to execute \"${INIT_SCRIPT}\": $?, aborting" && exit 1
 
 echo "processing ${project}...DONE"
done

