#!/bin/sh
# author:      Erik Sohns <erik.sohns@posteo.net>
# this script removes all precompiled header files from the projects directories
# *NOTE*: it is neither portable nor particularly stable !
# parameters:   - (UNIX) platform [linux|solaris]
# return value: - 0 success, 1 failure

# sanity checks
command -v dirname >/dev/null 2>&1 || { echo "dirname is not installed, aborting" >&2; exit 1; }
command -v readlink >/dev/null 2>&1 || { echo "readlink is not installed, aborting" >&2; exit 1; }

DEFAULT_BUILD_SUBDIR="cmake"
BUILD_SUBDIR=${DEFAULT_BUILD_SUBDIR}
if [ $# -lt 1 ]; then
 echo "INFO: using default build directory: \"${BUILD_SUBDIR}\""
else
 # parse any arguments
 if [ $# -ge 1 ]; then
  BUILD_SUBDIR="$1"
 fi
fi
#echo "DEBUG: build directory: \"${BUILD_SUBDIR}\""

DEFAULT_PROJECTS_DIRECTORY="$(dirname $(readlink -f $0))/../../../.."
PROJECTS_DIRECTORY=${DEFAULT_PROJECTS_DIRECTORY}
# sanity check(s)
[ ! -d ${PROJECTS_DIRECTORY} ] && echo "ERROR: invalid project directory (was: \"${PROJECT_DIRECTORY}\"), aborting" && exit 1
#echo "DEBUG: projects directory: \"${PROJECTS_DIRECTORY}\""

SUB_DIRECTORIES="Common
ACEStream
ACENetwork"
BUILD_SUB_DIRECTORIES="build/gcc
build/clang"
for DIRECTORY in $SUB_DIRECTORIES
do
 for DIRECTORY_2 in $BUILD_SUB_DIRECTORIES
 do
  CURRENT_DIRECTORY="${PROJECTS_DIRECTORY}/${DIRECTORY}/${DIRECTORY_2}"
  cd $CURRENT_DIRECTORY
  [ $? -ne 0 ] && echo "ERROR: failed to cd to \"${CURRENT_DIRECTORY}\": $?, aborting" && exit 1
  echo "DEBUG: processing: \"${DIRECTORY}/${DIRECTORY_2}\"..."

  find . -name "*.pch" -type f -print0 | tee /dev/fd/2 | xargs -0 rm -f
  [ $? -ne 0 ] && echo "ERROR: failed to find: $?, aborting" && exit 1
  find . -name "*.gch" -type f -print0 | tee /dev/fd/2 | xargs -0 rm -f
  [ $? -ne 0 ] && echo "ERROR: failed to find: $?, aborting" && exit 1
#  find . -name "stdafx.h" -type f -print0 | tee /dev/fd/2 | xargs -0 touch
 # [ $? -ne 0 ] && echo "ERROR: failed to find: $?, aborting" && exit 1

  echo "DEBUG: processing: \"${DIRECTORY}/${DIRECTORY_2}\"...DONE"
 done
done
