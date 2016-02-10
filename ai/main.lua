dofile('server.lua')

local function parse(arg)
  local cmd = torch.CmdLine()

  cmd:option('-alpha',              0.1, 'learning rate')
  cmd:option('-e',                  0.1, 'e')
  cmd:option('-gamma',             0.99, 'discount factor')
  cmd:option('-maxSteps',      10000000, 'maximum number of steps')
  cmd:option('-maxMemorySize',  1000000, 'maximum size of a memory')
  cmd:option('-minibatchSize',       32, 'size of a minibatch')
  cmd:option('-port',              8080, 'port number on which a WebSocker server listens')
  cmd:option('-seed',                 0, 'random seed')
  cmd:option('-targetUpdateFreq',  1000, 'target network update frequency')

  return cmd:parse(arg)
end

local function main()
  local opt = parse(arg)
  math.randomseed(opt.seed)
  Server:new(opt):listen()
end

main()
