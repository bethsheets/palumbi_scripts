#!/usr/bin/env python
import sys

file = sys.argv[1]
out = open(sys.argv[2],'w+')
ok = ['mnp','ins','del','complex']
with open(file) as f:
    for line in f:
        if line[0] is '#' or any(x in line for x in ok):
            out.write(line)
            continue
        vals = line.split("\t")
        ref=vals[3]
        alt=vals[4]
        if len(ref) is 1 or ',' in alt:
            out.write(line)
            continue
        for base in range(len(ref)):
            if ref[base]!=alt[base]:
                vals[1]=str(int(vals[1])+int(base))
                vals[3]=ref[base]
                vals[4]=alt[base]
                newline="\t".join(vals)
                out.write(newline)
                break
out.close() 
