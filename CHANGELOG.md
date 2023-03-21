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
