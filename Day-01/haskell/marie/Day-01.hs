import Data.List (sort, transpose)

main = do
  input <- getContents -- read input from stdin
  let numbers = parseInput input
  print $ sum $ map (abs . foldl subtract 0) $ transpose $ map sort numbers
  let count a x = length $ filter (a ==) x
  print $ sum $ map (\x -> x * count x (head $ tail numbers)) (head numbers)

parseInput :: String -> [[Int]]
parseInput input = transpose $ map (map read . words) $ lines input
