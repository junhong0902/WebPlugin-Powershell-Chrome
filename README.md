# WebPlugin-Powershell
Make sure to use the latest selenium dll and the chrome driver that matches your chrome's version, copy it under lib folder.

CyberArk custom CPM web plugins.

## Commonly used functions
*More fucntion can be found via webdriver.xml (inside lib folder)*
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
