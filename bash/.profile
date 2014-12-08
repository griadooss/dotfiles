# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so that it includes path to course material for the Coursera MOOC Hardare/Software Interface
if [ -d "$HOME/course-materials/tools" ] ; then
  PATH="$HOME/course-materilas/tools:$PATH"
fi

# the following PATH extention added by me when installing the COURSERA course "Algorithms, Part1" which requires coding in JAVA
# I elected to install their IDE DrJava
#if [ -d "$HOME/algs4/bin" ] ; then
#    PATH="$HOME/algs4/bin:$PATH"
#fi

