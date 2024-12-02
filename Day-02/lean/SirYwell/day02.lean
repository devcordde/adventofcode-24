def isSafeIncreasing (list: List Nat) : Bool := match list with
  | x :: y :: rest => x < y && y - x >= 1 && y - x <= 3 && isSafeIncreasing (y :: rest)
  | _ => true

def dropEachOnce (list: List a) : List (List a) :=
  list.foldr (fun _ r => 0 :: r.map (. + 1) ) [] |>.map (fun i => list.take i ++ list.drop (i + 1))

def isSafe (dampeners: Nat) (list : List Nat) : Bool := match dampeners with
  | 0 => isSafeIncreasing list || isSafeIncreasing list.reverse
  | x + 1 => (dropEachOnce list).any (isSafe x)

def pn (dampeners : Nat) (input: List (List Nat)) : Nat := input.filter (isSafe dampeners) |>.length

def main : IO Unit := do
  let file <- IO.FS.readFile "day02.txt"
  let listOfReports := file.splitOn "\n" |>.map (String.splitOn . |>.map String.toNat!)
  pn 0 listOfReports |> IO.println
  pn 1 listOfReports |> IO.println
