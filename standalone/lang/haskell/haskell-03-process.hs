import System.Process
import System.IO

import Data.Time.LocalTime
import Data.Time.Format

import Control.Concurrent
import Control.Monad

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ---
-- wrap Funktion

myTimeFormat = "%a %b %d %H:%M:%S"

wFormatTime :: FormatTime t => t -> String
wFormatTime myUtcTime = formatTime 
  Data.Time.Format.defaultTimeLocale myTimeFormat myUtcTime

wSleep :: Int -> IO ()
wSleep mySecond = threadDelay (div 1000000 mySecond)

printDate pipein = do
     now <- getZonedTime
     let nowFmt = wFormatTime now

     hPutStrLn pipein nowFmt
     hFlush pipein

     wSleep 1

cmdout = "less" -- or dzen2

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ---
-- main

main = do
    (Just pipein, _, _, ph)  <- 
        createProcess (System.Process.proc cmdout []) 
        { std_in = CreatePipe }
    
    forever $ printDate pipein
    hClose pipein
    
    putStrLn ""
  


