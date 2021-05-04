#Make sure to use the latest selenium dll and the chrome driver that matches your chrome's version
$PathToFolder = 'D:\Program Files (x86)\CyberArk\Password Manager\bin\Selenium-Plugin'
[System.Reflection.Assembly]::LoadFrom("D:\Program Files (x86)\CyberArk\Password Manager\bin\Selenium-Plugin\WebDriver.dll" -f $PathToFolder)
if ($env:Path -notcontains ";$PathToFolder" ) {
    $env:Path += ";$PathToFolder"
}
Add-Type -AssemblyName System.Windows.Forms


# Init variable
$strURL = 'https://'
$strActionName = $args[0]
$intState = $args[1]
$strUserName = $args[2]
$strAddress = $args[3]
$strPwd = $args[4]
$strNewPwd = $args[5]
$strLogonUserName = $args[6]
$strLogonPwd = $args[7]

$temp = '/admin/login.jsp'
$strFullURL = "$strURL$strAddress$temp"

#Edit this script to handle end of script (clear chrome)
function Endfunction
{
    # Function params
    Param (
    $Errorcode, $stop
    )
    #write-host $stop
	if ($stop -ne 1)
	{
		#If logout required
        $temp = "/admin/logout.jsp"
		$ChromeDriver.Url = "$strURL$strAddress$temp"
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
			$ChromeDriver.FindElementById('dijit_form_TextBox_0').SendKeys($strUserName)
		}
		catch
		{
			Endfunction 'Unable to connect to the remote server' 1
			break
		}
		
		$ChromeDriver.FindElementById('dijit_form_TextBox_1').SendKeys($strPwd)
        Sleep(1)
        $ChromeDriver.FindElementById('authTypeId').SendKeys("Internal");
        Sleep(1)
        $ChromeDriver.FindElementById('loginPage_loginSubmit_label').Click()

        Sleep(10)
        $ChromeDriver.FindElementById('carousel-next').Click()
		Sleep(10)
		try
		{
            $ChromeDriver.FindElementById('bs-example-navbar-collapse-1')
		}
		catch
		{
			Endfunction '403 - Forbidden' 1
		}
        Endfunction '200 - Connect Success'
				
    }


	'Logon'
    {
		$ChromeDriver = New-Object OpenQA.Selenium.Chrome.ChromeDriver($ChromeOptions)
		$ChromeDriver.Url = $strFullURL
		Sleep(3)
		write-host $strFullURL
		try
		{
			$ChromeDriver.FindElementById('dijit_form_TextBox_0').SendKeys($strLogonUserName)
		}
		catch
		{
			Endfunction 'Unable to connect to the remote server'
			break
		}
		
		$ChromeDriver.FindElementById('dijit_form_TextBox_1').SendKeys($strLogonPwd)
        Sleep(1)
        $ChromeDriver.FindElementById('authTypeId').SendKeys("Internal");
        Sleep(1)
        $ChromeDriver.FindElementById('loginPage_loginSubmit_label').Click()
        Sleep(10)
        $ChromeDriver.FindElementById('carousel-next').Click()
		Sleep(10)
		try
		{
            $ChromeDriver.FindElementById('bs-example-navbar-collapse-1')
		}
		catch
		{
			Endfunction '403 - Forbidden' 1
		}
        Endfunction '200 - Connect Success'
				
    }
	

	'changepass'
	{
		$ChromeDriver = New-Object OpenQA.Selenium.Chrome.ChromeDriver($ChromeOptions)
		$ChromeDriver.Url = $strFullURL
		Sleep(3)
		#write-host $strFullURL
		try
		{
			$ChromeDriver.FindElementById('dijit_form_TextBox_0').SendKeys($strLogonUserName)
		}
		catch
		{
			Endfunction 'Unable to connect to the remote server'
			break
		}
		
		$ChromeDriver.FindElementById('dijit_form_TextBox_1').SendKeys($strLogonPwd)
        Sleep(1)
        $ChromeDriver.FindElementById('authTypeId').SendKeys("Internal")
        Sleep(1)
        $ChromeDriver.FindElementById('loginPage_loginSubmit_label').Click()

        Sleep(10)
        $ChromeDriver.FindElementById('carousel-next').Click()
		Sleep(10)
		try
		{
            $ChromeDriver.FindElementById('bs-example-navbar-collapse-1')
		}
		catch
		{
			Endfunction '403 - Forbidden' 1
		}
		
		Sleep(3)
        
        $temp= "/admin/#administration/administration_identitymanagement/administration_identitymanagement_identities/users"
		$strFullURL = "$strURL$strAddress$temp"
        $ChromeDriver.Url = $strFullURL
		Sleep(3)

        $ChromeDriver.FindElementById('nacUserTable_xwtTableContextualToolbar_FilterToggleButton').Click()
        Sleep(3)
        $ChromeDriver.FindElementById('xwt_widget_table__ByExampleWidget_1').SendKeys($strUserName)
        Sleep(5)
        $ChromeDriver.FindElementByXPath('//*[@id="nacUserTable"]/div[4]/div[2]/div[2]/div/table/tbody/tr/td[1]/div/div').SendKeys([OpenQA.Selenium.Keys]::ENTER)
        #write-host "Successfully select user\n"

		try
		{
     
            Sleep(2)
            $ChromeDriver.FindElementById('nacUserEditBtn_label').Click()
            Sleep(1)
            $ChromeDriver.FindElementById('nsfUserPwd').SendKeys($strNewPwd)
            Sleep(1)
            $ChromeDriver.FindElementById('nsfUserPwd2').SendKeys($strNewPwd)
            Sleep(1)
            
            $ChromeDriver.FindElementById('submitBtn_label').Click()
            Sleep(1)
		}
		catch
		{
			Endfunction '401 - Unauthorized'
            break
		}
		
        Sleep(1)

        if ($ChromeDriver.FindElementByXPath('/html/body/div[44]').length -ne 0)
        {
            write-host "Password changed successfully"
            Endfunction '200 - Change Password Success'
        }
        else
        {
            write-host "Not detected any success prompt, checking failure pop-up"
        }

		Sleep(3)
           

        #Try to catch for password change failure
        try
		{
            Sleep(2)
            $ChromeDriver.FindElementByXPath('/html/body/div[47]/div/div/div[2]/div')
            Sleep(1)
            $ChromeDriver.FindElementById('xwt_widget_form_TextButton_10').Click()
            Sleep(2)
            #Redirect somewhere else before logging out. (pop up blocking logout)
            $ChromeDriver.FindElementByXPath('/html/body/div[39]/div[1]/div/ul/ul/li[1]/a').Click()
            Sleep(2)
            $ChromeDriver.FindElementByXPath('/html/body/div[48]/div/div/div[4]/div/button[2]').Click()

            Endfunction 'Invalid New Password'
            
		}
		catch
		{
            
			Endfunction '200 - Change Password Success'
            break
		}
        
        #Endfunction 'Invalid New Password'
		
	}


	default
	{
		Endfunction '404 - Not Found' 1
	}
}
    
