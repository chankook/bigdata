library(httr)
library(rvest)
library(stringr)

getwd()

# 게시판 주소#
url = 'http://www.motie.go.kr/motie/ne/presse/press2/bbs/bbsList.do'

# 제목과 본문을 저장할 벡터 
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
    
    # 제목
    title = html_text(html_nodes(h, 'td.subject'))
    print(title)
    df[post.num, 'title'] = title
    
    # 본문
    content = html_text(html_nodes(h, 'tbody td'))
    content = content[head(7)]
    content = str_trim(content) #str_trim: 문자열의 가장 앞과 가장 뒤에  공백이 있을 경우 제거해주는 함수
    content = str_replace_all(content, '[[:space:]]', ' ')
    print(content)
    
    
    df[post.num, 'content'] = content
    
    # 날짜
    date = html_text(html_nodes(h, 'tbody td'))
    date = date[head(5)]
    print(date)
    df[post.num, 'date'] = date
    
    # 글번호 증가
    post.num <- post.num + 1
    
    
    
  } 
}
write.table(df, 'motie.csv', sep=',')