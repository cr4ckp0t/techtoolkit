# Ping Hostnames

param(
	[string]$in = $(Read-Host "Enter a hostname, txt file of hostnames, or 'q' to exit: ")
)

function Ping-Hostname($computer) {
	if (Test-Connection -ComputerName $computer -Count 1 -Quiet) {
		Write-Host "$computer is ONLINE!" -ForegroundColor Green
	} else {
		Write-Host "$computer is OFFLINE!" -ForegroundColor Red
	}
}

# no input provided
if ($in -like "") {
	Write-Host "Usage: .\PingHostnames.ps1 -in C:\Path\To\Hostnames.txt" -ForegroundColor Yellow
	Write-Host "Usage: .\PingHostnames.ps1 -in DT2UA1234567" -ForegroundColor Yellow

# quit
} elseif ($in -like "q") {
	Exit

# single hostname input
} elseif ($in.ToLower().StartsWith('dt') -eq $True -or $in.ToLower().StartsWith('lt') -eq $True) {
	Ping-Hostname $in

} else {
	if (Test-Path $in) {
		Get-Content $in | ForEach-Object {Ping-Hostname $_}
		Write-Host "Done!" -ForegroundColor Cyan
	} else {
		Write-Host "File '$in' does not exist or isn't readable." -ForegroundColor Red
	}
}