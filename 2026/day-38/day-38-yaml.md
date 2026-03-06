## Challenge Tasks

### Task 1: Key-Value Pairs

- [✅] Valid YAML

### Task 2: Lists

- [✅] Valid YAML

### Task 3: Nested Objects

- [✅] Valid YAML

When you add a tab instead of spaces, the YAML validator throws an indentation error because YAML only supports spaces for indentation.

### Task 4: Multi-line Strings
- `|`: 
echo "Starting server"
echo "Loading configuration"
systemctl start nginx
- `>`:
echo "Starting server" echo "Loading configuration" systemctl start nginx


`>`: When you want multiple lines to become one long line (long descriptions, messages)
`|`: When we want to use line break as it is

example: command: >
  sh -c "npx prisma migrate deploy &&
         node src/server.js"
This uses > so the command becomes one long command line.

`|`  → keep lines
`>`  → join lines

### Task 5: Validate Your YAML

- validated using `https://www.yamllint.com/`
All working well

### Task 6: Spot the Difference

- Block 2: wrong indentation of tool docker
`Block 2 is incorrect because the list items under tools are not aligned with the same indentation. YAML requires consistent indentation for list elements.`