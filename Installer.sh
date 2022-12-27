RED='\033[1;31m'
GREEN='\033[1;32m'
CYAN='\033[1;36m'
WHITE='\033[1;37m'
NOCOLOR='\033[0m'

if [[ $(dirname "$0") == /opt/homebrew/Caskroom/youtype* ]]; then
    FROMHOMEBREW=1
    APPDESTINATION="$(dirname "$0")"
else
    FROMHOMEBREW=0
    APPDESTINATION="/Applications"
fi
ARCHFILENAME="/tmp/YouType.zip"
APPFILENAME="$APPDESTINATION/YouType.app"

#---------------------------------------------------------------------------------------------------

printf "${CYAN}============================ Installing YouType =============================\n"

if test -d $APPFILENAME; then
    printf "${WHITE}YouType is already installed. Would you like to reinstall? (y/n): "
    read REINSTALL
    if [[ $REINSTALL == "y" || $REINSTALL == "Y" ]]; then
        CONTINUE=1
        tput cuu 1; tput el;
    else
        CONTINUE=0
    fi
else
    CONTINUE=1
fi

if [[ $CONTINUE == 0 ]]; then
    printf "${CYAN}=============================================================================\n"
    exit
fi

printf "${WHITE}- Downloading ${RED}"
curl -fsSL -o $ARCHFILENAME 'https://github.com/freefelt/YouType/raw/main/YouType.zip'

if test -f $ARCHFILENAME; then
    printf "${GREEN}DONE\n"
    printf "${WHITE}- Unarchiving "
    
    pkill -x YouType
    
    unzip -qq -o $ARCHFILENAME -d $APPDESTINATION
    if test -d $APPFILENAME; then
        printf "${GREEN}DONE\n"
        
        if [[ $(xattr $APPFILENAME) = *com.apple.quarantine* ]]; then
            printf "${WHITE}- Removing com.apple.quarantine attribute\n"
            xattr -d com.apple.quarantine $APPFILENAME
        fi
        
        if [[ $FROMHOMEBREW == 0 ]]; then
            open -R $APPFILENAME
        fi
    else
        printf "${RED}FAILED\n"
    fi
    
    rm $ARCHFILENAME
fi

if test -d $APPFILENAME; then
    printf "${GREEN}  ** SUCCESS **\n"
else
    printf "${RED}  ** FAIL **\n"
fi

printf "${CYAN}=============================================================================\n"
