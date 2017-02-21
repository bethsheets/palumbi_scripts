#!/bin/bash


#to call: bash batch-fastqc.sh *.fastq

for i in $@; do 
	echo -e "#!/bin/bash\n#SBATCH -p owners -c 1 \n" > TEMPBATCH.sbatch
	echo "/share/PI/spalumbi/programs/FastQC/fastqc -o qc/ --extract -f fastq $i" >> TEMPBATCH.sbatch
	sbatch TEMPBATCH.sbatch
done
