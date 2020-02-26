# PS-Get-PassPhrase
PowerShell module to build a passphrase by rolling 5 dice.
The assumption is that we use the wordlist eff_large_wordlist.txt from https://www.eff.org/dice.
But it is possible to build your own wordlist.

Output is accessible in PowerShell pipeline.

```
PS C:\> Import-Module .\Get-PassPhrase.ps1 -Force
PS C:\> Get-Help Get-Passphrase -Full
```
More information and examples can be found using Get-Help, see output below:
```
NAME
    Get-PassPhrase

SYNOPSIS
    Build Passphrase using dice rolls.

    Prerequisites:
    1: Tab separated word list file with two columns per row
         DiceRoll = 11111-16666, 21111-26666 and so on, up to 61111-66666
         Word     = single word

       Protip: Download eff_large_wordlist.txt from https://www.eff.org/dice
       Place wordlist(s) in script folder or subfolder Resources

    2: Import the Get-Passphrase.ps1 module using the command
         Import-Module .\Get-PassPhrase.ps1 -Force

SYNTAX
    Get-Passphrase [[-Words] <Int32>] [[-Space] <Boolean>] [[-User] <String>] [<CommonParameters>]

DESCRIPTION
    PowerShell script to build a passphrase by rolling 5 dice.

PARAMETERS
    -Words <Int32>
        Choose the number of words to use for your passphrase.

        Required?                    false
        Position?                    1
        Default value                3
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -Space <Boolean>
        Specify if each word should be separated by space.

        Required?                    false
        Position?                    2
        Default value                False
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -User <String>
        Name the user that needs a new password.

        Required?                    false
        Position?                    3
        Default value
        Accept pipeline input?       false
        Accept wildcard characters?  false

    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see
        about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

    -------------------------- EXAMPLE 1 --------------------------

    PS C:\Scripts\Get-PassPhrase> Import-Module .\Get-PassPhrase.ps1 -Force
    PS C:\Scripts\Get-PassPhrase> Get-PassPhrase
    BaconAcornMultiply

    -------------------------- EXAMPLE 2 --------------------------

    PS C:\Scripts\Get-PassPhrase> Import-Module .\Get-PassPhrase.ps1 -Force
    PS C:\Scripts\Get-PassPhrase> Get-PassPhrase -Words 4 -Space 1
    Guide Promenade Epileptic Snowboard

    -------------------------- EXAMPLE 3 --------------------------

    PS C:\Scripts\Get-PassPhrase> Import-Module .\Get-PassPhrase.ps1 -Force
    PS C:\Scripts\Get-PassPhrase> Get-WordList -Casing lower
    PS C:\Scripts\Get-PassPhrase> Get-PassPhrase -Words 4 -Space 1
    number dining shelter landlady

    -------------------------- EXAMPLE 4 --------------------------

    PS C:\Scripts\Get-PassPhrase> Import-Module .\Get-PassPhrase.ps1 -Force
    PS C:\Scripts\Get-PassPhrase> "User", "UserName", "UserLongName" | ForEach-Object -Process { Get-PassPhrase -User $_ }
    User                    GearDaycareShed
    UserName                JaundiceBrookReliable
    UserLongName            AliasGroomAnteater

    -------------------------- EXAMPLE 5 --------------------------

    PS C:\Scripts\Get-PassPhrase>Import-Module .\Get-PassPhrase.ps1 -Force
    PS C:\Scripts\Get-PassPhrase> "User", "UserName", "UserLongName" | ForEach-Object -Process { Get-PassPhrase -Words 4 -Space 1 -Us
    er $_ }
    User                    Dimness Crunching Cannon Plausible
    UserName                Sitter Calm Astronaut Molehill
    UserLongName            Astronaut Problem Kissable Harmonize

RELATED LINKS
    https://github.com/dotBATman_no/ps-Get-PassPhrase/
