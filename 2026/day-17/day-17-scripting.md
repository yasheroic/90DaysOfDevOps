### Task 1: For Loop

1. ![for_loop.sh](image.png)
2. ![count_loop/sh](image-1.png)
**Note:** 
Inside (( )) (C-style loop), you don’t use -eq or -le.
Those are used in [ ] test conditions.
![count_loop using (( i=1;i<=10;i++ ))](image-2.png)

---

### Task 2: While Loop
1. ![countdown.sh](image-3.png)

---

### Task 3: Command-Line Arguments

1. ![./greet/sh](image-4.png)
2. ![./args_demo](image-5.png)

---

### Task 4: Install Packages via Script
1. ![,.package.sh](image-6.png)
use array but can also use `for i in nginx curl wget`

2.![can be run only via root user](image-7.png)

### Task 5: Error Handling
1. ![./safe.sh](image-8.png)