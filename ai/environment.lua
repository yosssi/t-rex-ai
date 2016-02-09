dofile('agent.lua')
dofile('consts.lua')

local JSON = assert(loadfile "JSON.lua")()

Environment = {}

Environment.__index = Environment

function Environment:new()
  local env = {}

  setmetatable(env, self)

  env.ag = Agent:new()

  return env
end

function Environment:update(msg)
  local m = JSON:decode(msg)

  if m.msgType == MSG_TYPE_READY then
    return ACTION_JUMP
  elseif m.msgType == MSG_TYPE_STATE then
    print(m)
    return ACTION_NONE
  else
    return ACTION_NONE
  end
end
