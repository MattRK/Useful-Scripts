#######Load the required PowerShell snapins and modules######
#Load the Sharepoint Management cmdlets
Add-PsSnapin Microsoft.SharePoint.PowerShell 

######Sharepoint Variables######
#Define the top level site collection
$spSiteCollection = "http://url.tothesitecollection.com/NameOfSiteCollection"
#Define the Specific document library we will import the XML files into
$spDocumentLibrary = "Form Document Library"

######Path Variables######
#Define the XML incoming path
$XMLIncomingPath = "c:\xmlincoming"
#Define the XML archival path
$XMLArchivePath = "c:\xmlincoming\archive"

######Import the files into Sharepoint######

#Setup the connection to the sharepoint site and document library
$spWeb = get-spweb -Identit $spSiteCollection
$spFolder = $spweb.getfolder($spDocumentLibrary)
$spfilecollection = $spfolder.files

#Define the directory to get the XML files from & limit the scope to just XML files
$directory = get-childitem $XMLIncomingPath\*.* -include *.xml

#Loop through process all of the files in the directory
foreach ($file in $directory) {
	#Add the file to the library
	$spfilecollection.Add("$spDocumentLibrary/$($file.Name)",$file.OpenRead(), $false)
	
	#Wait for Powershell to close the file
	Start-Sleep -Second 10
	
	#Move the file from the incoming folder to the archive folder
	Move-Item $file $XMLArchivePath
}