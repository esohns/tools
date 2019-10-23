#!/bin/sh
# author:      Erik Sohns <eriksohns@123mail.org>
# this script runs another script in each folder below a given root folder
# *NOTE*: it is neither portable nor particularly stable !
# parameters:   N/A
# return value: - 0 success, 1 failure

# sanity checks
command -v getopts >/dev/null 2>&1 || { echo "getopts is not installed, aborting" >&2; exit 1; }
command -v basename >/dev/null 2>&1 || { echo "basename is not installed, aborting" >&2; exit 1; }
command -v dirname >/dev/null 2>&1 || { echo "dirname is not installed, aborting" >&2; exit 1; }
command -v realpath >/dev/null 2>&1 || { echo "realpath is not installed, aborting" >&2; exit 1; }

# A POSIX variable
#OPTIND=1  Reset in case getopts has been used previously in the shell.
while getopts "d:gs:" opt; do
    case "$opt" in
    d)
        ROOT_DIRECTORY=$OPTARG
        ;;
    g)  GIT_PROJECT_FOLDERS_ONLY=1
        ;;
    s)  SCRIPT=$OPTARG
        ;;
    esac
done
#shift $((OPTIND-1))
#[ "${1:-}" = "--" ] && shift
echo "DEBUG: root directory: \"${ROOT_DIRECTORY}\""
[ ${GIT_PROJECT_FOLDERS_ONLY} -ne 0 ] && echo "DEBUG: process git project folders only"
echo "DEBUG: script: \"${SCRIPT}\""

# sanity check(s)
[ ! -d ${ROOT_DIRECTORY} ] && echo "ERROR: invalid root directory (was: \"${ROOT_DIRECTORY}\"), aborting" && exit 1
# sanity check(s)
[ ! -x ${SCRIPT} ] && echo "ERROR: invalid script (was: \"${SCRIPT}\"), aborting" && exit 1

GIT_DIRECTORY=".git"
cd $ROOT_DIRECTORY
[ $? -ne 0 ] && echo "ERROR: failed to cd to \"${ROOT_DIRECTORY}\": $?, aborting" && exit 1
for DIRECTORY in */
do
 if [[ ${GIT_PROJECT_FOLDERS_ONLY} -ne 0 && ! -d ${ROOT_DIRECTORY}/${DIRECTORY}/${GIT_DIRECTORY} ]]; then
  echo "skipping directory: \"${DIRECTORY%/}\"..."
  continue
 fi
 echo "processing directory: \"${DIRECTORY%/}\"..."

 cd ${ROOT_DIRECTORY}/${DIRECTORY}
 [ $? -ne 0 ] && echo "ERROR: failed to cd to \"${ROOT_DIRECTORY}/${DIRECTORY}\": $?, aborting" && exit 1

 ${SCRIPT}
 [ $? -ne 0 ] && echo "ERROR: failed to run \"$(basename ${SCRIPT})\": $?, aborting" && exit 1

 echo "processing directory \"${DIRECTORY%/}\"...DONE"
done

