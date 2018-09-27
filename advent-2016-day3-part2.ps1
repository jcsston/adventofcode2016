
$input = Get-Content -Path "day3.txt"

$count = 0
$lineNo = 0
$triangles = New-Object System.Collections.Generic.List[System.Object]

foreach ($line in $input.Split("`n")) {
    $line = $line.Trim()
    $lineNo++

    $sides = $line.Split(" ", [System.StringSplitOptions]::RemoveEmptyEntries)
    $pos = 0
    foreach ($side in $sides) {
        if ($triangles.Count -le $pos) {
            $o = New-Object System.Collections.Generic.List[System.Object]
            $triangles.Add($o)
        }
        $triangles[$pos++].Add($side)
    }

    # Check if we have 3 sides to compare
    if (($triangles.Count -gt 0) -and ($triangles[0].Count -eq 3)) {
        foreach ($triangle in $triangles) {
            $side1 = [int]$triangle[0]
            $side2 = [int]$triangle[1]
            $side3 = [int]$triangle[2]
            # Remove the processed sides
            $triangle.Clear()

            # Check that each pair of sides is greater than the remaining side
            if ((($side1 + $side2) -gt $side3) -and (($side1 + $side3) -gt $side2) -and (($side2 + $side3) -gt $side1)) {
                $count++
            }
        }
    }
}

Write-Output "Valid Triangle Count: $count"
