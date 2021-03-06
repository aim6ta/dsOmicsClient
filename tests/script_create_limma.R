#### Create new
library(resourcer)
library(DSLite)
library(dsBaseClient)
library(dsBase)
library(dsOmics)


# make a DSLite server with resources inside
dslite.server <- newDSLiteServer(resources = list(
  GSE66351 = resourcer::newResource(name = "GSE66351", url = "https://github.com/isglobal-brge/dsOmicsClient/raw/master/data/GSE66351.Rdata", format = "ExpressionSet"),
  GSE80970 = resourcer::newResource(name = "GSE80970", url = "https://github.com/isglobal-brge/dsOmicsClient/raw/master/data/GSE80970.Rdata", format = "ExpressionSet")
))


# build login details
builder <- DSI::newDSLoginBuilder()
builder$append(server = "study1", url = "dslite.server", resource = "GSE66351", driver = "DSLiteDriver")
builder$append(server = "study2", url = "dslite.server", resource = "GSE80970", driver = "DSLiteDriver")
logindata <- builder$build()# login and assign resources
conns <- datashield.login(logins = logindata, assign = TRUE, symbol = "res")# R data file resource


datashield.assign.expr(conns, symbol = "ES", expr = quote(as.resource.object(res)))

ds.ls(conns)
ds.dim('ES', datasources = conns)

vars <- c("casecon")
type <- 1
cally <- paste0("limmaDS(", 'ES', ",", deparse(vars[1]), ",", deparse(NULL),
                ",", type, "," , FALSE, 
                ",", deparse(NULL) , ")")
cally
fit <- datashield.aggregate(conns, as.symbol(cally))
lapply(fit, function(x) head(x[order(x[,7]),]))[[1]]
datashield.logout(conns)


load("c:/juan/CREAL/GitHub/dsOmicsClient/data/GSE66351.Rdata")
dd<-model.matrix( ~ gse66351.sel$casecon)
fit2 <- limma::lmFit(gse66351.sel, dd)
fit2 <- limma::eBayes(fit2)
limma::topTable(fit2)


# make a DSLite server with resources inside
dslite.server <- newDSLiteServer(resources = list(
  tcga_liver = resourcer::newResource(name = "tcga_liver", 
                                     url = "http://duffel.rail.bio/recount/TCGA/rse_gene_liver.Rdata", 
                                     format = "RangedSummarizedExperiment")
))


# build login details
builder <- DSI::newDSLoginBuilder()
builder$append(server = "study1", url = "dslite.server", resource = "tcga_liver", 
               driver = "DSLiteDriver")
logindata <- builder$build()# login and assign resources
conns <- datashield.login(logins = logindata, assign = TRUE, symbol = "res")


datashield.assign.expr(conns, symbol = "rse", expr = quote(as.resource.object(res)))

variable_names <- c("gdc_cases.demographic.gender")
covariable_names <- NULL
type <- 2
cally <- paste0("limmaDS(", 'rse', ",", deparse(variable_names), ",", 
                deparse(covariable_names),
                ",", type, ",", TRUE, 
                ",", deparse(NULL) , ")")
cally
fit <- datashield.aggregate(conns, as.symbol(cally))
lapply(fit, function(x) head(x[order(x[,7]),]))[[1]]
datashield.logout(conns)


