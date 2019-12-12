# Sys.setenv(JAVA_HOME="C:/Program Files/Java/jre1.8.0_211")  # 해당 디렉토리(C:/Program Files/Java/)에 들어가서 jre 버전이 맞는지 확인함. 여러분 버전은 181? 191? 확인하세요. 
library(rJava)
library(KoNLP)
library(tm)
library(SnowballC)
library(data.table)

useNIADic()

# words <- function(doc){
#   doc <- as.character(doc)
#   doc2 <- paste(SimplePos22(doc))
#   doc3 <- str_match(doc2, "([가-힣]+)/(PA|PV|NC)")
#   doc4 <- doc3[,2]
#   doc4[!is.na(doc4)]
# }

###################################################################################################
##############데이터 불러오기 ##############
d <- get(load("insurance.RData"))
colnames(d)


docs = d$contents

docs <- docs[1:2]

###################################################################################################
##############정제 작업 ##############

docs <- gsub("[[:punct:]]", " ", docs) #기호제거
docs <- gsub("\\d+", " ", docs) #숫자제거
docs <- gsub("▲", " ", docs)
docs <- gsub("△", " ", docs)
docs <- gsub("■", " ", docs)
docs <- gsub("▶", " ", docs)
docs <- gsub("◎", " ", docs)
docs <- gsub("◆", " ", docs)
docs <- gsub("◇", "", docs)


# delete<- c("▲","△","■","◎","▶","◆","◇")
# for (i in 1:length(delete)){
#   docs <- gsub(delete[i]," ",docs)
#   print(i)
# }

nouns <- extractNoun(docs)
nouns <- sapply(nouns, paste, collapse=" ")
main_Cop <- VCorpus(VectorSource(nouns))

# # cleansing  
# 
# main_Cop <- tm_map(main_Cop, content_transformer(tolower))
# main_Cop <- tm_map(main_Cop, toSpace, "/^[A-z]+$/")
# main_Cop <- tm_map(main_Cop, removeWords, stopwords('english'))
# main_Cop <- tm_map(main_Cop, removePunctuation)
# main_Cop <- tm_map(main_Cop, removeNumbers)
# main_Cop <- tm_map(main_Cop, stripWhitespace)

###################################################################################################
##############빈도 추출 ##############

tdm <- TermDocumentMatrix(main_Cop)
mTDM <- as.matrix(tdm) # 매트릭스로 전환
Fre = rowSums(mTDM)

sTDM <- mTDM[rowSums(mTDM)>3,] # 단어수가 3개 이상인 것만 추출

Fre_table <- data.frame(word = rownames(sTDM), Fre = rowSums(sTDM))
rownames(Fre_table) <- 1:nrow(Fre_table)

####### 빈도순으로 정렬 ##########
# install.packages("dplyr")
library(dplyr)
Fre_table <- arrange(Fre_table, desc(Fre))

## 다른 정렬방식##
Fre_table <- Fre_table[order(Fre_table$Fre, decreasing = T),]

############ 일부 단어만 추출############
list <- c("본부장","보험료")
s_Fre_table <- Fre_table[which(Fre_table$word %in% list),]

###################################################################################################
##############연관성 분석 ##############

b_mTDM <- ifelse(mTDM>0, 1, 0)
tt_matrix <- b_mTDM %*% t(b_mTDM)

### 단어수가 일정 수준 이상인 것들만 처리
sTDM <- mTDM[rowSums(mTDM)>3,] # 단어수가 3개 이상인 것만 추출
b_sTDM <- ifelse(sTDM>0, 1, 0)
tt_matrix <- b_sTDM %*% t(b_sTDM)

From <- c() 
To <- c()  
Support <- c()
Confidence <- c()
Lift <- c()

for (i in 1:nrow(tt_matrix)){
  for (j in 1:ncol(tt_matrix)){
    From <- c(From, rownames(tt_matrix)[i])
    To <- c(To, colnames(tt_matrix)[j])
    ### SUPPORT(i -> j)
    Support <- c(Support, tt_matrix[i,j]/ncol(b_mTDM))
    ### FOR TIME SAVING, IF SUPPORT IS ZERO, THEN CONFIDENCE, LIFT IS ALSO ZERO.
    if (Support == 0){
      Confidence <- c(Confidence,0)
      Lift <- c(Lift,0)
      next
    }
    
    ### CONFIDENCE(i -> j)
    Confidence <- c(Confidence, tt_matrix[i,j]/diag(tt_matrix)[[i]])
    
    ### LIFT(i -> j)
    Lift <- c(Lift, (tt_matrix[i,j]/diag(tt_matrix)[[i]])/(diag(tt_matrix)[[j]]/ncol(b_mTDM)))
  }
  cat("nrow(i) = ", i, "total nrow = ", nrow(tt_matrix), "\n")
}

asso_data <- as.data.table(cbind(From, To, Support, Confidence, Lift))
## 특정단어만 추출
asso_data[which(asso_data$From %in% "박정희"),]
subset(asso_data, From =="박정희")
filter(asso_data, From =="박정희")

## 특정단어그룹 추출
list <- c("박정희","본부장")
s_asso_data <- asso_data[which(asso_data$From %in% list),]

###################################################################################################
#################연관성 분석 ################
##############(특정 키워드 중심) ############

From <- c() 
To <- c()  
Support <- c()
Confidence <- c()
Lift <- c()

term <- which(rownames(tt_matrix) %in% "박정희")

for (i in term:term){
  for (j in 1:ncol(tt_matrix)){
    From <- c(From, rownames(tt_matrix)[i])
    To <- c(To, colnames(tt_matrix)[j])
    ### SUPPORT(i -> j)
    Support <- c(Support, tt_matrix[i,j]/ncol(b_mTDM))
    ### FOR TIME SAVING, IF SUPPORT IS ZERO, THEN CONFIDENCE, LIFT IS ALSO ZERO.
    if (Support == 0){
      Confidence <- c(Confidence,0)
      Lift <- c(Lift,0)
      next
    }
    
    ### CONFIDENCE(i -> j)
    Confidence <- c(Confidence, tt_matrix[i,j]/diag(tt_matrix)[[i]])
    
    ### LIFT(i -> j)
    Lift <- c(Lift, (tt_matrix[i,j]/diag(tt_matrix)[[i]])/(diag(tt_matrix)[[j]]/ncol(b_mTDM)))
  }
  cat("nrow(i) = ", i, "total nrow = ", nrow(tt_matrix), "\n")
}

asso_data <- as.data.table(cbind(From, To, Support, Confidence, Lift))
