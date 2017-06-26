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

separator = "%{B-}%{F" ++ myColor "yellow500" ++ "}|%{B-}%{F-}"

-- Powerline Symbol
rightHardArrow = "\57520"
rightSoftArrow = "\57521"
leftHardArrow  = "\57522"
leftSoftArrow  = "\57523"

-- theme
preIcon    = "%{F" ++ myColor "yellow500" ++ "}"
postIcon   = "%{F-}"

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
    
    let tagText = "%{l}" ++ (join $ map (outputByTag monitor) tags)
    timeText  <- ("%{c}" ++) <$> outputByDatetime
    titleText <- ("%{r}" ++) <$> outputByTitle

    let text = tagText ++ timeText ++ titleText
    return text

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- each segments

outputByTag :: Int -> String -> String
outputByTag monitor tagStatus = 
    textPre ++ textName ++ textPost ++ textClear
  where
    -- text = ''

    tagIndex  = drop 1 tagStatus 
    tagMark   = take 1 tagStatus 
    index     = (read::String->Int) tagIndex - 1     -- zero based
    tagName   = tagShows !! index

    ----- pre tag
    
    textPre   = case tagMark of
        "#" -> "%{B" ++ myColor "blue500" ++ "}"
            ++ "%{F" ++ myColor "black" ++ "}"
            ++ "%{U" ++ myColor "white" ++ "}%{+u}" 
            ++ rightHardArrow
            ++ "%{B" ++ myColor "blue500" ++ "}"
            ++ "%{F" ++ myColor "white" ++ "}"
            ++ "%{U" ++ myColor "white" ++ "}%{+u}"
        "+" -> "%{B" ++ myColor "yellow500" ++ "}"
            ++ "%{F" ++ myColor "grey400" ++ "}"
        ":" -> "%{B-}"
            ++"%{F" ++ myColor "white" ++ "}"
            ++ "%{U" ++ myColor "red500" ++ "}%{+u}"
        "!" -> "%{B" ++ myColor "red500" ++ "}"
            ++ "%{F" ++ myColor "white" ++ "}"
            ++ "%{U" ++ myColor "white" ++ "}%{+u}"
        _   -> "%{B-}"
            ++ "%{F" ++ myColor "grey600" ++ "}%{-u}"

    ----- tag by number
    
    -- clickable tags
    textName  = "%{A:herbstclient focus_monitor \"" 
        ++ show(monitor) ++ "\" && " ++ "herbstclient use \"" 
        ++ tagIndex ++ "\":} " ++ tagName ++ " %{A} "
   
    -- non clickable tags
    -- textName = " " ++ tagName ++ " "

    ----- post tag

    textPost  = if (tagMark == "#")
                    then "%{B-}"
                      ++ "%{F" ++ myColor "blue500" ++ "}"
                      ++ "%{U" ++ myColor "red500" ++ "}%{+u}"
                      ++ rightHardArrow
                    else ""
    
    textClear = "%{B-}%{F-}%{-u}"

outputByTitle :: IO String
outputByTitle = do
    segment <- readIORef segmentWindowtitle
    let text  = segment ++ " " ++ separator ++ "  "

    return text

outputByDatetime :: IO String
outputByDatetime = do
    segment <- readIORef segmentDatetime
    return segment

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
    let text = " " ++ icon ++ " %{B-}"
               ++ "%{F" ++ myColor "grey700" ++ "} " ++ windowtitle
    writeIORef segmentWindowtitle text

formatDatetime :: ZonedTime -> String
formatDatetime now = dateText ++ "  " ++ timeText
  where
    dateStr = wFormatTime now "%a %b %d"
    timeStr = wFormatTime now "%H:%M:%S"
     
    dateIcon = preIcon ++ "\61555" ++ postIcon
    timeIcon = preIcon ++ "\61463" ++ postIcon

    dateText = " " ++ dateIcon ++ " %{B-}"
               ++ "%{F" ++ myColor "grey700" ++ "} " ++ dateStr

    timeText = " " ++ timeIcon ++ " %{B-}"
               ++ "%{F" ++ myColor "blue500" ++ "} " ++ timeStr

setDatetime :: IO ()
setDatetime = do
    now <- getZonedTime     
    writeIORef segmentDatetime $ formatDatetime now
