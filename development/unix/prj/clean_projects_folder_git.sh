#!/bin/sh
# author:      Erik Sohns <eriksohns@123mail.org>
# this script cleans all git projects in the main project folder
# *NOTE*: it is neither portable nor particularly stable !
# parameters:   N/A
# return value: - 0 success, 1 failure

# sanity checks
command -v dirname >/dev/null 2>&1 || { echo "dirname is not installed, aborting" >&2; exit 1; }
command -v git >/dev/null 2>&1 || { echo "git is not installed, aborting" >&2; exit 1; }
command -v realpath >/dev/null 2>&1 || { echo "realpath is not installed, aborting" >&2; exit 1; }

DEFAULT_PROJECTS_ROOT_DIRECTORY="$(dirname $(realpath -e $0))/../../../.."
PROJECTS_DIRECTORY=${DEFAULT_PROJECTS_ROOT_DIRECTORY}
# sanity check(s)
[ ! -d ${PROJECTS_DIRECTORY} ] && echo "ERROR: invalid project directory (was: \"${PROJECTS_DIRECTORY}\"), aborting" && exit 1
#echo "DEBUG: projects directory: \"${PROJECTS_DIRECTORY}\""

cd $PROJECTS_DIRECTORY
[ $? -ne 0 ] && echo "ERROR: failed to cd to \"${PROJECTS_DIRECTORY}\": $?, aborting" && exit 1

GIT_DIRECTORY=".git"
for DIRECTORY in */
do
 [ ! -d ${PROJECTS_DIRECTORY}/${DIRECTORY}/${GIT_DIRECTORY} ] && continue
 echo "processing directory: \"${DIRECTORY%/}\"..."

 cd ${PROJECTS_DIRECTORY}/${DIRECTORY}
 [ $? -ne 0 ] && echo "ERROR: failed to cd to \"${CURRENT_DIRECTORY}\": $?, aborting" && exit 1

 echo "gc..."
 git gc --aggressive --auto >/dev/null 2>&1
 [ $? -ne 0 ] && echo "ERROR: failed to git gc: $?, aborting" && exit 1
 echo "gc...DONE"
 echo "reflog expire..."
 git reflog expire --expire=now --all >/dev/null 2>&1
 [ $? -ne 0 ] && echo "ERROR: failed to git reflog expire: $?, aborting" && exit 1
 echo "reflog expire...DONE"
 echo "repack..."
 git repack -ad --quiet >/dev/null 2>&1
 [ $? -ne 0 ] && echo "ERROR: failed to git repack: $?, aborting" && exit 1
 echo "repack...DONE"
 echo "gc (prune)..."
 git gc --aggressive --prune=now --quiet
 [ $? -ne 0 ] && echo "ERROR: failed to git gc --prune: $?, aborting" && exit 1
 echo "gc (prune)...DONE"

 echo "processing directory \"${DIRECTORY%/}\"...DONE"
done

