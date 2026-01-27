# Hands on Logs

- **1.process commands:**
    - ps:
    ps
    PID TTY          TIME CMD
   1442 pts/0    00:00:00 bash
   1499 pts/0    00:00:00 ps
   - ps -aux: (Output in output.txt file)
   - top: (Output in output.txt file)
   - free:
                        total        used        free      shared  buff/cache   available
        Mem:          936152      356164      364380        2764      377392      579988
        Swap:              0           0           0

- **2.system commands:**
    - systemctl status:(output in output.txt file)
    - systemctl list-units: (output in output.txt file)
    - systemctl start apache2
    - sudo apt install apache2, sudo systemctl start apache2
    - sudo systemctl enable apache2
        Synchronizing state of apache2.service with SysV service script with /usr/lib/systemd/systemd-sysv-install.
        Executing: /usr/lib/systemd/systemd-sysv-install enable apache2
    -  sudo systemctl status apache2
        ● apache2.service - The Apache HTTP Server
            Loaded: loaded (/usr/lib/systemd/system/apache2.service; enabled; preset: enabled)
            Active: active (running) since Tue 2026-01-27 20:31:26 UTC; 1min 21s ago
            Docs: https://httpd.apache.org/docs/2.4/
        Main PID: 2450 (apache2)
            Tasks: 55 (limit: 1008)
            Memory: 5.4M (peak: 5.8M)
                CPU: 49ms
            CGroup: /system.slice/apache2.service
                    ├─2450 /usr/sbin/apache2 -k start
                    ├─2452 /usr/sbin/apache2 -k start
                    └─2453 /usr/sbin/apache2 -k start

        Jan 27 20:31:25 ip-172-31-20-62 systemd[1]: Starting apache2.service - The Apache HTTP Server...
        Jan 27 20:31:26 ip-172-31-20-62 systemd[1]: Started apache2.service - The Apache HTTP Server.
    - sudo systemctl start apache2
    - sudo systemctl enable apache2