# This is a file for generating pgs using LDPred.

## Step 1: Creating the target dataset

We first need to prune the list of SNPs to make it a manageable amount for LDPred to function. 
This is an example of what to do in the SSC dataset:

For recoding file, see the the SSC liftover tutorial on how to generate the recoding file.

```R

a = read.table("chr1.info", header = T)
a$Rsq = as.numeric(as.character(a$Rsq))
  b = subset(a, Rsq > 0.998)
  b = subset(b, MAF > 0.05)
  c = b
  
for (i in 2:22){
  a = read.table(paste0("chr", i, ".info"), header = T)
  a$Rsq = as.numeric(as.character(a$Rsq))
  b = subset(a, Rsq > 0.998)
  b = subset(b, MAF > 0.05)
  c = rbind(c, b)
}

recoding = fread("~/SFARI/liftOverPlink/plinkrecodingfile.txt")

setnames(recoding, "chrompos", "SNP")
merged = merge(c, recoding, by = "SNP")

write.table(merged3[,c("ID")], file = "~/file/LDpredkeepsnp1.txt", row.names = F, col.names = T, quote = F)

```

Next, prune the file in Plink

```bash
./plink --extract LDpredkeepsnp1.txt --hwe 0.000001 --maf 0.05 --geno 0.05 --mind 0.05 --make-bed --out SFARImergedallLDPred --bfile SFARImergedall

```

## Step 2: Creating the training dataset

LDpred needs specific headers etc for the files to work. So let's try and generate that. In addition, it needs the columns to be in the exact order. We will use the "basic" format to generate this. 

   hg19chrc    snpid    a1    a2    bp    or    p       
    chr1    rs4951859    C    G    729679    0.97853    0.2083  
    chr1    rs142557973    T    C    731718    1.01949    0.3298

Generate this in R, and save the file to the location where you have the target dataset. 


# LD Pred command

Run LD Pred in two steps. We will 

```bash
python2.7 coord_genotypes.py --gf=LDpred_data_p1.000_test_0 --ssf=LDpred_data_p1.000_ss_0.txt --out traincheck7 --N=10000  


```
