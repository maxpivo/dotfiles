module MyPipeHandler
( detachDzen2
, detachTransset
) where

import System.Process
import System.Posix.Types
import System.Exit

import GHC.IO.Handle

import System.IO
import System.Posix.Process

import Control.Concurrent
import Control.Monad

-- cabal install split
import Data.List.Split

import MyOutput

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- helper

-- for use with transset
wSleep :: Int -> IO ()
wSleep mySecond = threadDelay (1000000 * mySecond)

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- pipe 

handleCommandEvent :: Int -> String -> IO ()
handleCommandEvent monitor event
  | origin == "reload"      = do system("pkill dzen2"); return ()
  | origin == "quit_panel"  = do exitSuccess; return ()
  | elem origin tagCmds     = do setTagValue monitor
  | elem origin titleCmds   = do setWindowtitle (column !! 2)
  where
    tagCmds   = ["tag_changed", "tag_flags", "tag_added", "tag_removed"]
    titleCmds = ["window_title_changed", "focus_changed"]

    -- find out event origin
    column = splitOn "\t" event
    origin = column !! 0

contentInit :: Int -> Handle -> IO ()
contentInit monitor pipe_dzen2_in = do
    -- initialize statusbar before loop
    setTagValue monitor 
    setWindowtitle ""
    
    text <- getStatusbarText monitor

    hPutStrLn pipe_dzen2_in text
    hFlush pipe_dzen2_in

contentWalk :: Int -> Handle -> IO ()
contentWalk monitor pipe_dzen2_in = do
    let command_in = "herbstclient"

    (_, Just pipe_idle_out, _, ph)  <- 
        createProcess (proc command_in ["--idle"]) 
        { std_out = CreatePipe }

    forever $ do
        -- wait for next event 
        event <- hGetLine pipe_idle_out 
        handleCommandEvent monitor event
 
        text <- getStatusbarText monitor

        hPutStrLn pipe_dzen2_in text
        hFlush pipe_dzen2_in

    hClose pipe_idle_out

runDzen2 :: Int -> [String] -> IO ()
runDzen2 monitor parameters = do
    let command_out = "dzen2"

    (Just pipe_dzen2_in, _, _, ph)  <- 
        createProcess (proc command_out parameters) 
        { std_in = CreatePipe }
       
    contentInit monitor pipe_dzen2_in
    contentWalk monitor pipe_dzen2_in  -- loop for each event
    
    hClose pipe_dzen2_in

detachDzen2 :: Int -> [String] -> IO ProcessID
detachDzen2 monitor parameters = forkProcess 
    $ runDzen2 monitor parameters 
    
detachTransset :: IO ProcessID
detachTransset = forkProcess $ do    
    wSleep 1
    system "transset .8 -n dzentop >/dev/null"
    return ()
