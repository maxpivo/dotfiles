-- Accessing List/ Array in Haskell
-- Actualy it is a single linked lists

--import Control.Lens

list :: [Int]
list = [1..9] ++ [0]

indices' :: [Int] -> [Int]
indices' l = [0 .. (length l) - 1]

main = do
    putStr "list    : "
    print list
    putStr "indices : "
    print $ indices' list
    putStrLn ""

    print (list !! 3)
    --putStrLn $ show (list ^? element 13)
    putStrLn ""

    -- loop over an array/ list
    mapM_ print list
    putStrLn ""

    mapM_ (putStr . (": " ++) . show ) ([1..9] ++ [0])
    putStrLn ""
    
    putStrLn (concatMap ((": " ++) . show ) ([1..9] ++ [0]) )
