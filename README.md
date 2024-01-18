# SimpleNotification.sh

V1.0 20191115 - Tomos Tyler
	Initial creation, leverages Jamf helper as the PPPC preference is pre configured
	by default

V1.1 20191115 - Tomos Tyler, added support for optional custom logo

V1.1 20240118 - Tomos Tyler, Removed base64, just using the path now, just tested and saw that icons are not displayed unless they are ICNS files

Script Use
must be to a mac enrolled in a Jamf Server, it utilised the JamfHelper command, so no Jamf, no dialog.
Use the hard coded value or pass parameters to the script through Jamf

The Logo is optional!!
Use the path to an ICNS file

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
