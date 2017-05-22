import MyFunc
import Control.Monad

sequ1 :: [String]
sequ1 = 
    ["World", "Lady"] 
    >>= list4 "Hello" 
    >>= list5 "Good Morning"

sequ2 :: [String]
sequ2 = do
    x <- ["World", "Lady"]
    y <- list4 "Hello" x
    list5 "Good Morning" y

main = do    
    print $ sequ2
