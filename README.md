# RSR_Nag
This script borrows **heavily** from Bart Reardon's [updatePrompt](https://github.com/bartreardon/swiftDialog-scripts/blob/main/Update%20Notifications/updatePrompt.sh) dialog.

In this adaption we're reading the RSR 'version' installed (`-ProductVersionExtra`) and then specifying a required RSR version value via a Jamf Pro variable.

If the existing version and required version dont match we're simply sending the user to the Software Update preference pane.

The `persistant` variable will force the dialog to remain until the update is installed, the subsequent reboot effectively kills the dialog process.

<img width="732" alt="Screenshot 2023-05-19 at 3 21 57 PM" src="https://github.com/dpertschi/RSR_Nag/assets/16840386/77d69533-d72f-433c-ab1f-56a902f7a434">
