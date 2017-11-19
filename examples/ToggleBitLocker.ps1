param(
	[string]$in = $(Read-Host "Enter a hostname, path to text file of hostnames, or 'q' to exit: "),
	[switch]$nocheck
)

function Reset-BitLocker($computer, $nocheck) {
	Write-Host "Querying $computer. Please wait. . ." -ForegroundColor Yellow
	if (Test-Connection -ComputerName $computer -Count 1 -Quiet) {
		$blStatus = Get-WmiObject -ComputerName $in -Namespace "Root\cimv2\security\MicrosoftVolumeEncryption" -ClassName "Win32_Encryptablevolume" -filter "DriveLetter = 'C:'"
		if ($blStatus.ProtectionStatus -eq "1" -or $nocheck -eq $True) {
			# suspend bitlocker
			Write-Host "Suspending BitLocker on $computer. Please wait. . ." -ForegroundColor Cyan
			Invoke-Command -ComputerName $computer -ScriptBlock {Start-Process -FilePath "manage-bde.exe" -ArgumentList "-protectors -disable C:" -Wait}

			Start-Sleep -Seconds 3	# wait 3 seconds before enabling again
			
			# restore bitlocker
			Write-Host "Restoring BitLocker on $computer. Please wait. . ." -ForegroundColor Cyan
			Invoke-Command -ComputerName $computer -ScriptBlock {Start-Process -FilePath "manage-bde.exe" -ArgumentList "-protectors -enable C:" -Wait}
			
			# done!
			Write-Host "Completed operation on $computer." -ForegroundColor Green
		} else {
			Write-Host "BitLocker is not enabled on $computer (or encryption is in progress)." -ForegroundColor Red
		}
	} else {
		Write-Host "Unable to connect to $computer. Device may be off the network." -ForegroundColor Red
	}
}

# check for empty string
if ($in -like "") {
	Write-Host "Usage: .\ToggleBitLocker.ps1 -in [hostname] [-nocheck]" -ForegroundColor Red
	Write-Host "Usage: .\ToggleBitLocker.ps1 -in [filepath] [-nocheck]" -ForegroundColor Red

# quit
} elseif ($in -like "q") {
	exit

# single use
} elseif ($in.ToLower().StartsWith('dt') -eq $True -or $in.ToLower().StartsWith('lt') -eq $True) {
	Reset-BitLocker -computer $in -nocheck $nocheck

# read file of hostnames
} else {
	if (Test-Path $in) {
		Get-Content $in | ForEach-Object {Reset-BitLocker -computer $_ -nocheck $nocheck}
	} else {
		Write-Host "Unable to read from $in. Check the path and try again." -ForegroundColor Red
	}
}