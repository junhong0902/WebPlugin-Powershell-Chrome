##-------------------------------------------
## Load Dependencies
##-------------------------------------------
$PathToFolder = 'C:\Program Files (x86)\CyberArk\Password Manager\bin\lib'
[System.Reflection.Assembly]::LoadFrom("$PathToFolder\WebDriver.dll" -f $PathToFolder)
if ($env:Path -notcontains ";$PathToFolder" ) {
    $env:Path += ";$PathToFolder"
}



##-------------------------------------------
## Load Script Libraries
##-------------------------------------------
# Custom scripts/functions, add more as needed.
$lib_home = "$PathToFolder\modules\"
Get-ChildItem ($lib_home + "*.ps1") | ForEach-Object {. (Join-Path $lib_home $_.Name)}



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

$loginURL = '/admin/login.jsp' # The web directory after address
$logoutURL = '/admin/logout.jsp'  # If logout requires more then a redirect, please edit EndScript per your requirement
$FullLoginURL = "$strURL$strAddress$loginURL"
$FullLogoutURL = "$strURL$strAddress$logoutURL"




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
		Sleep(3)
        
        # Start login action
		try
		{
            # Verify by seaching username element, can directly sendkeys 
			$ChromeDriver.FindElementById('Username_Id').SendKeys($strUserName)
		}
		catch
		{
            # No action required, if failed at try section will execute end function.
            # EndScript with second parameter '1' means no logout required.
			EndScript 'Unable to connect to the remote server' 1 
		}
		
        # Continue by find and enter password.
		# Ex. $ChromeDriver.FindElementById('Password_Id').SendKeys($strPwd)
        # Ex. $ChromeDriver.FindElementById('submit_button').Click()
        # Sleep(5)
		try
		{
            # After login, find element to verify login
            # Ex. $ChromeDriver.FindElementById('bs-example-navbar-collapse-1')
		}
		catch
		{
			EndScript '403 - Forbidden' 1
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
		Sleep(3)

		try
		{
            # Verify by seaching username element, can directly sendkeys. Here we use logon username
			# Ex. $ChromeDriver.FindElementById('username_Id').SendKeys($strLogonUserName)
		}
		catch
		{
            # No other action required. Trigger EndScript
			EndScript 'Unable to connect to the remote server' 1
		}
		
		# Continue by find and enter password.
		# Ex. $ChromeDriver.FindElementById('Password_Id').SendKeys($strLogonPwd)
        # Ex. $ChromeDriver.FindElementById('submit_button').Click()
        # Sleep(5)

		try
		{
            # After login, find element to verify login
            # Ex. $ChromeDriver.FindElementById('bs-example-navbar-collapse-1')
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
		$ChromeDriver = New-Object OpenQA.Selenium.Chrome.ChromeDriver($ChromeOptions)
		$ChromeDriver.Url = $FullLoginURL
		Sleep(3)

		try
		{
            # Verify by seaching username element, can directly sendkeys.
            # Check if logon account exists
            if ($strLogonUserName -eq "" )
            {
	            # Ex.$ChromeDriver.FindElementById('Username_Id').SendKeys($strUserName)
            }
            else 
            {
                # Ex. $ChromeDriver.FindElementById('username_Id').SendKeys($strLogonUserName)
            }
		}
		catch
		{
            # No other action required. Trigger EndScript
			EndScript 'Unable to connect to the remote server' 1
		}
		
		### Continue by find and enter password.
        if ($strLogonUserName -eq "" )
        {
	        # Ex.$ChromeDriver.FindElementById('password_Id').SendKeys($strPwd)
        }
        else 
        {
            # Ex. $ChromeDriver.FindElementById('password_Id').SendKeys($strLogonPwd)
        }

        # Ex. $ChromeDriver.FindElementById('submit_button').Click()
        # Sleep(5)

		try
		{
            # After login, find element to verify login
            # Ex. $ChromeDriver.FindElementById('bs-example-navbar-collapse-1')
		}
		catch
		{
			EndScript '403 - Forbidden' 1
		}
		
		Sleep(3)

        # Change password action
        ## Maybe can first redirect to change password page
        ### Ex. $temp= "/administration/users"
		### Ex. $strFullURL = "$strURL$strAddress$temp"
        ### Ex. $ChromeDriver.Url = $strFullURL
		### Ex. Sleep(3)
        
        # Optional try section, could do without checking as after change, cpm will trigger another verify (with newpass) anyway.
		try
		{                 
            # Ex. $ChromeDriver.FindElementById('submitBtn').Click()
		}
		catch
		{
			EndScript '401 - Unauthorized here'
		}
		
		Sleep(3)

		EndScript '200 - Change Password Success'
	}


	default
	{
		EndScript '404 - Not Found' 1
	}
}


