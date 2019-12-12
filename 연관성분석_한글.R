# Sys.setenv(JAVA_HOME="C:/Program Files/Java/jre1.8.0_211")   
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
##############import data ##############
d <- get(load("insurance.RData"))
colnames(d)


docs = d$contents

docs <- docs[1:2]

###################################################################################################
##############cleansing ##############

docs <- gsub("[[:punct:]]", " ", docs) #deleting punctions
docs <- gsub("\\d+", " ", docs) #deleting numbers
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
##############frequency extraction ##############

tdm <- TermDocumentMatrix(main_Cop)
mTDM <- as.matrix(tdm) # to matrix
Fre = rowSums(mTDM)

sTDM <- mTDM[rowSums(mTDM)>3,] # only over three words

Fre_table <- data.frame(word = rownames(sTDM), Fre = rowSums(sTDM))
rownames(Fre_table) <- 1:nrow(Fre_table)

####### sorting ##########
# install.packages("dplyr")
library(dplyr)
Fre_table <- arrange(Fre_table, desc(Fre))

## other sorting way##
Fre_table <- Fre_table[order(Fre_table$Fre, decreasing = T),]

############ extracting some words############
list <- c("본부장","보험료")
s_Fre_table <- Fre_table[which(Fre_table$word %in% list),]

###################################################################################################
##############Association rules ##############

b_mTDM <- ifelse(mTDM>0, 1, 0)
tt_matrix <- b_mTDM %*% t(b_mTDM)

### 
sTDM <- mTDM[rowSums(mTDM)>3,] # only over three words
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
## only for a certain word
asso_data[which(asso_data$From %in% "박정희"),]
subset(asso_data, From =="박정희")
filter(asso_data, From =="박정희")

## only for a certain word group
list <- c("박정희","본부장")
s_asso_data <- asso_data[which(asso_data$From %in% list),]

###################################################################################################
#################Association rules ################
##############(for a certain word) ############

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
