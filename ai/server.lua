dofile('environment.lua')

Server = {}

Server.__index = Server

function Server:new(opt)
  local srv = {}

  setmetatable(srv, self)

  srv.port = opt.port
  srv.env  = Environment:new()

  return srv
end

function Server:listen()
  local copas = require('copas')

  require('websocket').server.copas.listen{
    port = self.port,
    protocols = {
      ai = function(ws)
        while true do
          local msg = ws:receive()
          if msg then
            ws:send(self.env:update(msg))
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
