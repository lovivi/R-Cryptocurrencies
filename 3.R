library('rvest')
library(stringr)

okex_get_price("btc_usdt")
okex_get_price <- function(trade){
  url <- paste0('https://www.okex.com/api/v1/ticker.do?symbol=',trade)
  
  webpage <- read_html(url)
  webpage <- html_text(webpage)
  
  step1 <- str_split(webpage,"[,]",simplify = T)
  step2 <- str_split(step1,"\"",simplify = T)[,c(2,4)][-2,]
  
  okex <- as.numeric(step2[5:6,2])
  names(okex) <- step2[5:6,1]
  okex
}


usdt <- 10000
for (i in 1:100) {
  a1 <- okex_get_price("btc_usdt")
  a2 <- okex_get_price("ltc_btc")
  a3 <- okex_get_price("ltc_usdt")
  
  
  btc <- usdt/a1[2]
  btc <- btc*0.999
  gas <- btc/a2[2]
  gas <- gas*0.999
  usdt_b <- gas*a3[1]
  cat("usdt to btc to ltc to usdt \n")
  cat(usdt_b,usdt_b-usdt,'\n')
  
  gas <- usdt/a3[2]
  gas <- gas*0.999
  btc <- gas*a2[1]
  btc <- btc*0.999
  usdt_b <- btc*a1[1]
  cat("usdt to ltc to btc to usdt \n")
  cat(usdt_b,usdt_b-usdt,'\n')
  cat("----------------\n")
  Sys.sleep(3)
  
}


