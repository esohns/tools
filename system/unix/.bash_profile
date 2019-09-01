# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs
PATH="/mnt/win_d/projects/tools/system/unix:/mnt/win_d/projects/tools/development/unix/prj:$PATH"
export PATH

PRJ_ROOT=/mnt/win_d/projects
export PRJ_ROOT

LIB_ROOT=/run/media/$USER/USB_BLACK/lib
export LIB_ROOT

#ACE_ROOT=$LIB_ROOT/ACE_TAO/ACE
ACE_ROOT=/usr/local/src/ACE_wrappers
export ACE_ROOT
