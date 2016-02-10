require('nn')

dofile('consts.lua')
dofile('utils.lua')
dofile('memory.lua')

Agent = {}

Agent.__index = Agent

function Agent:new(opt)
  local ag = {}

  setmetatable(ag, self)

  ag.alpha            = opt.alpha
  ag.e                = opt.e
  ag.m                = Memory:new(opt)
  ag.minibatchSize    = opt.minibatchSize
  ag.gamma            = opt.gamma
  ag.model            = ag:createModel()
  ag.target           = nil
  ag.targetUpdateFreq = opt.targetUpdateFreq
  ag.w, ag.dw         = ag.model:getParameters()
  ag.dw:zero()

  ag.deltas           = ag.dw:clone():fill(0)

  ag.tmp              = ag.dw:clone():fill(0)
  ag.g                = ag.dw:clone():fill(0)
  ag.g2               = ag.dw:clone():fill(0)

  self:init()

  return ag
end

function Agent:init()
  self.a = nil
  self.s = nil
end

function Agent:act(s)
  local a = nil

  if math.random() < self.e then
    a = math.random(A_NUM)
  else
    local Q = self.model:forward(s)[1]
    local maxQ = Q[1]
    local optimalA = {1}

    for ad = 2, A_NUM do
      if Q[ad] > maxQ then
        maxQ = Q[ad]
        optimalA = {ad}
      elseif Q[ad] == maxQ then
        optimalA[#optilamA + 1] = ad
      end
    end

    a = optimalA[math.random(#optimalA)]
  end

  self.s = s
  self.a = a

  return a
end

function Agent:update(r, sd, step)
  if self.a ~= nil then
    self.m:add(self.s, self.a, r, sd)
    self:learn()
  end

  if step > 0 and step % self.targetUpdateFreq == 0 then
    self.target = self.model:clone()
  end
end

function Agent:learn()
  local s, a, r, sd = self.m:sample(self.minibatchSize)

  if s == nil or a == nil or r == nil or sd == nil then
    return
  end

  local targets, delta, QdMax = self:getQUpdate(s, a, r, sd)

  self.dw:zero()

  self.model:backward(s, targets)

  self.g:mul(0.95):add(0.05, self.dw)
  self.tmp:cmul(self.dw, self.dw)
  self.g2:mul(0.95):add(0.05, self.tmp)
  self.tmp:cmul(self.g, self.g)
  self.tmp:mul(-1)
  self.tmp:add(self.g2)
  self.tmp:add(0.01)
  self.tmp:sqrt()

  self.deltas:mul(0):addcdiv(self.alpha, self.dw, self.tmp)
  self.w:add(self.deltas)
end

function Agent:createModel()
  local model = nn.Sequential()

  model:add(nn.Linear(S_SIZE, A_NUM))

  return model
end

function Agent:getQUpdate(s, a, r, sd)
  local target = self.target
  if target == nil then
    target = self.model
  end

  local QdMax = target:forward(sd):double():max(2)

  local Qd = QdMax:clone():mul(self.gamma)

  local delta = r:clone()

  delta:add(Qd)

  local QAll = self.model:forward(s):double()

  local Q = torch.Tensor(QAll:size(1))

  for i = 1, QAll:size(1) do
    Q[i] = QAll[i][a[i][1]]
  end

  delta:add(-1, Q)

  local targets = torch.Tensor(self.minibatchSize, A_NUM):zero()
  for i = 1, self.minibatchSize do
    targets[i][a[i][1]] = delta[i]
  end

  return targets, delta, QdMax
end
