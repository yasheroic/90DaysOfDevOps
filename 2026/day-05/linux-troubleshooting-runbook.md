# Runbook
## What is Runbook

 - A mini runbook is a concise, step-by-step operational guide used by DevOps teams to quickly diagnose and resolve a specific alert or incident.
 - A mini runbook in DevOps is a short, quick-reference playbook that tells you exactly what to do when something breaks — without fluff.
 - Think of it as “incident handling in 2–3 minutes.

### Runbook for SSH Service

- Target service: SSH
- Process: sshd
- Purpose: Remote access service
- Snapshot: CPU & Memory
    - PID: 5112
    - ps -o pid,pcpu,pmem,comm -p 5112:
    - ![ps -o pid,pcpu,pmem,comm -p 5112](image.png):sshd CPU usage is low (<1%) under idle conditions; spikes only during active logins.
    - htop:
    - ![htop](image-1.png):
    - free -h:
    - ![free-h](image-2.png) :low swap measn ssh is not putting pressure
    - top -H -p <PID>:
    - ![ top -H -p](image-3.png) :See if one SSH connection is burning CPU.

### Red Flags
- sshd CPU > 20% without active logins
- Rapid growth in number of sshd processes
- RSS memory increasing continuously
- High load average but low system CPU usage (possible stuck I/O)

-------------------------------------------------------------------------
- Snapshot: Disk & IO:
    - df-h:
    - ![alt text](image-4.png): If disk if full SSH login can fail
    - du -sh /var/log/auth.log:
    - ![alt text](image-5.png): SSH logs consuming normal disk space; no log bloat observed.
## Disk & IO – SSH

- Verified filesystem usage using df -h
- Checked SSH-related logs for disk growth
- Observed disk IO using vmstat and iostat
- No disk saturation or IO wait observed

Conclusion: Disk and IO are not impacting SSH service.
-------------------------------------------
 - Snapshot:  Network
 - sudo lsof -i :22:
 - ![sudo lsof -i :22](image-6.png)- Confirms which process owns port 22.
 - who:
 - ![who](image-7.png)

 ### Network Red Flags
- SSH not in LISTEN state
- Port 22 bound to unexpected process
- High number of SSH connections from same IP
- Packet loss or high latency during login

-------


