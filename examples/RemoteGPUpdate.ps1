# Remotely force a Group Policy update
# By Adam Koch <akoch@ghs.org>

param(
	[string]$in = $(Read-Host "Enter a hostname, txt file of hostnames, or 'q' to exit: "),
	[switch]$force
)

# no input provided
if ($in -like "") {
	Write-Host "Usage: .\RemoteGPUpdate.ps1 -in C:\Path\To\Hostnames.txt [-force]" -ForegroundColor Red
	Write-Host "Usage: .\RemoteGPUpdate.ps1 -in DT2UA1234567 [-force]" -ForegroundColor Red

# quit
} elseif ($in -like "q") {
	exit

# single hostname input
} elseif ($in.ToLower().StartsWith('dt') -eq $True -or $in.ToLower().StartsWith('lt') -eq $True) {
	Write-Host "Querying connection to $in." -ForegroundColor Yellow
	if (Test-Connection -ComputerName $in -Quiet) {
		Write-Host "Running Group Policy update on $in. Please wait. . ." -ForegroundColor Yellow
		if ($force -eq $True) {
			Invoke-Command -ComputerName $in -ScriptBlock {Start-Process -FilePath "gpupdate.exe" -ArgumentList "/force"}
		} else {
			Invoke-Command -ComputerName $in -ScriptBlock {Start-Process -FilePath "gpupdate.exe"}
		}
		Write-Host "Done!" -ForegroundColor Green
	} else {
		Write-Host "$in did not respond to query. Please try again." -ForegroundColor Red
	}
} else {
	# check for file existence
	if (Test-Path $in) {
		Get-Content $in | ForEach-Object {
			Write-Host "Querying connection to $_." -ForegroundColor Yellow
			if (Test-Connection -ComputerName $_ -Quiet) {
				Write-Host "Running Group Policy update on $_. Please wait. . ." -ForegroundColor Yellow
				if ($force -eq $True) {
					Invoke-Command -ComputerName $_ -ScriptBlock {Start-Process -FilePath "gpupdate.exe" -ArgumentList "/force"}
				} else {
					Invoke-Command -ComputerName $_ -ScriptBlock {Start-Process -FilePath "gpupdate.exe"}
				}
			} else {
				Write-Host "$_ did not respond. Skipping. . ."
			}
		}
		Write-Host "Done!" -ForegroundColor Green
	} else {
		Write-Host "File '$in' does not exist or isn't readable." -ForegroundColor Red
	}
}