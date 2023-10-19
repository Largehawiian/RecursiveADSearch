#
[cmdletbinding()]
param(
    [parameter(Mandatory)][String]$GroupToSearch,
    [parameter(Mandatory)][String]$ExportPath
)
$Return = [System.Collections.ArrayList]::New()
Get-ADGroupMember -Recursive -Identity $GroupToSearch | Foreach-Object {
    $MemberOfGroups = [System.Collections.ArrayList]::New()
    (Get-ADUser $_.SamAccountName -Properties memberOf).Memberof | ForEach-Object {
        $o = $_.Split("=")[1].split(",")[0]
        [void]$MemberOfGroups.Add($o)
    }
    $o = [pscustomobject]@{
        "Secret Agent Name" = $_.Name
        Groups              = $MemberOfGroups -join ", "
    }
    [void]$Return.Add($o)
}
$Return | Export-Csv -NoTypeInformation -Path $ExportPath