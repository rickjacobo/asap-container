param (
	[parameter(mandatory=$false,position=1)]
	$ComputerName,
	[parameter(mandatory=$false,position=2)]
	$Datastore,	
	[parameter(mandatory=$false,position=3)]
	$NetworkName,
	[parameter(mandatory=$false,position=4)]
	$VMHost,
	[parameter(mandatory=$true,position=5)]
	$MemoryGB,
	[parameter(mandatory=$true,position=6)]
	$NumCPU,
	[parameter(mandatory=$true,position=7)]
	$Template,
	[parameter(mandatory=$false,position=8)]
	$AdditionalDiskGB,
	[Switch]$Start
	
)
$ProgressPreference = "SilentlyContinue"
try {Connect-VIServer -Server $ENV:ENV_VISERVER -User $ENV:ENV_VISERVER_USER -Password $ENV:ENV_VISERVER_PASSWORD | Out-Null} catch {}

if (Get-VM $ComputerName) {Write-Host "$ComputerName already exists!"}
else {

if ($ComputerName) {
	
}
else {
	$ComputerName = ./modules/name/name.ps1
}

$Datastore = (Get-Datastore | where Name -like "*$Datastore*" | sort-object FreeSpaceGB -Descending | select -First 1).name
$VMHost = (Get-VMHost | where Name -like "*$VMHost*" | sort-object MemoryUsageGB | select -First 1).Name
New-VM -Name $ComputerName -datastore $Datastore -vmhost $VMHost -NetworkName $NetworkName -template $Template -confirm:$false | Select Id -OutVariable ID | Out-Null

Do {Start-Sleep -Seconds 3} while (Get-Task |  sort-object StartTime -Descending | where {$_.Description -like "*Clone*" -and $_.State -ne "Success" -and $_.ObjectId -eq "$ID"} )
Set-VM -VM $ComputerName -MemoryGB $MemoryGB -NumCpu $NumCPU -Confirm:$false | Out-Null

if ($AdditionalDiskGB) {
New-HardDisk -VM $ComputerName -CapacityGB $AdditionalDiskGB -StorageFormat Thin -Confirm:$false | Select Name,CapacityGB,StorageFormat | Out-Null
}

if ($Start) {
Write-Host "Starting $ComputerName"
Start-VM -VM $ComputerName -Confirm:$false | Out-Null
}


}
