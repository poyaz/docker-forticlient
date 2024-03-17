# 2024-03-17 23:35

### Add

- Add DNS server for use dns over vpn service (Default port listener: 1051)
- Disable root login on ssh server
- Add SSH_PORT for run ssh listener on specific port

### Change

- Change port listens, these range are 1080 to 1082 (http/socks5: 1080, dns: 1081, ssh: 1082)

### Remove

- Remove compose files for publishing port

# 2023-03-25 11:57

### Bugfix

- Add fork options on socat command
- Fix using private/public key on ssh when password of ssh user is empty (Generate random password if password environment is empty)

# 2023-03-21 15:07

### Bugfix

- Fix socat compose file for run command

# 2023-03-18 15:24

### Add

- Support multi env file for run multi instance of vpn
- Add port forwarder over VPM connection for using like RDP

### Change

- Move ssh service to new docker-compose file for better management (Path: **docker/docker-compose.ssh.yml**)
- Move ssh env file to new docker-compose file (Path: **docker/docker-compose.env-ssh.yml**)
- Move ssh publish port to new docker-compose file (Path: **docker/docker-compose.ssh-publish.yml**)

# 2022-08-13 10:10

### Change

- Change health check interval

# 2020-08-12 2:40

### Add

- Add two environment variable for change publish port and run ssh and socks on custom port

# 2022-08-10 10:17

### Add

- Add license file

# 2022-08-10 10:13

### Add

- Create docker-compose
- Create script for build image

### Change

- Change project structure
