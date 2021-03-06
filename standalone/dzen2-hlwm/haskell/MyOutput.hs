module MyOutput
( setTagValue
, setWindowtitle
, setDatetime
, getStatusbarText
) where

import Data.IORef
import System.IO.Unsafe

import System.Process
import System.IO

import Control.Monad

import Data.Time.LocalTime
import Data.Time.Format

import MyGMC

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- initialize

-- assuming $ herbstclient tag_status
-- 	#1	:2	:3	:4	.5	.6	.7	.8	.9

-- custom tag names
tagShows :: [String] 
tagShows = ["一 ichi", "二 ni", "三 san", "四 shi", 
    "五 go", "六 roku", "七 shichi", "八 hachi", "九 kyū", "十 jū"]

-- initialize variable segment
-- simulate global variable using unsafe

segmentWindowtitle :: IORef String
segmentWindowtitle = unsafePerformIO $ newIORef "" -- empty string

tagsStatus :: IORef [String]
tagsStatus = unsafePerformIO $ newIORef []         -- empty string list

segmentDatetime :: IORef String
segmentDatetime = unsafePerformIO $ newIORef ""    -- empty string

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- decoration

separator = "^bg()^fg(" ++ myColor "black" ++ ")|^bg()^fg()"

-- http://fontawesome.io/
fontAwesome = "^fn(FontAwesome-9)"

-- Powerline Symbol
rightHardArrow = "^fn(powerlinesymbols-14)\57520^fn()"
rightSoftArrow = "^fn(powerlinesymbols-14)\57521^fn()"
leftHardArrow  = "^fn(powerlinesymbols-14)\57522^fn()"
leftSoftArrow  = "^fn(powerlinesymbols-14)\57523^fn()"

-- theme
preIcon    = "^fg(" ++ myColor "yellow500" ++ ")" ++ fontAwesome
postIcon   = "^fn()^fg()"

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- helper
 
wFormatTime :: FormatTime t => t -> String -> String
wFormatTime myUtcTime myTimeFormat = formatTime 
    Data.Time.Format.defaultTimeLocale myTimeFormat myUtcTime

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- main

getStatusbarText :: Int -> IO String
getStatusbarText monitor = do    
    tags <- readIORef tagsStatus
    let tagText = join $ map (outputByTag monitor) tags

    timeText  <- outputByDatetime
    titleText <- outputByTitle

    let text = tagText ++ timeText ++ titleText
    return text

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- each segments

outputByTag :: Int -> String -> String
outputByTag monitor tagStatus = textPre ++ textName ++ textPost
  where
    -- text = ''

    tagIndex  = drop 1 tagStatus 
    tagMark   = take 1 tagStatus 
    index     = (read::String->Int) tagIndex - 1     -- zero based
    tagName   = tagShows !! index

    ----- pre tag
    
    textPre   = case tagMark of
        "#" -> "^bg(" ++ myColor "blue500" ++ ")"
            ++ "^fg(" ++ myColor "black" ++ ")"
            ++ rightHardArrow
            ++ "^bg(" ++ myColor "blue500" ++ ")"
            ++ "^fg(" ++ myColor "white" ++ ")"
        "+" -> "^bg(" ++ myColor "yellow500" ++ ")"
            ++ "^fg(" ++ myColor "grey400" ++ ")"
        ":" -> "^bg()^fg(" ++ myColor "white" ++ ")"
        "!" -> "^bg(" ++ myColor "red500" ++ ")"
            ++ "^fg(" ++ myColor "white" ++ ")"
        _   -> "^bg()^fg(" ++ myColor "grey600" ++ ")"

    ----- tag by number
   
    -- assuming using dzen2_svn
    -- clickable tags if using SVN dzen
    textName  = "^ca(1,herbstclient focus_monitor \"" 
        ++ show(monitor) ++ "\" && " ++ "herbstclient use \"" 
        ++ tagIndex ++ "\") " ++ tagName ++ " ^ca() "

    ----- post tag

    textPost  = if (tagMark == "#")
                    then "^bg(" ++ myColor "black" ++ ")"
                      ++ "^fg(" ++ myColor "blue500" ++ ")"
                      ++ rightHardArrow
                    else ""

outputByTitle :: IO String
outputByTitle = do
    segment <- readIORef segmentWindowtitle
    let text  = " ^r(5x0) " ++ separator ++ " ^r(5x0) " ++ segment

    return text

outputByDatetime :: IO String
outputByDatetime = do
    segment <- readIORef segmentDatetime
    let text  = " ^r(5x0) " ++ separator ++ " ^r(5x0) " ++ segment

    return text

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- setting variables, response to event handler
--import Data.IORef
 
setTagValue :: Int -> IO ()
setTagValue monitor = do
    let args = ["tag_status", show(monitor)]

    (_, Just pipe_out, _, ph) <- 
        createProcess (proc "herbstclient" args)
        { std_out = CreatePipe } 
        
    raw <- hGetContents pipe_out   
    _ <- waitForProcess ph

    let statusList = words raw
    writeIORef tagsStatus statusList

setWindowtitle :: String -> IO ()
setWindowtitle windowtitle = do
    let icon = preIcon ++ "\61444" ++ postIcon
    let text = " " ++ icon ++ " ^bg()"
               ++ "^fg(" ++ myColor "grey700" ++ ") " ++ windowtitle
    writeIORef segmentWindowtitle text

formatDatetime :: ZonedTime -> String
formatDatetime now = dateText ++ "  " ++ timeText
  where
    dateStr = wFormatTime now "%a %b %d"
    timeStr = wFormatTime now "%H:%M:%S"
     
    dateIcon = preIcon ++ "\61555" ++ postIcon
    timeIcon = preIcon ++ "\61463" ++ postIcon

    dateText = " " ++ dateIcon ++ " ^bg()"
               ++ "^fg(" ++ myColor "grey700" ++ ") " ++ dateStr

    timeText = " " ++ timeIcon ++ " ^bg()"
               ++ "^fg(" ++ myColor "blue500" ++ ") " ++ timeStr

setDatetime :: IO ()
setDatetime = do
    now <- getZonedTime     
    writeIORef segmentDatetime $ formatDatetime now
