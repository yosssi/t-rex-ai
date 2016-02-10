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
  env.score    = 0
  env.step     = 0
  env.maxScore = 0
  env.scores   = {}

  env:init()

  return env
end

function Environment:init()
  self.s     = nil
end

function Environment:debug(r, sd)
  if self.s == nil then
    return
  end

  io.write(string.format('step: %d, maxScore: %d, episode: %d, score: %d', self.step, self.maxScore, self.ep, self.score))

  io.write(', s:')
  for i = 1, (#self.s)[2] do
    io.write(' ' .. tostring(self.s[1][i]))
  end

  io.write(string.format(', a: %d, r: %d', self.ag.a, r))

  io.write(', sd:')
  for i = 1, (#sd)[2] do
    io.write(' ' .. tostring(sd[1][i]))
  end
  io.write('\n')
end

function Environment:update(msg)
  local m = JSON:decode(msg)

  if m.msgType == MSG_TYPE_READY then
    return A_JUMP
  elseif m.msgType == MSG_TYPE_STATE then
    local sd = state(m.state)

    local r = self:reward(sd)

    -- self:debug(r, sd)

    self.ag:update(r, sd, self.step)

    if self.maxSteps <= self.step then
      return nil
    end

    if isGameOver(sd) then
      self:debug(r, sd)
      self:init()
      self.scores[self.ep] = self.score
      self.ag:init()
      return A_NONE
    end

    -- Proceed to the next step

    self.step = self.step + 1

    if self.s == nil then
      self.ep = self.ep + 1
    end

    self.s = sd

    self.score = m.state.score

    self.maxScore = math.max(self.maxScore, m.state.score)

    return self.ag:act(self.s)
  end
end

function Environment:reward(s)
  if isGameOver(s) then
    return -1
  else
    return 0
  end
end
