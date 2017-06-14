pin = 1

tmr.create():
  alarm(
  5000,
  tmr.ALARM_AUTO,
  function()
    status, temp, humi, temp_dec, humi_dec = dht.read(pin)
    if status == dht.OK then
      print("DHT Temperature: ".. ((temp*9/5)+32) .." ; ".."Humidity: "..humi)
    elseif status == dht.ERROR_CHECKSUM then
      print( "DHT Checksum error." )
    elseif status == dht.ERROR_TIMEOUT then
      print( "DHT timed out." )
    end
  end)
