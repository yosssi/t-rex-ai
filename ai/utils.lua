dofile('consts.lua')

function b2n(b)
  if b then
    return 1
  else
    return 0
  end
end

function state(t)
  local s = torch.Tensor(1, S_SIZE):zero()

  s[1][1] = t.trex.y
  s[1][2] = b2n(t.trex.ducking)
  s[1][3] = b2n(t.trex.speedDrop)
  s[1][4] = b2n(t.isGameOver)

  if t.obstacles then
    table.sort(t.obstacles, function(a, b) return a.x < b.x end)
  end

  for i = 1, 3 do
    local x = 0
    local y = 0
    local w = 0
    local h = 0

    if t.obstacles and i <= #t.obstacles then
      x = t.obstacles[i].x
      y = t.obstacles[i].y
      w = t.obstacles[i].width
      h = t.obstacles[i].height
    end

    s[1][i * 4 + 1] = x
    s[1][i * 4 + 2] = y
    s[1][i * 4 + 3] = w
    s[1][i * 4 + 4] = h
  end

  return s
end

function isGameOver(s)
  return s[1][4] == 1
end
