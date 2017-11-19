# Install Printer on Remote Device Using Print Logic
# By: Adam Koch <akoch@ghs.org>
param(
	[string]$computer = $(Read-Host "Enter Hostname"),
	[string]$printers = $(Read-Host "Enter Printer's V-name")
)

$printLogic = "Program Files (x86)\Printer Properties Pro\Printer Installer Client\bin\PrinterInstallerConsole.exe"

function InstallPrinter($computer, $printer, $default) {
	Write-Host "Installing $printer on $computer. Please wait. . ." -ForegroundColor Yellow
	Invoke-Command -ComputerName $computer -ScriptBlock {param($printer) & "C:\Program Files (x86)\Printer Properties Pro\Printer Installer Client\bin\PrinterInstallerConsole.exe" $printer} -ArgumentList "InstallPrinter=$printer"
}

# do some checks
if ($computer -like "" -or $printers -like "") {
	Write-Host "Usage: .\RemoteGPUpdate.ps1 -computer [HOSTNAME] -printers [PRINTERS]" -ForegroundColor Red
	Write-Host "Printers can be comma separated, or file of V-numbers separated by a new line." -ForegroundColor Red
} elseif (!(Test-Connection -ComputerName $computer -Count 1 -Quiet)) {
	Write-Host "Hostname $computer is not responding." -ForegroundColor Red
} elseif (!(Test-Path "\\$computer\c$\$printLogic")) {
	Write-Host "PrinterLogic is not installed on $computer." -ForegroundColor Red	
} else {
	Write-Host "Installing printers. This can take some time. Please be patient. . ." -ForegroundColor Cyan
	if ($printers.IndexOf(',') -gt -1) {
		# replace spaces, just in case
		$printers = $printers -replace " ", ""

		# loop through the printers and add each one
		$printers.Split(',') | ForEach-Object { InstallPrinter -computer $computer -printer $_ }
	} elseif (Test-Path $printers) {
		Get-Content $printers | ForEach-Object { InstallPrinter -computer $computer -printer $_ }
	} else {
		InstallPrinter -computer $computer -printer $printers
	}
	Write-Host "Done!" -ForegroundColor Green
}