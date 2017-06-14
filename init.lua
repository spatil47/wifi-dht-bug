dofile("wifi_cfg.lua")

wifi.eventmon.register(
  wifi.eventmon.STA_CONNECTED,
  function(T)
    print("WiFi station connected to access point \"" .. T.SSID .. "\" on channel " .. T.channel ..". RSSI is " .. wifi.sta.getrssi() .. " dBm.")
  end
)

wifi.eventmon.register(
  wifi.eventmon.STA_DISCONNECTED,
  function(T)
    print("WiFi station disconnected from access point \"".. T.SSID .. "\" due to error " .. T.reason .. ".")
  end
)

wifi.eventmon.register(
  wifi.eventmon.STA_AUTHMODE_CHANGE,
  function(T)
    print("WiFi station authentication mode changed from " .. T.old_auth_mode .." to ".. T.new_auth_mode .. ".")
  end
)

wifi.eventmon.register(
  wifi.eventmon.STA_GOT_IP,
  function(T)
    print("WiFi station assigned IP address " .. T.IP ..".")
    sntp.sync( { "pool.ntp.org", "time.nist.gov" },
      function(sec, usec, server, info)
        print("NTP synchronization with " .. server .. " successful. Time is " .. sec .. " seconds from Unix epoch.")
      end,
      function(errcode, errnote)
        print("NTP synchronization failed due to error " .. errcode .. ".")
      end
    )
  end
)

wifi.eventmon.register(
  wifi.eventmon.STA_DHCP_TIMEOUT,
  function()
    print("WiFi station DHCP timed out.")
  end
)

wifi.eventmon.register(
  wifi.eventmon.WIFI_MODE_CHANGED,
  function(T)
    print("WiFi station mode changed from ".. T.old_mode .." to ".. T.new_mode .. ".")
  end
)

wifi.setmode(wifi.STATION)
wifi.sta.config(station_cfg)
wifi.sta.setip(ip_cfg)

wifi.sta.connect()
