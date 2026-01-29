## practice basic file read/writ

### Day-06

- touch notes.txt
- echo "hello" >> notes.txt [Adds text hello in the notes.txt file]
- echo "hello 2" >> notes.txt [Adds text hello 2 in the notes.txt file below hello]
- echo "replace" >> notes.txt [replaces all the text in notes.txt file]
- cat notes.txt [shows all the text in notes.txt file]
- ls -l | tee notes.txt 
total 4
-rw-rw-r-- 1 ubuntu ubuntu 8 Jan 29 18:12 notes.txt
cat notes.txt 
total 4
-rw-rw-r-- 1 ubuntu ubuntu 8 Jan 29 18:12 notes.txt
[what tee does is it does the command and also at same times saves it in a file]
- ls -l | tee -a notes.txt [here instead of replacing it appends, adds to next line]
- head -n 5 notes.txt [shows first 5 lines of the file]
- tail -F notes.txt [Interactive- to check if something is being added to that file, the shell doesnt close if we add something new to log we can see there]


