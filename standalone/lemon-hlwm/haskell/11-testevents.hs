import System.Process
import System.IO
import System.Posix.Process

import Data.Time.LocalTime
import Data.Time.Format

import Control.Concurrent
import Control.Monad

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- helper

wFormatTime :: FormatTime t => t -> String
wFormatTime myUtcTime = formatTime 
    Data.Time.Format.defaultTimeLocale myTimeFormat myUtcTime
  where myTimeFormat = "%H:%M:%S"

wSleep :: Int -> IO ()
wSleep mySecond = threadDelay (1000000 * mySecond)

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- pipe 

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
     now <- getZonedTime
     let timeStr = wFormatTime now
     let timeText = "interval" ++ "\t" ++ timeStr

     hPutStrLn pipe_cat_in timeText
     hFlush pipe_cat_in

     wSleep 3

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- main

main = do
    (Just pipe_cat_in, Just pipe_cat_out, _, ph) <- 
        createProcess (proc "cat" []) 
        { std_in = CreatePipe, std_out = CreatePipe }

    forkProcess $ contentEventIdle(pipe_cat_in)
    forkProcess $ contentEventInterval(pipe_cat_in)
    
    forever $ do
        -- wait for next event 
        event <- hGetLine pipe_cat_out
        putStrLn $ "event:\t[" ++ event ++ "]"

    hClose pipe_cat_out
    hClose pipe_cat_in
    
    return ()
