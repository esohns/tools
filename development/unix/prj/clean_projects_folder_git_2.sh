#!/bin/sh
# author:      Erik Sohns <eriksohns@123mail.org>
# this script cleans all git projects in the main project folder
# *NOTE*: it is neither portable nor particularly stable !
# parameters:   N/A
# return value: - 0 success, 1 failure

# sanity checks
command -v basename >/dev/null 2>&1 || { echo "basename is not installed, aborting" >&2; exit 1; }
command -v dirname >/dev/null 2>&1 || { echo "dirname is not installed, aborting" >&2; exit 1; }
command -v realpath >/dev/null 2>&1 || { echo "realpath is not installed, aborting" >&2; exit 1; }

RUN_IN_FOLDERS_SCRIPT="$(dirname $(realpath -e $0))/../../../tools/unix/run_in_folder.sh"
[ ! -x ${RUN_IN_FOLDERS_SCRIPT} ] && echo "ERROR: invalid 'run-in-folders' script (was: \"${RUN_IN_FOLDERS_SCRIPT}\"), aborting" && exit 1
echo "DEBUG: found 'run-in-folders' script: \"${RUN_IN_FOLDERS_SCRIPT}\""
CLEAN_GIT_PROJECT_SCRIPT="$(dirname $(realpath -e $0))/clean_git_project.sh"
[ ! -x ${CLEAN_GIT_PROJECT_SCRIPT} ] && echo "ERROR: invalid 'clean-git-project' script (was: \"${CLEAN_GIT_PROJECT_SCRIPT}\"), aborting" && exit 1
echo "DEBUG: found 'clean-git-project' script: \"${CLEAN_GIT_PROJECT_SCRIPT}\""

DEFAULT_PROJECTS_ROOT_DIRECTORY="$(realpath -e $(dirname $(realpath -e $0))/../../../..)"
PROJECTS_DIRECTORY=${DEFAULT_PROJECTS_ROOT_DIRECTORY}
# sanity check(s)
[ ! -d ${PROJECTS_DIRECTORY} ] && echo "ERROR: invalid projects root directory (was: \"${PROJECTS_DIRECTORY}\"), aborting" && exit 1
echo "DEBUG: projects root directory: \"${PROJECTS_DIRECTORY}\""

${RUN_IN_FOLDERS_SCRIPT} -g -s ${CLEAN_GIT_PROJECT_SCRIPT} -d ${PROJECTS_DIRECTORY}
[ $? -ne 0 ] && echo "ERROR: failed to $(basename ${RUN_IN_FOLDERS_SCRIPT}) ${CLEAN_GIT_PROJECT_SCRIPT} ${PROJECTS_DIRECTORY}: $?, aborting" && exit 1

