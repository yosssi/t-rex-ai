Agent = {}

Agent.__index = Agent

function Agent:new()
  local ag = {}

  setmetatable(ag, self)

  return ag
end

function Agent:a()

end
