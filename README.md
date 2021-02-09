# CyberArk-WebPlugin-Powershell-Selenium-Chrome
CyberArk custom CPM web plugins.

#### Process Flow:
CPM (TPC) -> (SPAWN)PowerShell Script -> PowerShell output matching prompts file -> CPM (Success/Failure)

## What to do
1. Copy everything to CPM installation directory (use bin folder as reference, can exclude /bin/examples)
2. Edit /bin/template.ps1, /bin/Seleniumprocess.ini and /bin/Seleniumprompts.ini
3. Create a platform and points prompts and process files to the one we use here.
4. Test each stages in PS(PowerShell) by running "run.cmd verifypass", "run.cmd logon", "run.cmd changepass". Remember to update cpmparm.ini accordingly.

## Things to note
1. Make sure to use the latest chrome driver that matches your chrome's version, copy it under lib folder.
2. (Optional) Rename the prompt and process files.
3. Inside process file, change the script path under Start Powershell script section.
4. Make sure that the parameters pass to the PS script isn't missing or empty, otherwise the order of the parameters will be wrong.
5. PS template include 3 sections (verifypass, changepass, logon). Can add more as needed.
6. Double check all init variables in PS script are all in place.
7. Make sure the dependencies path is correct in PS script
8. **Password generation should avoid special characters!!!**


## Commonly used functions
*More functions can be found in webdriver.xml (in lib folder)*
##### Input selection
```
$ChromeDriver.FindElementById('')
$ChromeDriver.FindElementByXPath('')
$ChromeDriver.FindElementByName('')
$ChromeDriver.FindElementByClassName('')
```
##### Other options
```
$ChromeDriver.FindElementByCssSelector('')
$ChromeDriver.FindElementByLinkText('Welcome to Twitter!')
$ChromeDriver.FindElementByPartialLinkText('')
$ChromeDriver.FindElementByTagName('')
```
##### Button
```
$ChromeDriver.FindElementById('wp-submit').Click()
$ChromeDriver.FindElementByXPath('//*[@id="main"]/div[2]/div[1]/article/h2/a').Click()
```
##### SendKeys
```
$ChromeDriver.FindElementsById('user_login').SendKeys('yourlogin@domain.com')
```

##### Send ENTER or TAB (Start by locating an element, use 'body' if not able to find any element)
```
$ChromeDriver.FindElementByTagName('body').SendKeys([OpenQA.Selenium.Keys]::TAB + [OpenQA.Selenium.Keys]::ENTER)
```

## Drivers

##### Selenium
Download and extract it with 7zip. Copy the .dll and .xml files under lib folder.
```
https://www.nuget.org/packages/Selenium.WebDriver
```

##### Chrome 
```
https://sites.google.com/a/chromium.org/chromedriver/
```
