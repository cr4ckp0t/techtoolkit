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

Clear-Host
Write-Host "#############################" -ForegroundColor Green
Write-Host "Tech Toolkit v$version" -ForegroundColor Green
Write-Host "By: Adam Koch <akoch@ghs.org>" -ForegroundColor Green
Write-Host "#############################" -ForegroundColor Green
Write-Host ""
Write-Host "Choose An Option [1-9]:" -ForegroundColor Green
Write-Host "1. Get Logged On User" -ForegroundColor Green
Write-Host "2. Get Last Logged On User" -ForegroundColor Green