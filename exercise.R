#######################################
############ basic #############
#######################################

a <- 1

a = 2

b <- sum(1,8,4,5,9)
b

num <- c(1,8,4,5,9)
num
sd(num)
var(num)
sum(num)
min(num)
max(num)
mean(num)
median(num)
range(num)
quantile(num)

sd(num);var(num);sum(num);min(num);max(num);mean(num);median(num);range(num);quantile(num)


fruit <- c("apple", "Leeato", "banana")
fruit

name <- c("Jane", "Tom", "Peter")
name

melon <- "watermelon"
melon

total <- c(num, fruit, name, melon)
total

a <- 1
b <- 2
a == 2

a <- 1
b <- 2
a == b

a != b

a < b

a <= b

a > b

a >= b

total

total[7]

getwd()

setwd("C:/R/data")

mydata <- read.csv("age.csv", header=T, na.strings=".") 
help(read.csv)
View(mydata)  # V: capital
edit(mydata)   # editing available

read <- readLines("example.txt",  encoding = "UTF-8")

write.csv(object, "filename.csv", row.names=F)
# write.csv(mydata, "age2.csv", row.names=F)

save(mydata, file="age2.RData")
load("age2.RData")  # loading RData

library(packagename)
search()  # showing data and packages which are used currently
detach("package:packagename")  # removing a certain package

rm(a,b)
rm(list=ls())



#######################################
######## Data cleansing ################
#######################################

##1.Data structure  

nvector <- c(1,2,3,4,5)  
nvector

is(nvector)   

cvector <- c("Korean","English","math")
cvector

is(cvector)

cvector <- c("male","female","male","female")
is(cvector)

cvar <- as.factor(cvector)  
is(cvar)

cvar

cvar <- as.data.frame(cvector)  
cvar
#as.numeric  
#as.character   
#as.factor      
#as.data.frame  

m <- matrix(1:9, ncol = 3)
m
m <- matrix(0, ncol = 3, nrow =3)
m

no<-c(1,2,3,4)
name<-c("Lee", "Kim", "Park", "Jung")
gender<-c("M", "F", "M", "F")
dfrm1<-data.frame(no, name, gender)
dfrm1


##2.editing a dataframe 

###1) cbind( ) & rbind( )

height<-c(180, 170, 185, 168)
weight<-c(90, 54, 100, 52)
age<-c(20, 18, 23, 19)


dfrm2<-data.frame(age, height, weight)
dfrm2
a <- cbind(dfrm1, dfrm2)
a

no<-c(5,6,7,8)
name<-c("Cheon", "Rhoh", "Moon", "Choi")
gender<-c("F", "F", "F", "M")
dfrm3<-data.frame(no, name, gender)
a <- rbind(dfrm1, dfrm3)
a

###2) merge( )  
dfrm4<-data.frame(name=c("Lee", "Kim", "Park"), age=c(20,18,23))
dfrm4
dfrm5<-data.frame(name=c("Lee", "Jung", "Park"), height=c(180, 168, 185))
dfrm5
merge(dfrm4, dfrm5, by="name")

dfrm6<-merge(dfrm4, dfrm5, all=T)
dfrm6

###3) NA
Na_cleaning<-na.omit(dfrm6)
Na_cleaning

###4) subset( ) 

subset(dfrm1, gender == "F")
subset(dfrm1, name == "Lee")
subset(dfrm1, no == 2)
dfrm7<-subset(dfrm1, select="name")
dfrm7

###5) colnames( )  
dfrm8<-data.frame(name=c("Lee", "Kim", "Park"), age=c(20,18,23))
dfrm8
colnames(dfrm8)

colnames(dfrm8)<- c("name", "age")
dfrm8
colnames(dfrm8)[2]<- "AGE"
dfrm8

###6) indexing

dfrm1
dfrm1[1,]
dfrm1[,1]
dfrm1[2,1]
dfrm1[1,c(1,3)]


##3.apply function 

###1) apply function  

head(iris)
apply(iris[,1:4], 2, sum)
apply(iris[,1:4], 2, max)
apply(iris[,1:4], 2, sd)
apply(iris[,1:4], 2, mean)

###2) lapply 
lapply(iris[,1:4],mean, na.rm=T)

###3) sapply 

sapply(iris[,1:4], mean, na.rm=T)

###4) tapply(output,reference column,function)

tapply(iris$Sepal.Length, iris$Species, mean)

attach(iris)
tapply(Sepal.Length, Species, mean)
# with(iris, tapply(Sepal.Length, Species, mean))  


## 4.dplyr 

setwd("C:/R")  
#install.packages("dplyr")  
library(dplyr)
data <- read.csv("./data/age.csv")  
head(data,5)

###1) filter 
data1 <- filter(data, Male > 42 & Female > 43)
head(data1)
str(data1)

data2 <- select(data, Gu, Dong)
head(data2); str(data2)  

###3) arrange
data4 <- arrange(data, Age)  #ascending
head(data4)

data4 <- arrange(data, desc(Age))  #descening
head(data4)

###4) mutate  
data6<-mutate(data, MaleFemale = Male + Female) 
head(data6)

###5) summarise  
data7<- data %>% group_by(Gu) %>% summarise(average = mean(Age, na.rm=T))       
head(data7)



#######################################
######## basic statistics ################
#######################################

setwd("C:/R/data")

# 2. opening data
fat<-read.csv('fat.csv', header=T, stringsAsFactors = T, na.strings="999") 
# stringAsFactors = T : transforming columns with string to factors
# na.rm = T : deleting a row with NA


# 3. encoding and recode

colnames(fat)
str(fat)

# install.packages("car")
library(car)
# car = Companion to Applied Regression

fat$EDU <- recode(fat$edu, '1'=6, '2'=9, '3'=12, '4'=16)

View(fat)

fat$region <- factor(fat$region, levels = c(1,2), labels = c("µµ½Ã", "³óÃÌ")) 
table(fat$region)
table(fat$sex)
table(fat$sex, fat$region)


fat$rQ4 <- recode(fat$Q4, '1'=5, '2'=4, '3'=3, '4'=2, '5'=1)
table(fat$Q4)
table(fat$rQ4)

# install.packages("psych")
library(psych)  # alpha()
library(dplyr)  # select(), mutate()

factor1 <- select(fat, Q1, Q2, Q3)
alpha(factor1)

factor2 <- select(fat, rQ4, Q5, Q6)
alpha(factor2)

fat <- mutate(fat, health=(Q1+Q2+Q3)/3, qol=(rQ4+Q5+Q6)/3) 
colnames(fat)

par(mfrow=c(1,2))  # display with 1 row and 2 columns

hist(fat$bmi)
boxplot(fat$bmi)

par(mfrow=c(1,1))  
plot(fat$fat, fat$bmi)

plot(fat[,c("edu", "age", "bmi", "fat", "pressure")])

#corrlation
corPlot(fat[,c("edu", "age", "bmi", "fat", "pressure")], numbers=T)

#4. dealing with NA

summary(fat) 
colSums(is.na(fat))

# install.packages("DMwR")
library(DMwR)

fat2 <- centralImputation(fat)
#fat2 <- knnImputation(fat) 

colSums(is.na(fat2)) 


#5. deleting outliers
library(car)
#fat2 <- read.csv("fat2.csv")

par(mfrow=c(1,2))  # display with 1 row and 2 columns
Boxplot(fat2$health,id=list(n=5))  # car ÆĞÅ°ÁöÀÇ Boxplot() ÇÔ¼ö
Boxplot(fat2$qol, id=list(n=5))

par(mfrow=c(1,1))  
scatterplot(qol~health, data=fat2, id=list(n=5)) 
scatterplot(fat2$health,fat2$qol) 

# install.packages("scatterplot3d")
library(scatterplot3d)
scatterplot3d(fat2$qol,fat2$age,fat2$health, main="3D Scatterplot")

dim(fat2)

fat2 <- fat2[-c(8,531,529,396),]
dim(fat2)  #dimension

#library(dplyr)
fat3<- select(fat2, sex, edu, age, region, health, qol)
colnames(fat3)
str(fat3)

fat4<-subset(fat2, select=c("sex", "edu", "age", "region", "health", "qol"))
colnames(fat4)
str(fat4)

# regression
fit <- lm(qol ~ health, data=fat3)
summary(fit)

fit2 <- lm(qol ~ health+edu+age+sex, data=fat3)
summary(fit2)
vif(fit2)

