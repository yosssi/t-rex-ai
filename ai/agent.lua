dofile('consts.lua')
dofile('utils.lua')

Agent = {}

Agent.__index = Agent

function Agent:new(opt)
  local ag = {}

  setmetatable(ag, self)

  ag.e = opt.e

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
    return ACTION_NONE
  end

  local a = nil

  if math.random() < self.e then
    a = A[math.random(#A)]
  else
    a = ACTION_JUMP
  end

  self.a = a
  self.s = s

  return a
end

function Agent:update(r)
  if self.a == nil then
    return
  end
end
