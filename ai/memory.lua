dofile('consts.lua')

Memory = {}

Memory.__index = Memory

function Memory:new(opt)
  local m = {}

  setmetatable(m, self)

  m.maxSize = opt.maxMemorySize

  m.s       = torch.Tensor(m.maxSize, S_SIZE):zero()
  m.a       = torch.Tensor(m.maxSize, 1):zero()
  m.r       = torch.Tensor(m.maxSize, 1):zero()
  m.sd      = torch.Tensor(m.maxSize, S_SIZE):zero()

  m.size    = 0
  m.i       = 1

  return m
end

function Memory:add(s, a, r, sd)
  self.s[self.i]  = s
  self.a[self.i]  = a
  self.r[self.i]  = r
  self.sd[self.i] = sd

  self.size = math.min(self.size + 1, self.maxSize)

  if self.i == self.maxSize then
    self.i = 1
  else
    self.i = self.i + 1
  end
end

function Memory:sample(size)
  if self.size < size then
    return nil, nil, nil, nil
  end

  local s   = torch.Tensor(size, S_SIZE):zero()
  local a   = torch.Tensor(size, 1):zero()
  local r   = torch.Tensor(size, 1):zero()
  local sd  = torch.Tensor(size, S_SIZE):zero()

  for i = 1, size do
    local j = math.random(self.size)
    s[i]  = self.s[j]
    a[i]  = self.a[j]
    r[i]  = self.r[j]
    sd[i] = self.sd[j]
  end

  return s, a, r, sd
end
