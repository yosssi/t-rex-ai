dofile('agent.lua')
dofile('consts.lua')
dofile('utils.lua')

local JSON = assert(loadfile "JSON.lua")()

Environment = {}

Environment.__index = Environment

function Environment:new(opt)
  local env = {}

  setmetatable(env, self)

  env.ag       = Agent:new(opt)
  env.maxSteps = opt.maxSteps
  env.ep       = 0
  env.step     = 0
  env.maxScore = 0

  env:init()

  return env
end

function Environment:init()
  self.s     = nil
  self.score = 0
end

function Environment:debug(r)
  io.write('step: ' .. tostring(self.step) .. ', maxScore: ' .. tostring(self.maxScore) .. ', episode: ' .. tostring(self.ep) .. ', score: ' .. tostring(self.score) .. ', reward: ' .. tostring(r) .. ', state: ')
  for i = 1, (#self.s)[2] do
    io.write(tostring(self.s[1][i]) .. ' ')
  end
  io.write('\n')
end

function Environment:update(msg)
  local m = JSON:decode(msg)

  if m.msgType == MSG_TYPE_READY then
    return ACTION_JUMP
  elseif m.msgType == MSG_TYPE_STATE then
    local s = state(m.state)

    local r = self:reward(s)

    self.ag:update(r)

    if self.maxSteps <= self.step then
      return nil
    end

    if self.s == nil then
      self.ep = self.ep + 1
    end

    self.s = s

    self.step = self.step + 1

    self.score = m.state.score

    self.maxScore = math.max(self.maxScore, m.state.score)

    self:debug(r)

    if isGameOver(s) then
      self:init()
    end

    return self.ag:act(s)
  end
end

function Environment:reward(s)
  if self.s == nil then
    return 0
  elseif isGameOver(s) then
    return -1
  else
    return 1
  end
end
