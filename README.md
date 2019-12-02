# SimpleNotification.sh

V1.0 20191115 - Tomos Tyler
	Initial creation, leverages Jamf helper as the PPPC preference is configured
	by default

V1.1 20191115 - Tomos Tyler, added support for optional custom logo

Script Use
must be to a mac enrolled in a Jamf Server
Use the hard coded value or pass parameters to the script through Jamf

The Logo is optional!!

The logo is a nice little feature, the system will default to a MacOS logo
but you have the choice of creating an icon and converting to base64 for
use in your DIalog Window

To make your icon turn into a base64 string
base64 <path to image> > /tmp/myLogo.txt
Example
base64 /tmp/D8Logo.png > /tmp/d8Logo.txt
this command will read your graphic file and output the converted string to 
/tmp/d8Logo.txt you can then open that file and copy the entire string. Place 
it as a hard coded value in the script or pass as a parameter from jamf.

Open Command
I am not re-writing the man page for the open command, but...
The URL string can be very useful if you want to notify your users to a Jamf Update, or 
software release using a jamfselfservice URL, Email link or any of the other URLS
the open command can facilitate.
other examples
FTP Connection
theURL="ftp://ftp.d8services.com"
Open a file
theURL="/Users/Shared/CodeofConduct.pdf"
