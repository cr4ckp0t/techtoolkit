# Run All Configuration Manager Actions
# By Adam Koch <akoch@ghs.org>
param(
	[string]$computer = $(Read-Host "Enter the hostname or 'q' to quit: ")
)

$cmActions = @(
	"Software Metering Usage Report Cycle|{00000000-0000-0000-0000-000000000031}",
	"Request Machine Policy|{00000000-0000-0000-0000-000000000021}",
	"Evaluate Machine Policy|{00000000-0000-0000-0000-000000000022}",
	"Updates Source Scan Cycle|{00000000-0000-0000-0000-000000000113}",
	"Request & Evaluate User Policy|{00000000-0000-0000-0000-000000000043}",
	"Hardware Inventory Collection Cycle|{00000000-0000-0000-0000-000000000001}",
	"Software Inventory Collection Cycle|{00000000-0000-0000-0000-000000000002}",
	"Application Global Evaluation Task|{00000000-0000-0000-0000-000000000123}",
	"Software Updates Assignments Evaluation Cycle|{00000000-0000-0000-0000-000000000108}",
	"Discovery Data Collection Cycle|{00000000-0000-0000-0000-000000000003}",
	"MSI Product Source Update Cycle|{00000000-0000-0000-0000-000000000107}",
	"Standard File Collection Cycle|{00000000-0000-0000-0000-000000000104}"
)

If ($computer -like "") {
	Write-Host "You must provide a valid hostname. Please try again." -ForegroundColor Red
} ElseIf ($computer -like "q") {
	Write-Host "Good-bye!" -ForegroundColor Cyan
	Exit
} Else {
	Write-Host "Querying $computer for network connectivity. . ." -ForegroundColor Yellow
	If (Test-Connection -ComputerName $computer -Quiet) {
		ForEach ($action in $cmActions) {
			$actionName, $actionID = $action.split("|")
			Write-Host "Running Action: $actionName. . ." -ForegroundColor Cyan
			Invoke-WmiMethod -ComputerName $computer -Namespace root\CCM -Class SMS_Client -Name TriggerSchedule -ArgumentList $actionId, "NOINTERACTIVE"
		}
		Write-Host "Done!" -ForegroundColor Green
	} Else {
		Write-Host "$computer failed to repond. Please try again." -ForegroundColor Red
	}
}