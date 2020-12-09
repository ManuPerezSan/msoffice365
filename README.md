# WVD-Report
Connect to your Windows Virtual Desktop and obtain data about your environment (host pools, application groups, published apps and sessions)

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
  
## Parameter Outfile
    The name of the output file file

## Output
    Output file is saved in %APPDATA%\Microsoft\Teams\Backgrounds\Uploads
