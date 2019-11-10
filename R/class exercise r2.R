## A-z
length(LETTERS)
for (i in 1:length(LETTERS))
     print(LETTERS[(27-i)])


for (i in 1:length(LETTERS))
  print(LETTERS[(27-i)])


for (x in 1:1000) {
  print(x)
  if(x==20) {
    break
  }
}




for(i in 1:100)
    {y=sample(c(1,2,3,4,5,6,7,8,9,10),1)
    print(y) 
    if (y==8) {break}
}
 

y<-sample(c(1,2,3,4,5,6,7,8,9,10),1)
print(y)
x <- 0
while(y!=8) {
  y<-sample(c(1,2,3,4,5,6,7,8,9,10),1)
  print(y)
}