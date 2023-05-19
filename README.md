# RSR_Nag
This script borrows **heavily** from Bart Reardon's [updatePrompt](https://github.com/bartreardon/swiftDialog-scripts/blob/main/Update%20Notifications/updatePrompt.sh) dialog.

In this adaption we're reading the RSR 'version' installe (-ProductVersionExtra) and then specifying a required RSR version value via a JamfPro variable.

If the existing version anbd required version dont match we're simply sending the user to the Software Update preference pane.

The 'persistant' variable will force the dialog to remain until the update is installed, the subsequent reboot effectively kills the dialog process.
