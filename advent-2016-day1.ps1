#$input = "R2, L3" # Test input = 5
#$input = "R2, R2, R2" # Test input = 2
#$input = "R5, L5, R5, R3" # Test input = 12
$input = "R1, R3, L2, L5, L2, L1, R3, L4, R2, L2, L4, R2, L1, R1, L2, R3, L1, L4, R2, L5, R3, R4, L1, R2, L1, R3, L4, R5, L4, L5, R5, L3, R2, L3, L3, R1, R3, L4, R2, R5, L4, R1, L1, L1, R5, L2, R1, L2, R188, L5, L3, R5, R1, L2, L4, R3, R5, L3, R3, R45, L4, R4, R72, R2, R3, L1, R1, L1, L1, R192, L1, L1, L1, L4, R1, L2, L5, L3, R5, L3, R3, L4, L3, R1, R4, L2, R2, R3, L5, R3, L1, R1, R4, L2, L3, R1, R3, L4, L3, L4, L2, L2, R1, R3, L5, L1, R4, R2, L4, L1, R3, R3, R1, L5, L2, R4, R4, R2, R1, R5, R5, L4, L1, R5, R3, R4, R5, R3, L1, L2, L4, R1, R4, R5, L2, L3, R4, L4, R2, L2, L4, L2, R5, R1, R4, R3, R5, L4, L4, L5, L5, R3, R4, L1, L3, R2, L2, R1, L3, L5, R5, R5, R3, L4, L2, R4, R5, R1, R4, L3"

# North = 0, East = 1, South = 2, West = 3
$direction = 0;
$x = 0; # West/East
$y = 0; # North/South

$input.Split(",") | ForEach-Object {
    $walkInstruction = $_.Trim()
    $turn = $walkInstruction[0]
    $steps = [int]$walkInstruction.Substring(1)

    # Turn our direction
    if ($turn -eq "L") {
        $direction--;
    } elseif ($turn -eq "R") {
        $direction++;
    } else {
        Write-Error "Unhandled turn type: $turn"
    }

    # Check if our direction has wrapped around
    if ($direction -eq -1) {
        $direction = 3; # We turned from North (0) to West (3)
    } elseif ($direction -eq 4) {
        $direction = 0; # We turned from West (3) to North (0)
    }

    switch ($direction) {
        0 { # North
            $y += $steps;
            break
        }
        1 { # East
            $x += $steps;
            break
        }
        2 { # South
            $y -= $steps;
            break
        }
        3 { # West
            $x -= $steps;
            break
        }
        default {
            Write-Error "Unhandled direction: $direction"
        }
    }
}

# Determine final distance from starting point
$finalDistance = [Math]::Abs($x) + [Math]::Abs($y)

Write-Output "Final Distance is $finalDistance"
