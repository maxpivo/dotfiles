-- This is a modularized config for herbstluftwm tags in dzen2 statusbar

import System.Environment
import System.Process
import System.IO
import GHC.IO.Handle

import MyHelper
import MyOutput

-- initialize

panelHeight = 24

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- process handler

testDzen2 :: Int -> [String] -> IO ()
testDzen2 monitor parameters = do
    let command_out = "dzen2"

    (Just pipe_in, _, _, ph)  <- 
        createProcess (proc command_out (parameters ++ ["-p"]) )
        { std_in = CreatePipe }

    -- initialize statusbar before loop
    setTagValue monitor 
    setWindowtitle "test"
    
    text <- getStatusbarText monitor

    hPutStrLn pipe_in text
    hFlush pipe_in
    
    hClose pipe_in

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- main

main = do
    -- initialize
    
    args <- getArgs
    let monitor = getMonitor args
        
    geometry <- getGeometry monitor
    let dzen2Parameters = getDzen2Parameters panelHeight geometry
    
    -- test

    -- do `man herbsluftclient`, and type \pad to search what it means
    system $ "herbstclient pad " ++ show(monitor) ++ " "
        ++ show(panelHeight) ++ " 0 " ++ show(panelHeight) ++ " 0"

    -- run process
    testDzen2 monitor dzen2Parameters

    -- end of IO
    return ()
