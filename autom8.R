setwd("C:/Users/andre/Documents/R")

library.path <- .libPaths()[1]
install.packages("quantmod",repos = "http://cran.us.r-project.org",
                 lib = library.path)
require("quatmod")

library("quantmod")

options("getSymbols.warning4.0"=FALSE)

cat("Now getting data...\n")

stk=getSymbols("SPY",from="2020-01-01", auto.assign = F)

cat("Writing data...\n")

write.zoo(stk, file = "C:/Users/andre/Downloads/SPY.csv", sep=",")

cat("Done!...\n")


#' @echo off 
#' C: 
#' PATH "C:\Program Files\R\R-4.0.4\bin\x64"
#' cd C:\Users\andre\Documents\R
#' Rscript autom.R
#' pause