#!/bin/bash


###############################################################
#	Copyright (c) 2019, D8 Services Ltd.  All rights reserved.  
#											
#	
#	THIS SOFTWARE IS PROVIDED BY D8 SERVICES LTD. "AS IS" AND ANY
#	EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
#	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
#	DISCLAIMED. IN NO EVENT SHALL D8 SERVICES LTD. BE LIABLE FOR ANY
#	DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
#	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
#	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
#	ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
#	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
#	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
#
###############################################################
#
# About this Script
# SimpleNotification.sh
# https://github.com/D8Services/SimpleNotification
#
# V1.0 20191115 - Tomos Tyler
#	Initial creation, leverages Jamf helper as the PPPC preference is configured
#	by default
# V1.1 20191115 - Tomos Tyler, added support for custom logo
#
# Script Use
# must be to a mac enrolled in a Jamf Server
# Use the hard coded value or pass parameters to the script through Jamf
# 
# The Logo is optional!!
# 
# The logo is a nice little feature, the system will default to a MacOS logo
# but you have the choice of creating an icon and converting to base64 for
# use in your DIalog Window
#
# To make your icon turn into a base64 string
# base64 <path to image> > /tmp/myLogo.txt
# Example
# base64 /tmp/D8Logo.png > /tmp/d8Logo.txt
# this command will read your graphic file and output the converted string to 
# /tmp/d8Logo.txt you can then open that file and copy the entire string. Place 
# it as a hard coded value in the script or pass as a parameter from jamf.
# 
# Open Command
# I am not re-writing the man page for the open command, but...
# The URL string can be very useful if you want to notify your users to a Jamf Update, or 
# software release using a jamfselfservice URL, Email link or any of the other URLS
# the open command can facilitate.
# other examples
# FTP Connection
# theURL="ftp://ftp.d8services.com"
# Open a file
# theURL="/Users/Shared/CodeofConduct.pdf"
# Jamf Self Service
# theURL="jamfselfservice://content?entity=policy&id=X&action=view"
# 
#Hard Coded Values
# Main text displayed to the user
theMessage=""
# title of the Window
theTitle=""
# the URL for the user to open
#theURL="https://www.d8services.com"
theURL=""
# the base64 of your logo (optional, can be left blank)
thelogo=""
######### Do not edit below this line ##########

# CHECK TO SEE IF A VALUE WAS PASSED IN PARAMETER 4 AND, IF SO, ASSIGN TO "USERNAME"
if [ "${4}" != "" ] && [ "${theMessage}" == "" ];then
	theMessage="${4}"
fi
if [ "${5}" != "" ] && [ "${theTitle}" == "" ];then
	theTitle="${5}"
fi
if [ "${6}" != "" ] && [ "${theURL}" == "" ];then
	theURL="${6}"
fi
if [ "${7}" != "" ] && [ "${thelogo}" == "" ];then
	thelogo="${7}"
fi

if [[ -z "${theMessage}" ]] || [[ -z "${theTitle}" ]] || [[ -z "${theURL}" ]];then
	echo "ERROR: one or more parameters were not passed from Jamf, please check your parameter use. Exiting"
	exit 1
fi

jamfHelper="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"

loggedInUser=$(ls -l /dev/console | cut -d " " -f 4)
currentUID=$(dscl . read /Users/$loggedInUser UniqueID | awk '{print $2}')
#if [[ $currentUID == "0" ]];then
#	exit 1
#fi

# Check if theLogo string is populated and display the appropriate dialog
if [[ -z "${thelogo}" ]];then
launchctl "asuser" "$currentUID" "$jamfHelper" -title "${theTitle}" -windowType utility -description "${theMessage}" -icon "/System/Library/CoreServices/ReportPanic.app/Contents/Resources/ProblemReporter.icns" -button2 "Cancel" -button1 "Open" -defaultButton 1 -countdown 20
else
cat << EOF > /tmp/theLogo.txt
$thelogo
EOF
cat /tmp/theLogo.txt | base64 --decode > /tmp/theLogo.png
launchctl "asuser" "$currentUID" "$jamfHelper" -title "${theTitle}" -windowType utility -description "${theMessage}" -icon "/private/tmp/theLogo.png" -button2 "Cancel" -button1 "Open" -defaultButton 1
fi

# Open the URL if the user clicked OK
if [[ $? == "0" ]];then
sudo -u $loggedInUser -i open "${theURL}"
fi

