import Data.Char (digitToInt)
import Data.List (group, sort)
import Text.Printf (printf)

solve :: [[Int]] -> Int -> Int -> Int -> [(Int, Int)]
solve grid row column n
    | not (0 <= row && row < length grid && 0 <= column && column < length (head grid)) = []
    | grid !! row !! column /= n = []
    | n == 9 = [(row, column)]
    | otherwise = concat [solve grid (row + fst d) (column + snd d) (n + 1) | d <- [(0, 1), (1, 0), (0, -1), (-1, 0)]]

main :: IO ()
main = do
    content <- readFile "input.txt"
    let grid = [map digitToInt xs | xs <- lines content]
    let coordinates = [(row, column) | row <- [0..(length grid - 1)], column <- [0..(length (head grid) - 1)]]
    let paths = map (\pos -> uncurry (solve grid) pos 0) coordinates
    printf "Part 1: %d\n" $ sum $ map (\pos -> length $ map head . group . sort $ pos) paths
    printf "Part 2: %d\n" $ sum $ map length paths
