# Get Generic Account Password
param(
	[string]$account = $(Read-Host "Enter a generic account or 'q' to quit: ")
)

$hostnames = @{
	# GHS Accounts
	"GHS-OCCULARIS01" = "DT2UA71422YY";
	"GHS-VWPNT01" = "DT2UA0460DG6";
	"GHS-FOOD01" = "DT2UA4290SBX";
	"GHS-FOOD02" = "DT2UA32605FW";
	"GHS-GIFT01" = "DT2UA4340ZG4";
	"GHS-OPTI01" = "LTCNU409BDPF";
	"GHS-TRAIN01" = "DT2UA42018SY";
	"GHS-VEND01" = "DT2UA2191LLH";
	"GHS-VISIT01" = "DT2UA4260RXH";

	# GMH Accounts
	"GMH-CLIN01" = "DT2UA30301R4";
	"GMH-ERED01" = "DT2UA3021M39";
	"GMH-HUGS01" = "DT2UA10316K7";
	"GMH-MIPH01" = "DT2UA505153Z";
	"GMH-NICU01" = "DTMXL7191FM4";
	"GMH-PHARM01" = "DT2UA6511H5Q";
	"GMH-PHYS01" = "DT2UA505155L";
	"GMH-RAD01" = "DTMXL7191FLQ";
	"GMH-RCP01" = "DT2UA5051561";
	"GMH-SURG01" = "DTMXL7191FMW";

	# GrMH Accounts
	"GrMH-CLIN01" = "DT2UA50515M2";
	"GrMH-ERED01" = "DT2UA50514W7";
	"GrMH-SURG01" = "DT2UA70511WZ";

	# HH Accounts
	"HH-CLIN01" = "DT2UA50514W5";
	"HH-ERED01" = "DT2UA3211BP6";
	"HH-SURG01" = "LT5CG5042MC2";

	# LCMH Accounts
	"LCMH-CLIN01" = "DT2UA50515MR";

	# NGH Accounts
	"NGH-CLIN01" = "DT2UA4260RVF";
	"NGH-ERED01" = "DT2UA4390LZL";

	# OMH Accounts
	"OMH-CLIN01" = "DT2UA5132C3K";
	"OMH-ERED01" = "DT2UA5291L13";
	"OMH-PHYS01" = "DTMXL7191FNM";
	"OMH-SURG01" = "DT2UA6311VFY";

	# Other Accounts
	"CC-SURG01" = "DTMXL7191FJ0";
	"CI-PHYS01" = "DT2UA5041GW9";
	# "GHS-EMS01" = "LT9HKSA92026";
	"UMG-SURG01" = "DTMXL7191FMJ";

	# PW Accounts
	"PW-CLIN01" = "DT2UA5051504";
	"PW-SURG01" = "DT2UA3261PS9";
	"PWOP-SURG01" = "DT2UA5021NNS";

	# SOM Accounts
	"SOM-SIGN01" = "DT2UA6021ZWW";
	"SOM-TRAIN02" = "DT2UA206035D";
}

if ($account -like "") {
	Write-Host "Account can't be blank." -ForegroundColor Red
} ElseIf ($account -like "q") {
	Exit
} ElseIf ($hostnames.ContainsKey($account.ToUpper()) -eq $False) {
	Write-Host "Account not found. Try again." -ForegroundColor Red
} else {
	$account = $account.ToUpper()
	$hostname = $hostnames.$account.ToUpper()
	Write-Host "Querying $hostname for $account's password.  Please wait..." -ForegroundColor Yellow
	If (Test-Connection -ComputerName $hostname -Count 1 -Quiet) {
		$registry = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('LocalMachine', $hostName)
		$registryKey = $registry.OpenSubKey("SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Winlogon")
		$autoAdminLogon = $registryKey.GetValue("AutoAdminLogon")
		If ($autoAdminLogon -like "1") {
			$password = $registryKey.GetValue("DefaultPassWord")
			$password | clip.exe
			Write-Host "Copied $account's password to clipboard." -ForegroundColor Green
			Write-Host "Password is $password" -ForegroundColor Green
			Write-Host "Press any key to continue...Screen and clipboard will be cleared." -ForegroundColor Yellow
			cmd /c pause | out-null
			"" | clip.exe
			Clear-Host
		} else {
			Write-Host "$hostname is not setup as autologon." -ForegroundColor Red
		}
	} else {
		Write-Host "$hostname is not responding to queries." -ForegroundColor Red
	}
}