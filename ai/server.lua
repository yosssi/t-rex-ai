dofile('environment.lua')

Server = {}

Server.__index = Server

function Server:new(opt)
  local srv = {}

  setmetatable(srv, self)

  srv.port = opt.port
  srv.env  = Environment:new(opt)

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
            local a = self.env:update(msg)
            if a then
              ws:send(tostring(a))
            else
              ws:close()
              os.exit(0)
              return
            end
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
