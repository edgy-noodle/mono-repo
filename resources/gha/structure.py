# Saving changes using this script rather than bash (e.g. sed) due to complexity involved in
# handling | and ` characters while processing multi-line file in the console

import fileinput
import os

with fileinput.input('README.md', inplace=True) as readme:
    replace_struct = False
    for line in readme:
        # If we're not in struct, print the contents as they are
        if not replace_struct:
            if '```struct' in line:
                print(line, end='')
                replace_struct = True
            else:
                print(line, end='')
        # When struct is found, write the generated structure into the file
        else:
            if '```' in line:
                with open(os.environ["STRUCTURE"]) as f:
                    print(f.read(), end='```\n')
                replace_struct = False
