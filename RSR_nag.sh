#!/bin/zsh

#  CREDIT
#  https://github.com/bartreardon/swiftDialog-scripts/blob/main/Update%20Notifications/updatePrompt.sh
#  Created by Bart Reardon on 15/9/21.
#
#  Modified to nag uer to install pending Rapid Security Update
#

dialogApp="/usr/local/bin/dialog"

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# Check for Swiftdialog installation
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

if [ ! -f "$dialogApp" ]; then
echo "Installing Swiftdialog"
/usr/local/jamf/bin/jamf policy -event SwiftDialog_Install
else
echo "Swiftdialog installed, continuing ..."
fi

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# Set Variables
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

OSVer=$(sw_vers -ProductVersion)
RSRVer=$(sw_vers -ProductVersionExtra)
requiredRSR="(b)"

infolink="https://support.apple.com/en-us/HT201224"
persistant=0 # set this to 1 and the popup will persist until the update is performed

title="Rapid Security Response"
titlefont="colour=#004c97"
#titlefont="colour=white"

message="### You are running macOS version "$OSVer" "$RSRVer" 

A *Rapid Security Response* software update - **"$OSVer" "$requiredRSR"** - 
has been released, and is now required.  

This is a **small** update, please install at your earliest convenience."
infotext="More Information"

icon="/Library/Application Support/Corp/Icon_white_center.png"

overlay="/System/Library/CoreServices/Rosetta 2 Updater.app/Contents/Resources/AppIcon.icns"
button1text="Open Software Update"
buttona1ction="open -b com.apple.systempreferences /System/Library/PreferencePanes/SoftwareUpdate.prefPane"

# check the current version against the required version and exit if we're already at or exceded
if [[ $requiredRSR = $RSRVer ]]; then
	echo "You have v${RSRVer}"
	exit 0
fi

runDialog () {
    ${dialogApp} -p -d \
    		--title "${title}" \
            --titlefont ${titlefont} \
            --overlayicon "${overlay}" \
            --icon "${icon}" \
            --message "${message}" \
            --infobuttontext "${infotext}" \
            --infobuttonaction "${infolink}" \
            --button1text "${button1text}" \
            --bannerimage "/Tools/swiftDialog/Projects/sec.jpg" \
#            --bannertitle "Rapid Security Response"
    
    processExitCode $?
}

updateselected=0

processExitCode () {
    exitcode=$1
    if [[ $exitcode == 0 ]]; then
        updateselected=1
        open -b com.apple.systempreferences /System/Library/PreferencePanes/SoftwareUpdate.prefPane
    elif [[ $exitcode == 2 ]]; then
        currentUser=$(echo "show State:/Users/ConsoleUser" | scutil | awk '/Name :/ { print $3 }' )
        uid=$(id -u "$currentUser")
        launchctl asuser $uid open "${button2action}"
  	elif [[ $exitcode == 3 ]]; then
  		updateselected=1
    fi
}


# the main loop
while [[ ${persistant} -eq 1 ]] || [[ ${updateselected} -eq 0 ]]
do
    if [[ -e "${dialogApp}" ]]; then
        runDialog
    else
        # well something is up if dialog is missing - force an exit
        updateselected=1
    fi
done

exit 0
