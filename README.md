# forticlient

Connect to a FortiNet VPNs through docker

## Usage

The container uses the `openfortivpn` linux binary to manage ppp interface

All of the container traffic is routed through the VPN, so you can in turn route host traffic through the container to access remote subnets.

### Linux

```bash
# Create a docker network, to be able to control addresses
docker network create --subnet=172.20.0.0/16 fortinet

# Start the priviledged docker container with a static ip
docker run -it --rm \
  --privileged \
  --net your-network-name --ip 172.20.0.2 \
  -e VPN_ADDR=host:port \
  -e VPN_USER=me@domain \
  -e VPN_PASS=secret \
  poyaz/forticlient

# Add route for you remote subnet (ex. 10.201.0.0/16)
ip route add 10.201.0.0/16 via 172.20.0.2

# Access remote host from the subnet
ssh 10.201.8.1
```

### OSX

```bash
# Create a docker-machine and configure shell to use it
docker-machine create fortinet --driver virtualbox
eval $(docker-machine env fortinet)

# Start the privileged docker container on its host network
docker run -it --rm \
  --privileged --net host \
  -e VPN_ADDR=host:port \
  -e VPN_USER=me@domain \
  -e VPN_PASS=secret \
  poyaz/forticlient

# Add route for you remote subnet (ex. 10.201.0.0/16)
sudo route add -net 10.201.0.0/16 $(docker-machine ip fortinet)

# Access remote host from the subnet
ssh 10.201.8.1
```

## Misc

If you don't want to use a docker network, you can find out the container ip once it is started with:
```bash
# Find out the container IP
docker inspect --format '{{ .NetworkSettings.IPAddress }}' <container>

```
