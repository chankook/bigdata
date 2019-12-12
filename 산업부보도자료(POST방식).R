library(httr)
library(rvest)
library(stringr)

getwd()

# address #
url = 'http://www.motie.go.kr/motie/ne/presse/press2/bbs/bbsList.do'

# empty dataframe
df = data.frame(title=c(), content=c(), date=c())

post.num = 1

for(i in 0:50) {
  
  r = POST(url, encode = 'form',
           body = list(bbs_cd_n=81,
                       bbs_seq_n='',
                       currentPage= (i*10)+1,
                       from_brf='',
                       brf_code_v='',
                       cate_n=1,
                       sch_clear= 'Y',
                       start_dt_d='',
                       end_dt_d='',
                       search_key_n='title_v',
                       search_val_v=''))
  
  # Network -> bbsList.do -> Form Data
  
  policy = read_html(r)
  title2 = html_nodes(policy, 'tr')
  title2 = html_nodes(title2, 'div.ellipsis')
  
  title3 = html_nodes(title2, 'a')
  
  policy.links = html_attr(title3, 'href')
  
  
  
  for(link in policy.links){
    
    link= paste0('http://www.motie.go.kr/ne/presse/press2/bbs/', link)
    print(link)
    h = read_html(link)
    
    # title
    title = html_text(html_nodes(h, 'td.subject'))
    print(title)
    df[post.num, 'title'] = title
    
    # contents
    content = html_text(html_nodes(h, 'tbody td'))
    content = content[head(7)]
    content = str_trim(content) #str_trim: deleting the front blank and the back blank in strig
    content = str_replace_all(content, '[[:space:]]', ' ')
    print(content)
    
    
    df[post.num, 'content'] = content
    
    # date
    date = html_text(html_nodes(h, 'tbody td'))
    date = date[head(5)]
    print(date)
    df[post.num, 'date'] = date
    
    # post number
    post.num <- post.num + 1
    
    
    
  } 
}
write.table(df, 'motie.csv', sep=',')