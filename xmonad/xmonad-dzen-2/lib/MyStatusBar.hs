module MyStatusBar
( csbdConkyMonitor
, csbdTopBackground
, csbdTopLeft
, csbdTopRight
, csbdBottomBackground
, csbdBottomLeft
, csbdBottomCenter
, csbdBottomRight
) where

-- csbd = Call Stabus Bar DZen2

-- own module: configuration decomposition --
import MyColor

------------------------------------------------------------------------

-- Dzen2 Bar

-- Reading:
-- https://github.com/robm/dzen

-- Inspired by
-- https://github.com/harukachan/dotfiles/tree/master/unminimalVarokah

------------------------------------------------------------------------    

fgColor = myColor "Foreground"
bgColor = myColor "Background"
dcColor = myColor "Decoration"

screenWidth = "1280"

font1 = "awesome-9"
font2 = "profont-9"
font3 = "Droid Sans Fallback-9:bold"
font4 = "takaopgothic-9"

dzenArgs = " -p -e 'button3=' -fn '"++font3++"' "
dzenColors = " -fg '"++fgColor++"' -bg '"++bgColor++"' "

------------------------------------------------------------------------
-- Top

csbdTopBackground = "echo '^fg("++dcColor++")^p(;-10)^r("++screenWidth++"x5)' |"
    ++ " dzen2 -ta c -h 35 -w "++screenWidth++" "
    ++ dzenArgs ++ dzenColors

csbdTopLeft = "sleep 0.5 && "
    ++ " conky -c ~/.xmonad/assets/conky-dzen/top-left | "
    ++ " dzen2 -ta l -h 21 -y 4 -w 350 -x 0 "
    ++ dzenArgs ++ dzenColors

csbdTopRight = "sleep 0.5 && "
    ++ " conky -c ~/.xmonad/assets/conky-dzen/top-right | "
    ++ " dzen2 -ta r -h 21 -y 4 -w 350 -x -350 "
    ++ dzenArgs ++ dzenColors

csbdConkyMonitor = "sleep 0.5 && "
    ++ " conky -c ~/.xmonad/assets/conky-dzen/top-center | "
    ++ " dzen2 -ta c -h 18 -x 0 -y 4 "
    ++ " -w `expr "++screenWidth++" - 600` -x 300 "    
    ++ dzenArgs ++ dzenColors

------------------------------------------------------------------------
-- Bottom

csbdBottomBackground = "echo '^fg("++dcColor++")^p(;21)^r("++screenWidth++"x5)' |"
    ++ " dzen2 -ta c -h 35 -y -35 -w "++screenWidth++" "
    ++ dzenArgs ++ dzenColors
    
csbdBottomLeft = "sleep 1; "
    ++ " dzen2 -ta l -h 25 -y -29 "
    ++ " -w `expr "++screenWidth++" / 2` "
    ++ dzenArgs ++ dzenColors

csbdBottomRight = "sleep 1.5 && "
    ++ " conky -c ~/.xmonad/assets/conky-dzen/bottom | "
    ++ " dzen2 -ta r -h 25 -y -29 -w 200 -x -200 "
    ++ dzenArgs ++ dzenColors
        
csbdBottomCenter = "sleep 2; "
    ++ " dzen2 -ta c -h 20 -y -24 "
    ++ " -w 600 -x `expr "++screenWidth++" / 2 - 150` "
    ++ dzenArgs ++ dzenColors
    
