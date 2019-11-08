a <- 1:10
a
b="d":"m"
b=letters
c=b[4:13]
c
f<- c(1,1,1,0,0,0,0,0)
f
vf <- factor(f, levels=c(0,1), labels=c("No","Yes"))
help("objects")

.Ob <- 1
ls(pattern = "O")
ls(pattern= "O", all.names = TRUE)    # also shows ".[foo]"

# shows an empty list because inside myfunc no variables are defined
myfunc <- function() {ls()}
myfunc()

# define a local variable inside myfunc
myfunc <- function() {y <- 1; ls()}
myfunc()                # shows "y"
