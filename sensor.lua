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
