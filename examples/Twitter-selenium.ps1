#Make sure to use the latest selenium dll and the chrome driver that matches your chrome's version
$PathToFolder = 'C:\Program Files (x86)\CyberArk\Password Manager\bin'
[System.Reflection.Assembly]::LoadFrom("C:\Program Files (x86)\CyberArk\Password Manager\bin\WebDriver.dll" -f $PathToFolder)
if ($env:Path -notcontains ";$PathToFolder" ) {
    $env:Path += ";$PathToFolder"
}
#Add-Type -AssemblyName System.Windows.Forms


# Init variable
$strURL = 'https://'
$strActionName = $args[0]
$intState = $args[1]
$strUserName = $args[2]
$strAddress = $args[3]
$strPwd = $args[4]
$strNewPwd = $args[5]

$temp = '/login'
$strFullURL = "$strURL$strAddress$temp"

#Edit this script to handle end of script (clear chrome)
function Endfunction
{
    # Function params
    Param (
    $Errorcode, $stop
    )
	if ($stop -ne 1)
	{
		#If logout required
		$ChromeDriver.Url = 'https://twitter.com/logout'
		Sleep(1)
		$ChromeDriver.FindElementByTagName('body').SendKeys([OpenQA.Selenium.Keys]::TAB +[OpenQA.Selenium.Keys]::TAB + [OpenQA.Selenium.Keys]::TAB +[OpenQA.Selenium.Keys]::ENTER)
		Sleep(1)
	}
	## Make sure this is run before sending the request
	$ChromeDriver.close()
	$ChromeDriver.quit()

	write-host $Errorcode

    # Return result
    return 'End of script'
}

if ($intState -eq '1')
{
	#write-host 'intState = 1!!!'
	$strActionName = 'verifypass'
}


##Chrome settings
$ChromeOptions = New-Object OpenQA.Selenium.Chrome.ChromeOptions
#$ChromeOptions.AddArgument('start-maximized')
$ChromeOptions.AcceptInsecureCertificates = $True
$ChromeOptions.AddArgument("--no-sandbox")
$ChromeOptions.AddArgument("--incognito")
$ChromeOptions.AddArgument("--headless") #Comment this for debugging

#write-host $strFullURL
switch($strActionName)
{
    'verifypass'
    {
		$ChromeDriver = New-Object OpenQA.Selenium.Chrome.ChromeDriver($ChromeOptions)
		$ChromeDriver.Url = $strFullURL
		Sleep(3)
		#write-host $strFullURL
		try
		{
			$ChromeDriver.FindElementByName('session[username_or_email]').SendKeys($strUserName)
		}
		catch
		{
			Endfunction 'Unable to connect to the remote server'
			break
		}
		
		$ChromeDriver.FindElementByName('session[password]').SendKeys($strPwd)
		$ChromeDriver.FindElementByTagName('body').SendKeys([OpenQA.Selenium.Keys]::TAB + [OpenQA.Selenium.Keys]::ENTER)
		
		Sleep(3)
		try
		{
			$ChromeDriver.FindElementByXPath('/html/body/div/div/div/div[2]/main/div/div/div/div[1]/div/div[2]/div/div[2]/div[1]/div/div/div/div[2]/div[1]/div/div/div/div/div/div/div/div/div/div[1]/div/div/div/div[2]/div/div/div/div')
			Endfunction '200 - Connect Success'
		}
		catch
		{
			Endfunction '403 - Forbidden' 1
		}
				
    }


	'Logon'
    {
		$ChromeDriver = New-Object OpenQA.Selenium.Chrome.ChromeDriver($ChromeOptions)
		$ChromeDriver.Url = $strFullURL
		Sleep(3)
		#write-host $strFullURL
		try
		{
			$ChromeDriver.FindElementByName('session[username_or_email]').SendKeys($strUserName)
		}
		catch
		{
			Endfunction 'Unable to connect to the remote server'
		}
		
		$ChromeDriver.FindElementByName('session[password]').SendKeys($strPwd)
		$ChromeDriver.FindElementByTagName('body').SendKeys([OpenQA.Selenium.Keys]::TAB + [OpenQA.Selenium.Keys]::ENTER)
		
		Sleep(3)
		try
		{
			$ChromeDriver.FindElementByXPath('/html/body/div/div/div/div[2]/main/div/div/div/div[1]/div/div[2]/div/div[2]/div[1]/div/div/div/div[2]/div[1]/div/div/div/div/div/div/div/div/div/div[1]/div/div/div/div[2]/div/div/div/div')
			Endfunction '200 - Connect Success'
		}
		catch
		{
			Endfunction '403 - Forbidden' 1
		}
				
    }
	

	'changepass'
	{
		$ChromeDriver = New-Object OpenQA.Selenium.Chrome.ChromeDriver($ChromeOptions)
		$ChromeDriver.Url = $strFullURL
		Sleep(3)
		#write-host 'connecting'
		write-host $strNewPwd
		try
		{
			$ChromeDriver.FindElementByName('session[username_or_email]').SendKeys($strUserName)
			$ChromeDriver.FindElementByName('session[password]').SendKeys($strPwd)
			$ChromeDriver.FindElementByTagName('body').SendKeys([OpenQA.Selenium.Keys]::TAB + [OpenQA.Selenium.Keys]::ENTER)
		}
		catch
		{
			Endfunction 'Unable to connect to the remote server' 1
			Exit
		}
		
		Sleep(3)
		try
		{
			$ChromeDriver.Url = 'https://twitter.com/settings/password'
			Sleep(3)
			#write-host 'changing pass'
			$ChromeDriver.FindElementByName('current_password').SendKeys($strPwd)
			$ChromeDriver.FindElementByName('new_password').SendKeys($strNewPwd)
			$ChromeDriver.FindElementByName('password_confirmation').SendKeys($strNewPwd)
			Sleep(1)
			$ChromeDriver.FindElementByName('password_confirmation').SendKeys([OpenQA.Selenium.Keys]::TAB + [OpenQA.Selenium.Keys]::ENTER)
		}
		catch
		{
			Endfunction '401 - Unauthorized here'
		}
		
		Sleep(3)

		Endfunction '200 - Change Password Success'
	}


	default
	{
		Endfunction '404 - Not Found' 1
	}
}
    


<#
#Input selection
$ChromeDriver.FindElementById('')
$ChromeDriver.FindElementByXPath('')
$ChromeDriver.FindElementByName('')
$ChromeDriver.FindElementByClassName('')

#Other options
$ChromeDriver.FindElementByCssSelector('')
$ChromeDriver.FindElementByLinkText('Welcome to Twitter!')
$ChromeDriver.FindElementByPartialLinkText('')
$ChromeDriver.FindElementByTagName('')

#Button
$ChromeDriver.FindElementById('wp-submit').Click()
$ChromeDriver.FindElementByXPath('//*[@id="main"]/div[2]/div[1]/article/h2/a').Click()

#SendKeys
$ChromeDriver.FindElementsById('user_login').SendKeys('yourlogin@domain.com')

#Send ENTER or TAB (Always start with a tab, use 'body' to always able to find the element
$ChromeDriver.FindElementByTagName('body').SendKeys([OpenQA.Selenium.Keys]::TAB + [OpenQA.Selenium.Keys]::ENTER)
#>
