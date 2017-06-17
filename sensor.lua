dht_cfg =
  {
    pin = 1,
    time = 15000
  }

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
