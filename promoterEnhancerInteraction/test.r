df1 = data.frame(CustomerId = c(1,2,2,4,5,6), Product = c(rep("Toaster", 3), rep("Radio", 3)))
df2 = data.frame(CustomerId = c(2, 4,2, 6), State = c(rep("Alabama", 2), rep("Ohio", 2)))
merge(x=df1,y=df2,by="CustomerId",all=F)

