def indexOf (update : List Nat) (order : Nat × Nat) : (Option Nat × Option Nat) :=
  (update.indexOf? order.fst, update.indexOf? order.snd)

def inOrder (update : List Nat) (order : Nat × Nat) : Bool := match indexOf update order with
| (some n, some m) => n <= m
| _ => true

def updateInOrder (update : List Nat) (orders : List (Nat × Nat)) : Option Nat :=
  if orders.all (inOrder update) then update.get? (update.length / 2) else none

def sumMiddlesInOrder (updates : List (List Nat)) (orders : List (Nat × Nat)) : Nat :=
  updates.foldl (fun acc elem => updateInOrder elem orders |>.getD 0 |>.add acc) 0

def filterUnsorted (updates : List (List Nat)) (orders : List (Nat × Nat)) : List (List Nat) :=
  updates.filter (fun u => !orders.all (inOrder u))

def sort(update : List Nat) (orders : List (Nat × Nat)) : List Nat :=
  update.mergeSort (fun l r => !orders.contains (r, l))

def sumMiddlesFilterAndSort (updates : List (List Nat)) (orders : List (Nat × Nat)) : Nat :=
  filterUnsorted updates orders |>.map (sort . orders) |>.foldl (fun acc l => acc + l.get! (l.length / 2)) 0

def main : IO Unit := do
  let file <- IO.FS.readFile "day05.txt"
  let g := file.splitOn "\n\n"
  let orders := g.head!.splitOn "\n" |>.map (·.splitOn "|" |>.map String.toNat! |> fun l => (l.head!, l.tail.head!))
  let updates := g.tail.head!.splitOn "\n" |>.map (·.splitOn "," |>.map String.toNat!)
  sumMiddlesInOrder updates orders |> IO.println
  sumMiddlesFilterAndSort updates orders |> IO.println
