Param(
    [Parameter(mandatory = $true, Position=0)][ValidateSet("Windows10", "Bing", "Unsplash")][string]$Provider,
    [Parameter(Mandatory=$false,Position=1)][String]$idx=0,
    [Parameter(Mandatory=$false,Position=2)][String]$n=1,
    [Parameter(Mandatory=$false,Position=3)][String]$mkt='es-US'
)

# Teams upload folder
$uploadFolder = $env:APPDATA+"\Microsoft\Teams\Backgrounds\Uploads"

if (-not (Test-Path $uploadFolder)){
    New-Item $uploadFolder -ItemType Directory -Force -Confirm:$false
}

switch($provider){
    'Windows10' {
        $date = (Get-Date -Hour 0 -Minute 0 -Second 0).AddDays(-1)
        $lockScreenImagesPath = $env:LOCALAPPDATA + "\Packages\Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy\LocalState\Assets"

        if (-not (Test-Path $lockScreenImagesPath)){
            Throw "Folder not found $lockScreenImagesPath. Only for Windows 10"
        }

        # Filter background images (more than 100KB)
        $images = Get-ChildItem $lockScreenImagesPath | where{$_.CreationTime -ge $date -AND $_.Length -ge 10000}

        foreach ($image in $images){
            $imageFile = $image.FullName
            Add-Type -AssemblyName System.Drawing
            $photo = New-Object System.Drawing.Bitmap $imageFile
    
            # Filter landscape images
            if ($photo.Width -gt $photo.Height){
                Copy-Item $image.Fullname $($uploadFolder  + '\' + $image + '.jpg') -Force -Confirm:$false

                Write-Verbose "Downloaded $($uploadFolder  + '\' + $image + '.jpg')"
            }
    
        }
    }

    'Bing' {
        # Martina Grom, @magrom, atwork.at 
        # https://github.com/martinagrom/Office365Scripts/blob/master/GetDailyBingPicture.ps1

        # Bing API
        $uri = "https://www.bing.com/HPImageArchive.aspx?format=js&idx=$idx&n=$n&mkt=$mkt"

        # Get the picture metadata
        $response = Invoke-WebRequest -Method Get -Uri $uri

        # Extract the image content
        $body = ConvertFrom-Json -InputObject $response.Content
        $fileurl = "https://www.bing.com/"+$body.images[0].url
        $filename = $body.images[0].startdate+"-"+$body.images[0].title.Replace(" ","-").Replace("?","")+".jpg"

        # Download the picture
        Invoke-WebRequest -Method Get -Uri $fileurl -OutFile (Join-Path $uploadFolder $filename)

        Write-Verbose "Downloaded $(Join-Path $uploadFolder $filename)"

    }

    'Unsplash' {

        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        $uri = 'https://source.unsplash.com/1920x1080/?nature,mountain'

        # Get the picture metadata
        $response = Invoke-WebRequest -Method Get -Uri $uri

        # Extract the image content
        $fileUrl = $response.BaseResponse.ResponseUri.AbsolutePath.Split('/')[-1]
        $filename = $fileUrl +'.jpg'
        Write-Verbose "fileUrl: $fileUrl"
        Write-Verbose "filename: $filename"

        # Download the picture
        Invoke-WebRequest -Method Get -Uri $uri -OutFile (Join-Path $uploadFolder $filename)

        Write-Verbose "Downloaded $(Join-Path $uploadFolder $filename)"

    }

}