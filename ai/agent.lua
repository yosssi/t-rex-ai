dofile('consts.lua')
dofile('utils.lua')
dofile('memory.lua')

Agent = {}

Agent.__index = Agent

function Agent:new(opt)
  local ag = {}

  setmetatable(ag, self)

  ag.e             = opt.e
  ag.m             = Memory:new(opt)
  ag.minibatchSize = opt.minibatchSize

  self:init()

  return ag
end

function Agent:init()
  self.a = nil
  self.s = nil
end

function Agent:act(s)
  if isGameOver(s) then
    self:init()
    return A_NONE
  end

  local a = nil

  if math.random() < self.e then
    a = math.random(A_NUM)
  else
    a = A_JUMP
  end

  self.a = a
  self.s = s

  return a
end

function Agent:update(r, sd)
  if self.a == nil then
    return
  end
end

function Agent:learn()

end
