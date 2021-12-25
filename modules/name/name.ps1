$CurrentDir = PWD
cd $PSScriptRoot
$Name = (Get-Random (Get-Content ./adjectives.txt)) + "-" + (Get-Random (Get-Content ./colors.txt)) + "-" + (Get-Random (Get-Content ./nouns.txt))
$Name
cd $CurrentDir
