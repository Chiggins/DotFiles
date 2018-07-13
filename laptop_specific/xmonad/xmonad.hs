import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO

main = do
  xmproc <- spawnPipe "xmobar ~/.xmobarrc"
  xmonad $ defaultConfig
    { manageHook = manageDocks <+> manageHook defaultConfig
    , layoutHook = avoidStruts  $  layoutHook defaultConfig
    , logHook = dynamicLogWithPP xmobarPP
        { ppOutput = hPutStrLn xmproc
        , ppTitle = xmobarColor "green" "" . shorten 50
        } 
    } `additionalKeys`
    [ ((mod4Mask, xK_l), spawn "xscreensaver-command -lock") -- lock screen
    , ((mod1Mask, xK_Print), spawn "sleep 0.2; scrot -s") -- screenshot active window
    , ((0, xK_Print), spawn "scrot") -- screenshot entire screen
    , ((mod1Mask .|. shiftMask, xK_i), spawn "chromium") -- Google Chrome
--    , ((), spawn "amixer -q set Master 5-")
--    , ((), spawn "amixer -q set Master 5+")
    ]
