import Data.Char

calculate :: String -> Int -> Int -> Int -> Int -> Int -> Int -> Int
calculate (x:xs) read run n1 n2 ign sum
    | null xs = sum
    | ign == 0 && read == 1 && take 7 (x:xs) == "don't()" = calculate (drop 6 xs) 0 run n1 n2 ign sum
    | ign == 0 && read == 0 && take 4 (x:xs) == "do()" =  calculate (drop 3 xs) 1 run n1 n2 ign sum
    | take 4 (x:xs) == "mul(" = calculate (drop 3 xs) read 1 n1 n2 ign sum
    | read == 1 && run == 1 && isDigit x = calculate xs read run (n1 * 10 + (ord x - ord '0') ) n2 ign sum
    | read == 1 && run == 1 && x == ',' = calculate xs read 2 n1 n2 ign sum
    | read == 1 && run == 1 = calculate xs read 0 0 n2 ign sum
    | read == 1 && run == 2 && isDigit x = calculate xs read run n1 (n2 * 10 + (ord x - ord '0') ) ign sum
    | read == 1 && run == 2 && x == ')' = calculate xs read 0 0 0 ign (sum + n1 * n2)
    | read == 1 && run == 2 = calculate xs read 0 0 0 ign sum
    | otherwise = calculate xs read run n1 n2 ign sum

main :: IO ()
main = do
    content <- readFile "03input.txt"
    print ( calculate ((concat . lines) content) 1 0 0 0 1 0 )
    print ( calculate ((concat . lines) content) 1 0 0 0 0 0 )
