<#
  .SYNOPSIS
   Build Passphrase using dice rolls.

   Prerequisites:
   1: Tab separated word list file with two columns per row
        DiceRoll = 11111-16666, 21111-26666 and so on, up to 61111-66666
        Word     = single word
     
      Protip: Download eff_large_wordlist.txt from https://www.eff.org/dice
      Place wordlist(s) in script folder or subfolder Resources

   2: Import the Get-Passphrase.ps1 module using the command
        Import-Module .\Get-PassPhrase.ps1 -Force
     
  .LINK
   https://github.com/dotBATman_no/ps-Get-PassPhrase/

   .EXAMPLE
   PS C:\Scripts\Get-PassPhrase> Import-Module .\Get-PassPhrase.ps1 -Force
   PS C:\Scripts\Get-PassPhrase> Get-PassPhrase
   BaconAcornMultiply
   .EXAMPLE
   PS C:\Scripts\Get-PassPhrase> Import-Module .\Get-PassPhrase.ps1 -Force
   PS C:\Scripts\Get-PassPhrase> Get-PassPhrase -Words 4 -Space 1
   Guide Promenade Epileptic Snowboard
   .EXAMPLE
   PS C:\Scripts\Get-PassPhrase> Import-Module .\Get-PassPhrase.ps1 -Force
   PS C:\Scripts\Get-PassPhrase> Get-WordList -Casing lower
   PS C:\Scripts\Get-PassPhrase> Get-PassPhrase -Words 4 -Space 1
   number dining shelter landlady
   .EXAMPLE
   PS C:\Scripts\Get-PassPhrase> Import-Module .\Get-PassPhrase.ps1 -Force
   PS C:\Scripts\Get-PassPhrase> "User", "UserName", "UserLongName" | ForEach-Object -Process { Get-PassPhrase -User $_ }
   User                    GearDaycareShed
   UserName                JaundiceBrookReliable
   UserLongName            AliasGroomAnteater
   .EXAMPLE
   PS C:\Scripts\Get-PassPhrase> Import-Module .\Get-PassPhrase.ps1 -Force
   PS C:\Scripts\Get-PassPhrase> "User", "UserName", "UserLongName" | ForEach-Object -Process { Get-PassPhrase -Words 4 -Space 1 -User $_ }
   User                    Dimness Crunching Cannon Plausible
   UserName                Sitter Calm Astronaut Molehill
   UserLongName            Astronaut Problem Kissable Harmonize
   
#>

Function Get-Passphrase
{
  [CmdletBinding()]
  Param (
    # Choose the number of words to use for your passphrase.
    [Parameter(Position=0)]
     [int]$Words = 3,
    # Specify if each word should be separated by space.    
    [Parameter(Position=1)]
     [bool]$Space = $false,
    # Name the user that needs a new password.
    [Parameter(Position=2)]
    [string]$User)
  
  <#
    .SYNOPSIS
    Create a Pass Phrase consisting of X number of words.

    .EXAMPLE
    Get-Passphrase -Words 3 -Case TitleCase

  #>

  if ($null -eq $htWordList) 
  { 
    try   { Get-WordList }
    catch { Throw "Script failed to load required resource (wordlist)." }
  }
       
  # Repeats X times
  for (($i=0), ($strTempPwd = "");$i -lt $Words;$i++)
  {
    # Roll 5 dice
    $iDiceRoll =  (Get-Random -Minimum 1 -Maximum 6)*10000
    $iDiceRoll += (Get-Random -Minimum 1 -Maximum 6)*1000
    $iDiceRoll += (Get-Random -Minimum 1 -Maximum 6)*100
    $iDiceRoll += (Get-Random -Minimum 1 -Maximum 6)*10
    $iDiceRoll += (Get-Random -Minimum 1 -Maximum 6)*1
        
    # Retrieve corresponding word from Wordlist
    $strPassphrase += $htWordList["$iDiceRoll"]
    if ( $Space ) { $strPassphrase += " " }
  
  }
  
  # Avoid space at the end of pass phrase! 
  if ($user)
  { Return "$($User.Padright(22," "))$($strPassphrase.TrimEnd())" } 
  else
  { Return $strPassphrase.TrimEnd() }  
  
}

Function Get-WordList
{
  [CmdletBinding()]
  Param (
    # Default is to use EFF 5 dice Word List eff_large_wordlist.txt, see https://www.eff.org/dice.
    [Parameter(Position=0)]
    [string]$WordList = "eff_large_wordlist.txt",
    # Select UPPER/lower/TitleCase - leave blank to keep casing from wordlist file.
    [Parameter(Position=1)]
    [ValidateSet("UPPER", "lower", "Title", "TitleCase", "Proper")]
    [string]$Casing = "TitleCase")
  
  $TextInfo = (Get-Culture).TextInfo
  $ResourcePath = Split-Path -parent $PSCommandPath      # Use the folder the script was started from
  
  If (Test-Path -Path "$ResourcePath\Resources\$WordList" -PathType Leaf) 
  {
    $strWordListFile = "$ResourcePath\Resources\$WordList" 
  }
  else
  {
    $strWordListFile = "$ResourcePath\$WordList"     
  }

  If (Test-Path -Path $strWordListFile -PathType Leaf)
  {
    # File Exists, build hashtable
    $arrWordList = Import-Csv -path $strWordListFile -Header "DiceRoll", "Word" -Delimiter "`t" 
    
    # Define ordered hashtable for diceroll word list
    # Ensure variable is not defined already
    Remove-Variable -ErrorAction SilentlyContinue htWordList
    $global:htWordList = [ordered]@{}
    switch ($Casing) 
    {
        
      $null   { for ($i=0;$i -lt $arrWordList.Count;$i++) { $htWordList.Add($arrWordList[$i].DiceRoll, $arrWordList[$i].Word) }                        } # UsE CaSing fRom wOrD list
      "UPPER" { for ($i=0;$i -lt $arrWordList.Count;$i++) { $htWordList.Add($arrWordList[$i].DiceRoll, $TextInfo.ToUpper($arrWordList[$i].Word)) }     } # Use UPPERCASE for all words
      "lower" { for ($i=0;$i -lt $arrWordList.Count;$i++) { $htWordList.Add($arrWordList[$i].DiceRoll, $TextInfo.ToLower($arrWordList[$i].Word)) }     } # Use lowercase for all words
      Default { for ($i=0;$i -lt $arrWordList.Count;$i++) { $htWordList.Add($arrWordList[$i].DiceRoll, $TextInfo.ToTitleCase($arrWordList[$i].Word)) } } # Use Title Case For All Words
    
    } 
    Remove-Variable arrWordList # Remove array holding wordlist file
   
  }
  else
  {
    
    Write-Host "File not found: $strWordListFile

    Issue: Could not locate word list to use for diceroll pass phrase generation!
    
    Pro-tip to help build passphrases that are easy to communicate:
    Download the file 'eff_large_wordlist.txt' from https://www.eff.org/dice
    The script will default to use this file if present.
    
    Alternatively: 
    Create a 5 dice wordlist file and place this in script folder (or subfolder Resources).
    Name this file using the -WordList parameter
    
    The Wordlist file must hold two columns per row separated by <tab> character.
      'DiceRoll' =  five dice combinations, starting at 11111 and ending at 66666.
      'Word'     =  corresponding word.
    
    Example (based on eff_large_wordlist.txt):
       11111<tab>abacus
       [..]
       16666<tab>copilot
       21111<tab>coping
       [..]
       26666<tab>five
       [..]
       66666<tab>zoom
    
    "
    
    Throw
    
  }

}
