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
			Endfunction 'Unable to connect to the remote server'
			break
		}
		
		$ChromeDriver.FindElementById('dijit_form_TextBox_1').SendKeys($strPwd)
        $ChromeDriver.FindElementById('authTypeId').SendKeys("Internal");
        
        $ChromeDriver.FindElementById('loginPage_loginSubmit_label').Click()

        Sleep(10)
        $ChromeDriver.FindElementById('carousel-next').Click()
        #Sleep(10)
		#$ChromeDriver.FindElementById('dijit_form_TextBox_1').SendKeys([OpenQA.Selenium.Keys]::TAB + [OpenQA.Selenium.Keys]::ENTER + [OpenQA.Selenium.Keys]::ENTER)
		
		try
		{
            $ChromeDriver.FindElementById('bs-example-navbar-collapse-1')
			#$ChromeDriver.FindElementByXPath('/html/body/div/div/div/div[2]/main/div/div/div/div[1]/div/div[2]/div/div[2]/div[1]/div/div/div/div[2]/div[1]/div/div/div/div/div/div/div/div/div/div[1]/div/div/div/div[2]/div/div/div/div')
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
        $ChromeDriver.FindElementById('authTypeId').SendKeys("Internal");
        
        $ChromeDriver.FindElementById('loginPage_loginSubmit_label').Click()
        write-host "11111111111111111"
        write-host $strLogonUserName
        write-host "11111111111111111"
        write-host $strLogonPwd
        Sleep(10)
        $ChromeDriver.FindElementById('carousel-next').Click()
        write-host "22222222222222222"
        #Sleep(10)
		#$ChromeDriver.FindElementById('dijit_form_TextBox_1').SendKeys([OpenQA.Selenium.Keys]::TAB + [OpenQA.Selenium.Keys]::ENTER + [OpenQA.Selenium.Keys]::ENTER)
		
		try
		{
            $ChromeDriver.FindElementById('bs-example-navbar-collapse-1')
			#$ChromeDriver.FindElementByXPath('/html/body/div/div/div/div[2]/main/div/div/div/div[1]/div/div[2]/div/div[2]/div[1]/div/div/div/div[2]/div[1]/div/div/div/div/div/div/div/div/div/div[1]/div/div/div/div[2]/div/div/div/div')
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
        $ChromeDriver.FindElementById('authTypeId').SendKeys("Internal")
        
        $ChromeDriver.FindElementById('loginPage_loginSubmit_label').Click()

        Sleep(20)
        $ChromeDriver.FindElementById('carousel-next').Click()
        #Sleep(10)
		#$ChromeDriver.FindElementById('dijit_form_TextBox_1').SendKeys([OpenQA.Selenium.Keys]::TAB + [OpenQA.Selenium.Keys]::ENTER + [OpenQA.Selenium.Keys]::ENTER)
		
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
        Sleep(8)
        write-host "1111111111111111111111111111changepass"
        $ChromeDriver.FindElementByXPath('//*[@id="nacUserTable"]/div[4]/div[2]/div[2]/div/table/tbody/tr/td[1]/div/div').SendKeys([OpenQA.Selenium.Keys]::ENTER)
        #$ChromeDriver.FindElementByXPath('//*[@id="nacUserTable"]/div[4]/div[2]/div[2]/div/table/tbody/tr/td[1]/div/div').Click()
        #$ChromeDriver.FindElementByXPath('//*[@id="nacUserTable"]/div[4]/div[2]/div[2]/div/table/tbody/tr/td[1]/div/div/input').Click()
        write-host "2222222222222222222222222"

		try
		{
     
            Sleep(2)
            $ChromeDriver.FindElementById('nacUserEditBtn_label').Click()
            Sleep(3)
            write-host "3333333333333333333333333333"
            $ChromeDriver.FindElementById('nsfUserPwd').SendKeys($strNewPwd)
            $ChromeDriver.FindElementById('nsfUserPwd2').SendKeys($strNewPwd)
            
            $ChromeDriver.FindElementById('submitBtn_label').Click()
		}
		catch
		{
			Endfunction '401 - Unauthorized here'
            break
		}
		
		Sleep(3)

		Endfunction '200 - Change Password Success'
	}


	default
	{
		Endfunction '404 - Not Found' 1
	}
}
    
