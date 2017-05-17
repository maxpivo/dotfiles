-- Passing Argument with Map in Haskell

import Data.Foldable

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
       
-- function
pairMessage :: String -> Pair -> String
pairMessage text (key, value) = 
    text ++ ": " ++ key ++ " | " ++ value
   
-- function: loop over a hash dictionary of tuples
hashMessage1 :: String -> [Pair] -> [String]
hashMessage1 text dictionary = 
    map (pairMessage text) dictionary 

-- function: loop over a hash dictionary of tuples
hashMessage2 :: String -> [Pair] -> [String]
hashMessage2 text dictionary = 
    map (pairMessage' text) dictionary 
    where
        pairMessage' text (key, value) = 
            text ++ ": " ++ key ++ " | " ++ value

-- function: loop over a hash dictionary of tuples
hashMessage3 :: String -> [Pair] -> [String]
hashMessage3 text dictionary = 
    map ( \(key, value) ->
          text ++ ": " ++ key ++ " | " ++ value    
        ) dictionary 

-- function
dumpHash5 :: String -> [Pair] -> IO ()
dumpHash5 text dictionary = do
    -- loop over a hash dictionary of tuples
    let messages = map ( \(key, value) ->
            text ++ ": " ++ key ++ " | " ++ value
            ) dictionary      
    mapM_ putStrLn messages
    
-- function
dumpHash6 :: String -> [Pair] -> IO ()
dumpHash6 text dictionary = do
    -- loop over a hash dictionary of tuples    
    forM_ messages putStrLn
    where messages = map ( \(key, value) ->
            text ++ ": " ++ key ++ " | " ++ value
            ) dictionary 
            
-- function
dumpHash7 :: String -> [Pair] -> IO ()
dumpHash7 text dictionary = do
    -- loop over a hash dictionary of tuples    
    forM_ messages debugStrLn
    where 
        debugStrLn message = do 
            putStrLn message

            -- uncomment to debug in terminal
            -- putStrLn ("Debug [" ++ message ++ "]")

        messages = map ( \(key, value) ->
            text ++ ": " ++ key ++ " | " ++ value
            ) dictionary 

main = do
    putStrLn $ pairMessage "Test" ("Key", "Value")
    putStrLn ""

    mapM_ putStrLn (hashMessage3 "Name" colorSchemes)
    putStrLn ""
    
    dumpHash7 "Name" colorSchemes
    putStrLn ""
