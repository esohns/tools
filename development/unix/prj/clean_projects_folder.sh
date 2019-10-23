#!/bin/sh
# author:      Erik Sohns <eriksohns@123mail.org>
# this script cleans all git projects in the main project folder
# *NOTE*: it is neither portable nor particularly stable !
# parameters:   N/A
# return value: - 0 success, 1 failure

# sanity checks
command -v basename >/dev/null 2>&1 || { echo "basename is not installed, aborting" >&2; exit 1; }
command -v cd >/dev/null 2>&1 || { echo "cd is not installed, aborting" >&2; exit 1; }
command -v dirname >/dev/null 2>&1 || { echo "dirname is not installed, aborting" >&2; exit 1; }
command -v find >/dev/null 2>&1 || { echo "find is not installed, aborting" >&2; exit 1; }
command -v git >/dev/null 2>&1 || { echo "git is not installed, aborting" >&2; exit 1; }
command -v realpath >/dev/null 2>&1 || { echo "realpath is not installed, aborting" >&2; exit 1; }
command -v rm >/dev/null 2>&1 || { echo "rm is not installed, aborting" >&2; exit 1; }
command -v xargs >/dev/null 2>&1 || { echo "xargs is not installed, aborting" >&2; exit 1; }

DEFAULT_PROJECTS_ROOT_DIRECTORY="$(dirname $(realpath -e $0))/../../../.."
PROJECTS_DIRECTORY=${DEFAULT_PROJECTS_ROOT_DIRECTORY}
# sanity check(s)
[ ! -d ${PROJECTS_DIRECTORY} ] && echo "ERROR: invalid project directory (was: \"${PROJECTS_DIRECTORY}\"), aborting" && exit 1
#echo "DEBUG: projects directory: \"${PROJECTS_DIRECTORY}\""

cd $PROJECTS_DIRECTORY
[ $? -ne 0 ] && echo "ERROR: failed to cd to \"${PROJECTS_DIRECTORY}\": $?, aborting" && exit 1

# step1: remove build caches
SUB_DIRECTORIES="Common
ACEStream
ACENetwork
ardrone"
for PROJECT_DIRECTORY in ${SUB_DIRECTORIES}
do
 echo "\"${PROJECT_DIRECTORY}\"..."

 CURRENT_PROJECT_DIRECTORY="${PROJECTS_DIRECTORY}/${PROJECT_DIRECTORY}/cmake"
 if [[ ! -d ${CURRENT_PROJECT_DIRECTORY} ]]; then
 echo "\"${CURRENT_PROJECT_DIRECTORY}\"..."
  continue
 fi
 cd ${CURRENT_PROJECT_DIRECTORY}
 find . -name cotire | xargs rm -rf
 [ $? -ne 0 ] && echo "ERROR: failed to remove \"${CURRENT_PROJECT_DIRECTORY}\": $?, aborting" && exit 1

 echo "\"$PROJECT_DIRECTORY\"...DONE"
done

# step2: clean git cache
SCRIPT_FILE="$(dirname $0)/clean_projects_folder_git.sh"
[ ! -x ${SCRIPT_FILE} ] && echo "ERROR: invalid script (was: \"${SCRIPT_FILE}\"), aborting" && exit 1
echo "$(basename $SCRIPT_FILE)..."
${SCRIPT_FILE}
 [ $? -ne 0 ] && echo "ERROR: failed to run \"${SCRIPT_FILE}\": $?, aborting" && exit 1
echo "$(basename $SCRIPT_FILE)...DONE"

