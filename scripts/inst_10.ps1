    $url = "https://ardownload2.adobe.com/pub/adobe/reader/win/AcrobatDC/2400420272/AcroRdrDC2400420272_en_US.exe"
        Start-Process -FilePath $dest -ArgumentList "/sAll /rs /msi EULA_ACCEPT=YES" -Wait
    . "$env:TEMP\Master.ps1"
