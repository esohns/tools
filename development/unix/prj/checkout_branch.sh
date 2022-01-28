#!/bin/sh
# author:      Erik Sohns <eriksohns@123mail.org>
# this script checks out a particular branch of a git project.
# *NOTE*: it is neither portable nor particularly stable !
# parameters: - project directory
#             - git branch
# return value: - 0 success, 1 failure

# sanity checks
command -v printenv >/dev/null 2>&1 || { echo "printenv is not installed, aborting" >&2; exit 1; }
command -v grep >/dev/null 2>&1 || { echo "grep is not installed, aborting" >&2; exit 1; }
command -v awk >/dev/null 2>&1 || { echo "awk is not installed, aborting" >&2; exit 1; }
command -v git >/dev/null 2>&1 || { echo "git is not installed, aborting" >&2; exit 1; }

if [ $# -lt 2 ]; then
 echo "ERROR: invalid parameters, aborting" && exit 1
fi
PROJECT="$1"
#echo "DEBUG: project: \"${PROJECT}\""
BRANCH="$2"
#echo "DEBUG: branch: \"${BRANCH}\""

LIB_ROOT="$(printenv | grep LIB_ROOT | awk '{split($0,a,"="); print a[2]}')"
# sanity check(s)
[ ! -d ${LIB_ROOT} ] && echo "ERROR: invalid LIB_ROOT directory (was: \"${LIB_ROOT}\"), aborting" && exit 1
#echo "DEBUG: LIB_ROOT directory: \"${LIB_ROOT}\""
# sanity checks
[ ! -d ${LIB_ROOT}/${PROJECT} ] && echo "ERROR: invalid project directory (was: \"${LIB_ROOT}/${PROJECT}\"), aborting" && exit 1

cd ${LIB_ROOT}/${PROJECT}
git checkout ${BRANCH}
[ $? -ne 0 ] && echo "ERROR: failed to git checkout ${BRANCH}, aborting" && exit 1
echo "checked out ${PROJECT}/${BRANCH}...DONE"

