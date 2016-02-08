dofile('controller.lua')

WSServer = {}

WSServer.__index = WSServer

function WSServer:new(opt)
  local srv = {}

  setmetatable(srv, self)

  srv.port = opt.port
  srv.ctrl = Controller:new()

  return srv
end

function WSServer:listen()
  local copas = require('copas')

  require('websocket').server.copas.listen{
    port = self.port,
    protocols = {
      ai = function(ws)
        while true do
          local msg = ws:receive()
          if msg then
            ws:send(self.ctrl:handle(msg))
          else
            ws:close()
            return
          end
        end
      end
    }
  }

  copas.loop()
end
