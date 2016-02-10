dofile('server.lua')

local function parse(arg)
  local cmd = torch.CmdLine()

  cmd:option('-e',                  0.1, 'e')
  cmd:option('-maxSteps',      10000000, 'maximum number of steps')
  cmd:option('-memorySize',     1000000, 'size of a memory')
  cmd:option('-minibatchSize',       32, 'size of a minibatch')
  cmd:option('-port',              8080, 'port number on which a WebSocker server listens')
  cmd:option('-seed',                 0, 'random seed')

  return cmd:parse(arg)
end

local function main()
  opt = parse(arg)
  math.randomseed(opt.seed)
  Server:new(opt):listen()
end

main()
