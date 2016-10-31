FIRST=1
for i in "$@"; do
    if [ "$FIRST" -eq 1 ]
        then
            echo "CONTIG" > TEMP-COUNTS-0
            samtools idxstats $i | head -n -1 | cut -f 1 >> TEMP-COUNTS-0
            FIRST=0
    fi
    echo $i
    BASE=$(samtools view -H $i | grep @RG | grep -o SM:.* | sed 's/SM://g')
    echo $BASE > TEMP-COUNTS-$i
    samtools idxstats $i | head -n -1 | cut -f 3 >> TEMP-COUNTS-$i
done
paste TEMP-COUNTS* > merged_counts.txt
rm TEMP-COUNTS*
