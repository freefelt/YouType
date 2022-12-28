RED='\033[1;31m'
GREEN='\033[1;32m'
CYAN='\033[1;36m'
YELLOW="\033[0;33m"
WHITE='\033[1;37m'
NOCOLOR='\033[0m'

APPFILENAME="/Applications/YouType.app"
PLISTFILENAME="$(echo ~)/Library/Preferences/com.AVKorotkov.YouType.plist"
CACHEPATH="$(echo ~)/Library/Caches/com.AVKorotkov.YouType"

#---------------------------------------------------------------------------------------------------

if test -d $APPFILENAME; then
    if [[ $NONINTERACTIVE != 1 ]]; then
        printf "${WHITE}Are you sure you want to uninstall YouType? ${CYAN}(y/n): "
        read UNINSTALL
        if [[ $UNINSTALL == "y" || $UNINSTALL == "Y" ]]; then
            CONTINUE=1
            tput cuu 1; tput el;
        else
            CONTINUE=0
        fi
    else
        CONTINUE=1
    fi
else
    CONTINUE=0
    printf "${WHITE}YouType is not installed\n"
fi

if [[ $CONTINUE == 0 ]]; then
    exit
fi

printf "${CYAN}=========================== Uninstalling YouType ============================\n"

printf "${WHITE}- Removing ${YELLOW}$APPFILENAME "
if test -d $APPFILENAME; then
    pkill -x YouType
    rm -r $APPFILENAME
    if test -d $APPFILENAME; then
        printf "${RED}FAILED\n"
    else
        printf "${GREEN}DONE\n"
    fi
else
    printf "${GREEN}NO\n"
fi

printf "${WHITE}- Removing ${YELLOW}$PLISTFILENAME "
if test -f $PLISTFILENAME; then
    rm $PLISTFILENAME
    if test -f $PLISTFILENAME; then
        printf "${RED}FAILED\n"
    else
        printf "${GREEN}DONE\n"
    fi
else
    printf "${GREEN}NO\n"
fi

printf "${WHITE}- Removing ${YELLOW}$CACHEPATH "
if test -d $CACHEPATH; then
    rm -r $CACHEPATH
    if test -d $CACHEPATH; then
        printf "${RED}FAILED\n"
    else
        printf "${GREEN}DONE\n"
    fi
else
    printf "${GREEN}NO\n"
fi

printf "${CYAN}=============================================================================\n"
