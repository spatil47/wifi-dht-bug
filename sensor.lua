dht_cfg =
  {
    pin = 1,
    time = 15000
  }

mqtt_cfg.crouton_deviceInfo =
  {
    deviceInfo =
      {
        name = client_id,
        endPoints =
          {
            temperature =
              {
                title = "Temperature",
                ["card-type"] = "crouton-simple-text",
                units = "degrees Fahrenheit",
                values =
                  {
                    value = 70,
                  }
              },
            humidity =
              {
                title = "Humidity",
                ["card-type"] = "crouton-simple-text",
                units = "percent",
                values =
                  {
                    value = 40,
                  }
              }
          },
        description = "AM2032 and NodeMCU-based IoT temperature and humidity sensor",
        status = "good"
      }
  }

m:subscribe(
  "/inbox/" .. client_id .. "/deviceInfo",
  0,
  function(c)
    print("Subscribed to Crouton inbox MQTT topic.")
    ok, json = pcall(sjson.encode, mqtt_cfg.crouton_deviceInfo)
    if ok then
      print ("Encoded Crouton device info as JSON string.")
      print ("Result: " .. json)
    else
      print ("Failed to encode Crouton device info as JSON string.")
    end
    c:publish(
      "/outbox/"..client_id.."/deviceInfo",
      json,
      0,
      0,
      function(dht_c)
        print("Transmitted Crouton device info JSON string to MQTT broker.")
        tmr.create():
          alarm(
            dht_cfg.time,
            tmr.ALARM_AUTO,
            function()
              status, temp, humi, temp_dec, humi_dec = dht.read(dht_cfg.pin)
              if status == dht.OK then
                print("Temperature measured ".. ((temp*9/5)+32) .." degrees Fahrenheit. Humidity is "..humi .. "%.")
                dht_c:publish(
                  "/outbox/"..client_id.."/temperature",
                  "{ \"value\": " .. ((temp*9/5)+32) .. " }",
                  0,
                  0,
                  function()
                    print("Transmitted temperature or humidity value to MQTT broker.")
                  end
                )
                dht_c:publish(
                  "/outbox/"..client_id.."/humidity",
                  "{ \"value\": " .. humi .. " }",
                  0,
                  0,
                  function()
                    print("Transmitted temperature or humidity value to MQTT broker.")
                  end
                )
              elseif status == dht.ERROR_CHECKSUM then
                print( "Temperature/humidity measurement failed due to DHT checksum error." )
              elseif status == dht.ERROR_TIMEOUT then
                print( "Temperature/humidity measurement failed due to DHT timeout." )
              end
            end
          )
      end
    )
  end
)

m:on(
  "message",
  function(recv_c, topic, message)
    if topic == "/inbox/"..client_id.."/deviceInfo" and message == "get" then
      recv_c:publish("/outbox/"..client_id.."/deviceInfo", json, 0, 0)
      print("sent")
    end
  end
)
