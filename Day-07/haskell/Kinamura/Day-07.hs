checkAll :: [Int] -> Int -> Int -> Bool -> Bool
checkAll (x:xs) curr tar p
    | curr > tar = False
    | curr == 0 = checkAll xs x tar p
    | null xs = (curr + x) == tar || (curr * x) == tar || (p && (curr * (10 ^ length (show x)) + x) == tar)
    | otherwise = checkAll xs (curr + x) tar p || checkAll xs (curr * x) tar p || (p && checkAll xs (curr * (10 ^ length (show x)) + x) tar p)

main = do
    input <- readFile "07input.txt"
    let parsed = map (\line -> let (num:rest) = words $ map (\c -> if c == ':' then ' ' else c) line in read num : map read rest) (lines input)
    let resultCheck = map (\line -> if checkAll (tail line) 0 (head line) False then head line else 0) parsed
    let resultCheck2 = map (\line -> if checkAll (tail line) 0 (head line) True then head line else 0) (filter (\line -> head line `notElem` resultCheck) parsed)
    putStrLn $ "Part 1: " ++ show (sum resultCheck) ++ "\nPart 2: " ++ show (sum resultCheck2 + sum resultCheck)
