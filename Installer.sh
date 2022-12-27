echo "============= Downloading YouType ============="
curl -fsSL -o YouType.zip 'https://github.com/freefelt/YouType/raw/main/YouType.zip'

if test -f "YouType.zip"; then
    echo "============= Installing YouType ============="
    unzip -qq -o YouType.zip -d /Applications/
    if test -d "/Applications/YouType.app"; then
        rm YouType.zip
        if [[ $(xattr "/Applications/YouType.app") = *com.apple.quarantine* ]]; then
            xattr -d com.apple.quarantine /Applications/YouType.app
        fi
        
        echo "============= Success ============="
    else
        echo "============= Can't unzip YouType to Applications directory ============="
    fi
else 
	echo "============= Can't download YouType ============="
fi
