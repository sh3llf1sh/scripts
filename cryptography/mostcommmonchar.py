#!/usr/bin/python
import collections
import sys
import re
import os.path

if len(sys.argv) != 2:
    print("Usage: mostcommanchar.py <file_name> or use -h for help/description")
    sys.exit()
else:
    file = sys.argv[1]

if str(file) == "-h":
   print("""

#####################################################
#            mostcommonchar.py                      #
#####################################################

This script is used for listing character occurrences 
that appear in a file. I wrote this to check for char
occurrences in cryptographic problems. In order to
work out and break ceaser cyphers and provide insight
into which kind of characters keep coming up to map
to common letters. i.e pddw = dx2 = oo or ee would be
the most likely pair.I will increase the functionality
of the script as my knowledge and experience of crypto
problems grow.

You just need to supply a file with your crypt problem
in a file a parse it as a cmd line argument. i.e:

./mostcommonchar.py /home/myuser/problems/mycryptofile
""")
   sys.exit()
else:
     if os.path.isfile(file):
       file_true=file
     else:
       print("Usage: mostcommanchar.py <file_name> or use -h for help/description")
       sys.exit()
 
with open(file_true, 'r') as myfile:
    data=myfile.read().replace('\n', '')

while data != "":
    print(collections.Counter(data).most_common(1)[0])
    current_most_common = str(collections.Counter(data).most_common(1)[0])
    data = re.sub(current_most_common[2], '', data)

