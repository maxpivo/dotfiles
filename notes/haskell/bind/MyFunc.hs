module MyFunc 
( unboxStr
, putUnbox
, say1, say2, say3, say4
, list1, list3, list4, list5
) where

-- tools

unboxStr :: Maybe String -> String
unboxStr (Just text) = text
unboxStr Nothing = ""

putUnbox :: Maybe String -> IO ()
putUnbox (Just text) = putStrLn text
putUnbox Nothing = return ()

-- basic

say1 :: String -> String
say1 str = "Hello " ++ str

say2 :: String -> String -> String
say2 str1 str2 = str1 ++ " " ++ str2

-- with failsafe

say3 :: String -> Maybe String
say3 str = 
    if (length str) /= 0
        then Just ("Hello " ++ str)
        else Nothing

say4 :: String -> String -> Maybe String
say4 text greet = 
    if ((length text) /= 0) && ((length greet) /= 0) 
        then Just (greet ++ text)
        else Nothing

list1 :: [String] -> [String]
list1 str = map ("Hello " ++) str

list3 :: String -> [String]
list3 str = 
    if (length str) /= 0
        then ["Hello " ++ str]
        else []

list4 :: String -> String -> [String]
list4 greet text = 
    if ((length text) /= 0) && ((length greet) /= 0) 
        then [greet ++ " " ++ text]
        else []

list5 :: String -> String -> [String]
list5 greet text = 
    if ((length text) /= 0) && ((length greet) /= 0) 
        then [text ++ " " ++ greet]
        else []
