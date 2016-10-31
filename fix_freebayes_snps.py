#! /usr/bin/env python
import sys

for line in sys.stdin:
    if line.startswith('#'):
        sys.stdout.write(line)
        continue
    l=line.split('\t')
    ind=0
    while l[3][ind]==l[4][ind]:
        ind=ind+1
    l[1]=str(int(l[1])+ind)
    l[3]=l[3][ind]
    l[4]=l[4][ind]
    l="\t".join(l)
    sys.stdout.write(l)
