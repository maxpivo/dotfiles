-- Accessing Associative Array in Haskell

-- google material colors
-- https://material.io/guidelines/style/color.html

colorSchemes :: [(String, String)]
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
    
-- action procedure
putPairLn :: (String, String) -> IO ()
putPairLn (key, value) = do
    putStrLn(key ++ " | " ++ value)

-- function
pairStr :: (String, String) -> String
pairStr (key, value) = key ++ " | " ++ value

-- action procedure
pairStrIO :: (String, String) -> IO String
pairStrIO (key, value) = do return (key ++ " | " ++ value)

main = do
    print (colorSchemes !! 2)
    putStrLn ""

    -- loop over a hash dictionary of tuples      
    -- using side effect only (using IO)
    mapM_ print colorSchemes
    putStrLn ""
    
    -- producing new list (no IO), print raw
    print $ map fst colorSchemes
    putStrLn ""

    mapM_ (print . fst) colorSchemes
    putStrLn ""
    
    mapM_ (putStrLn . snd) colorSchemes
    putStrLn ""
       
    -- using side effect only (using IO)
    mapM_ putPairLn colorSchemes
    putStrLn ""

    -- producing new list first
    mapM_ putStrLn (map pairStr colorSchemes)
    putStrLn ""    

    -- IO example 
    myPair <- pairStrIO ("myKey", "myValue")
    putStrLn myPair
    
    pairStrIO ("myKey", "myValue") >>= putStrLn 
    putStrLn =<< pairStrIO ("myKey", "myValue") 
    
    myMapResult <- mapM pairStrIO colorSchemes
    putStrLn $ show myMapResult
    putStrLn ""  
    
    (mapM pairStrIO colorSchemes) >>= (putStrLn . show)
    (putStrLn . show) =<< (mapM pairStrIO colorSchemes)
    putStrLn ""      
