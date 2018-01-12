library(jsonlite)
library(httr)

binance_server_time()
binance_order_book_ticker("BTCUSDT", limit = 50)
binance_order_book_ticker("WTCETH", 20)
binance_traded_symbols()

binance_trade_list("BTCUSDT", start_time = "2017/11/10 06:00", end_time = "2017/11/10 07:00")
binance_trade_list("LRCETH", limit = 100)
binance_trade_list("WTCBTC", fromId = "543120", limit = 50)

cp <- c()
ap <- c()
bp <- c()
for (i  in 1:10000) {
  ap<- c(ap,(binance_order_book_ticker("BTCUSDT", limit = 5)$ask_orders[1,1]))
  bp<- c(bp,(binance_order_book_ticker("BTCUSDT", limit = 5)$bid_orders[1,1]))
  cp<- c(cp,(binance_current_price()[13,]))
  Sys.sleep(2)
  print(i)
}



for (i  in 1:10000) {
  print((binance_order_book_ticker("BTCUSDT", limit = 5)$ask_orders[1,1]))
  print(((binance_order_book_ticker("BTCUSDT", limit = 5)$bid_orders[1,1])))
  print((binance_current_price()[13,]))
  Sys.sleep(2)
  print(i)
}


# coinmarketcap_global(pricecurrency = "EUR", field = "all", limit = 200)
# coinmarketcap_global(pricecurrency ="JPY", field = "total_supply", limit = 50)





aaa <- binance_trade_list("BTCUSDT", start_time = "2016/11/10 06:00", end_time = "2018/1/09 07:00", limit = 500)

plot(aaa$price,type = "l")

coin_name <- binance_traded_symbols()
library(stringr)
coin_name <- coin_name[grep(pattern = "BTC",coin_name)]
coin_name_n <-which( binance_current_price()$symbol %in% coin_name)


before <- as.matrix(binance_current_price())[coin_name_n[-7],]


for (i in  1:1000){
  now1 <- as.matrix(binance_current_price())[coin_name_n[-7],]
  cha <- as.numeric(before[,2])-as.numeric(now1[,2])
  cha[cha>0] <- "down"
  cha[cha<0] <- "up"
  print(binance_server_time())
  print(binance_current_price()[13,])
  print(table(cha))
  before <- now1
  Sys.sleep(5)
}
p <- list()


for (i in 36:length(coin_name)){
  try(p[[i]] <- 
    binance_trade_list(coin_name[i], start_time = "2017/11/10 06:00", end_time = "2017/11/10 07:00"))
  print(i)
  Sys.sleep(1)
}

length(p)

dim(p[[7]])
#################################################

btc_trade <- list()
for(i in 1:24){
  btc_trade[[i]] <- binance_trade_list(coin_name[7], 
                                       start_time = paste0("2017/11/11 ",i-1,":01"),
                                       end_time = paste0("2017/11/11 ",i,":00"))
  print(i)
}


par(mfrow=c(2,2))
plot(sapply(btc_trade,function(x) mean(x$price)),type="l",main = "price")
plot(sapply(btc_trade, nrow),type="l",main = "trade_num")
plot(sapply(btc_trade,function(x) sum(x$price*x$quantity)),type="l",main = "trade_quantity")
plot(sapply(btc_trade,function(x) length(which(x$was_buyer_maker))/nrow(x)),type="l",main = "buyer_maker")

##################################################



btc_trade <- c()
current_time <- as.numeric(as.POSIXlt(Sys.time()))

btc_trade <- c()
start_time <- as.POSIXlt("2018-01-04 23:59:00 CST")
for(j in 1:100){
  btc_trade <- c()
for(i in 1:24){
  end_time <- start_time 
  start_time <- start_time -3600
  tryCatch({
  btc_trade <- rbind(btc_trade,binance_trade_list(coin_name[5], 
                                       start_time = as.character(round(as.numeric(as.POSIXlt(start_time)))*1000),
                                       end_time =  as.character(round(as.numeric(as.POSIXlt(end_time)))*1000)))},
  error = function(e){
    print(end_time)
    print("error")
    Sys.sleep(1)
    cat("ERROR :",conditionMessage(e),"\n")
    #btc_trade <- rbind(btc_trade,binance_trade_list(coin_name[7], 
    #                                                start_time = as.character(round(as.numeric(as.POSIXlt(start_time)))*1000),
    #                                                end_time =  as.character(round(as.numeric(as.POSIXlt(end_time)))*1000)))
  }
  )
  print(end_time)
  Sys.sleep(0.2)
  
}
  Sys.sleep(2)
save(btc_trade,file = paste0("./data/",coin_name[5],"_",as.Date(end_time),".RData"))
}



as.numeric(as.POSIXct( "2017/11/12 1:01")) * 1000


trade_time <- (str_split(p[[7]]$time,"[ :]",simplify = T)[,2])
hist(as.numeric(trade_time))
