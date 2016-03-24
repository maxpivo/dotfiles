module MyLogHook  
( myLogHook
) where

import XMonad

-- hooks --
import XMonad.Hooks.DynamicLog
import qualified GHC.IO.Handle.Types        as H


-- miscelllanous --
import System.IO
------------------------------------------------------------------------

-- Status Bars and Logging

wrapXBitmap1 bitmap = "^i(/home/epsi/.xmonad/xbm8x8/"++bitmap++")"
wrapXBitmap2 bitmap = "  ^i(/home/epsi/.xmonad/xbm8x8/"++bitmap++")  "

myLogHook ::  H.Handle -> X ()
myLogHook h = dynamicLogWithPP $ def
    {
        ppCurrent         = dzenColor (colorDarkGray) (colorOrange)  
                          . wrap "[ " "]" . (icon_grid ++) . pad 
      , ppVisible         = dzenColor (colorBlue) (colorWhite) 
                          . pad
      , ppHidden          = dzenColor (colorWhite) (colorGreen)  
                          . pad
      , ppHiddenNoWindows = dzenColor (colorWhite) (colorDarkGray) 
                          . pad
      , ppUrgent          = dzenColor (colorRed) (colorPureWhite) 
                          . pad
      , ppWsSep           = ""
      , ppSep             = "      "
      , ppOrder           = \(ws:l:t:_) -> [l, ws, t]
      , ppLayout          = dzenColor (colorBlack) (colorWhite) . 
                             (\x -> case x of
                                     "common"       -> icon_comm
                                     "screenshot"   -> icon_scre
                                     "working"      -> icon_work
                                     "browser"      -> icon_brow
                                     _              -> x
                             )
      , ppTitle           = dzenColor (colorBlack) (colorWhite) 
                          . (" " ++) . (icon_run ++) . (" " ++) 
                          . shorten 50 
                          . (++ " ") . dzenEscape 
      , ppOutput          =   hPutStrLn h 
    }
    where icon_run  = wrapXBitmap1 "heart1.xbm"
          icon_grid = wrapXBitmap1 "grid.xbm"
          icon_comm = wrapXBitmap2 "mtall.xbm"
          icon_scre = wrapXBitmap2 "tall.xbm"
          icon_work = wrapXBitmap2 "tile.xbm"
          icon_brow = wrapXBitmap2 "full.xbm"
          
------------------------------------------------------------------------

-- Color names are easier to remember:
colorOrange         = "#FD971F"
colorDarkGray       = "#1B1D1E"
colorPink           = "#F92672"
colorNormalBorder   = "#CCCCC6"
colorFocusedBorder  = "#fd971f"

colorBlack          = "#121212"
colorRed            = "#c90c25"
colorGreen          = "#2a5b6a"
colorYellow         = "#54777d"
colorBlue           = "#5c5dad"
colorMagen          = "#6f4484"
colorCyan           = "#2B7694"
colorWhite          = "#D6D6D6"
colorPureBlack      = "#000000"
colorPureWhite      = "#FFFFFF"
