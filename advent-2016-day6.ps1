
$input = Get-Content -Path "day6.txt"

$messageLetterMap = @()
$message = ''

foreach ($line in $input.Split("`n")) {
    $line = $line.Trim()

    $pos = 0
    # Parse room details
    foreach ($character in $line.ToCharArray()) {
        # Create map for this position if we haven't yet
        if ($messageLetterMap.Count -le $pos) {
            $messageLetterMap += @{}
        }
        # Increment the count this character has been found in this position
        if ($messageLetterMap[$pos].Contains($character)) {
            $messageLetterMap[$pos][$character] += 1;
        } else {
            $messageLetterMap[$pos][$character] = 1;
        }
        $pos++
    }
}

foreach ($letterMap in $messageLetterMap) {
    $letter = $letterMap.GetEnumerator() | Sort-Object @{Expression="Value"; Ascending=$false}, @{Expression="Key"; Ascending=$true} | Select-Object -First 1
    $message += $letter.Key
}

Write-Output "Error corrected message: $message"
