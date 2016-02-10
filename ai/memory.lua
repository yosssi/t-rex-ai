dofile('consts.lua')

Memory = {}

Memory.__index = Memory

function Memory:new(opt)
  local m = {}

  setmetatable(m, self)

  m.size = opt.memorySize

  m.s  = torch.Tensor(m.size, S_SIZE)
  m.a  = torch.Tensor(m.size, 1)
  m.r  = torch.Tensor(m.size, 1)
  m.sd = torch.Tensor(m.size, S_SIZE)

  m.i  = 1

  return m
end
