library(httr) # HTTP
library(rvest) # HTML
library(stringr)
# library(curl)
# library(xml2)


g=c()
d=c()
time=c()
time1=c()
address=c()
dday=c()
dtitle=c()
dnews=c()
dcon=c()
dcon1=c()

for(year in 2019:2019){
  
  for(month in 1:1){
    
    for(day in 1:2){
      
      sk = paste0( year,".", month,".", day)
      #print(sk)
      time =c(time, sk)
      
      
      pk = paste0( year, month, day)  
      #print(pk)
      time1 =c(time1, pk)
      
      #class(k3)
      k1 = strptime(time, "%Y.%m.%d")
      k2 = (str_replace_all(k1, '-','.'))
      k2 = na.omit(k2) 
      k3 = str_replace_all(k2, '\\.','')
      
      keyword <-"에너지전환"
      a=paste0("https://search.naver.com/search.naver?ie=utf8&where=news&query=",keyword,"&sm=tab_pge&sort=1&photo=0&field=0&reporter_article=&pd=3&ds=")
      # a=paste0("https://search.naver.com/search.naver?ie=utf8&where=news&query=%22%EC%97%90%EB%84%88%EC%A7%80%EC%A0%84%ED%99%98%22&sm=tab_pge&sort=1&photo=0&field=0&reporter_article=&pd=3&ds=")

      b=paste0( a, k2, "&de=", k2, "&docid=&nso=so:dd,p:from")
      
      c=paste0( b, k3, "to", k3, ",a:all&mynews=0&start=")
      
    }
  }
}

d=c(d, c)  

pages=seq(1,2000,10)
for(page in pages){
  f=paste0( page, "&refresh_start=0")  
  g=c(g, f)
}

ua = user_agent("Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.99 Safari/537.36")

for(n in d){
  for(i in g){
    m=paste0( n, i)
    h = GET(m, ua)
    htxt = read_html(h)
    
    # title extraction  
    comments1 = html_nodes(htxt, 'dt')
    article.links1 = html_nodes(comments1, 'a._sp')
    links1 = html_attr(article.links1, 'title')
    links1 = str_replace_all(links1, "[[:punct:]]", " ")
    #print(links1)
    dtitle = c(dtitle, links1)
    
    # media extraction  
    comments2 = html_nodes(htxt, 'dd.txt')
    comments2 = html_nodes(comments2, 'span.')
    article.links2 = html_text(comments2)
    #print(article.links2)
    dnews = c(dnews, article.links2)
    
    # date extraction  
    comments3 = html_nodes(htxt, 'dd.txt_inline')
    article.links3 = html_text(comments3)
    article.links3 = str_extract(article.links3, '[0-9]+.[0-9]+.[0-9]+.')
    print(article.links3)
    dday = c(dday, article.links3)
    
    # summary extraction  
    comments4 = html_nodes(htxt, 'ul.type02')
    comments4 = html_nodes(comments4, 'dl')
    article.links4 = html_text(comments4)
    article.links4 = str_replace_all(article.links4, "[[:punct:]]", " ")
    #article.links4 = str_replace_all(article.links4, "[[:digit:]]", " ")
    #print(article.links4)
    dcon = c(dcon, article.links4)
    
    k01 = str_replace_all(article.links4, c(links1), "")
    k01 = str_replace_all(k01, article.links2, "")
    k01 = str_replace_all(k01, article.links3, "")
    k01 = str_replace_all(k01, "네이버뉴스", "")
    k01 = str_replace_all(k01, "보내기", "")
    k01 = str_trim(k01)
    dcon1 =c(dcon1, k01)
    
    #View(k7)
    
    if(length(links1)==0){break;
    } else {next}
  }
}



df= data.frame(dtitle,dday,dnews,dcon1)
View(df)
#df = unique(df)
write.table(df, 'et_Ko.csv', sep=',', row.names=T)