#!/bin/bash

#####
#
# @name MyINFRA.eu ~ Fancy Prompt 1.0
# @version 2025.07.001
# @since 2025.07.001
#
# @copyright (c) 2025 (and beyond) - Dennis de Houx, All In One, One For The code
# @author Dennis de Houx <dennis@dehoux.be>
# @license https://creativecommons.org/licenses/by-nc-nd/4.0/deed.en CC BY-NC-ND 4.0
#
#####

################################################################################
##  FUNCTIONS                                                                 ##
################################################################################

##
## ARRANGE $PWD AND STORE IT IN $NEW_PWD
## * The home directory (HOME) is replaced with a ~
## * The last pwdmaxlen characters of the PWD are displayed
## * Leading partial directory names are striped off
##  /home/me/stuff -> ~/stuff (if USER=me)
##  /usr/share/big_dir_name -> ../share/big_dir_name (if pwdmaxlen=20)
##
## Original source: WOLFMAN'S color bash promt
## https://wiki.chakralinux.org/index.php?title=Color_Bash_Prompt#Wolfman.27s
##

bash_prompt_command() {
    # How many characters of the $PWD should be kept
    local pwdmaxlen=25

    # Indicate that there has been dir truncation
    local trunc_symbol=".."

    # Store local dir
    local dir=${PWD##*/}

    # Which length to use
    pwdmaxlen=$(( ( pwdmaxlen < ${#dir} ) ? ${#dir} : pwdmaxlen ))

    NEW_PWD=${PWD/#$HOME/\~}

    local pwdoffset=$(( ${#NEW_PWD} - pwdmaxlen ))

    # Generate name
    if [ ${pwdoffset} -gt "0" ]; then
        NEW_PWD=${NEW_PWD:$pwdoffset:$pwdmaxlen}
        NEW_PWD=${trunc_symbol}/${NEW_PWD#*/}
    fi
}



##
## GENERATE A FORMAT SEQUENCE
##
format_font() {
    ## FIRST ARGUMENT TO RETURN FORMAT STRING
    local output=$1

    case $# in
        2)
            eval $output="'\[\033[0;${2}m\]'"
        ;;
        3)
            eval $output="'\[\033[0;${2};${3}m\]'"
        ;;
        4)
            eval $output="'\[\033[0;${2};${3};${4}m\]'"
        ;;
        *)
            eval $output="'\[\033[0m\]'"
        ;;
    esac
}



##
## COLORIZE BASH PROMT
##
bash_prompt() {

    ############################################################################
    ## COLOR CODES                                                            ##
    ## These can be used in the configuration below                           ##
    ############################################################################

    ## FONT EFFECT
    local      NONE='0'
    local      BOLD='1'
    local       DIM='2'
    local UNDERLINE='4'
    local     BLINK='5'
    local    INVERT='7'
    local    HIDDEN='8'

    ## COLORS
    local   DEFAULT='9'
    local     BLACK='0'
    local       RED='1'
    local     GREEN='2'
    local    YELLOW='3'
    local      BLUE='4'
    local   MAGENTA='5'
    local      CYAN='6'
    local    L_GRAY='7'
    local    D_GRAY='60'
    local     L_RED='61'
    local   L_GREEN='62'
    local  L_YELLOW='63'
    local    L_BLUE='64'
    local L_MAGENTA='65'
    local    L_CYAN='66'
    local     WHITE='67'

    ## TYPE
    local     RESET='0'
    local    EFFECT='0'
    local     COLOR='30'
    local        BG='40'

    ## 256 COLOR CODES
    local NO_FORMAT="\[\033[0m\]"
    local ORANGE_BOLD="\[\033[1;38;5;208m\]"
    local TOXIC_GREEN_BOLD="\[\033[1;38;5;118m\]"
    local RED_BOLD="\[\033[1;38;5;1m\]"
    local CYAN_BOLD="\[\033[1;38;5;87m\]"
    local BLACK_BOLD="\[\033[1;38;5;0m\]"
    local WHITE_BOLD="\[\033[1;38;5;15m\]"
    local GRAY_BOLD="\[\033[1;90m\]"
    local BLUE_BOLD="\[\033[1;38;5;74m\]"


    ############################################################################
    ## CONFIGURATION                                                          ##
    ## Choose your color combination here                                     ##
    ############################################################################
    local FONT_COLOR_1=$WHITE
    local BACKGROUND_1=$BLUE
    local TEXTEFFECT_1=$BOLD

    local FONT_COLOR_2=$WHITE
    local BACKGROUND_2=$L_BLUE
    local TEXTEFFECT_2=$BOLD

    local FONT_COLOR_3=$D_GRAY
    local BACKGROUND_3=$WHITE
    local TEXTEFFECT_3=$BOLD

    #local PROMT_FORMAT=$BLUE_BOLD
    local PROMT_FORMAT=$WHITE_BOLD


    ############################################################################
    ## EXAMPLE CONFIGURATIONS                                                 ##
    ## I use them for different hosts. Test them out ;)                       ##
    ############################################################################

    ## CONFIGURATION: User
    if [ "$USER" == "root" ]; then
        #FONT_COLOR_1=$WHITE; BACKGROUND_1=$RED; TEXTEFFECT_1=$BOLD
        FONT_COLOR_1=$WHITE; BACKGROUND_1=$RED; TEXTEFFECT_1=$BOLD
        FONT_COLOR_2=$WHITE; BACKGROUND_2=$BLUE; TEXTEFFECT_2=$BOLD
        FONT_COLOR_3=$WHITE; BACKGROUND_3=$CYAN; TEXTEFFECT_3=$BOLD
    else
        #FONT_COLOR_1=$WHITE; BACKGROUND_1=$BLUE; TEXTEFFECT_1=$BOLD
        FONT_COLOR_1=$WHITE; BACKGROUND_1=$GREEN; TEXTEFFECT_1=$BOLD
        FONT_COLOR_2=$WHITE; BACKGROUND_2=$BLUE; TEXTEFFECT_2=$BOLD
        FONT_COLOR_3=$WHITE; BACKGROUND_3=$CYAN; TEXTEFFECT_3=$BOLD
    fi

    ## CONFIGURATION: BLACK-RED
    #FONT_COLOR_1=$WHITE; BACKGROUND_1=$BLACK; TEXTEFFECT_1=$BOLD
    #FONT_COLOR_2=$WHITE; BACKGROUND_2=$D_GRAY; TEXTEFFECT_2=$BOLD
    #FONT_COLOR_3=$WHITE; BACKGROUND_3=$RED; TEXTEFFECT_3=$BOLD
    #PROMT_FORMAT=$RED_BOLD

    ## CONFIGURATION: RED-BLACK
    #FONT_COLOR_1=$WHITE; BACKGROUND_1=$RED; TEXTEFFECT_1=$BOLD
    #FONT_COLOR_2=$WHITE; BACKGROUND_2=$D_GRAY; TEXTEFFECT_2=$BOLD
    #FONT_COLOR_3=$WHITE; BACKGROUND_3=$BLACK; TEXTEFFECT_3=$BOLD
    #PROMT_FORMAT=$RED_BOLD

    ## CONFIGURATION: CYAN-BLUE
    #FONT_COLOR_1=$BLACK; BACKGROUND_1=$L_CYAN; TEXTEFFECT_1=$BOLD
    #FONT_COLOR_2=$WHITE; BACKGROUND_2=$L_BLUE; TEXTEFFECT_2=$BOLD
    #FONT_COLOR_3=$WHITE; BACKGROUND_3=$BLUE; TEXTEFFECT_3=$BOLD
    #PROMT_FORMAT=$CYAN_BOLD

    ## CONFIGURATION: MAGENTA-CYAN
    #FONT_COLOR_1=$BLACK; BACKGROUND_1=$L_MAGENTA; TEXTEFFECT_1=$BOLD
    #FONT_COLOR_2=$WHITE; BACKGROUND_2=$L_CYAN; TEXTEFFECT_2=$BOLD
    #FONT_COLOR_3=$WHITE; BACKGROUND_3=$CYAN; TEXTEFFECT_3=$BOLD
    #PROMT_FORMAT=$CYAN_BOLD

    ## CONFIGURATION: GRAY-SCALE
    #FONT_COLOR_1=$WHITE; BACKGROUND_1=$BLACK; TEXTEFFECT_1=$BOLD
    #FONT_COLOR_2=$WHITE; BACKGROUND_2=$D_GRAY; TEXTEFFECT_2=$BOLD
    #FONT_COLOR_3=$WHITE; BACKGROUND_3=$L_GRAY; TEXTEFFECT_3=$BOLD
    #PROMT_FORMAT=$BLACK_BOLD

    ## CONFIGURATION: GRAY-CYAN
    #FONT_COLOR_1=$WHITE; BACKGROUND_1=$BLACK; TEXTEFFECT_1=$BOLD
    #FONT_COLOR_2=$WHITE; BACKGROUND_2=$D_GRAY; TEXTEFFECT_2=$BOLD
    #FONT_COLOR_3=$BLACK; BACKGROUND_3=$L_CYAN; TEXTEFFECT_3=$BOLD
    #PROMT_FORMAT=$CYAN_BOLD


    ############################################################################
    ## TEXT FORMATING                                                         ##
    ## Generate the text formating according to configuration                 ##
    ############################################################################

    ## CONVERT CODES: add offset
    FC1=$(($FONT_COLOR_1+$COLOR))
    BG1=$(($BACKGROUND_1+$BG))
    FE1=$(($TEXTEFFECT_1+$EFFECT))

    FC2=$(($FONT_COLOR_2+$COLOR))
    BG2=$(($BACKGROUND_2+$BG))
    FE2=$(($TEXTEFFECT_2+$EFFECT))

    FC3=$(($FONT_COLOR_3+$COLOR))
    BG3=$(($BACKGROUND_3+$BG))
    FE3=$(($TEXTEFFECT_3+$EFFECT))

    FC4=$(($FONT_COLOR_4+$COLOR))
    BG4=$(($BACKGROUND_4+$BG))
    FE4=$(($TEXTEFFECT_4+$EFFECT))

    ## CALL FORMATING HELPER FUNCTION: effect + font color + BG color
    local TEXT_FORMAT_1
    local TEXT_FORMAT_2
    local TEXT_FORMAT_3
    local TEXT_FORMAT_4
    format_font TEXT_FORMAT_1 $FE1 $FC1 $BG1
    format_font TEXT_FORMAT_2 $FE2 $FC2 $BG2
    format_font TEXT_FORMAT_3 $FC3 $FE3 $BG3
    format_font TEXT_FORMAT_4 $FC4 $FE4 $BG4

    # GENERATE PROMT SECTIONS
    local PROMT_USER=$"$TEXT_FORMAT_1 \u "
    #local PROMT_HOST=$"$TEXT_FORMAT_2 \h "
    #local PROMT_HOST=$"$TEXT_FORMAT_2 \H "
    #local PROMT_HOST=$"$TEXT_FORMAT_2 $(hostname -f) "
    local PROMT_HOST=$"$TEXT_FORMAT_2 $(hostnamectl hostname --static) "
    local PROMT_PWD=$"$TEXT_FORMAT_3 \${NEW_PWD} "
    local PROMT_INPUT=$"$PROMT_FORMAT "


    ############################################################################
    ## SEPARATOR FORMATING                                                    ##
    ## Generate the separators between sections                               ##
    ## Uses background colors of the sections                                 ##
    ############################################################################

    ## CONVERT CODES
    TSFC1=$(($BACKGROUND_1+$COLOR))
    TSBG1=$(($BACKGROUND_2+$BG))

    TSFC2=$(($BACKGROUND_2+$COLOR))
    TSBG2=$(($BACKGROUND_3+$BG))

    TSFC3=$(($BACKGROUND_3+$COLOR))
    TSBG3=$(($DEFAULT+$BG))

    ## CALL FORMATING HELPER FUNCTION: effect + font color + BG color
    local SEPARATOR_FORMAT_1
    local SEPARATOR_FORMAT_2
    local SEPARATOR_FORMAT_3
    format_font SEPARATOR_FORMAT_1 $TSFC1 $TSBG1
    format_font SEPARATOR_FORMAT_2 $TSFC2 $TSBG2
    format_font SEPARATOR_FORMAT_3 $TSFC3 $TSBG3

    # GENERATE SEPARATORS WITH FANCY TRIANGLE OR ROUNDS
    local TRIANGLE=$'\uE0B0'
    #local ROUNDED=$'\u25D7'
    local ROUNDED=$''
    #local SEPARATOR_1=$SEPARATOR_FORMAT_1$TRIANGLE
    local SEPARATOR_1=$SEPARATOR_FORMAT_1$ROUNDED
    #local SEPARATOR_2=$SEPARATOR_FORMAT_2$TRIANGLE
    local SEPARATOR_2=$SEPARATOR_FORMAT_2$ROUNDED
    #local SEPARATOR_3=$SEPARATOR_FORMAT_3$TRIANGLE
    local SEPARATOR_3=$SEPARATOR_FORMAT_3$ROUNDED


    ############################################################################
    ## WINDOW TITLE                                                           ##
    ## Prevent messed up terminal-window titles                               ##
    ############################################################################
    case $TERM in
        xterm*|rxvt*)
            #local TITLEBAR='\[\033]0;\u@$(hostname -f):${NEW_PWD}\007\]'
            local TITLEBAR='\[\033]0;\u@$(hostnamectl hostname --static):${NEW_PWD}\007\]'
        ;;
        *)
            local TITLEBAR=""
        ;;
    esac


    ############################################################################
    ## BASH PROMT                                                             ##
    ## Generate promt and remove format from the rest                         ##
    ############################################################################
    PS1="$TITLEBAR\n${PROMT_USER}${SEPARATOR_1}${PROMT_HOST}${SEPARATOR_2}${PROMT_PWD}${SEPARATOR_3}${PROMT_INPUT}"

    ## For terminal line coloring, leaving the rest standard
    none="$(tput sgr0)"
    trap 'echo -ne "${none}"' DEBUG
}



################################################################################
##  MAIN                                                                      ##
################################################################################

## Bash provides an environment variable called PROMPT_COMMAND.
## The contents of this variable are executed as a regular Bash command
## just before Bash displays a prompt.
## We want it to call our own command to truncate PWD and store it in NEW_PWD
PROMPT_COMMAND=bash_prompt_command

## Call bash_promnt only once, then unset it (not needed any more)
## It will set $PS1 with colors and relative to $NEW_PWD,
## which gets updated by $PROMT_COMMAND on behalf of the terminal
bash_prompt
unset bash_prompt
