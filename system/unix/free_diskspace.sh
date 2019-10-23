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
command -v shopt >/dev/null 2>&1 || { echo "shopt is not installed, aborting" >&2; exit 1; }

DEFAULT_PROJECTS_ROOT_DIRECTORY="$(dirname $(realpath -e $0))/../../.."
PROJECTS_ROOT_DIRECTORY="${DEFAULT_PROJECTS_ROOT_DIRECTORY}"

# projects
clean_projects_folder.sh
echo "cleaned projects"

# profile
if [ -r ~/.ccache/ccache.conf ]; then
 cp -f ~/.ccache/ccache.conf ~/.ccache/ccache.conf.bak
fi
rm -rf ~/.ccache
mkdir ~/.ccache
if [ -r ~/ccache.conf.bak ]; then
 mv -f ~/ccache.conf.bak ~/.ccache/ccache.conf
fi
echo "cleaned profile"

# system
rm -rf /var/cache >/dev/null 2>&1
rm -rf /var/tmp >/dev/null 2>&1
echo "cleaned system"

df -h

