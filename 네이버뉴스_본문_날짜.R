#업데이트 2018.11.9. 
library(httr) # HTTP 
library(rvest) # HTML
library(stringr)
library(curl)
library(xml2)
library(sjmisc) #is_empty function

g=c()
d=c()
time=c()
time1=c()
address=c()
dday=c()
dtitle=c()
dnews=c()
contents=c()
for(year in 2017:2019){
  
  for(month in 1:12){
    
    for(day in 1:31){
      
      sk = paste0( year,".", month,".", day)
      #print(sk)
      time =c(time, sk)
      
      
      # pk = paste0( year, month, day)  
      # #print(pk)
      # time1 =c(time1, pk)
      # 
      #class(k3)
      k1 = strptime(time, "%Y.%m.%d")
      k2 = (str_replace_all(k1, '-','.'))
      k2 = na.omit(k2) 
      k3 = str_replace_all(k2, '\\.','')
      
      # a=paste0("https://search.naver.com/search.naver?ie=utf8&where=news&query=%EB%B8%94%EB%A1%9D%EC%B2%B4%EC%9D%B8%20%EC%97%90%EB%84%88%EC%A7%80&sm=tab_pge&sort=1&photo=0&field=0&reporter_article=&pd=3&ds=")

      keyword <- "에너지"      
      a=paste0("https://search.naver.com/search.naver?ie=utf8&where=news&query=",keyword,"&sm=tab_pge&sort=1&photo=0&field=0&reporter_article=&pd=3&ds=")
      
      b=paste0( a, k2, "&de=", k2, "&docid=&nso=so:dd,p:from")
      
      c=paste0( b, k3, "to", k3, ",a:all&mynews=0&start=")
      
    }
  }
}


d=c(d, c)  
pages=seq(1,100,10)
for(page in pages){
  f=paste0( page, "&refresh_start=0")  
  g=c(g, f)
}
ua = user_agent("Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.99 Safari/537.36")

# crawling an article with a Naver News button
for(n in d){
  for(i in g){
    m=paste0(n, i)
    h = GET(m, ua)
    htxt = read_html(h)

    naverbutton <- html_nodes(htxt, 'dd.txt_inline') %>% html_node(css= 'a._sp_each_url') %>% html_attr('href')

    naverbutton_order <- grep("http", naverbutton)
    url_list <- naverbutton[grep("http", naverbutton)]
    
    press_name <- html_nodes(htxt, 'dd.txt_inline') %>% html_nodes('span._sp_each_source') %>%
        html_text()
    
    # possibleError <- tryCatch(, error=function(e) e)
    # if(inherits(possibleError, "error")){break;} else {next}
    z <- 1
    
    for (url in url_list){
      htxt1 <- read_html(url)
      # title extraction  
      headline = html_nodes(htxt1, css='div.article_info') %>% html_nodes('h3#articleTitle') %>%
        html_text()

      if(is_empty(headline)==TRUE){next;}
      print(headline)
      dtitle = c(dtitle, headline)
      # Sys.sleep(1)

      # media extraction
      press <- press_name[naverbutton_order[z]]
      print(press)
      z <- z + 1
      dnews = c(dnews, press)
      
      # date extraction
      date <- html_nodes(htxt1, 'div.article_info') %>% html_nodes('span.t11') %>% html_text()
      print(date)
      dday = c(dday, date[1])
      
      # contents extraction
      article <- html_nodes(htxt1, 'div#articleBodyContents') %>% html_text()
      article <- substring(article, 72)
      contents = c(contents, article)
    }
  }
}

df= data.frame(dtitle,dday,dnews,contents)
# View(df)
# write.table(df, 'blockchain_energy_ko.csv', sep=',', row.names=T)
###save as a text file(utf-8)
# write.table(df, "blockchain_energy_ko.txt", 
            # sep="\t", row.names = TRUE, col.names = TRUE, quote = FALSE, append = TRUE,  na = "NA", fileEncoding = "UTF-8") 

