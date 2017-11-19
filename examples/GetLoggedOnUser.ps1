param(
	[string]$computer = $(Read-Host "Enter hostname of computer or enter 'q' to quit: ")
)

Function Get-LoggedOnUser($computer) {
	if ($computer -notlike "") {
		Write-Host "Querying $computer for network connection. . ." -ForegroundColor Yellow
		if (Test-Connection -ComputerName $computer -Count 1 -Quiet) {
			$userID = Invoke-Command -ComputerName $computer -ScriptBlock {
				$userID = Get-WmiObject -Class Win32_ComputerSystem | Select-Object Username
				$userID.Username = $userID.Username  -replace ".*\\"
				if ($userID.Username -like "") {
					$userID.Username = "None"
				}
				return $userID
			}
			return $userID
		} else {
			return $False
		}
	}
}

if ($computer -like 'q') {
	exit
} else {
	$user = Get-LoggedOnUser -computer $computer
	if ($user -eq $False) {
		Write-Host "Connection to $computer failed." -Foreground Red
	} else {
		Write-Host "The logged on user is:" $user.Username -ForegroundColor Green
	}
}