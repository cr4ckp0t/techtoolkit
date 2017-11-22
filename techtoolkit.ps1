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

$version = "0.1alpha"

function Write-MainMenu() {
    Clear-Host
    Write-Host "#############################" -ForegroundColor Green
    Write-Host "Tech Toolkit v$version" -ForegroundColor Green
    Write-Host "By: Adam Koch <akoch@ghs.org>" -ForegroundColor Green
    Write-Host "#############################" -ForegroundColor Green
    Write-Host ""
    Write-Host "1. Bypass Auto Logon" -ForegroundColor Green
    Write-Host "2. Get Last Logged On User" -ForegroundColor Green
    Write-Host "3. Get Logged On User" -ForegroundColor Green
    Write-Host "4. Install Printer on Remote Device" -ForegroundColor Green
    Write-Host "5. Mass Ping Request" -ForegroundColor Green
    Write-Host "6. Force Group Policy Update" -ForegroundColor Green
    Write-Host "7. Reinstall SCCM" -ForegroundColor Green
    Write-Host "8. Run Configuration Manager Actions" -ForegroundColor Green
    Write-Host "9. Toggle BitLocker" -ForegroundColor Green
    Write-Host "10. Toggle WiFi Adapter" -ForegroundColor Green
    Write-Host "11. Quit" -ForegroundColor Green
    Write-Host ""
    Write-Host "Choose An Option [1-11]: " -ForegroundColor Green -NoNewline
}

# main body of the script
Do {
    Write-MainMenu
    $userChoice = Read-Host

    switch ($userChoice) {
        # bypass autologon
        1 { }

        # get last logged on user
        2 { }

        # get current logged on user
        3 { }

        # install printer on remote device
        4 { }

        # mass ping request
        5 { }

        # force group policy update
        6 { }

        # reinstall sccm
        7 { }

        # run configuration manager actions
        8 { }

        # toggle bitlocker
    }
} Until ($userChoice -eq "11")