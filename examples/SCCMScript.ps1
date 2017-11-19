Write-Host "=================================================" -ForegroundColor Green
Write-Host "This program will allow you to Install/Uninstall" -ForegroundColor Green
Write-Host "SCCM." -ForegroundColor Green
Write-Host "=================================================" -ForegroundColor Green

Function Running($proc)
{
    $Now = "Exists"
    While ($Now -eq "Exists")
    {
        If(Get-Process $proc -ErrorAction silentlycontinue)
        {
            $Now = "Exists"
            
            Start-Sleep -Seconds 15
        } Else {
            $Now = "Nope"
            Write-Host "Uninstall complete!" -ForegroundColor Yellow
            
        }
    }
}

function Get-Hostname {
    #Prompt for computer to connect to.
    Write-Host "Please enter a computer name: " -ForegroundColor Green -NoNewline
    $hostname = Read-Host
    #Test network connection before making connection.
    If ($hostname -ne $Env:Computername) {
        If (!(Test-Connection -comp $hostname -count 1 -quiet)) {
            Write-Warning "$computer is not accessible, please try a different computer or verify it is powered on." 
            #Break
            .$StartScript
        }
    }

    Try {
        #Verify that the OS Version is 6.0 and above, otherwise the script will fail
        If ((Get-WmiObject -ComputerName $hostname Win32_OperatingSystem -ea stop).Version -lt 6.0) {
            Write-Warning "The Operating System of the computer is not supported. 'nClient: Vista and above 'nServer: Windows 2008 and above." 
            Break
        }
    } Catch {
        Write-Warning "$($error[0])"
        Break
    }
    
    return $hostname
}

#Main Script Body
$StartScript = {
    #Get hostname of computer
    $computer = Get-Hostname
    Do {
        
        #Configure enable choice 
        $uninstall = New-Object System.Management.Automation.Host.ChoiceDescription "&Uninstall","Uninstall SCCM"
    
        #Configure disable choice 
        $install = New-Object System.Management.Automation.Host.ChoiceDescription "&Install","Install SCCM"
        
        #Configure quit choice
        $quit = New-Object System.Management.Automation.Host.ChoiceDescription "&Quit","Quit"
        
        #Configure new hostname choice
        $newComputer = New-Object System.Management.Automation.Host.ChoiceDescription "&New Hostname","New Hostname"
    
        #Determine Values for Choice 
        $choice = [System.Management.Automation.Host.ChoiceDescription[]] @($install,$uninstall,$newComputer,$quit) 
    
        #Determine Default Selection 
        [int]$default = 3 
    
        #Present choice option to user 
        $userchoice = $host.ui.PromptforChoice("","Install or Uninstall SCCM for $computer ?",$choice,$default) 
        If($userchoice -eq "0") {
            Write-Host
            Write-Host "Installing SCCM..." -ForegroundColor Green
            Invoke-Command -ComputerName $computer -ScriptBlock {
                $Arg = @('/mp:ssccmsitecm04.ghs.org', 'SMSSITECODE=CM1') 
                Start-Process -FilePath 'C:\Windows\ccmsetup\ccmsetup.exe' -ArgumentList $Arg[0],$Arg[1] -Wait
            }
            Write-Host "Installation in progress..." -ForegroundColor Yellow
            While(-not (Test-Path \\$computer\c$\Windows\CCM\ClientUX\SCClient.exe)) {
                Start-Sleep -Milliseconds 100
            }
            Write-Host "Installation Complete!" -ForegroundColor Yellow
        } ElseIf($userchoice -eq "1") {
            Write-Host
            Write-Host "Uninstalling SCCM..." -ForegroundColor Green
            Invoke-Command -ComputerName $computer -ScriptBlock { Start-Process -FilePath 'C:\Windows\ccmsetup\ccmsetup.exe' -ArgumentList /uninstall -Wait }
            Running CCMSetup
        } ElseIf($userchoice -eq 2) {
            $computer = Get-Hostname
            Write-Host
            Write-Host "$computer is now the active computer." -ForegroundColor Yellow
            Write-Host
        }
    } 
    #If user selects No, then quit the script     
    Until ($userchoice -eq 3)
}
#Starting Script
&$StartScript

