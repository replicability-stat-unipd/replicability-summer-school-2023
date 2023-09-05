library(curatedOvarianData)
devtools::load_all()

listdata <- data(package = "curatedOvarianData")$results[, "Item"]
datl <- lapply(listdata, getdata, package = "curatedOvarianData")
names(datl) <- listdata

# we need the debulking as phenotype, lets see which data have it

has_debulking <- sapply(datl, function(d) any(!is.na(pData(d)[, "debulking"])))
datl_debulking <- datl[has_debulking]

# let's see how many NAs and remove the dataset with an high percentage

pNA <- sapply(datl_debulking, function(x) mean(is.na(pData(x)[, "debulking"])))
ncases <- sapply(datl_debulking, function(x) length(pData(x)[, "debulking"]))
missing <- data.frame(pNA, ncases)

# remove dataset with more than 20% of NA on debulking
datl_debulking <- datl_debulking[pNA < 0.2]

# let's explore the genes, we keep the genes that are in common with all
# datasets. One dataset the "TCGA.mirna.8x15kv2_eset" dataset has some genes that are
# completely different from the others, we remove it.

# get_gene_names(datl_debulking$TCGA.mirna.8x15kv2_eset)
datl_debulking <- datl_debulking[names(datl_debulking) != "TCGA.mirna.8x15kv2_eset"]

# now we intersect all the gene names to keep only the common ones
genes <- lapply(datl_debulking, get_gene_names)
common_genes <- base::Reduce(base::intersect, genes)

# converting into dataframe with selected 
datl_debulking_df <- lapply(datl_debulking, get_bio_data, common_genes, "debulking")

# saving
saveRDS(datl_debulking_df, "03-biostatistics/data/gene_data_clean.rds")