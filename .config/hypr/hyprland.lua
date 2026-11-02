-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- Hyprlain - Hyprland Lua Configuration                 --
-- https://github.com/Ascaniolamp/Hyprlain                --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/configuring/core/monitors/
-- Main monitor (Samsung Odyssey G40B): 1080p @ 240 Hz
hl.monitor({
    output    = "HDMI-A-3",
    mode      = "1920x1080@239.76",
    position  = "0x0",
    scale     = 1,
    transform = 0,
})

-- Secondary monitor (LG MP59G): rotated right 90 degrees (portrait)
hl.monitor({
    output    = "DP-2",
    mode      = "1920x1080@74.97",
    position  = "1920x0",
    scale     = 1,
    transform = 3,
})

-- Fallback for any other monitor
hl.monitor({
    output   = "",
    mode     = "highrr",
    position = "auto",
    scale    = 1,
})

-------------------------
---- MODULE IMPORTS -----
-------------------------

require("palette")
require("programs")
require("style")
require("input")
require("keys")
require("windows")
require("plugins")
require("wallpaper")
