library(stringr)
library(httr)
library(rvest)
# library(curl)
library(lubridate)

rm(list=ls())

g=c()
d=c()
time=c()
time1=c()
address=c()

for(year in 2019:2019){
  
  for(month in 2:2){
    
    for(day in 1:2){
      
      sk = paste0( year,".", month,".", day)
      #print(sk)
      time =c(time, sk)
      
      #pk = paste0( month,"/", day,"/",year)
      #print(sk)
      #time1 =c(time1, pk)
      
      
      #class(k3)
      k1 = na.omit(strptime(time, "%Y.%m.%d"))
      k2 = (str_replace_all(k1, '-','.'))
      k3 = str_replace_all(k2, '\\.','.+')
      j1 = year(k1)
      j2 = month(k1)
      j3 = day(k1)
      j4 = paste0( month,"/", day,"/", year)
      time1 =c(time1, j4)
      
      
      
      a=paste0("https://www.google.co.kr/search?q=%22energy%22&newwindow=1&tbs=cdr:1,cd_min:")
      # 일본어(에너지전환-エネルギー転換)
      #=paste0( a, j2, "%2F", j3, "%2F", j1, "%2Ccd_max%3A", j2, "%2F", j3, "%2F", j1, "&tbm=nws#q=nuclear&hl=ko&tbs=cdr:1,cd_min:")
      
      c=paste0( a, time1, ",cd_max:", time1, "&tbm=nws&start=")
      
      
    }
  }
}

d=c(d, c)   

pages = seq(0,1000, by = 10)
g =c(g, pages)


dday=c()
dtitle=c()
dnews=c()
dcon=c()
dtitle1=c()
dcon1=c()

#ua = user_agent("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_3) AppleWebKit/537.75.14 (KHTML, like Gecko) Version/7.0.3 Safari/7046A194A")
ua = user_agent("Mozilla/5.0 (Macintosh; U; Intel Mac OS X; en-US) AppleWebKit/533.4 (KHTML, like Gecko) Chrome/5.0.375.86 Safari/533.4")



for(i in d){
  for(w in g){
    f =paste0(i, w)
    h = GET(f, ua)
    htxt = read_html(h)
    
    # 제목 추출
    
    comments1 = html_nodes(htxt, 'div.alpha')
    article.links1 = html_nodes(comments1, 'h3.r.alpha')
    links1 = html_text(article.links1)
    print(links1)
    dtitle = c(dtitle, links1)
    
    
    # 매체 추출
    htxt = read_html(h)
    comments2 = html_nodes(htxt, 'div.s')
    #comments2 = html_nodes(comments2, 'span.alpha.alpha')
    article.links2 = html_text(comments2)
    if(length(links1)>0&length(article.links2)==0){article.links2="1"}
    #print(article.links2)
    dnews = c(dnews, article.links2)
    
    # 날짜 추출
    comments3 = html_nodes(htxt, 'div.s')
    comments3 = html_nodes(comments3, 'span.f.alpha')
    article.links3 = html_text(comments3)
    if(length(links1)>0&length(article.links3)==0){article.links3="1"}
    
    #article.links3 = str_extract(article.links3, '[0-9]+. [0-9]+. [0-9]+.')
    print(article.links3)
    dday = c(dday, article.links3)
    
    # 요약문 추출
    
    comments4 = html_nodes(htxt, 'div.s')    
    # comments4 = html_nodes(htxt, 'span.st')
    article.links4 = html_text(comments4)
    if(length(links1)>0&length(article.links4)==0){article.links4="1"}
    print(article.links4)
    dcon = c(dcon, article.links4)
    
    rtime=runif(1, 50, 60)
    Sys.sleep(time=rtime)
    
    if(length(links1)==0){break;
    } else {next}
    
  }
  
}
df= data.frame(dtitle,dday,dnews,dcon)
