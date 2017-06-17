client_id = string.format("node-%x", node.chipid())

m = mqtt.Client(client_id, 120, mqtt_cfg.user, mqtt_cfg.pwd)

m:lwt(
  "/outbox/"..client_id.."/lwt",
  "offline",
  0,
  0
)

m:on(
  "offline",
  function(client)
    print ("Disconnected from MQTT broker.")
  end
)

m:on(
  "message",
  function(client, topic, data)
    print(topic .. ":" )
    if data ~= nil then
      print(data)
    end
  end
)

m:on(
  "connect",
  function(client)
    print("Connected to MQTT broker " .. mqtt_cfg.host .. " on port " .. mqtt_cfg.port .. ".")
    dofile("sensor.lua")
  end
)

m:connect(
  mqtt_cfg.host,
  mqtt_cfg.port,
  0,
  nil,
  function(client, reason)
    print("Failed to connect to MQTT broker due to error " .. reason .. ".")
  end
)

