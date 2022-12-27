echo "============= Downloading YouType ============="
curl -fsSL -o YouType.zip 'https://github.com/freefelt/YouType/raw/main/YouType.zip'

echo "Base dir: $(dirname "$0")"

if test -f "YouType.zip"; then
    echo "============= Installing YouType ============="
    if [[ $(dirname "$0") == /opt/homebrew/Caskroom/youtype* ]]; then
        APPDESTINATION=""
    else
        APPDESTINATION="/Applications/"
    fi
    APPFILENAME="${APPDESTINATION}YouType.app"
    
    unzip -qq -o YouType.zip -d "$APPDESTINATION"
    if test -d "$APPFILENAME"; then
        rm YouType.zip
        if [[ $(xattr "$APPFILENAME") = *com.apple.quarantine* ]]; then
        echo "============= Removing com.apple.quarantine attribute ============="
            xattr -d com.apple.quarantine "$APPFILENAME"
        fi
        
        echo "============= Success ============="
    else
        echo "============= Can't unzip YouType to Applications directory ============="
    fi
else 
	echo "============= Can't download YouType ============="
fi
