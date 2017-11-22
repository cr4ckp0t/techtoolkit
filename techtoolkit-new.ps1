# I/S Desktop Analyst Toolkit
# By Adam Koch <akoch@ghs.org>
# https://github.com/akoch-ghs/techtoolkit

<#
	Tech Tookit - For manipulating remote machines.
    Copyright (C) 2017  Adam Koch <akoch@ghs.org>

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#>
Remove-Module cliMenu -ErrorAction SilentlyContinue; Import-Module .\lib\CliMenu.psd1

#########################
# helper functions
#########################
Function Display-Menu($name) {
	Clear-Host
	Show-Menu -MenuName $name
}

Set-MenuOption -Heading "GHS Desktop Technician Toolkit" -SubHeading "Writen By: Adam Koch <akoch@ghs.org>" -MenuFillChar "#" -MenuFillColor Cyan
Set-MenuOption -HeadingColor Green -MenuNameColor DarkGray -SubHeadingColor DarkCyan -FooterTextColor DarkGray
Set-MenuOption -MaxWith 60

#########################
# main menu items
#########################
$mainItemBitLocker = @{
    Name = "BitLocker"
    DisplayName = "BitLocker Functions"
    Action = { Display-Menu -name "BitLocker" }
    DisableConfirm = $True
}

$mainItemSCCM = @{
	Name = "SCCM"
	DisplayName = "SCCM Functions"
	Action = { Display-Menu -name "SCCM" }
	DisableConfirm = $True
}

$mainItemExit = @{
	Name = "Exit"
	DisplayName = "Exit"
	Action = {
		Clear-Host
		Write-Host "Good-Bye!" -ForegroundColor Green
		Break
	}
	DisableConfirm = $False
}

#########################
# bitlocker menu items
#########################
$blItemStatus = @{
	Name = "BLStatus"
	DisplayName = "Get BitLocker Status"
	Action = { 
		Clear-Host
		Write-Host "Testing BL Menu"
		Pause
		Clear-Host
		Show-Menu -MenuName BitLocker
	}
	DisableConfirm = $True
}

$blItemGoBack = @{
	Name ="BLGoBack"
	DisplayName = "Go Back"
	Action = { Display-Menu -name "Main" }
	DisableConfirm = $True
}

#########################
# Main Menu
#########################
$objMainItemBitLocker = New-MenuItem @mainItemBitLocker
$objMainItemSCCM = New-MenuItem @mainItemSCCM
$objMainItemExit = New-MenuItem @mainItemExit
New-Menu -Name Main -DisplayName "Main Menu"
$objMainItemBitLocker | Add-MenuItem -Menu Main
$objMainItemSCCM | Add-MenuItem -Menu Main
$objMainItemExit | Add-MenuItem -Menu Main

#########################
# BitLocker Menu
#########################
$objBitLockerItemStatus = New-MenuItem @blItemStatus
$objBitLockerItemGoBack = New-MenuItem @blItemGoBack
New-Menu -Name BitLocker -DisplayName "BitLocker Functions"
$objBitLockerItemStatus | Add-MenuItem -Menu BitLocker
$objBitLockerItemGoBack | Add-MenuItem -Menu BitLocker

Display-Menu -name "Main"