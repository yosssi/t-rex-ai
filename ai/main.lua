dofile('ws_server.lua')

local function parse(arg)
  local cmd = torch.CmdLine()
  cmd:option('-port', 8080, 'port number on which a WebSocker server listens')
  return cmd:parse(arg)
end

local function main()
  WSServer:new(parse(arg)):listen()
end

main()
