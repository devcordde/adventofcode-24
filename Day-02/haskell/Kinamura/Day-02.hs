parseInput :: String -> [[Int]]
parseInput = map (map read . words) . lines

checkSafe :: [Int] -> Bool
checkSafe ys = all (\x -> (x > 0 && x < 4) || (x > -4 && x < 0)) diffs && (all (> 0) diffs || all (< 0) diffs)
  where
    diffs = zipWith (-) (tail ys) ys

doubleCheck:: Int -> [Int] -> Bool
doubleCheck pos xs = (pos < length xs) && (checkSafe (take pos xs ++ drop (pos + 1 ) xs) || doubleCheck (pos+1) xs)

main :: IO ()
main = do
    content <- readFile "02input.txt"
    let numbers = parseInput content
    print (length $ filter checkSafe numbers)
    print (length $ filter (doubleCheck 0) numbers)
