#index the reference, which in my case is Cannabis_mt.fa (Cannabis mitochondrial reference genome)
bwa index Cannabis_mt.fa
#use Burrows-Wheeler mem alignment (fastest and most accurate BWA algorithm) to align reference to both strands/fastq files and create a unified sam file
bwa mem Cannabis_mt.fa C52*.fastq > C52.sam
#convert bam file to sam file
samtools view -b -o C52.bam -S C52.sam
#sort bam file using samtools
samtools sort C52.bam C52.sorted
#index sorted bam file
samtools index C52.sorted.bam
#enable viewing file in tview
samtools faidx Cannabis_mt.fa
#using tview to make sure the sorted bam file aligned correctly to the Cannabis reference
samtools tview C52.sorted.bam Cannabis_mt.fa
#pile up read bases using alignments to reference sequence, create VCF file
samtools mpileup -uf Cannabis_mt.fa C52.sorted.bam | bcftools view -vcg -> C52.vcf
#exclude any INDELS (insertions and deletions) in the genome and creating a cleaned up VCF table (overwriting previous), view file to make sure everything is hunky-dory
#exclude any sequences with quality scores less than 100 using awk
grep -v INDEL C52.vcf | awk '$6 > 100' | less -S > C52.vcf
