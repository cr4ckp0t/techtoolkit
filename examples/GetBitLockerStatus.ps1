# GetBitLockerStatus
# By: Adam Koch <akoch@ghs.org>
param(
	[string]$computer = $(Read-Host "Enter the hostname or 'q' to exit: ")
)

If ($computer -like "") {
	Write-Host "Hostname can't be blank. Please try again!" -ForegroundColor Red
} ElseIf ($computer -eq "q") {
	Exit
} Else {
	Write-Host "Querying $computer to test connection." -ForegroundColor Yellow
	If (Test-Connection -ComputerName $computer -Count 1 -Quiet) {
		manage-bde.exe -cn $computer -status c:
		Write-Host "Done!" -ForegroundColor Green
	} Else {
		Write-Host "$computer is offline. Confirm the device is on the network and try again." -ForegroundColor Red
	}
}