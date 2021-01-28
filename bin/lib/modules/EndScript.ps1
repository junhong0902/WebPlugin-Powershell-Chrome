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