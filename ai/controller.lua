dofile('consts.lua')

local JSON = assert(loadfile "JSON.lua")()

Controller = {}

Controller.__index = Controller

function Controller:new()
  local ctrl = {}

  setmetatable(ctrl, self)

  return ctrl
end

function Controller:handle(msg)
  local m = JSON:decode(msg)
  if m.type == TYPE_WAIT_FOR_START then
    return ACTION_JUMP
  elseif m.type == TYPE_UPDATE then
    print(m.data.score)
    return ACTION_NONE
  elseif m.type == TYPE_GAMEOVER then
    print('game over!')
    return ACTION_NONE
  else
    return ACTION_NONE
  end
end
