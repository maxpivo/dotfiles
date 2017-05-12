-- Accessing Associative Array in Haskell

import System.Process

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

main = do
    print (colorSchemes !! 2)
    putStrLn ""

    -- loop over a hash dictionary of tuples
    mapM_ print colorSchemes
    putStrLn ""

    mapM_ (print . fst) colorSchemes
    putStrLn ""
    
    mapM_ (putStrLn . snd) colorSchemes
    putStrLn ""
    
    mapM_ putPairLn colorSchemes
    putStrLn ""
    
