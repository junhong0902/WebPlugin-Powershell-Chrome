##-------------------------------------------
## Load Dependencies
##-------------------------------------------
$PathToFolder = 'D:\Program Files (x86)\CyberArk\Password Manager\bin\Selenium-Plugin'
[System.Reflection.Assembly]::LoadFrom($PathToFolder + "\WebDriver.dll" -f $PathToFolder) | Out-Null
if ($env:Path -notcontains ";$PathToFolder" ) {
    $env:Path += ";$PathToFolder"
}



##-------------------------------------------
## Load Script Libraries
##-------------------------------------------
# Custom scripts/functions, add more as needed.
#$lib_home = $PathToFolder + "\modules\"
#Get-ChildItem ($lib_home + "*.ps1") | ForEach-Object {. (Join-Path $lib_home $_.Name)}



##-------------------------------------------
## Chrome driver settings
##-------------------------------------------
$ChromeOptions = New-Object OpenQA.Selenium.Chrome.ChromeOptions
#$ChromeOptions.AddArgument('start-maximized')
$ChromeOptions.AcceptInsecureCertificates = $True
$ChromeOptions.AddArgument("--no-sandbox")
$ChromeOptions.AddArgument("--incognito")
$ChromeOptions.AddArgument("--headless") #Comment this for debugging. CPM runs in headless mode!



##-------------------------------------------
## Init Variables
##-------------------------------------------
$strURL = 'https://'
$strActionName = $args[0]
$verifyLogon = $args[1]
$strUserName = $args[2]
$strAddress = $args[3]
$strPwd = $args[4]
$strNewPwd = $args[5]
$strLogonUserName = $args[6]
$strLogonPwd = $args[7]

$loginURL = '' # The web directory after address
$logoutURL = '/login.cgi?logout=1'  # If logout requires more then a redirect, please edit EndScript per your requirement
$FullLoginURL = "$strURL$strAddress$loginURL"
$FullLogoutURL = "$strURL$strAddress$logoutURL"

##-------------------------------------------
## Functions
##-------------------------------------------
function EndScript
{
    # Function params
    Param (
    $Output, $Logout
    )


	if ($Logout -ne "1")
	{
		#If logout required
		$ChromeDriver.Url = $FullLogoutURL
		Sleep(1)
	}
	## Make sure this is run before sending the request
	$ChromeDriver.close()
	$ChromeDriver.quit()

	write-host $Output

    # Return result
    return 'PowerShell Script Ended'
}


##-------------------------------------------
## Script starts here
##-------------------------------------------

# Check if verifyLogon = 1
if ($verifyLogon -eq '1')
{
	$strActionName = 'verifypass'
}


switch($strActionName)
{
    # Verify password action 
    'verifypass'
    {
        # Start a chrome tab and load URL
		$ChromeDriver = New-Object OpenQA.Selenium.Chrome.ChromeDriver($ChromeOptions)
		$ChromeDriver.Url = $FullLoginURL
		Sleep(5)
        
        # Start login action
		try
		{
            # Verify by seaching username element, can directly sendkeys 
			$ChromeDriver.FindElementByName('username').SendKeys($strUserName)
		}
		catch
		{
            # No action required, if failed at try section will execute end function.
            # EndScript with second parameter '1' means no logout required.
			EndScript 'Unable to connect to the remote server' 
		}
		
        # Continue by find and enter password.
		$ChromeDriver.FindElementByName('password').SendKeys($strPwd)
        Sleep(3)
        $ChromeDriver.FindElementByName('logon').Click()
        Sleep(5)

        if ($ChromeDriver.FindElementByXpath('//*[@id="confirm_dialog"]/div[2]/input[1]') )
        {
            $ChromeDriver.FindElementByXpath('//*[@id="confirm_dialog"]/div[2]/input[1]').Click()
        }
        Sleep(5)

		try
		{
            # After login, find element to verify login
            #$ChromeDriver.Url = $strFullURL
            $ChromeDriver.FindElementById('content')
		}
		catch
		{
			EndScript '403 - Forbidden' 
		}
        
        # If successful, return success code to cpm
        EndScript '200 - Connect Success'
				
    }

    # If logon account required, here CPM verify logon account can login
	'Logon'
    {
        # Start a chrome tab and load URL
		$ChromeDriver = New-Object OpenQA.Selenium.Chrome.ChromeDriver($ChromeOptions)
		$ChromeDriver.Url = $FullLoginURL
		Sleep(5)

		try
		{
            # Verify by seaching username element, can directly sendkeys.
	        $ChromeDriver.FindElementByName('username').SendKeys($strUserName)

		}
		catch
		{
            # No other action required. Trigger EndScript
			EndScript 'Unable to connect to the remote server' 1
		}
		
		# Continue by find and enter password.
        Sleep(1)
		$ChromeDriver.FindElementById('password').SendKeys($strPwd)
        Sleep(1)
        $ChromeDriver.FindElementByName('logon').Click()
        Sleep(5)

        if ($ChromeDriver.FindElementByXpath('//*[@id="confirm_dialog"]/div[2]/input[1]') )
        {
            $ChromeDriver.FindElementByXpath('//*[@id="confirm_dialog"]/div[2]/input[1]').Click()
        }
        Sleep(5)

		try
		{
            # After login, find element to verify login
            $ChromeDriver.FindElementById('content')
		}
		catch
		{
			EndScript '403 - Forbidden' 1
		}
        
        # If successful, return success code to cpm
        EndScript '200 - Connect Success'
				
    }
	
    # change password action
	'changepass'
	{
        # Start a chrome tab and load URL
        #write-host 'Starting change pass'
		$ChromeDriver = New-Object OpenQA.Selenium.Chrome.ChromeDriver($ChromeOptions)
		$ChromeDriver.Url = $FullLoginURL
        #write-host 'Starting web'
		Sleep(5)

		try
		{
            # Verify by seaching username element, can directly sendkeys.
	        $ChromeDriver.FindElementByName('username').SendKeys($strUserName)

		}
		catch
		{
            # No other action required. Trigger EndScript
			EndScript 'Unable to connect to the remote server' 1
		}
		
		# Continue by find and enter password.
        Sleep(1)
		$ChromeDriver.FindElementById('password').SendKeys($strPwd)
        Sleep(1)
        $ChromeDriver.FindElementByName('logon').Click()
        Sleep(5)

        if ($ChromeDriver.FindElementByXpath('//*[@id="confirm_dialog"]/div[2]/input[1]'))
        {
            $ChromeDriver.FindElementByXpath('//*[@id="confirm_dialog"]/div[2]/input[1]').Click()
            Sleep(5)
        }
        

		try
		{
            # After login, find element to verify login
            $ChromeDriver.FindElementById('content')
		}
		catch
		{
			EndScript '403 - Forbidden' 1
		}
		
		Sleep(3)

        # Change password action
        ## Maybe can first redirect to change password page
        $temp= "/account/password/change.cgi"
		$strFullURL = "$strURL$strAddress$temp"
        $ChromeDriver.Url = $strFullURL
		Sleep(5)

        $ChromeDriver.FindElementByName('old_password').SendKeys($strPwd)
        Sleep(1)
        $ChromeDriver.FindElementByName('new_password').SendKeys($strNewPwd)
        Sleep(1)
        $ChromeDriver.FindElementByName('new_password2').SendKeys($strNewPwd)
        Sleep(1)
        $ChromeDriver.FindElementByName('action_change').Click()
        Sleep(1)

<#
        try
        {
            $ChromeDriver.FindElementByName('old_password').SendKeys($strPwd)
            Sleep(1)
            $ChromeDriver.FindElementByName('new_password').SendKeys($strNewPwd)
            Sleep(1)
            $ChromeDriver.FindElementByName('new_password2').SendKeys($strNewPwd)
            Sleep(1)
            $ChromeDriver.FindElementByName('action_change').Click()
            Sleep(1)
        }
        catch
        {
            write-host 'Cannot locate change pass page'
            EndScript '404 - Not Found'
            break
        }
#>
        EndScript '200 - Change Password Success'
        break

<#        # Optional try section, could do without checking as after change, cpm will trigger another verify (with newpass) anyway.
		$i=0
        DO
        {

            if ($ChromeDriver.FindElementByXpath('//*[@id="message-center"]/div/div[4]/div[2]/div[1]/div[2]/div[1]/div/div[2]/div[2]/div/span[2]')){
                EndScript '200 - Change Password Success'
                break
            }
            $i = $i+1
            write-host $i
            if ($i -eq 10)
            {
                EndScript '401 - Unauthorized here'
                break
            }
            Sleep(2)
        }while (1)


        try
		{                 
            
            Sleep(30)
		}
		catch
		{
			EndScript '401 - Unauthorized here'
		}
		
		Sleep(3)

		EndScript '200 - Change Password Success'
#>
	}


	default
	{
		EndScript '404 - Not Found' 1
	}
}

