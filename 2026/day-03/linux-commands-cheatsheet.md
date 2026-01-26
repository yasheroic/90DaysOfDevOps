# Cheat Sheet

## 1. Process Management

- ps: Lists the processes running on the system during that timeframe
- top: lists all the active processes
- htop: more interactive version of top command, lists all active processes
- ps aux: lists all processes in more detailed way
- kill: to kill a process, use: kill <PID>
- ps -ef | grep <pattern>. Eg ps -ef | grep nginx : Finds a specific proces
- python app.py &: run process in bg using &
- jobs: see background jobs
- free: memory usage (RAM)
- nohup: run process in bg which keeps running even if terminal is closed

## 2. File system

- pwd: which directory you are in
- cd: change directory
- ls: list everyhting inside the directory
- ls -a: list everything inside the directory with more details and file permissions
- touch <filename>: create file
- mkdir <folder-name>: create directory
- rm <filename>: delete file
- rm -rf<folder-name>/: delete folder
- cp <source> <destination>: copy file
- mv <source> <destination>: move file
- mv <source> <destination>: rename file (same command just use correct file namers if dest file doesnt exist it will create one)
- find /var/log -name "*.log" : find files 
- locate nginx.conf : agai  find files
- cat <filename>: view contents of a file
- vim <filename>: edit a file
- tail -f app.log: show the contents of a file from bottom and even it appends it shows that too
- head -n 20 app.log : show first 20 lines of a file
- chmod 755 script.sh: change file permission
- chmod +x deploy.sh: change file permission
- df -h: disk usage
- ln file1 link1: hard link
- ln -s /var/log/nginx/access.log access.log: soft link

## 3. Networking troubleshooting

- ping <domain-name>, eg: ping google.com : to check if a site is sending back packets or not [to check netowrk conenctivity]
- curl https://example.com:  Check headers and status code
- wget: download something
- nslookup <sitename>: dns troublebshoot
- ss -tulnp: check listening ports
- nc -zv localhost 8080: check if port is reachable or not
- lsof -i :8080 : who is using the port
- ufw status: check firewall status
- iptables -L : check security groups
- ifconfig: check your current ip adress and other NIC adresses
- traceroute google.com - trace network path
- mtr google.com - trace network path







