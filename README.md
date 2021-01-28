# CyberArk-WebPlugin-Powershell-Selenium-Chrome
CyberArk custom CPM web plugins.

## What to do
1. Copy everything to CPM installation directory (use bin folder as reference)
2. Edit /bin/template.ps1, and /bin/seleniumprocess.ini and /bin/seleniumprompts.ini
3. Create a platform that and point prompts and process files to the one we use here.
4. Test by running "run.cmd verifypass", "run.cmd logon", "run.cmd changepass". Remember to update cpmparm.ini accordingly.

## Things to note
1. Make sure to use the latest chrome driver that matches your chrome's version, copy it under lib folder.
2. Remember to rename the prompt and process files for your own use.
3. Inside process file, change the script location/name under Start Powershell script section
4. Make sure that the parameters pass to the PS script isnt missing, otherwise the order of the parameters will be wrong
5. PS template include 3 sections (verifypass, changepass, logon). Can add more as required.
6. Double check all init variables in PS script are all in place.
7. Make sure the Dependencies path is correct in PS script
8. **Avoid special characters!!!**


## Commonly used functions
*More functions can be found via webdriver.xml (inside lib folder)*
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

##### Send ENTER or TAB (Always start with a tab, use 'body' to always able to find the element
```
$ChromeDriver.FindElementByTagName('body').SendKeys([OpenQA.Selenium.Keys]::TAB + [OpenQA.Selenium.Keys]::ENTER)
```
