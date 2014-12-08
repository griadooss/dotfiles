  # ~/.bashrc                                              -*- coding: utf-8 -*-
  #-----------------------------------------------------------------------------
  # For Linux. TODO: make compatible with *BSD/non-GNU userland.
  #
  # Contains lots of stuff from various other .bashrc files found
  # on the web (especially on the Arch Linux forums :)).
  #
  # It is assumed that ~/.bash_profile is a symlink to ~/.bashrc, or at least
  # always sources it, so that this file is sourced by both login- and non-login
  # shells.
  #
  # This file is also intended for use with the root account, but many of the
  # the settings will be disabled then (in particular many aliases and
  # functions), since it's better to use a mostly standard setup as root.
  #-----------------------------------------------------------------------------

  # If not running interactively: exit immediately.
  # Note that 'return' works because the file is sourced, not executed.
  if [[ $- != *i* ]] || [ -z "$PS1" ]; then
    return 0
fi

#-----------------------------------------------------------------------------
# Special Variables
#-----------------------------------------------------------------------------
# This file has special settings for both Arch Linux and Debian distributions.
# Uncomment which one you use.  If you use neither, comment out both.
#__distribution="ArchLinux"
__distribution="Debian"    # also for derivates like Ubuntu

#-----------------------------------------------------------------------------
# Environment Variables
#-----------------------------------------------------------------------------
# Security: close root shells after n seconds of inactivity
[ "$UID" = 0 ] && export TMOUT=180

# PATH addons
# [ -d "$HOME/bin" ] && PATH="$HOME/bin:$PATH"
if [ "$UID" != 0 ]; then
    PATH="$PATH:/usr/local/bin:/usr/sbin:/sbin:/usr/local/sbin"
    [ -d "$HOME/opt/jdownloader/bin" ] && PATH="$PATH:$HOME/opt/jdownloader/bin"
fi
export PATH

# Pager and Editor
export PAGER="less"
export EDITOR="vim"
export VISUAL=$EDITOR
if [ "$UID" != 0 ]; then
    export XPAGER=$PAGER
    export XEDITOR="jedit"
fi

# virtualenv
#####################################

# added by me 23/11/2014 after installing 'vitrualenvwrapper'
# see: somononsoftware.com/virtualevn-tutorial-part-2/

export WORKON_HOME=$HOME/.virtualenvs
#export PROJECT_HOME=/media/dyndata/Repositories/git
#export VIRTUALENVWRAPPER_SCRIPT=/usr/local/bin/virtualenvwrapper.sh
source /usr/local/bin/virtualenvwrapper_lazy.sh

#####################################

# less
export LESS="-MWi -x4 --shift 5"
export LESSHISTFILE="-"     # no less history file
if [ "$UID" != 0 ]; then
    export LESSCHARSET="utf-8"
    if [ -z "$LESSOPEN" ]; then
        if [ "$__distribution" = "Debian" ]; then
            [ -x "`which lesspipe`" ] && eval "$(lesspipe)"
        else
            [ -x "`which lesspipe.sh`" ] && export LESSOPEN="|lesspipe.sh %s"
        fi
    fi
    # Yep, 'less' can colorize manpages
    export LESS_TERMCAP_mb=$'\E[01;31m'
    export LESS_TERMCAP_md=$'\E[01;31m'
    export LESS_TERMCAP_me=$'\E[0m'
    export LESS_TERMCAP_se=$'\E[0m'                           
    export LESS_TERMCAP_so=$'\E[01;44;33m'                                 
    export LESS_TERMCAP_ue=$'\E[0m'
    export LESS_TERMCAP_us=$'\E[01;32m'
fi

# Bash History
export HISTSIZE=5000
export HISTFILESIZE=5000
export HISTFILE="$HOME/.bash_history_${HOSTNAME}"
if [ "$UID" != 0 ]; then
    export HISTCONTROL="ignoreboth"   # ignores duplicate lines next to each other and lines with a leading space
    export HISTIGNORE="[bf]g:exit:logout"
fi

# ls and grep default options
LS_OPTIONS="-hFN --color=auto"
GREP_OPTIONS="-r -E --color=always"
if [ "$UID" = 0 ]; then
    LS_OPTIONS="-N --color=auto"
    GREP_OPTIONS=""
fi
export LS_OPTIONS GREP_OPTIONS

# dircolors
if [ -s "$HOME/.dircolors" ]; then
    eval "`dircolors -b $HOME/.dircolors`"
else
    eval "`dircolors -b`"
fi

# Browser
BROWSER="elinks"
if [ "$DISPLAY" ]; then
    export BROWSER="firefox"
fi
export BROWSER

# Java
if [ "$__distribution" = "Debian" ]; then
    export JAVA_HOME="/usr/lib/jvm/java-6-sun"
fi

#export MAIL="/var/spool/mail/$USER"
#export MAILCHECK=MAIL_CHECK=0

# ^d must be pressed twice to exit shell
export IGNOREEOF=1

#-----------------------------------------------------------------------------
# Prompts
#-----------------------------------------------------------------------------
set_prompts() {
    # regular colors
    local DEFAULT="\[\033[0m\]"   # standard terminal fg color
    local BLACK="\[\033[0;30m\]"
    local RED="\[\033[0;31m\]"
    local GREEN="\[\033[0;32m\]"
    local YELLOW="\[\033[0;33m\]"
    local BLUE="\[\033[0;34m\]"
    local MAGENTA="\[\033[0;35m\]"
    local CYAN="\[\033[0;36m\]"
    local WHITE="\[\033[0;37m\]"

    # emphasized/bold colors
    local EM_BLACK="\[\033[1;30m\]"
    local EM_RED="\[\033[1;31m\]"
    local EM_GREEN="\[\033[1;32m\]"
    local EM_YELLOW="\[\033[1;33m\]"
    local EM_BLUE="\[\033[1;34m\]"
    local EM_MAGENTA="\[\033[1;35m\]"
    local EM_CYAN="\[\033[1;36m\]"
    local EM_WHITE="\[\033[1;37m\]"

    # background colors
    local BG_BLACK="\[\033[40m\]"
    local BG_RED="\[\033[41m\]"
    local BG_GREEN="\[\033[42m\]"
    local BG_YELLOW="\[\033[43m\]"
    local BG_BLUE="\[\033[44m\]"
    local BG_MAGENTA="\[\033[45m\]"
    local BG_CYAN="\[\033[46m\]"
    local BG_WHITE="\[\033[47m\]"

    # Default prompts
    #PS1="${EM_BLACK}"'$?'"${EM_BLACK}(${EM_BLUE}\u${EM_BLACK}@${EM_CYAN}\h ${EM_WHITE}\w${EM_BLACK})${EM_BLUE}\$${DEFAULT} "
    #PS1="\!,\l,\$?\$ "
    #PS1='\[\e[0;36m\]Che mi venisse un colpo!\[\e[1;37m\]\n\[\e[0;36m\]└─\[\e[1;32m\][\A]\[\e[0m\]\$ '
    #PS1="\[\e[0;36m\]Che mi venisse un colpo!\[\e[0;37m\]\n\[\e[0;36m\]└─\[\e[1;32m\][\A]⧐ \[\e[0;34m\]{\W}\[\e[0m\]\$   "
    PS1="\[\e[0;36m\]Pensano sempre ai fatti loro!\[\e[0;37m\]\n\[\e[0;36m\]└─\[\e[1;32m\][\!:\#]⧐⧐  \[\e[0;34m\]{\W}\[\e[0m\] \$ "
    PS2="${EM_BLUE}>${DEFAULT} "
    PS3=$PS2
    PS4="${EM_BLUE}+${DEFAULT} "

    # Special red-colored prompts for root
    if [ "$UID" = 0 ]; then
        #PS1="${EM_BLACK}"'$?'"${EM_BLACK}(${EM_RED}\u${EM_BLACK}@${EM_CYAN}\h ${EM_RED}\w${EM_BLACK})${EM_RED}\$${DEFAULT} "
        #PS1="\[\e[1;31m\]SuPeRuSeR has control! Measure twice cut once!\[\e[0;37m\]\n\[\e[0;36m\]└─\[\e[1;32m\][\!:\#] \[e\[1;34m\]{\W}\[\e[0m\] \$  "
        PS1="\[\e[1;31m\]SuPeRuSeR has control! Measure twice cut once!\[\e[0;37m\]\n\[\e[0;36m\]└─\[\e[1;32m\][\!:\#]\[\e[4;35m\]        \[\e[0;34m\]{\W}\[\e[0m\] \$  "
        PS2="${EM_RED}>${DEFAULT} "
        PS3=$PS2
        PS4="${EM_RED}+${DEFAULT} "
    fi

    # Special prompt for Debian: Include variable identifying the chroot you work in in the prompt
    # (copied from default Debian .bashrc file, never actually tested)
    #if [ -z "$debian_chroot" ] && [ -r "/etc/debian_chroot" ]; then
    #    export debian_chroot=`cat /etc/debian_chroot`
    #    PS1="${debian_chroot:+($debian_chroot)}${PS1}"
    #     PS1="\[\e[1;31m\]SuPeRuSeR has control! Measure twice cut once!\[\e[0;37m\]\n\[\e[0;36m\]└─\[\e[1;32m\][\!:\#]⧐⧐ \[\e[1;34m\]{\W}\[\e[0m\] \$  "
    #fi

    export PS1 PS2 PS3 PS4
}
set_prompts
unset -f set_prompts

#-----------------------------------------------------------------------------
# Misc Settings
#-----------------------------------------------------------------------------
setterm -blength 0
set bell-style visible

mesg n
umask 022

if tty -s; then
    stty -ixon
    stty -ixoff
fi

shopt -s cmdhist      \
         dotglob      \
         extglob      \
         histappend   \
         cdable_vars  \
         checkwinsize

# Added by me 04/12/2014
# Sets shell editor mode from the default emacs to that of vi
set -o vi

# Whenever displaying the prompt, write the previous line to disk
PROMPT_COMMAND='history -a'

if [ "$UID" != 0 ]; then
    shopt -s cdspell    \
             nocaseglob

    #shopt -u mailwarn

    set -o notify

    ulimit -S -c 0   # cf. 'man bash', not 'man ulimit'

    # Enable bash completion
    complete -cf sudo
    complete -cf which
    complete -cf man
    if [ -r /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

#-----------------------------------------------------------------------------
# Aliases + Functions
#-----------------------------------------------------------------------------
alias ls="ls $LS_OPTIONS"
alias l="ls -l"
alias ll="ls -l"
alias la="ls -lA"
alias lh="ls -lh"
alias lah="ls -lAh"
alias laf="ls -laF"
alias p="$PAGER"
alias e="$EDITOR"
alias vi="$EDITOR"       # it has become such a habit to type vi...
alias nano="nano -w"

# root stops parsing this file here!
if [ "$UID" = 0 ]; then
    return 0
fi


# ------------- The rest of the file is for NON-root user only! --------------


if [ "$DISPLAY" ]; then
    alias p="$XPAGER"
    alias e="$XEDITOR"
fi

# That's what I call directory navigation! (function 'cdpushd' defined below)
alias cd="cdpushd >/dev/null"
alias b="popd >/dev/null"

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

# Entered by me Dec 2014 as shortcuts to repositories
 alias rep="cd /media/dyndata/Repositories/git/"
 alias plug="cd /home/griadooss/.virtualenvs/venv1/lib/python2.7/site-packages/"

alias cp="cp -i"   # prompt before overwriting
alias mv="mv -i"   # prompt before overwriting
#alias rm="rm -i"  # prompt before deleting
alias mkdir="mkdir -p"
alias co="chown"
alias cm="chmod"
alias grep="grep $GREP_OPTIONS"
alias g="grep -i"
alias h="history"
alias hg="history | grep"
alias df="df -hT"
alias du="du -hsc"
alias free="free -m"
alias ps="ps -efH"
alias psr="ps -U root -u root u"
alias top="htop"
alias m="mount | column -t 2>/dev/null"
alias f="find | grep"       # quick search in current directory, recursive
alias path='echo -e ${PATH//:/\\n}'
alias dirs="dirs -v"
alias jobs="jobs -l"

alias s="sudo"
#alias ss="sudo -s"         # sudo shell
alias ss="sudo -i"          # sudo login shell

alias openports="netstat -nape --inet"
alias myip="curl www.whatismyip.org"
alias ping="ping -c 10"
alias ns="netstat -alnp --protocol=inet | grep -v CLOSE_WAIT | cut -c-6,21-94 | tail +2"
alias ns2="sudo watch -n 3 -d -t netstat -vantp"
alias scp="scp -pr"
alias wget="wget -c"

alias startx="exec startx"   # ensures that no shell is open when X exits
alias dosbox="dosbox -conf $HOME/.dosboxrc"
alias clam="clamscan --bell -i"
alias jdownloader="java -jar $HOME/opt/jdownloader/bin/JDownloader.jar"
alias mp="mplayer"
alias cdt="eject -T"     # CD tray open/close
alias ncmpc="ncmpc -c"   # enable colors
#alias brand="growisofs -Z /dev/dvd -v -l -R -J -joliet-long"
alias calc='python -ic "from math import *; from random import *"'

alias resetresolution="xrandr --size 1680x1050"
#alias resetgamma="nvidia-settings --assign RedGamma=1.0 --assign BlueGamma=1.0 --assign GreenGamma=1.0"
alias resetgamma="xgamma -gamma 1.0"

alias mute="amixer -q set Front toggle"
alias unmute="mute"

# Windows/DOS compatibility :)
alias cls="clear"
alias ipconfig="ifconfig"
#alias chdir="cd"
#alias dir="ls -l"
#alias copy="cp"
#alias xcopy="cp -r"
#alias move="mv"
#alias ren="mv"
#alias del="rm"
#alias deltree="rm -r"
#alias md="mkdir -p"
#alias rd="rmdir"
#alias mem="free -m"

# Colorize these commands if possible
if which grc &>/dev/null; then
    alias .cl='grc -es --colour=auto'
    alias configure='.cl ./configure'
    alias diff='.cl diff'
    alias make='.cl make'
    alias gcc='.cl gcc'
    alias g++='.cl g++'
    #alias as='.cl as'
    #alias gas='.cl gas'
    alias ld='.cl ld'
    alias netstat='.cl netstat'
    alias ping='.cl ping -c 10'
    alias traceroute='.cl traceroute'
fi

# Distribution specific stuff - package management related
case "$__distribution" in
    ArchLinux)
        alias ,="pacman"
        alias ,l="pacman -Q"         # list all installed pkgs
        alias ,ll="pacman -Ql"       # list contents of 
        alias ,o="pacman -Qo"        # show which installed pkg  belongs to
        alias ,?="pacman -Si"        # show info about 
        alias ,??="pacman -Qi"       # show info about 
        alias ,s="pacsearch"         # search for    (function is defined below)
        alias ,u="sudo pacman -Sy"   # synchronize/update pkg database
        alias ,uu="sudo pacman -Syu" # system upgrade
        alias ,i="sudo pacman -S"    # install 
        alias ,ii="sudo pacman -U"   # install 
        alias ,r="sudo pacman -Rs"   # remove  + unused dependencies, but leave .pacsave backups
        alias ,p="sudo pacman -Rns"  # remove  + unused dependencies

        # :D
        alias icanhas="sudo pacman -S"
        alias donotwant="sudo pacman -Rs"

        # yaourt should not be run as root; it will ask for root pw if necessary
        alias ,,="yaourt"
        alias ,,l="yaourt -Q"
        alias ,,ll="yaourt -Ql"
        alias ,,o="yaourt -Qo"
        alias ,,?="yaourt -Si"
        alias ,,??="yaourt -Qi"
        alias ,,s="yaourt -Ss"
        alias ,,u="yaourt -Sy"
        alias ,,uu="yaourt -Syu --aur"   # also upgrade AUR pkgs
        alias ,,i="yaourt -S"
        alias ,,ii="yaourt -U"
        alias ,,r="yaourt -Rs"
        alias ,,p="yaourt -Rns"
        alias ,,g="yaourt -G"    # retrieve PKGBUILD and sources for  - works with all repositories and AUR

        # Normal pacman search with color output
        # Usage: pacsearch 
        pacsearch() {
            echo -e "$(pacman -Ss $@ | sed \
            -e 's#core/.*#\\033[1;31m&\\033[0;37m#g' \
            -e 's#extra/.*#\\033[0;32m&\\033[0;37m#g' \
            -e 's#community/.*#\\033[1;35m&\\033[0;37m#g' \
            -e 's#^.*/.* [0-9].*#\\033[0;36m&\\033[0;37m#g' )"
        }
    ;;
    Debian)
        alias ,="aptitude"
        alias ,,="apt-get"
        alias ,,,="dpkg"
        alias ,l="dpkg -l"
        alias ,ll="dpkg -L"
        alias ,o="dpkg -S"
        alias ,?="aptitude show"
        alias ,??="dpkg -p"
        alias ,s="aptitude search"
        alias ,u="sudo aptitude update"
        alias ,uu="sudo aptitude update && sudo aptitude safe-upgrade"
        alias ,uuu="sudo aptitude update && sudo aptitude full-upgrade"
        alias ,i="sudo aptitude install"
        alias ,ii="sudo dpkg -i"
        alias ,r="sudo aptitude remove"
        alias ,p="sudo aptitude purge"

        # :D
        alias icanhas="sudo aptitude install"
        alias donotwant="sudo aptitude remove"

        # Lists all installed packages that can be configured via "dpkg-reconfigure "
        # (It lists only those that ask questions. Technically, every package can be reconfigured)
        # Usage: debian_listreconfigurable
        debian_listreconfigurable() {
    	    ls /var/lib/dpkg/info/*.templates | xargs -n 1 basename | sed -e "s/.templates$//"
        }
    
        # Prompts to purge all packages that were deleted but still have their configuration files left
        # Usage: debian_purge
        debian_purge() {
    	    local pkgs="`dpkg -l | grep ^rc | cut -d' ' -f3`"
    	    if [ ! -z "$pkgs" ]; then
    	        echo "The following packages are removed but their configuration files are still there:"
    	        echo "$pkgs"
    	        echo -n "Remove them completely? [Y/n] "
    	        read -n 1 choice
    	        if [ -z "$choice" ] || [ "$choice" = "y" ] || [ "$choice" = "Y" ]; then
    	    	    echo "$pkgs" | xargs sudo aptitude purge
    	        fi
    	    else
    	        echo "No packages need to be purged."
    	    fi
        }
    ;;
esac

# This makes pushd behave like cd when no argument is passed
cdpushd() {
    if [ -n "$1" ]; then
        pushd "$*"
    else
        if [ "`pwd`" != "$HOME" ]; then
            pushd ~
        fi
    fi
}

# Simple backup copy of files/directories
# Usage: bak 
bak() {
    bakdir="$HOME/.backup"

    [ ! -d "$bakdir" ] && mkdir -p -m 700 "$bakdir"

    for f in "$@"; do
        f="`echo "$f" | sed 's!/\+$!!'`"   # strip trailing slashes
        command cp -ai "$f" "$HOME/.backup/$f.bak`date +'%Y%m%d%H%M'`"
    done
}

# Run command detached from terminal and without output
# Usage: nh 
nh() {
    nohup "$@" &>/dev/null &
}

# Creates the directory and copies/moves the file into it, in one step
# Usage: cpd/mvd  
cpd() {
    [ ! -d "$2" ] && mkdir -p "$2"
    cp "$1" "$2"
}
mvd() {
    [ ! -d "$2" ] && mkdir -p "$2"
    mv "$1" "$2"
}

# GNU screen wrapper function
# Usage: 'screen' lists screen sessions, otherwise
#        'screen ' reattaches to , otherwise
#        'screen ' creates a new session 
screen() {
    if ! which screen &>/dev/null; then
        echo "${FUNCNAME[0]}(): You must install 'screen' first."
        return 1
    fi

    if [ "$1" ]; then
        command screen -D -R -a -A -S $HOSTNAME.$1
    else
        command screen -ls
        echo "To reattach a running session, type 'screen '"
    fi
}

# Creates an archive from given directory
mktar() { tar cvf  "${1%%/}.tar"     "${1%%/}/"; }
mktgz() { tar cvzf "${1%%/}.tar.gz"  "${1%%/}/"; }
mktbz() { tar cvjf "${1%%/}.tar.bz2" "${1%%/}/"; }

# Extract an archive (subdir will be made if the archive may contain multiple files)
# TODO: find/write better solution, this is kinda ugly.
# Usage: x 
x() {
    for prog in uncompress tar 7za unzip unrar unace tar gunzip bunzip2; do
        if ! which $prog &>/dev/null; then
            echo "${FUNCNAME[0]}(): Warning: Can't find program '$prog'."
        fi
    done

    local is_tgz=0
    local is_tbz2=0
    local n=""

    local ext="${1##*.}"
    local ext_lc="`echo $ext | tr [:upper:] [:lower:]`"

    # For .tar.gz and .tar.bz2, strip "both extensions", otherwise just strip one
    case "$1" in
        *.tar.gz)  n="`echo "$1" | sed 's/\.tar\..\+$//'`"; is_tgz=1  ;;
        *.tar.bz2) n="`echo "$1" | sed 's/\.tar\..\+$//'`"; is_tbz2=1 ;;
        *)         n="${1%.*}"
    esac

    case "$ext_lc" in
        z)        uncompress "$1" ;;
        tar)      mkdir "$n"; mv "$1" "$n"; cd "$n"; tar xvf "$1" ; mv "$1" ..; cd .. ;;
        7z)       mkdir "$n"; mv "$1" "$n"; cd "$n"; 7za x "$1"   ; mv "$1" ..; cd .. ;;
        zip)      mkdir "$n"; mv "$1" "$n"; cd "$n"; unzip "$1"   ; mv "$1" ..; cd .. ;;
        rar)      mkdir "$n"; mv "$1" "$n"; cd "$n"; unrar x "$1" ; mv "$1" ..; cd .. ;;
        ace)      mkdir "$n"; mv "$1" "$n"; cd "$n"; unace x "$1" ; mv "$1" ..; cd .. ;;
        tgz)      mkdir "$n"; mv "$1" "$n"; cd "$n"; tar xvzf "$1"; mv "$1" ..; cd .. ;;
        tbz|tbz2) mkdir "$n"; mv "$1" "$n"; cd "$n"; tar xvjf "$1"; mv "$1" ..; cd .. ;;
        gz)
            if [ $is_tgz ]; then
                mkdir "$n"; mv "$1" "$n"; cd "$n"; tar xvzf "$1"; mv "$1" ..; cd ..
            else
                gunzip "$1"
            fi ;;
        bz2)
            if [ $is_tbz2 ]; then
                mkdir "$n"; mv "$1" "$n"; cd "$n"; tar xvjf "$1"; mv "$1" ..; cd ..
            else
                bunzip2 "$1"
            fi ;;
        *) echo "${FUNCNAME[0]}(): Can't extract: unknown file extension $ext"; return 1
    esac
}

# Set permissions to "standard" values (644/755), recursive
# Usage: resetp 
resetp() {
    chmod -R u=rwX,go=rX "$@"
}

# Simple reminder (must leave shell open!)
# Usage:   remindme  
# Example: remindme 10m "omg, the pizza"
remindme() {
    if which zenity &>/dev/null; then
        echo "${FUNCNAME[0]}(): You must install 'zenity' first."
        return 1
    fi

    sleep "$1" && zenity --info --text "$2" &
}

# Takes a screenshot
# Usage: screenshot [seconds delay] [quality]
screenshot() {
    if ! which scrot &>/dev/null; then
        echo "${FUNCNAME[0]}(): You must install 'scrot' first."
        return 1
    fi

    local delay=1
    local quality=95

    [ "$1" ] && delay="$1"
    [ "$2" ] && quality="$2"

    scrot -q $quality -d $delay "$HOME/screenshot_`date +'%F'`.jpg"
}

# Change to specified pkg's documentation dir and display the files
# Usage: doc 
doc() {
    pushd "/usr/share/doc/$1" && ls
}

#-----------------------------------------------------------------------------
# "Autostart" Section
#-----------------------------------------------------------------------------
# Display some system info
#echo -e "\nuptime: `uptime | cut -b 14-27`"
#echo -e "\nlast:"
#last -3 | head -n $(expr $(last -3 | wc -l) - 2)

# fortune is fun
if which fortune &>/dev/null; then
    echo -e "\n------------------------------------------------------------------------------\n"
    fortune -a
    echo -e "\n------------------------------------------------------------------------------\n"
fi

# Start X11 automatically if in tty1
if [ -z "$DISPLAY" ]; then
    tty="`tty`"
    for t in "/dev/vc/1" "vc/1" "/dev/tty1" "tty1"; do
        if [ "$tty" = "$t" ]; then
            n=2
            echo "Starting X11 in $n seconds ... Ctrl+C to abort ..."
            echo
            sleep $n
            exec startx
        fi
    done
fi

#-----------------------------------------------------------------------------
#vim: set fenc=utf-8 ft=sh sts=4 sw=4 ts=4 et :

function today {
    echo "Today's date is:"
    date +"%A, %B %-d, %Y"
}
