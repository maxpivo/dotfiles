-- Accessing Tuples in Haskell

import System.Process

pair :: (String, String)
pair = ("key", "value")

key   :: (String, String) -> String
key   (k, _) = k

value :: (String, String) -> String
value (_, v) = v

putKeyLn :: (String, String) -> IO ()
putKeyLn (k, _) = do
    putStrLn k

main = do
    print $ fst pair
    print $ snd pair
    putStrLn ""
    
    putStrLn $ key pair
    putStrLn $ value pair
    putStrLn ""
    
    putKeyLn pair
        
