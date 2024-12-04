main = do
  input <- getContents -- read input from stdin
  let chars = lines input
      coords = concatMap (\y -> map (,y) [0 .. (length chars - 1)]) [0 .. (length (head chars) - 1)]
  print $ sum $ map (\c -> countWords c "XMAS" chars) coords
  print $ length $ filter (`isCross` chars) coords

countWords :: (Int, Int) -> String -> [[Char]] -> Int
countWords (x, y) word chars =
  let c = chars !! y !! x
      neighbors' = neighbors (x, y) (length word) (enumFrom Up) chars
   in if c == head word
        then length $ filter (== word) neighbors'
        else 0

isCross :: (Int, Int) -> [[Char]] -> Bool
isCross (x, y) chars =
  (chars !! y !! x == 'A')
    && ( let chars' = neighbors (x, y) 2 [UpLeft, UpRight, DownRight, DownLeft] chars
          in case chars' of
               ["AM", "AS", "AS", "AM"] -> True
               ["AS", "AM", "AM", "AS"] -> True
               ["AM", "AM", "AS", "AS"] -> True
               ["AS", "AS", "AM", "AM"] -> True
               _ -> False
       )

data Direction = Up | Down | Right | Left | UpLeft | UpRight | DownRight | DownLeft deriving (Enum)

neighbors :: (Int, Int) -> Int -> [Direction] -> [[Char]] -> [[Char]]
neighbors (x, y) amount directions chars =
  let coords = map (neighborCoords (x, y) amount chars) directions
   in filter (\x -> length x == amount) $ map (map (\(x, y) -> chars !! y !! x)) coords

neighborCoords :: (Int, Int) -> Int -> [[Char]] -> Direction -> [(Int, Int)]
neighborCoords (x, y) amount chars direction =
  let inRange (a, b) = a `elem` [0 .. length (head chars) - 1] && b `elem` [0 .. length chars - 1]
      mapCoords f = map f $ take amount [0 ..]
      coords = case direction of
        Up -> mapCoords (\a -> (x, y - a))
        Down -> mapCoords (\a -> (x, y + a))
        Main.Left -> mapCoords (\a -> (x - a, y))
        Main.Right -> mapCoords (\a -> (x + a, y))
        UpLeft -> mapCoords (\a -> (x - a, y - a))
        UpRight -> mapCoords (\a -> (x + a, y - a))
        DownRight -> mapCoords (\a -> (x + a, y + a))
        DownLeft -> mapCoords (\a -> (x - a, y + a))
   in filter inRange coords
