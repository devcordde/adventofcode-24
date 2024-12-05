structure Update where
  array : Array Nat
  indexArray : Array (Option Nat)

def buildUpdate (update : List Nat) : Update :=
  let indexArray := Array.mkArray 100 none
  let array := update.toArray
  let indexArray := array.zipWithIndex.foldl (fun a e => a.set! e.fst e.snd) indexArray
  ({array := array, indexArray := indexArray} : Update)

def indexOf (update : Update) (order : Nat × Nat) : (Option Nat × Option Nat) :=
  (update.indexArray.get! order.fst, update.indexArray.get! order.snd)

def inOrder (update : Update) (order : Nat × Nat) : Bool := match indexOf update order with
| (some n, some m) => n <= m
| _ => true

def updateInOrder (update : Update) (orders : List (Nat × Nat)) : Option Nat :=
  if orders.all (inOrder update) then update.array.get? (update.array.size / 2) else none

def sumMiddlesInOrder (updates : List Update) (orders : List (Nat × Nat)) : Nat :=
  updates.foldl (fun acc elem => updateInOrder elem orders |>.getD 0 |>.add acc) 0

def filterUnsorted (updates : List Update) (orders : List (Nat × Nat)) : List Update :=
  updates.filter (fun u => !orders.all (inOrder u))

def sort(update : Update) (orders : List (Nat × Nat)) : List Nat :=
  update.array.toList.mergeSort (fun l r => !orders.contains (r, l))

def sumMiddlesFilterAndSort (updates : List Update) (orders : List (Nat × Nat)) : Nat :=
  filterUnsorted updates orders |>.map (sort . orders) |>.foldl (fun acc l => acc + l.get! (l.length / 2)) 0

def main : IO Unit := do
  let file <- IO.FS.readFile "day05.txt"
  let g := file.splitOn "\n\n"
  let orders := g.head!.splitOn "\n" |>.map (·.splitOn "|" |>.map String.toNat! |> fun l => (l.head!, l.tail.head!))
  let updates := g.tail.head!.splitOn "\n" |>.map (·.splitOn "," |>.map String.toNat!) |>.map buildUpdate
  sumMiddlesInOrder updates orders |> IO.println
  sumMiddlesFilterAndSort updates orders |> IO.println
