# How Linux works under the hood

- **1. core components of Linux** : It follows the ASK format with Addtional H(Hardware in the core)
 - A: Application/User
 - S: Shell
 - K: Kernel

Kernel: It is the heart of the linux, it talks witht the hardware. It talks to the hardware in computer language i.e, binary

Shell: It acts as the middleman between Kernel and User/Application. A user types in the shell and it gets converted into the language the kernel understands

Application: It is the end user or the app

- **2. How processes are created and managed:**  A process is simply a program which runs on the linux system. anything running is a process. For ex: cd command or ping command if we run and type ps a, we can see the process ping running with a PID.

 - Zombie process: A a child process which has completed executing but still hasnt been stopped by the parent process
 - Running process: Any process which is running
 - Sleeping process: Also called daemon process which runs in the background and run continously

- **3. 5 commands:**
 - cd: change directory
 - ls: list all files and folder in a directory
 - mkdir: to make a folder
 - touch: to make a file
 - pwd: present working directory
