if [ -z "$VPNـADDR" -o -z "$VPNـUSER" -o -z "$VPNـPASS" ]; then
  echo "Variables VPNـADDR, VPNـUSER and VPNـPASS must be set."
  exit 1
fi

export VPNـTIMEOUT=${VPNـTIMEOUT:-5}

# Setup masquerade, to allow using the container as a gateway
for iface in $(ip a | grep eth | grep inet | awk '{print $2}'); do
  iptables -t nat -A POSTROUTING -s "$iface" -j MASQUERADE
done

while [ true ]; do
  echo "------------ VPN Starts ------------"
  /usr/bin/forticlient
  echo "------------ VPN exited ------------"
  sleep 10
done