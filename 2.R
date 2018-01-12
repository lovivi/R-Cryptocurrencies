library('rvest')

data1 <- c()

for (i in 1:1000) {
  # 指定要爬取的url
  url <- 'https://www.okex.com/api/v1/ticker.do?symbol=btc_usdt'
  bian <- binance_current_price()[13,]
  
  # 从网页读取html代码
  webpage <- read_html(url)
  webpage <- html_text(webpage)
  
  library(stringr)
  
  step1 <- str_split(webpage,"[,]",simplify = T)
  step2 <- str_split(step1,"\"",simplify = T)[,c(2,4)][-2,]
  
  okex <- step2[6,2]
  
  aaa <- c(okex,bian[1,2])
  aaa <- as.numeric(aaa)
  aaa <- c(as.character(Sys.time()),aaa,aaa[1]-aaa[2])
  names(aaa) <- c("time","okex","binance","cha")
  print(aaa)
  
  data1 <- rbind(data1,aaa)
  Sys.sleep(2)
}
