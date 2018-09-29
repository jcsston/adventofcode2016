<# 
--- Day 5: How About a Nice Game of Chess? ---
You are faced with a security door designed by Easter Bunny engineers that seem to have acquired most of their security knowledge by 
watching hacking movies.

The eight-character password for the door is generated one character at a time by finding the MD5 hash of some Door ID (your puzzle input) 
and an increasing integer index (starting with 0).

A hash indicates the next character in the password if its hexadecimal representation starts with five zeroes. If it does, the sixth 
character in the hash is the next character of the password.

For example, if the Door ID is abc:

The first index which produces a hash that starts with five zeroes is 3231929, which we find by hashing abc3231929; the sixth character of 
the hash, and thus the first character of the password, is 1.
5017308 produces the next interesting hash, which starts with 000008f82..., so the second character of the password is 8.
The third time a hash starts with five zeroes is for abc5278568, discovering the character f.
In this example, after continuing this search a total of eight times, the password is 18f47a30.

Given the actual Door ID, what is the password?

Your puzzle input is cxdnnyjw.
#>


#$input = "abc" # Test input
$input = "cxdnnyjw"


$password = ''
$md5 = [System.Security.Cryptography.MD5]::Create("MD5")
$utf8 = [system.Text.Encoding]::UTF8
$index = 0

while ($password.Length -lt 8) {   
    $matchFound = 0    
    while (!$matchFound) {
        $possibleHashInput = $input + $index
        $buffer = $utf8.GetBytes($possibleHashInput) 
        $hash = [System.BitConverter]::ToString($md5.ComputeHash($buffer))
        $hash = $hash.Replace('-', '')
        # Check if the hash starts with 5 zeros, if so use the 6 character as the password
        if ($hash -like '00000*') {
            $password += $hash[5]
            $matchFound = 1
        }
        $index++
    }
    Write-Output "Found password character after $index rounds. Password: $password"
}

$password = $password.ToLower()
Write-Output "Final password: $password" 
