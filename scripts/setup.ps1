try {Set-PowerCLIConfiguration -Scope User -ParticipateInCEIP:$false -Confirm:$false -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Out-Null} catch {}
try {Set-PowerCLIConfiguration -InvalidCertificateAction:Ignore -Confirm:$false -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Out-Null} catch {}
