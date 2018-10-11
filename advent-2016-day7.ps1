

# abba[mnop]qrst supports TLS (abba outside square brackets).
# abcd[bddb]xyyx does not support TLS (bddb is within square brackets, even though xyyx is outside square brackets).
# aaaa[qwer]tyui does not support TLS (aaaa is invalid; the interior characters must be different).
# ioxxoj[asdfgh]zxcvbn supports TLS (oxxo is outside square brackets, even though it's within a larger string).


function Get-ABBA {
    param( [array]$sequences )
    $hasABBA = $false
    foreach ($seq in $sequences) {
        for ($i = 0; ($i + 4) -le $seq.Length; $i++) {
            $pair1 = $seq.Substring($i, 2);
            $pair2 = $seq.Substring($i+2, 2)
            $reverseMatches = ($pair1[0] -eq $pair2[1]) -and ($pair1[1] -eq $pair2[0])
            $pairsAreDifferent = $pair1 -ne $pair2
            if ($reverseMatches -and $pairsAreDifferent) {
                $hasABBA = $true
            }
        }
    }
    $hasABBA
}

$input = "abba[mnop]qrst
abcd[bddb]xyyx
aaaa[qwer]tyui
ioxxoj[asdfgh]zxcvbn"

$input = Get-Content -Path "day7.txt"

$tlsSupportCount = 0
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


    $outerSeqGood = Get-ABBA $outerSequences
    $hyperSeqNotABBA = Get-ABBA $hypernetSeqs
    #Write-Output "Line $line outerSeqGood: $outerSeqGood hyperSeqNotABBA: $hyperSeqNotABBA"

    if ($outerSeqGood -and !$hyperSeqNotABBA) {
        Write-Output "Line $line supports TLS"
        $tlsSupportCount++
    }
}

Write-Output "$tlsSupportCount IPs support TLS"
