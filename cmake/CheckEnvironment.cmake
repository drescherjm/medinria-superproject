# This file checks that all dependencies are met, and it necessary sets up a few
# things, like adding the github.com signature to known_hosts.

# Assume Unix by default
set(HOME_PATH $ENV{HOME})

if (WIN32)
	# Check for Visual Studio 2010
	if (NOT MSVC10)
		message( SEND_ERROR "MedInria can only be compiled with Visual Studio 2010 at this time." )
	endif()

	# Check for DirectX SDK (for VTK)
	if ( NOT EXISTS "C:/Program Files (x86)/Microsoft DirectX SDK*" AND
		 NOT EXISTS "C:/Program Files/Microsoft DirectX SDK*")
		message( SEND_ERROR "You need to install Microsoft DirectX SDK : http://www.microsoft.com/en-us/download/details.aspx?id=6812" )
	endif()

	# GitBash
	find_program(BASH_BIN NAMES bash bash.exe)
	if (NOT BASH_BIN)
		message( SEND_ERROR "You need to install GitBash and add it to the PATH environment variable." )
	endif()
	
	set(HOME_PATH $ENV{HOMEPATH})
endif()

# Git
find_program(GIT_BIN NAMES git git.exe)
if (NOT GIT_BIN)
	message( SEND_ERROR "You need to install Git and add it to the PATH environment variable." )
endif()

# Subversion
find_program(SVN_BIN NAMES svn svn.exe)
if (NOT SVN_BIN)
	message( SEND_ERROR "You need to install Subversion and add it to the PATH environment variable." )
endif()

# Python
find_program(PYTHON_BIN NAMES python python.exe)
if (NOT PYTHON_BIN)
	message( SEND_ERROR "You need to install Python and add it to the PATH environment variable." )
endif()

# Perl
find_program(PERL_BIN NAMES perl perl.exe)
if (NOT PERL_BIN)
	message( SEND_ERROR "You need to install Perl and add it to the PATH environment variable." )
endif()

# Add github.com's SSH signature to the .ssh/known_hosts file
set(GITHUB_SIGN "github.com,207.97.227.239 ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==")
set(SSH_KNOWN_HOSTS_PATH ${HOME_PATH}/.ssh/known_hosts)
file(STRINGS ${SSH_KNOWN_HOSTS_PATH} KNOWN_HOSTS REGEX github\\.com)
list(LENGTH KNOWN_HOSTS N)
set (INDEX 0)
while(INDEX LESS N)
	list(GET KNOWN_HOSTS ${INDEX} KNOWN_HOST)
	string(STRIP ${KNOWN_HOST} KNOWN_HOST)
	string(COMPARE EQUAL ${KNOWN_HOST} ${GITHUB_SIGN} GITHUB_FOUND)
	if (GITHUB_FOUND)
		message(STATUS "Found Github's SSH signature in ${SSH_KNOWN_HOSTS_PATH}")
		break()
	endif()
	math( EXPR INDEX "${INDEX} + 1" )
endwhile()

if ( NOT GITHUB_FOUND)
	message( STATUS "Could not find Github's SSH signature, appending to ${SSH_KNOWN_HOSTS_PATH}..." )
	file(APPEND ${SSH_KNOWN_HOSTS_PATH} "\n${GITHUB_SIGN}\n")
endif()
