import Data.List (length, map, sort)

parseInput :: String -> ([Int], [Int])
parseInput content = (unzip . map (\[x, y] -> (x, y)) . map (map read . words) . lines) content

main :: IO ()
main = do
    content <- readFile "01input.txt"
    let (first, second) = parseInput content
    print (foldr1 (+) $ map (abs . uncurry (-)) $ zip (sort first) (sort second))
    print (foldr1 (+) $ map (\x -> (length $ filter (x==) second) * x ) first)
