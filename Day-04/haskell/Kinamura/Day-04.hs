import Data.Array
import Data.List ( transpose ) 

diag :: [String] -> [String]
diag x = [zipWith (!!) (drop n x) [0..] | n <- [0 .. length x -1]] ++ [zipWith (!!) (drop n (transpose x)) [0..] | n <- [1..length (head x) - 1]]

getAllDirs :: [String] -> [String]
getAllDirs x = x ++ transpose x ++ diag x ++ diag (map reverse x) ++ map reverse (x ++ transpose x ++ diag x ++ diag (map reverse x))

xmas :: String -> Int -> Int
xmas xs y
    | null xs = y
    | take 4 xs == "XMAS" = xmas (drop 3 xs) (y+1)
    | otherwise = xmas (drop 1 xs) y

masx :: Array (Int, Int) Char -> [(Int, Int)] -> Int
masx xs ys = sum $ map (\y -> if dia xs y == "SMMS" || dia xs y == "MSSM" || dia xs y == "MMSS" || dia xs y == "SSMM" then 1 else 0) ys
    where
        dia xs y = [xs!(fst y - 1, snd y - 1), xs!(fst y - 1, snd y + 1), xs!(fst y + 1, snd y + 1), xs!(fst y + 1, snd y - 1)]

main :: IO ()
main = do
    content <- readFile "04input.txt"
    let grid = listArray ((1,1), (length $ lines content,length $ head $ lines content)) (concat $ lines content)
    print $ xmas (unwords $ getAllDirs $ lines content) 0
    print (masx grid $ filter (\x -> grid!x =='A' && fst x > 1 && snd x > 1 && (fst x < fst (snd $ bounds grid)) && (snd x < snd (snd $ bounds grid))) (indices grid))
