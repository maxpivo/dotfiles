module MyPipeHandler
( detachLemon
, detachLemonConky
) where

import System.Process
import System.Posix.Types
import System.Exit
import System.Directory

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

wSleep :: Int -> IO ()
wSleep mySecond = threadDelay (1000000 * mySecond)

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- pipe 

getColumnTitle :: [String] -> String
getColumnTitle column
  | length(column) > 2 = column !! 2
  | otherwise          = ""

handleCommandEvent :: Int -> String -> IO ()
handleCommandEvent monitor event
  | origin == "reload"      = do system("pkill lemonbar"); return ()
  | origin == "quit_panel"  = do exitSuccess; return ()
  | elem origin tagCmds     = do setTagValue monitor
  | elem origin titleCmds   = do setWindowtitle $ getColumnTitle column
  | origin == "interval"    = do setDatetime
  where
    tagCmds   = ["tag_changed", "tag_flags", "tag_added", "tag_removed"]
    titleCmds = ["window_title_changed", "focus_changed"]

    -- find out event origin
    column = splitOn "\t" event
    origin = column !! 0

contentInit :: Int -> Handle -> IO ()
contentInit monitor pipe_lemon_in = do
    -- initialize statusbar before loop
    setTagValue monitor 
    setWindowtitle ""
    setDatetime

    text <- getStatusbarText monitor

    hPutStrLn pipe_lemon_in text
    hFlush pipe_lemon_in

contentEventIdle :: Handle -> IO ()
contentEventIdle pipe_cat_in = do
    let command_in = "herbstclient"

    (_, Just pipe_idle_out, _, ph) <- 
        createProcess (proc command_in ["--idle"]) 
        { std_out = CreatePipe }

    forever $ do
        -- wait for next event 
        event <- hGetLine pipe_idle_out

        hPutStrLn pipe_cat_in event
        hFlush pipe_cat_in

    hClose pipe_idle_out

contentEventInterval :: Handle -> IO ()
contentEventInterval pipe_cat_in = forever $ do
     hPutStrLn pipe_cat_in "interval"
     hFlush pipe_cat_in

     wSleep 1

contentWalk :: Int -> Handle -> IO ()
contentWalk monitor pipe_lemon_in = do
    (Just pipe_cat_in, Just pipe_cat_out, _, ph) <- 
        createProcess (proc "cat" []) 
        { std_in = CreatePipe, std_out = CreatePipe }

    forkProcess $ contentEventIdle(pipe_cat_in)
    forkProcess $ contentEventInterval(pipe_cat_in)
    
    forever $ do
        -- wait for next event 
        event <- hGetLine pipe_cat_out
        handleCommandEvent monitor event
 
        text <- getStatusbarText monitor

        hPutStrLn pipe_lemon_in text
        hFlush pipe_lemon_in

    hClose pipe_cat_out
    hClose pipe_cat_in

runLemon :: Int -> [String] -> IO ()
runLemon monitor parameters = do
    let command_out = "lemonbar"

    (Just pipe_lemon_in, Just pipe_lemon_out, _, ph) <- 
        createProcess (proc command_out parameters) 
        { std_in = CreatePipe, std_out = CreatePipe }

    (_, _, _, ph) <- 
        createProcess (proc "sh" []) 
        { std_in = UseHandle pipe_lemon_out }

    contentInit monitor pipe_lemon_in
    contentWalk monitor pipe_lemon_in  -- loop for each event
    
    hClose pipe_lemon_in
    hClose pipe_lemon_out

detachLemon :: Int -> [String] -> IO ProcessID
detachLemon monitor parameters = forkProcess 
    $ runLemon monitor parameters 

detachLemonConky :: [String] -> IO ()
detachLemonConky parameters = do
    -- Source directory is irrelevant in Haskell
    -- but we'll do it anyway for the sake of learning
    dirName <- getCurrentDirectory
    let conkyFileName = dirName ++ "/../assets" ++ "/conky.lua" 

    (_, Just pipeout, _, _) <- 
        createProcess (proc "conky" ["-c", conkyFileName])
        { std_out = CreatePipe } 

    (_, _, _, ph)  <- 
        createProcess (proc "lemonbar" parameters) 
        { std_in = UseHandle pipeout }
      
    hClose pipeout
