RED='\033[1;31m'
GREEN='\033[1;32m'
CYAN='\033[1;36m'
YELLOW="\033[0;33m"
WHITE='\033[1;37m'
NOCOLOR='\033[0m'

ARCHURL="https://github.com/freefelt/YouType/raw/main/YouType.zip"
APPDESTINATION="/Applications"
ARCHFILENAME="/tmp/YouType.zip"
APPFILENAME="$APPDESTINATION/YouType.app"

#---------------------------------------------------------------------------------------------------

if test -d $APPFILENAME; then
    if [[ $NONINTERACTIVE != 1 ]]; then
        printf "${WHITE}YouType is already installed. Would you like to reinstall? ${CYAN}(y/n): "
        read REINSTALL
        if [[ $REINSTALL == "y" || $REINSTALL == "Y" ]]; then
            CONTINUE=1
            tput cuu 1; tput el;
        else
            CONTINUE=0
        fi
    else
        CONTINUE=0
        printf "${WHITE}YouType is already installed\n"
    fi
else
    CONTINUE=1
fi

if [[ $CONTINUE == 0 ]]; then
    exit
fi

printf "${CYAN}============================ Installing YouType =============================\n"

printf "${WHITE}- Downloading ${YELLOW}$ARCHURL ${RED}"
curl -fsSL -o $ARCHFILENAME $ARCHURL

if test -f $ARCHFILENAME; then
    printf "${GREEN}DONE\n"
    printf "${WHITE}- Unarchiving to ${YELLOW}$APPFILENAME "
    
    pkill -x YouType
    
    unzip -qq -o $ARCHFILENAME -d $APPDESTINATION
    if test -d $APPFILENAME; then
        printf "${GREEN}DONE\n"
        
        printf "${WHITE}- Removing ${YELLOW}com.apple.quarantine ${WHITE}attribute "
        if [[ $(xattr $APPFILENAME) = *com.apple.quarantine* ]]; then
        
            xattr -d com.apple.quarantine $APPFILENAME
            
            if [[ $(xattr $APPFILENAME) = *com.apple.quarantine* ]]; then
                printf "${RED}FAILED\n"
            else
                printf "${GREEN}DONE\n"
            fi
        else
            printf "${GREEN}NO\n"
        fi
            
        if [[ $NONINTERACTIVE != 1 ]]; then
#            printf "${NOCOLOR}Would you like to run YouType? (y/n): "
#            read RUN
#            if [[ $RUN == "y" || $RUN == "Y" ]]; then
#                open -a YouType
#            fi
            open -R $APPFILENAME
        fi
    else
        printf "${RED}FAILED\n"
    fi
    
    rm $ARCHFILENAME
fi

printf "${CYAN}=============================================================================\n"
