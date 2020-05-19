if [ -z "$VPN_ADDR" -o -z "$VPN_USER" -o -z "$VPN_PASS" ]; then
  echo "Variables VPN_ADDR, VPN_USER and VPN_PASS must be set."
  exit 1
fi

export VPN_TIMEOUT=${VPN_TIMEOUT:-5}

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