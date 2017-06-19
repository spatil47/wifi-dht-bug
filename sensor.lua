dht_cfg =
  {
    pin = 1,
    time = 15000
  }

mqtt_cfg.deviceInfo =
  {
    name = "WiFi DHT Bug",
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

m:subscribe(
  "/inbox/" .. client_id .. "/deviceInfo",
  0,
  function(c)
    print("Subscribed to Crouton inbox MQTT topic.")
    ok, json = pcall(sjson.encode, mqtt_cfg.deviceInfo)
    if ok then
      print ("Encoded Crouton device info as JSON string.")
      print ("Result: " .. json)
    else
      print ("Failed to encode Crouton device info as JSON string.")
    end
    c:publish("/outbox/"..client_id.."/deviceInfo", json, 0, 0)
  end
)

tmr.create():
  alarm(
    dht_cfg.time,
    tmr.ALARM_AUTO,
    function()
      status, temp, humi, temp_dec, humi_dec = dht.read(dht_cfg.pin)
      if status == dht.OK then
        print("Temperature measured ".. ((temp*9/5)+32) .." degrees Fahrenheit. Humidity is "..humi .. "%.")
      elseif status == dht.ERROR_CHECKSUM then
        print( "Temperature/humidity measurement failed due to DHT checksum error." )
      elseif status == dht.ERROR_TIMEOUT then
        print( "Temperature/humidity measurement failed due to DHT timeout." )
      end
    end
  )
