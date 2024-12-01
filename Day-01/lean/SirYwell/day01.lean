def p1 (left: List Nat) (right: List Nat) : Nat :=
  left.zipWith (Int.ofNat . - Int.ofNat . |> Int.natAbs) right |> Nat.sum

def p2 (left: List Nat) (right: List Nat) : Nat :=
  left.foldl (fun acc elem => acc + right.count elem * elem) 0

def main : IO Unit := do
  let file <- IO.FS.readFile "input/day01.txt"
  let lines := file.splitOn "\n"
  let listOfPairs := lines.map (String.splitOn . "   ")
  let left := listOfPairs.map (.[0]! |>.toNat!) |>.mergeSort
  let right := listOfPairs.map (.[1]! |>.toNat!) |>.mergeSort
  p1 left right |> IO.println
  p2 left right |> IO.println
