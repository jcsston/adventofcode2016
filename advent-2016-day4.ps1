
$input = Get-Content -Path "day4.txt"

$sectorSum = 0
$lineNo = 0
$northPoleSectorId = @()

foreach ($line in $input.Split("`n")) {
    $line = $line.Trim()
    $lineNo++
    $letterMap = @{}
    $checksumSection = 0
    $checksum = ''
    $sectorId = ''
    $encryptedRoomName = ''

    # Parse room details
    foreach ($character in $line.ToCharArray()) {
        if ([System.Char]::IsLetter($character)) {
            # Check if we are reading in the checkum
            if ($checksumSection) {
                $checksum += $character
            } else {
                # Otherwise increment the count this character has been found
                if ($letterMap.Contains($character)) {
                    $letterMap[$character] += 1;
                } else {
                    $letterMap[$character] = 1;
                }
                $encryptedRoomName += $character
            }
        } elseif ([System.Char]::IsDigit($character)) {
            $sectorId += $character
        } elseif ($character -eq '[') {
            $checksumSection = 1
        } elseif ($character -eq ']') {
            $checksumSection = 0
        }  elseif ($character -eq '-') {
            # Replace with space
            $encryptedRoomName += ' '
        } else {
            Write-Error "Unhandled character $character found in line $line"
        }
    }

    # Determine if this room is valid
    $validRoom = 0
    # First get letter map and sort by value
    $checksumPos = 0
    foreach ($letter in $letterMap.GetEnumerator() | Sort-Object @{Expression="Value"; Ascending=$false}, @{Expression="Key"; Ascending=$true}) {
	    if ($checksum.Length -gt $checksumPos) {
            if ($checksum[$checksumPos] -eq $letter.Key) {
                $validRoom = 1
            } else {
                $validRoom = 0
                # Room is invalid, don't bother checking anything more
                break
            }
            $checksumPos++
        } else {
            Write-Debug "Reached end of checksum $checksum for line $line"
            break
        }
    }
    
    # The day 4 part 2 describes a caeser cipher. but the example doesn't match up, they say the offset is the sector id
    # Their example: the real name for 'qzmt-zixmtkozy-ivhz-343' is 'very encrypted name'
    # A key of 343 does not give you that result, 21 does
    # http://crypto.interactive-maths.com/caesar-shift-cipher.html 
    
    # Decrypt room name
    $roomName = ''
    $shiftOffset = $sectorId % 26
    #Write-Debug "Shift offset: $shiftOffset"

    foreach ($character in $encryptedRoomName.ToCharArray()) {
        $characterCode = [int]$character
        # Validate that the character is a-z
        if ($characterCode -ge 97 -and $characterCode -le 122) {
            [int]$correctLetter = $characterCode + $shiftOffset
            if ($correctLetter -gt 122) {
                $correctLetter -= 26
            }
            if ($correctLetter -lt 97) {
                $correctLetter += 26
            }
            #Write-Output "Decrypted Character Code: $characterCode = $character to $correctLetter"
            $roomName += [char]$correctLetter
        } elseif ($characterCode -eq 32) { 
            $roomName += ' '
        } else {
            Write-Error "Unhandled Character Code: $characterCode = $character "
        }
    }

    if ($validRoom) {
        $sectorSum += $sectorId
        if ($roomName -like '*north*pole*') {
            $northPoleSectorId += @($sectorId, $roomName)
        }
    }
    Write-Output "Room Line $line, valid = $validRoom Name $roomName"
}

Write-Output "Sector ID Sum of Valid Rooms: $sectorSum"
Write-Output "Sector ID North Pole Room(s): $northPoleSectorId"
