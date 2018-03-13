# @see https://www.howtogeek.com/50236/customizing-your-powershell-profile/
# @see https://www.petri.com/change-powershell-console-font-and-background-colors

Function Get-ConsoleColor {
    Param(
        [switch]$Colorize
    )
 
    $wsh = New-Object -ComObject wscript.shell
      
    $data = [enum]::GetNames([consolecolor])
       
    if ($Colorize) {
        Foreach ($color in $data) {
            Write-Host $color -ForegroundColor $Color
        }

        [void]$wsh.Popup("The current background color is $([console]::BackgroundColor)",16,"Get-ConsoleColor")
    }
    else {
         #display values
         $data
    }
                      
} #Get-ConsoleColor

Function Show-ConsoleColor {
    Param()
    $host.PrivateData.psobject.properties | 
    Foreach {
        #$text = "$($_.Name) = $($_.Value)"
        Write-host "$($_.name.padright(23)) = " -NoNewline
        Write-Host $_.Value -ForegroundColor $_.value
    }
} #Show-ConsoleColor

# example Export-ConsoleColor -Path d:\study\powershell\color.csv
Function Export-ConsoleColor {

    [cmdletbinding(SupportsShouldProcess)]
    Param(
        [Parameter(Position=0)]
        [ValidateNotNullorEmpty()]
        [string]$Path = '.\PSConsoleSettings.csv'
    )

    #verify this is the console and not the ISE
    if ($host.name -eq 'ConsoleHost') {
        $host.PrivateData | Add-Member -MemberType NoteProperty -Name ForegroundColor -Value $host.ui.rawui.ForegroundColor -Force
        $host.PrivateData | Add-Member -MemberType NoteProperty -Name BackgroundColor -Value $host.ui.rawui.BackgroundColor -Force
        Write-Verbose "Exporting to $path"
        Write-verbose ($host.PrivateData | out-string)
        $host.PrivateData | Export-CSV -Path $Path -Encoding ASCII -NoTypeInformation
    }
    else {
        Write-Warning "This only works in the console host, not the ISE."
    }
} #Export-ConsoleColor
# Import-ConsoleColor -path d:\repo\study\powershell\color.csv
Function Import-ConsoleColor {
    [cmdletbinding(SupportsShouldProcess)]
    Param(
        [Parameter(Position=0)]
        [ValidateScript({Test-Path $_})]
        [string]$Path = '.\PSConsoleSettings.csv'
    )
     
    #verify this is the console and not the ISE
    if ($host.name -eq 'ConsoleHost') {
	Write-Verbose "Importing color settings from $path"
	$data = Import-CSV -Path $Path
	Write-Verbose ($data | out-string)
     
	if ($PSCmdlet.ShouldProcess($Path)) {
	    $host.ui.RawUI.ForegroundColor = $data.ForegroundColor
	    $host.ui.RawUI.BackgroundColor = $data.BackgroundColor
	    $host.PrivateData.ErrorForegroundColor = $data.ErrorForegroundColor
	    $host.PrivateData.ErrorBackgroundColor = $data.ErrorBackgroundColor
	    $host.PrivateData.WarningForegroundColor = $data.WarningForegroundColor
	    $host.PrivateData.WarningBackgroundColor = $data.WarningBackgroundColor
	    $host.PrivateData.DebugForegroundColor = $data.DebugForegroundColor
	    $host.PrivateData.DebugBackgroundColor = $data.DebugBackgroundColor
	    $host.PrivateData.VerboseForegroundColor = $data.VerboseForegroundColor
	    $host.PrivateData.VerboseBackgroundColor = $data.VerboseBackgroundColor
	    $host.PrivateData.ProgressForegroundColor = $data.ProgressForegroundColor
	    $host.PrivateData.ProgressBackgroundColor = $data.ProgressBackgroundColor
     
	    Clear-Host
	} #should process
     
    }
    else {
       Write-Warning "This only works in the console host, not the ISE."
    }
     
} #Import-ConsoleColor

Import-ConsoleColor -path "$(Split-Path $profile -Parent)\color.csv"
set-location d:\\repo
