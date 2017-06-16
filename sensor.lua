dht_pin = 1

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

m:connect(
  mqtt_cfg.host,
  mqtt_cfg.port,
  0,
  function(client)
    print("Connected to MQTT broker " .. mqtt_cfg.host .. " on port " .. mqtt_cfg.port .. ".")
  end,
  function(client, reason)
    print("Failed to connect to MQTT broker due to error " .. reason .. ".")
  end
)

tmr.create():
  alarm(
    15000,
    tmr.ALARM_AUTO,
    function()
      status, temp, humi, temp_dec, humi_dec = dht.read(dht_pin)
      if status == dht.OK then
        print("DHT Temperature: ".. ((temp*9/5)+32) .." ; ".."Humidity: "..humi)
      elseif status == dht.ERROR_CHECKSUM then
        print( "Temperature/humidity measurement failed due to DHT checksum error." )
      elseif status == dht.ERROR_TIMEOUT then
        print( "Temperature/humidity measurement failed due to DHT timeout." )
      end
    end
  )
