import MyFunc

main = do
    putStrLn ":: Basic"
    putStrLn $ unboxStr (Just "Hello World")
    putStrLn ""

    -- -- --    
    putStrLn ":: One Argument"
    -- plain
    putStrLn $ say1 "World" 
    -- functor   
    putUnbox $ say1 <$> (Just "World")
    print    $ say1 <$> ["World", "Lady"]
    -- applicative
    putUnbox $ (Just say1) <*> (Just "World")
    print    $ [say1] <*> ["World", "Lady"] 
    putStrLn ""
    
    -- -- --    
    putStrLn ":: Two Arguments" 
    -- plain      
    putStrLn $ say2 "Hello" "World"    
    -- curry
    putStrLn $ (say2 "Hello") "World"    
    -- or even
    putStrLn $ (say2 "Hello") $ "World"    
    -- functor
    putUnbox $ (say2 "Hello") <$> (Just "World")    
    print    $ (say2 "Hello") <$> ["World", "Lady"]
    -- applicative
    putUnbox $ Just (say2 "Hello") <*> (Just "World")    
    print    $ [say2 "Hello"] <*> ["World", "Lady"]
    -- fmap is <$>
    putUnbox $ fmap (say2 "Hello") (Just "World")
    print    $ fmap (say2 "Hello") ["World", "Lady"]
    putStrLn ""
    
