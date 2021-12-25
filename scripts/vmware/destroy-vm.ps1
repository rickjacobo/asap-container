param (
        [parameter(mandatory=$true,position=1)]
        $ComputerName
)
$ProgressPreference = "SilentlyContinue"
try {Connect-VIServer -Server $ENV:ENV_VISERVER -User $ENV:ENV_VISERVER_USER -Password $ENV:ENV_VISERVER_PASSWORD | Out-Null} catch {}
try {Stop-VM $ComputerName -Confirm:$false ; Remove-VM $ComputerName -Confirm:$false -DeletePermanently} catch {}
