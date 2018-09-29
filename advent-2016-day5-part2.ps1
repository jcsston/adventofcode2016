<# 
--- Part Two ---
As the door slides open, you are presented with a second door that uses a slightly more inspired security mechanism. 
Clearly unimpressed by the last version (in what movie is the password decrypted in order?!), the Easter Bunny engineers 
have worked out a better solution.

Instead of simply filling in the password from left to right, the hash now also indicates the position within the password 
to fill. You still look for hashes that begin with five zeroes; however, now, the sixth character represents the position (0-7), 
and the seventh character is the character to put in that position.

A hash result of 000001f means that f is the second character in the password. Use only the first result for each position, 
and ignore invalid positions.

For example, if the Door ID is abc:

The first interesting hash is from abc3231929, which produces 0000015...; so, 5 goes in position 1: _5______.
In the previous method, 5017308 produced an interesting hash; however, it is ignored, because it specifies an invalid position (8).
The second interesting hash is at index 5357525, which produces 000004e...; so, e goes in position 4: _5__e___.
You almost choke on your popcorn as the final character falls into place, producing the password 05ace8e3.

Given the actual Door ID and this new method, what is the password? Be extra proud of your solution if it uses a cinematic "decrypting" animation.
#>


#$input = "abc" # Test input
$input = "cxdnnyjw"


$password = '________'.ToCharArray()
$passwordFill = 0
$md5 = [System.Security.Cryptography.MD5]::Create("MD5")
$utf8 = [system.Text.Encoding]::UTF8
$index = 0

while ($passwordFill -lt 8) {   
    $matchFound = 0    
    while (!$matchFound) {
        $possibleHashInput = $input + $index
        $buffer = $utf8.GetBytes($possibleHashInput) 
        $hash = [System.BitConverter]::ToString($md5.ComputeHash($buffer))
        $hash = $hash.Replace('-', '')
        # Check if the hash starts with 5 zeros, if so use the 6th character as the password index
        if ($hash -like '00000*') {
            $passwordPos = $hash[5]
            if ($passwordPos -match '\d') {
                #Write-Output "Checking interesting hash with index $index, $hash"
                $passwordPos = [int]::Parse($passwordPos)
                if ($passwordPos -lt 8) {
                    $passwordChracter = $hash[6]
                    if ($password[$passwordPos] -eq '_') {
                        #Write-Output "Found password character $passwordChracter, placing at $passwordPos. $passwordFill characters found"
                        $password[$passwordPos] = $passwordChracter
                        $matchFound = 1
                        $passwordFill++
                    }
                }
            }
        }
        $index++
    }
    Write-Output "Found password character after $index rounds. Password: $password"
}

$password = [string]::new($password).ToLower()
Write-Output "Final password: $password" 
