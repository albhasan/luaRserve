--###############################################
-- RSERVE - Start in its own terminal on debug mode
-- default port 6311
--###############################################
-- R
-- library(Rserve)
-- Rserve(debug=T)
--###############################################
-- TEST STARTS HERE
--###############################################


-- load the module and print its version
lrs = require "luarserve"
lrs.version()

-- print Rserve metadata
lrs.getserverid("localhost", 6311)

-- ask Rserve for 100 random numbers
printtable(lrs.evaluate("localhost", 6311, "rnorm(100)"), "-->")

-- ask Rserve for a random number
printtable(lrs.evaluate("localhost", 6311, "runif(1, 5.0, 7.5)"), "-->")

-- ask Rserve for a random matrix
 printtable(lrs.evaluate("localhost", 6311, "replicate(5, rnorm(7))"), "-->")

-- ask Rserve for a vector
lrs = require "luarserve"
printtable(lrs.evaluate("localhost", 6311, 'a <- c(1, 2, 5.3, 6, -2, 4)'), "-->")
printtable(lrs.evaluate("localhost", 6311, 'b <- c("one","two","three")'), "-->")
printtable(lrs.evaluate("localhost", 6311, 'c <- c(TRUE,TRUE,TRUE,FALSE,TRUE,FALSE)'), "-->")


-- ask Rserve for a matrix
lrs = require "luarserve"
printtable(lrs.evaluate("localhost", 6311, 'y <- matrix(1:20, nrow=5,ncol=4)'), "-->")
printtable(lrs.evaluate("localhost", 6311, "B = matrix(c(2, 4, 3, 1, 5, 7), nrow=3, ncol=2)"), "-->")
printtable(lrs.evaluate("localhost", 6311, "B = matrix(c(2, 4, 3, 1, 5, 7), nrow=2, ncol=3)"), "-->")
printtable(lrs.evaluate("localhost", 6311, "B = matrix(c(2, 4, 3, 1, 5, 7), nrow=2, ncol=3, byrow=TRUE)"), "-->")
printtable(lrs.evaluate("localhost", 6311, "B = matrix(c(2, 4, 3, 1, 5, 7), nrow=2, ncol=3, byrow=FALSE)"), "-->") -- the order of the elements does not change. Why?


-- ask Rserve for a data.frame
lrs = require "luarserve"
printtable(lrs.evaluate("localhost", 6311, 'd <- c(1,2,3,4); e <- c("red", "white", "red", NA); f <- c(TRUE,TRUE,TRUE,FALSE); mydata <- data.frame(d,e,f)'), "-->")
printtable(lrs.evaluate("localhost", 6311, 'd <- c(1,2,3,4); e <- c("red", "white", "red", NA); f <- c(TRUE,TRUE,TRUE,FALSE); mydata <- data.frame(d,e,f); names(mydata) <- c("ID","Color","Passed"); mydata'), "-->")


-- ask Rserve for a factor
lrs = require "luarserve"
printtable(lrs.evaluate("localhost", 6311, 'gender <- c(rep("male",2), rep("female", 3)); gender <- factor(gender)'), "-->")
printtable(lrs.evaluate("localhost", 6311, 'v <- c(1,3,5,8,2,1,3,5,3,5); x <- factor(v)'), "-->")


-- ask Rserve for a data.frame
lrs = require "luarserve"
printtable(lrs.evaluate("localhost", 6311, 'n <- c(2, 3, 5); s <- c("aa", "bb", "cc"); b <- c(TRUE, FALSE, TRUE); df <- data.frame(n, s, b)'), "-->")


-- ask Rserve for a linear regression
lrs = require "luarserve"
printtable(lrs.evaluate("localhost", 6311, 'library(MASS); data(cats); lm(Hwt ~ Bwt, data=cats[1:5,])'), "-->")
