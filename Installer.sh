RED='\033[1;31m'
GREEN='\033[1;32m'
CYAN='\033[1;36m'
WHITE='\033[1;37m'
NOCOLOR='\033[0m'

printf "${CYAN}============================ Installing YouType =============================\n"

if [[ $(dirname "$0") == /opt/homebrew/Caskroom/youtype* ]]; then
    FROMHOMEBREW=1
    ARCHFILENAME="YouType.zip"
    APPDESTINATION="$(dirname "$0")"
else
    FROMHOMEBREW=0
    ARCHFILENAME="/tmp/YouType.zip"
    APPDESTINATION="/Applications"
fi
APPFILENAME="$APPDESTINATION/YouType.app"

printf "${WHITE}- Downloading ${RED}"
curl -fsSL -o $ARCHFILENAME 'https://github.com/freefelt/YouType/raw/main/YouType.zip'

if test -f $ARCHFILENAME; then
    printf "${GREEN}DONE\n"
    printf "${WHITE}- Unarchiving "
    
    unzip -qq -o $ARCHFILENAME -d $APPDESTINATION
    if test -d $APPFILENAME; then
        printf "${GREEN}DONE\n"
        
        rm $ARCHFILENAME
        if [[ $(xattr $APPFILENAME) = *com.apple.quarantine* ]]; then
            printf "${WHITE}- Removing com.apple.quarantine attribute\n"
            xattr -d com.apple.quarantine $APPFILENAME
        fi
        
        printf "${WHITE}- Removing com.apple.quarantine attribute\n"
        
#        if [[ $FROMHOMEBREW == 0 ]]; then
#            printf "${NOCOLOR}Would you like to run YouType? (y/n): "
#            read RUN
#            if [[ $RUN == "y" || $RUN == "Y" ]]; then
#                open -a YouType
#            fi
#        fi
        
        printf "${GREEN}  ** SUCCESS **\n"
    else
        printf "${RED}Can't unzip YouType\n"
    fi
fi

printf "${CYAN}=============================================================================\n"
