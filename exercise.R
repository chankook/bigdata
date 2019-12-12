#######################################
############ 기초 중 기초 #############
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

name <- c("철수", "영희", "민수")
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

mydata <- read.csv("age.csv", header=T, na.strings=".")  # . 는 작업디렉토리를 의미한다.

View(mydata)  # V는 대문자임
edit(mydata)   # 편집가능

read <- readLines("example.txt",  encoding = "UTF-8")

write.csv(객체명, "파일이름.csv", row.names=F)
# write.csv(mydata, "age2.csv", row.names=F)

save(mydata, file="age2.RData")
load("age2.RData")  # 작업공간 불러오기

library(패키지명)
search()  # 현재 작업공간에 있는 모든 데이터나 패키지를 알려준다.
detach("package:패키지명")  # 나열되어 있는 패키지 중 원하는 패키지 제거

rm(a,b)
rm(list=ls())



#######################################
######## 데이터 전처리 ################
#######################################

##1.R의 데이터 구조  

nvector <- c(1,2,3,4,5)  
nvector

is(nvector)    # 데이터 형태가 무엇인지 확인하는 함수는 is( )

cvector <- c("국어","영어","수학")
cvector

is(cvector)

cvector <- c("남자","여자","남자","여자")
is(cvector)

cvar <- as.factor(cvector)  # 요인으로 변환시켜주는 함수
is(cvar)

cvar

cvar <- as.data.frame(cvector)  # 요인으로 변환시켜주는 함수
cvar
#as.numeric   # 숫자형 데이터로 변환
#as.character   # 문자형 데이터로 변환
#as.factor       # 요인형 데이터로 변환
#as.data.frame   # 데이터프레임 형태로 변환(뒤에서 살펴봄)

m <- matrix(1:9, ncol = 3)
m
m <- matrix(0, ncol = 3, nrow =3)
m

no<-c(1,2,3,4)
name<-c("Lee", "Kim", "Park", "Jung")
gender<-c("M", "F", "M", "F")
dfrm1<-data.frame(no, name, gender)
dfrm1


##2.데이터프레임 편집  

###1) cbind( )와 rbind( )

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

###3) 결측값(NA) 
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

colnames(dfrm8)<- c("이름", "나이")
dfrm8
colnames(dfrm8)[2]<- "AGE"
dfrm8

###6) 인텍싱(indexing)

dfrm1
dfrm1[1,]
dfrm1[,1]
dfrm1[2,1]
dfrm1[1,c(1,3)]


##3.apply 함수  

###1) apply 함수 : apply(x, d, f)  

head(iris)
apply(iris[,1:4], 2, sum)
apply(iris[,1:4], 2, max)
apply(iris[,1:4], 2, sd)
apply(iris[,1:4], 2, mean)

###2) lapply 함수 
lapply(iris[,1:4],mean, na.rm=T)

###3) sapply 함수

sapply(iris[,1:4], mean, na.rm=T)

###4) tapply(출력값,기준컬럼,적용함수): 요인의 수준별로 특정 벡터에 함수 적용

tapply(iris$Sepal.Length, iris$Species, mean)

attach(iris)
tapply(Sepal.Length, Species, mean)
# with(iris, tapply(Sepal.Length, Species, mean))  #with 함수로 attach 함수를 대체함


## 4.dplyr 활용 

setwd("C:/R")  # 작업디렉토리 설정
#install.packages("dplyr")  
library(dplyr)
data <- read.csv("./data/age.csv")  # . 는 작업디렉토리를 의미한다.
head(data,5)

###1) filter 함수 
data1 <- filter(data, 남자 > 42 & 여자 > 43)
head(data1)
str(data1)

data2 <- select(data, 자치구, 동)
head(data2); str(data2)  # head와 str 명령어를 동시에 수행할 경우 “;”를 사용함

###3) arrange 함수 
data4 <- arrange(data, 평균연령)  #오름차순 정렬
head(data4)

data4 <- arrange(data, desc(평균연령))  #오름차순 정렬
head(data4)

###4) mutate 함수  
data6<-mutate(data, 남자여자 = 남자 + 여자) 
head(data6)

###5) summarise 함수  
data7<- data %>% group_by(자치구) %>% summarise(average = mean(평균연령, na.rm=T)) # nr.rm 은 결측치 제거함수임      
head(data7)



#######################################
######## 기 초 통 계 ################
#######################################

setwd("C:/R/data")

# 2. 자료 불러오기
fat<-read.csv('fat.csv', header=T, stringsAsFactors = T, na.strings="999") 
# stringAsFactors = T : 문자열을 포함한 열들을 요인으로 변환
# header = T : 첫 번째 열을 변수로 읽기
# na.strings="999" : 빈값은 999로 기재
# na.rm = T : 빈값이 있는 행은 삭제


# 3. 자료 살펴보기와 변환(encoding과 recode 등)

colnames(fat)
str(fat)

# install.packages("car")
library(car)
# car = Companion to Applied Regression

fat$EDU <- recode(fat$edu, '1'=6, '2'=9, '3'=12, '4'=16)

View(fat)

fat$region <- factor(fat$region, levels = c(1,2), labels = c("도시", "농촌")) 
table(fat$region)
table(fat$sex)
table(fat$sex, fat$region)


fat$rQ4 <- recode(fat$Q4, '1'=5, '2'=4, '3'=3, '4'=2, '5'=1)
table(fat$Q4)
table(fat$rQ4)

# install.packages("psych")
library(psych)  # alpha()함수 패키지
library(dplyr)  # select(), mutate()

factor1 <- select(fat, Q1, Q2, Q3)
alpha(factor1)

factor2 <- select(fat, rQ4, Q5, Q6)
alpha(factor2)

fat <- mutate(fat, 건강관리=(Q1+Q2+Q3)/3, 삶의질=(rQ4+Q5+Q6)/3) 
colnames(fat)

par(mfrow=c(1,2))  #화면을 1행 2열로 분할

hist(fat$bmi)
boxplot(fat$bmi)

par(mfrow=c(1,1))  # 초기화면으로 복귀
plot(fat$fat, fat$bmi)

plot(fat[,c("edu", "age", "bmi", "fat", "pressure")])

#상관관계
corPlot(fat[,c("edu", "age", "bmi", "fat", "pressure")], numbers=T)

#4. 결측값 확인 처리

summary(fat) 
colSums(is.na(fat))

# install.packages("DMwR")
library(DMwR)

fat2 <- centralImputation(fat)
#fat2 <- knnImputation(fat) #최근접이웃대체

colSums(is.na(fat2)) 


#5. 이상치 탐색 제거
library(car)
#fat2 <- read.csv("fat2.csv")

par(mfrow=c(1,2))  #화면을 1행 2열로 분할
Boxplot(fat2$건강관리,id=list(n=5))  # car 패키지의 Boxplot() 함수
Boxplot(fat2$삶의질, id=list(n=5))

par(mfrow=c(1,1))  # 초기화면으로 복귀
scatterplot(삶의질~건강관리, data=fat2, id=list(n=5)) 
scatterplot(fat2$건강관리,fat2$삶의질) 

# install.packages("scatterplot3d")
library(scatterplot3d)
scatterplot3d(fat2$삶의질,fat2$age,fat2$건강관리, main="3D Scatterplot")

dim(fat2)

fat2 <- fat2[-c(8,531,529,396),]
dim(fat2)  #dimension

#library(dplyr)
fat3<- select(fat2, sex, edu, age, region, 건강관리, 삶의질)
colnames(fat3)
str(fat3)

fat4<-subset(fat2, select=c("sex", "edu", "age", "region", "건강관리", "삶의질"))
colnames(fat4)
str(fat4)

# 회귀분석
fit <- lm(삶의질 ~ 건강관리, data=fat3)
summary(fit)

fit2 <- lm(삶의질 ~ 건강관리+edu+age+sex, data=fat3)
summary(fit2)
vif(fit2)

