import MyFunc

main = do    
    -- -- --    
    putStrLn ":: Maybe Result"
    -- plain
    putUnbox $ say3 "World" 
    -- bind
    putUnbox $ (Just "World") >>= say3
    putUnbox $ say3 =<< (Just "World")
    putStrLn ""

    -- -- --    
    putStrLn ":: Chaining"
    putUnbox $ Just "Hello " >>= say4 "world," >>= say4 " How are you ?"
    putUnbox $ say4 " How are you ?" =<< say4 "world," =<< Just "Hello "
    putStrLn ""
    
    -- -- --   
    putStrLn ":: list1 :: [String] -> [String]"
    print $ list1 ["World", "Lady"]
    putStrLn ""

    -- -- --       
    putStrLn "say1 :: String -> String"
    print $ ["World"] >>= say1
    print $ say1 =<< ["Lady"]
    print $ ["World, ", "Lady"] >>= say1
    print $ ["World"] >>= say2 "Hello"    
    putStrLn ""

    -- -- --       
    putStrLn "list3 :: String -> [String]"
    print $ ["World", "Lady"] >>= list3
    print $ [] >>= list3

    -- -- --       
    putStrLn "list4 :: String -> String -> [String]"
    print $ ["World", "Lady"] >>= list4 "Hello" >>= list5 "Good Morning"
    print $ (list4 "Hello" =<< ["World", "Lady"]) >>= list5 "Good Morning"
