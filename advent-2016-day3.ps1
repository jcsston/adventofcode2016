
$input = Get-Content -Path "day3.txt"

$count = 0
$lineNo = 0

foreach ($line in $input.Split("`n")) {
    $line = $line.Trim()
    $lineNo++

    $sides = $line.Split(" ", [System.StringSplitOptions]::RemoveEmptyEntries)
    if ($sides.Length -ne 3) {
        Write-Error "Triangle on Line $lineNo does not have 3 sides, it has $($sides.Length) sides!"
        continue
    }

    $side1 = [int]$sides[0]
    $side2 = [int]$sides[1]
    $side3 = [int]$sides[2]

    # Check that each pair of sides is greater than the remaining side
    if ((($side1 + $side2) -gt $side3) -and (($side1 + $side3) -gt $side2) -and (($side2 + $side3) -gt $side1)) {
        $count++
    }
}

Write-Output "Valid Triangle Count: $count"
