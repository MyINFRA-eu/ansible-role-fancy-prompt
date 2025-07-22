#!/bin/bash

#####
#
# @name MyINFRA.eu ~ Fancy Aliases 1.0
# @version 2025.07.001
# @since 2025.07.001
#
# @copyright (c) 2025 (and beyond) - Dennis de Houx, All In One, One For The code
# @author Dennis de Houx <dennis@dehoux.be>
# @license https://creativecommons.org/licenses/by-nc-nd/4.0/deed.en CC BY-NC-ND 4.0
#
#####

################################################################################
##  ALIASES                                                                   ##
################################################################################

alias spico='sudo pico'
alias snano='sudo nano'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p'
alias ps='ps auxf'
alias less='less -R'
alias cls='clear'
alias apt-get='sudo apt-get'
alias multitail='multitail --no-repeat -c'

### Change directory aliases
alias home='cd ~'
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

### Remove a directory and all files
alias rmd='/bin/rm  --recursive --force --verbose '

### aliases for multiple directory listing commands
alias la='ls -Alh'                # show hidden files
alias ls='ls -aFh --color=always' # add colors and file type extensions
alias lx='ls -lXBh'               # sort by extension
alias lk='ls -lSrh'               # sort by size
alias lc='ls -ltcrh'              # sort by change time
alias lu='ls -lturh'              # sort by access time
alias lr='ls -lRh'                # recursive ls
alias lt='ls -ltrh'               # sort by date
alias lm='ls -alh |more'          # pipe through 'more'
alias lw='ls -xAh'                # wide listing format
alias ll='ls -Fls'                # long listing format
alias labc='ls -lap'              # alphabetical sort
alias lf="ls -l | egrep -v '^d'"  # files only
alias ldir="ls -l | egrep '^d'"   # directories only
alias lla='ls -Al'                # List and Hidden Files
alias las='ls -A'                 # Hidden Files
alias lls='ls -l'                 # List

### alias chmod commands
alias mx='chmod a+x'
alias 000='chmod -R 000'
alias 644='chmod -R 644'
alias 666='chmod -R 666'
alias 755='chmod -R 755'
alias 777='chmod -R 777'

### aliases to show disk space and space used in a folder
alias diskspace="du -S | sort -n -r |more"
alias folders='du -h --max-depth=1'
alias folderssort='find . -maxdepth 1 -type d -print0 | xargs -0 du -sk | sort -rn'
alias tree='tree -CAhF --dirsfirst'
alias treed='tree -CAFd'
alias mountedinfo='df -hT'

### aliases for archives
alias mktar='tar -cvf'
alias mkbz2='tar -cvjf'
alias mkgz='tar -cvzf'
alias untar='tar -xvf'
alias unbz2='tar -xvjf'
alias ungz='tar -xvzf'

### To have colors for ls and all grep commands such as grep, egrep and zgrep
export CLICOLOR=1
export export LS_COLORS='no=00:fi=00:di=00;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:*.xml=00;31:'
#export GREP_OPTIONS='--color=auto' #deprecated

### Color for manpages in less makes manpages a little easier to read
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

### Enable bash programmable completion features in interactive shells
if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
fi



################################################################################
##  SPECIAL FUNCTIONS                                                         ##
################################################################################

### Extracts any archive(s) (if unp isn't installed)
extract() {
        for archive in "$@"; do
                if [ -f "$archive" ]; then
                        case $archive in
                        *.tar.bz2) tar xvjf $archive ;;
                        *.tar.gz) tar xvzf $archive ;;
                        *.bz2) bunzip2 $archive ;;
                        *.rar) rar x $archive ;;
                        *.gz) gunzip $archive ;;
                        *.tar) tar xvf $archive ;;
                        *.tbz2) tar xvjf $archive ;;
                        *.tgz) tar xvzf $archive ;;
                        *.zip) unzip $archive ;;
                        *.Z) uncompress $archive ;;
                        *.7z) 7z x $archive ;;
                        *) echo "don't know how to extract '$archive'..." ;;
                        esac
                else
                        echo "'$archive' is not a valid file!"
                fi
        done
}

### Copy file with a progress bar
cpp() {
    set -e
    strace -q -ewrite cp -- "${1}" "${2}" 2>&1 |
    awk '{
        count += $NF
        if (count % 10 == 0) {
            percent = count / total_size * 100
            printf "%3d%% [", percent
            for (i=0;i<=percent;i++)
                printf "="
            printf ">"
            for (i=percent;i<100;i++)
                printf " "
            printf "]\r"
        }
    }
    END { print "" }' total_size="$(stat -c '%s' "${1}")" count=0
}

### Copy and go to the directory
cpg() {
        if [ -d "$2" ]; then
                cp "$1" "$2" && cd "$2"
        else
                cp "$1" "$2"
        fi
}

### Move and go to the directory
mvg() {
        if [ -d "$2" ]; then
                mv "$1" "$2" && cd "$2"
        else
                mv "$1" "$2"
        fi
}

### Create and go to the directory
mkdirg() {
        mkdir -p "$1"
        cd "$1"
}

### Goes up a specified number of directories  (i.e. up 4)
up() {
        local d=""
        limit=$1
        for ((i = 1; i <= limit; i++)); do
                d=$d/..
        done
        d=$(echo $d | sed 's/^\///')
        if [ -z "$d" ]; then
                d=..
        fi
        cd $d
}

### Automatically do an ls after each cd, z, or zoxide
cd ()
{
        if [ -n "$1" ]; then
                builtin cd "$@" && ls
        else
                builtin cd ~ && ls
        fi
}

### Returns the last 2 fields of the working directory
pwdtail() {
        pwd | awk -F/ '{nlast = NF -1;print $nlast"/"$NF}'
}

### IP address lookup
alias whatismyip="whatsmyip"
function whatsmyip () {
    # Internal IP Lookup.
    if command -v ip &> /dev/null; then
        echo -n "Internal IP: "
        ip addr show wlan0 | grep "inet " | awk '{print $2}' | cut -d/ -f1
    else
        echo -n "Internal IP: "
        ifconfig wlan0 | grep "inet " | awk '{print $2}'
    fi

    # External IP Lookup
    echo -n "External IP: "
    curl -s ifconfig.me
}

### Trim leading and trailing spaces (for scripts)
trim() {
        local var=$*
        var="${var#"${var%%[![:space:]]*}"}" # remove leading whitespace characters
        var="${var%"${var##*[![:space:]]}"}" # remove trailing whitespace characters
        echo -n "$var"
}
