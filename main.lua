local ui = require("ui")
require "webview"
local sys = require("sys")

local FRONTEND = embed and embed.File('main.html') or sys.File(sys.File(arg[1]).path .. "/main.html")

local function convertFilePathToUrl(filePath)
    local url = string.gsub(filePath, "\\", "/")
    return url
end

local windowmain = ui.Window("ecVideo", "dialog", 420, 450)
local buttonplay = ui.Button(windowmain, "PLAY", 50, 320)
local buttonpause = ui.Button(windowmain, "PAUSE", 100, 320)
local buttonopen = ui.Button(windowmain, "OPEN", 200, 320)
local videoplayer = ui.Webview(windowmain, FRONTEND.fullpath, 10, 10, 500, 300)

function buttonplay:onClick()
    videoplayer:eval("document.getElementById('player').play();")
end

function buttonpause:onClick()
    videoplayer:eval("document.getElementById('player').pause();")
end

function buttonopen:onClick()
    local file = ui.opendialog("", false, "video file (*.mp4)|*.mp4")

    if file ~= nil then
        local path = file.fullpath
        file:close()
        
        windowmain:status(path)

        videoplayer:eval("document.getElementById('player').src = '" .. convertFilePathToUrl(path) .. "'; document.getElementById('player').load();")

        buttonplay.enabled = true
        buttonpause.enabled = true
    end
end

function windowmain:onCreate()
    self.bgcolor = 0xFFFFFF
    self:center()
end

function videoplayer:onReady()
    self.devtools = false
    self.statusbar = false
    self.contextmenu = false
    buttonplay.enabled = false
    buttonpause.enabled = false
end

ui.run(windowmain):wait()
