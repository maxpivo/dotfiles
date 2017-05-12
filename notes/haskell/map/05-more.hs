-- Accessing Associative Array in Haskell

import System.Process

type Pair = (String, String)

pair :: Pair
pair = ("key", "value")

-- google material colors
-- https://material.io/guidelines/style/color.html

colorSchemes :: [Pair]
colorSchemes =
    [("blue50",     "#e3f2fd")
    ,("blue100",    "#bbdefb")
    ,("blue200",    "#90caf9")
    ,("blue300",    "#64b5f6")
    ,("blue400",    "#42a5f5")
    ,("blue500",    "#2196f3")
    ,("blue600",    "#1e88e5")
    ,("blue700",    "#1976d2")
    ,("blue800",    "#1565c0")
    ,("blue900",    "#0d47a1")
    ]
    
-- IO action procedure
dumpPair :: String -> Pair -> IO ()
dumpPair text (key, value) = do
    putStrLn(text ++ ": " ++ key ++ " | " ++ value)
   
-- IO action procedure
dumpHash1 :: String -> [Pair] -> IO ()
dumpHash1 text dictionary = do
    -- loop over a hash dictionary of tuples
    mapM_ (dumpPair text) dictionary
    -- where
  
-- IO action procedure
dumpHash2 :: String -> [Pair] -> IO ()
dumpHash2 text dictionary = do
    -- loop over a hash dictionary of tuples
    mapM_ (dumpPair' text) dictionary
    where
        dumpPair' text (key, value) = do
            putStrLn(text ++ ": " ++ key ++ " | " ++ value)

-- IO action procedure
dumpHash3 :: String -> [Pair] -> IO ()
dumpHash3 text dictionary = do
    -- loop over a hash dictionary of tuples
    mapM_ (\(key, value) -> do 
            putStrLn(text ++ ": " ++ key ++ " | " ++ value)
        ) dictionary       

main = do
    dumpPair "Test" ("Key", "Value")
    putStrLn ""

    dumpHash3 "Name" colorSchemes
    putStrLn ""
