# Toggle WiFi Network Adapter on Remote Devices
# By Adam Koch <akoch@ghs.org>

param(
	[parameter(position = 0, helpmessage="A hostname, or text file containing a list of hostnames.")]
	[alias("CN")]
	[string]$computer = $(Read-Host "Enter hostname or txt file of hostnames"),
	[switch]$enable
)

#$ErrorActionPreference = 'silentlycontinue'

function Set-WiFiAdapter($computer, $enable) {
	$wmi = Get-WmiObject -ComputerName $computer -Class Win32_NetworkAdapter -Filter "Name LIKE '%Wireless%'"
	if ($wmi.MACAddress -ne "") {
		# found an adapter
		if ($enable -eq $true) {
			Write-Host "Enabling"$wmi.name"on $computer. . ." -ForegroundColor Cyan 
			$wmi.enable()
		} else {
			Write-Host "Disabling"$wmi.name"on $computer. . ." -ForegroundColor Cyan
			$wmi.disable()
		}
		Write-Host "Done!" -ForegroundColor Green
	} else {
		Write-Host "Unable to find wireless adapter." -ForegroundColor Red
	}
}

if ($computer -like "") {
	Write-Host "Usage: .\DisableWiFiAdapter.ps1 -ComputerName [HOSTNAMES] [-enable]" -ForegroundColor Yellow
} elseif ($computer -like "q") {
	Exit
} elseif ($computer.ToLower().StartsWith('dt') -eq $True -or $computer.ToLower().StartsWith('lt') -eq $True -or $computer.StartsWith('10') -eq $True) {
	# single hostname (or ip)
	if (Test-Connection -ComputerName $computer -Count 1 -Quiet) {
		Set-WiFiAdapter -computer $computer -enable $enable
	} else {
		Write-Host "$computer is offline. Please try again." -ForegroundColor Red
	}
} elseif (Test-Path $computer) {
	# text file of hostnames
	Get-Content $computer | ForEach-Object { Set-WiFiAdapter -computer $_ -enable $enable }
} else {
	# something went wrong
	Write-Host "Unable to proccess your request. Please try again." -ForegroundColor Red
} 