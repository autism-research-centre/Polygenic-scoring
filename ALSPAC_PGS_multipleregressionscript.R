setwd("~/ALSPAC")
pheno = fread("./alspacbasefiles/alspacphenotypes.txt")
unrelated = fread("alspacbasefiles/unrelatedalspac.txt")
covariates = fread("./alspacbasefiles/alspaccovariates.txt")
setnames(pheno, "ID", "IID")
merged = merge(pheno, unrelated, by = "IID")
merged = merge(merged, covariates, by = "IID")

eigenvec = fread("./alspacbasefiles/alspacpca.eigenvec")

merged = merge(merged, eigenvec, by = "IID")

PRS1 = fread("PRSice2results/xxx.all.score", header = T)
merged = merge(merged, PRS1, by = "IID")

PRS2 = fread("PRSice2results/xxx.all.score", header = T)
merged = merge(merged, PRS2, by = "IID")


a = (lm(log(pheno) ~ PC1.y + PC2.y + PC3 + PC4 + PC5 + PC6 + PC7 + PC8 + PC9 + PC10 + Sex + `1.000000.x` + `1.000000.y`, data = merged))

b = (lm(log(pheno) ~ PC1.y + PC2.y + PC3 + PC4 + PC5 + PC6 + PC7 + PC8 + PC9 + PC10 + Sex, data = merged))
