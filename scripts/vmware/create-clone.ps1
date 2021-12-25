param (
    [parameter(mandatory=$true,position=1)]
    $ComputerName,
    [parameter(mandatory=$false,position=2)]
    $VMHost,
    [parameter(mandatory=$false,position=3)]
    $Datastore,
	[parameter(mandatory=$true,position=4)]
    $SnapshotVM,
	[parameter(mandatory=$true,position=5)]
    $Snapshot

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

$Notes = "$SnapshotVM clone (linked)"
$Snap = Get-Snapshot -VM $SnapshotVM -Name $Snapshot
New-VM -Name $ComputerName -VMHost $VMHost -Datastore $Datastore -VM $Snap.VM -ReferenceSnapshot $Snap -LinkedClone -Notes $Notes | Out-Null

Start-VM $ComputerName | Out-Null
}
