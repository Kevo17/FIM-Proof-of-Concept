Write-Host ""
Write-Host "What would you like to do?"
Write-Host ""
Write-Host "     A) Collect new Baseleine."
Write-Host "     B) Begin monitoring files with saved Baseline."
Write-Host ""

$response = Read-Host -Prompt "Please enter 'A' or 'B'"
Write-Host ""

Function Calculate-File-Hash($filepath)
{
    $filehash = Get-FileHash -Path $filepath -Algorithm SHA512
    return $filehash
}

Function Erase-Baseline-If-Already-Exists()
{
    $baselineExists = Test-Path -Path .\baseline.txt

    if($baselineExists)
    {
        #Deletes Existing Baseline
        Remove-Item -Path .\baseline.txt
    }
}

if ($response -eq "A".ToUpper())
    {
        #Calculate Hash from the target files and store in baseline.txt
        
        #Collect all files in the target folder
        $files = Get-ChildItem -Path .\Files
        
        #For each file, calculate the hash, and write to baseline.txt
        foreach ($f in $files)
        {
            $hash = Calculate-File-Hash $f.FullName
            "$($hash.path)|$($hash.Hash)" | Out-File -FilePath .\baseline.txt -Append
        } 
    }
elseif ($response -eq "B".ToUpper())
    {
        $fileHashDictionary = @{}
       
        #Load file|hash from baseline.txt and store them in a dictionary
        $filePathsAndHashes = Get-Content -Path .\baseline.txt

        foreach ($f in $filePathsAndHashes)
        {
            $fileHashDictionary.add($f.Split("|")[0],$f.Split("|")[1])
        }

        $fileHashDictionary.Values
      
        #Begin monitoring files with
        while ($true)
        {
             Start-Sleep -Seconds 1
            
             $files = Get-ChildItem -Path .\Files
        
        #For each file, calculate the hash, and write to baseline.txt
        foreach ($f in $files)
        {
            $hash = Calculate-File-Hash $f.FullName

            if ($fileHashDictionary[$hash.path] -eq $null)
            {
                Write-Host "$($hash.Path) has been created!" -ForegroundColor Green
            }
            else
            {
                if ($fileHashDictionary[$hash.Path] -eq $hash.Hash){}
            
            else
            {
                Write-Host "$($hash.Path) has changed!!!" -ForegroundColor Yellow
            }
         }
      }
    }
    foreach ($key in $fileHashDictionary.Keys)
        {
            $baselineFileStillExists = Test-Path -Path $key
            if (-Not $baselineeFileStillExists)
            {
                Write-Host "$($key) has been deleted!" -ForegroundColor DarkRed -BackgroundColor Gray
            }
        }
      }
    


  