# DownloadImagesToTeams
Get Bing, Unsplash or Windows10 daily images as custom backgrounds in Microsoft Teams

## Parameter Provider
    Possible values: Windows10, Bing or Unsplash

    Windows10 copy images from Microsoft.Windows.ContentDeliveryManager
    Bing and Unsplash use their REST API to download picture(s)

## Parameter idx
    Only when provider=Bing. 0 = today, 1 = yesterday (0 by default)

## Parameter n
    Only when provider=Bing. Number of images (1 by default)

## Parameter mkt
    Only when provider=Bing. The region (es-US by default)

## Output
    Output file is saved in %APPDATA%\Microsoft\Teams\Backgrounds\Uploads
