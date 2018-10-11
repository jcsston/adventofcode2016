

# aba[bab]xyz supports SSL (aba outside square brackets with corresponding bab within square brackets).
# xyx[xyx]xyx does not support SSL (xyx, but no corresponding yxy).
# aaa[kek]eke supports SSL (eke in supernet with corresponding kek in hypernet; the aaa sequence is not related, because the interior character must be different).
# zazbz[bzb]cdb supports SSL (zaz has no corresponding aza, but zbz has a corresponding bzb, even though zaz and zbz overlap).

function Get-ABA {
    param( [array]$sequences )
    $ABAlist = New-Object System.Collections.Generic.List[System.Object]
    foreach ($seq in $sequences) {
        for ($i = 0; ($i + 3) -le $seq.Length; $i++) {
            $part = $seq.Substring($i, 3);
            $outerMatches = $part[0] -eq $part[2]
            $innerDifferent = $part[0] -ne $part[1]
            if ($outerMatches -and $innerDifferent) {
                $ABAlist.Add($part)
            }
        }
    }
    $ABAlist
}

function Has-BAB {
    param( [array]$sequences, [string]$aba )
    $hasBAB = $false
    foreach ($seq in $sequences) {
        for ($i = 0; ($i + 3) -le $seq.Length; $i++) {
            $part = $seq.Substring($i, 3);
            $outerMatchInner = ($part[0] -eq $aba[1]) -and ($part[2] -eq $aba[1])
            $innerMatchingOuter = ($part[1] -eq $aba[0]) -and ($part[1] -eq $aba[2])
            if ($outerMatchInner -and $innerMatchingOuter) {
                $hasBAB = $true
            }
        }
    }
    $hasBAB
}

$input = "aba[bab]xyz
xyx[xyx]xyx
aaa[kek]eke
zazbz[bzb]cdb"

$input = Get-Content -Path "day7.txt"

$sslSupportCount = 0
foreach ($line in $input.Split("`n")) {
    $line = $line.Trim()
    
    $outerSequences = New-Object System.Collections.Generic.List[System.Object]
    $hypernetSeqs = New-Object System.Collections.Generic.List[System.Object]

    $outerSequence = ''
    $hypernetSeq = ''
    $hypernetSeqSection = 0
    foreach ($character in $line.ToCharArray()) {
        if ($character -eq '[') {
            $hypernetSeqSection = 1
            $outerSequences.Add($outerSequence)
            $outerSequence = ''
        } elseif ($character -eq ']') {
            $hypernetSeqSection = 0
            $hypernetSeqs.Add($hypernetSeq)
            $hypernetSeq = ''
        } else {
            # Check if we are reading in the hypernet
            if ($hypernetSeqSection) {
                $hypernetSeq += $character
            } else {
                $outerSequence += $character
            }
        }
    }
    if ($outerSequence.Length -gt 0) {
        $outerSequences.Add($outerSequence)
    }


    $ABAlist = Get-ABA $outerSequences
    foreach ($aba in $ABAlist) {
        if (Has-BAB $hypernetSeqs $aba) {
            Write-Output "Line $line supports SSL"
            $sslSupportCount++
            break
        }
    }
}

Write-Output "$sslSupportCount IPs support SSL"
