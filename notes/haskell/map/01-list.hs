-- Accessing List/ Array in Haskell
-- Actualy it is a single linked lists

--import Control.Lens
import Data.Foldable

list :: [Int]
list = [1..9] ++ [0]

indices' :: [Int] -> [Int]
indices' l = [0 .. (length l) - 1]

putList :: [Int] -> IO ()
putList myList =
    mapM_ myFunctionComposition myList
    where
        myFunctionComposition = (putStr . (": " ++) . show)

main = do
    print list
    putStrLn ""
        
    putStr "list    : "
    putStrLn $ show list
    
    putStr "indices : "
    putStrLn $ show $ indices' list
    putStrLn ""

    -- index
    print (list !! 3)
    --putStrLn $ show (list ^? element 13)
    putStrLn ""

    -- loop over an array/ list
       
    -- using side effect only (using IO)
    mapM_ print list
    putStrLn ""

    -- producing new list (no IO), print raw
    print $ map show list
    putStrLn ""
    
    -- using side effect of newly produced list
    forM_ (map show list) putStrLn
    putStrLn ""

    -- oneliner using mapM_
    mapM_ (putStr . (": " ++) . show) ([1..9] ++ [0]) >> putStrLn ""

    -- oneliner using forM_, reversed argument
    forM_ ([1..9] ++ [0]) (putStr . (": " ++) . show) >> putStrLn ""
    
    -- oneliner using map
    putStrLn $ concat  $ map ((": " ++) . show) ([1..9] ++ [0])
    putStrLn $ concatMap ((": " ++) . show) ([1..9] ++ [0])

    -- let clause
    let
        myFunctionComposition = (putStr . (": " ++) . show)
        myList = ([1..9] ++ [0])
        in mapM_ myFunctionComposition myList
    
    putStrLn ""  

    -- function
    putList ([1..9] ++ [0])    
    putStrLn ""  
