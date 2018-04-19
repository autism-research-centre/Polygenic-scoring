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

LDpred needs specific headers etc for the files to work. So let's try and generate that. In addition, it needs the columns to be in the exact order. We will use the "STANDARD" format to generate this. 

chr     pos     ref     alt     reffrq  info    rs       pval    effalt
    chr1    1020428 C       T       0.85083 0.98732 rs6687776    0.0587  -0.0100048507289348
    chr1    1020496 G       A       0.85073 0.98751 rs6678318    0.1287  -0.00826075392985992

Generate this in R, and save the file to the location where you have the target dataset. 
Please note, LDPRed requires the column order to be the same as described above. 


# Step 3: LD Pred command
Next, we run LDPred. 

LDPred requires three steps. The first step is coordinating genotypes. This will coordinate the files. This is done using the coord_genotypes script. --gf is the 

```bash
python2.7 coord_genotypes.py --gf=plinkgenotypefile --ssf=sumstatsfile --out=outfile1 --N=samplesize 

wget https://ctg.cncr.nl/software/MAGMA/ref_data/g1000_eur.zip
unzip g1000_eur.zip

python2.7 LDpred.py --coord=outfile1 --ld_radius=260 --local_ld_file_prefix=g1000_eur --PS=1,0.8,0.5,0.3 --N=samplesize --out=outfile2

./plink --bfile plinkgenotypefile --score outfile2.txt 3 4 7 --allow-no-sex --out outfile3

```

# Step 4: Finally, read the files into R, read the phenotype files, the covariates and run the regression in R
