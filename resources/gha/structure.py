# Import the fileinput module
import fileinput
import os
# Loop through the lines of README.md
with fileinput.input('README.md', inplace=True) as readme:
    replace_struct = False
    for line in readme:
        # If the line contains the placeholder, print the contents of tree.txt
        if not replace_struct:
            if '```struct' in line:
                print(line, end='')
                replace_struct = True
            # Otherwise, print the line as it is
            else:
                print(line, end='')
        else:
            if '```' in line:
                with open(os.environ["STRUCTURE"]) as f:
                    print(f.read(), end='```')
                replace_struct = False
