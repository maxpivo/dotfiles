import System.Process
import System.Directory

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ---
-- wrap Funktion

-- Source directory is irrelevant in Haskell
-- but we'll do it anyway for the sake of learning
wGetCmdIn :: String -> String
wGetCmdIn dirname = dirname ++ "/../assets" ++ "/conky.lua"

cmdout = "less" -- or dzen2

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ---
-- main

main = do
    dirname <- getCurrentDirectory
    let filename = wGetCmdIn dirname   
  
    (_, Just pipeout, _, _) <- 
        createProcess (proc "conky" ["-c", filename])
        { std_out = CreatePipe } 

    (_, _, _, ph)  <- 
        createProcess (proc cmdout []) 
        { std_in = UseHandle pipeout }
    
    _ <- waitForProcess ph

    putStrLn ""
  


