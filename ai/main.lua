dofile('server.lua')

local function parse(arg)
  local cmd = torch.CmdLine()
  cmd:option('-port', 8080, 'port number on which a WebSocker server listens')
  cmd:option('-seed', 0, 'random seed')
  return cmd:parse(arg)
end

local function main()
  opt = parse(arg)
  math.randomseed(opt.seed)
  Server:new(opt):listen()
end

main()
