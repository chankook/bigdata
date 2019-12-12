# http://jungto.libsyn.com/

library(httr)
library(rvest)
library(stringr)

mp3_src=c()
for(i in 1:10){
  src = paste0(
    'http://jungto.libsyn.com/webpage/page/', i, '/size/10')
  h = GET(src)
  mp3 = read_html(h)
  mp3 = html_nodes(mp3, 'div.postDetails a')
  mp3 = html_attr(mp3, 'href')
  mp3 = mp3[grep('traffic', mp3)]
  mp3_src=c(mp3_src, mp3)
}
for(j in 1:100){
  download =GET(mp3_src[j])
  writeBin(content(download, 'raw'), sprintf('%03d.mp3',j))
}