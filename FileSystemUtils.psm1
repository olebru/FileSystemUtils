
function Watch-Folder 
{
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $Folder = "\.",
        [Parameter()]
        [bool]
        $IncludeSubFolders = $false,
        [Parameter()]
        [string]
        $Filter = "*.*"
    )

    $filewatcher = New-Object System.IO.FileSystemWatcher

    $filewatcher.Path = $Folder
    $filewatcher.Filter = $Filter
 
    $filewatcher.IncludeSubdirectories = $IncludeSubFolders
    $filewatcher.EnableRaisingEvents = $true  

    $CreateChangeDeleteHandler = { 
        $path = $Event.SourceEventArgs.FullPath
        $changeType = $Event.SourceEventArgs.ChangeType
        $logline = "$(Get-Date), $changeType, $path"
        write-host $logline
    }    


    $RenameHandler = { 
        $path = $Event.SourceEventArgs.FullPath
        $changeType = $Event.SourceEventArgs.ChangeType
        $oldPath = $Event.SourceEventArgs.OldFullPath
        


        $logline = "$(Get-Date), $changeType, $oldPath was renamed to $path"
        write-host $logline
    }    


    Register-ObjectEvent $filewatcher "Created" -Action $CreateChangeDeleteHandler
    Register-ObjectEvent $filewatcher "Changed" -Action $CreateChangeDeleteHandler
    Register-ObjectEvent $filewatcher "Deleted" -Action $CreateChangeDeleteHandler
    Register-ObjectEvent $filewatcher "Renamed" -Action $RenameHandler
    
    while ($true) { Start-Sleep 1 }

}

Export-ModuleMember -Function Watch-Folder