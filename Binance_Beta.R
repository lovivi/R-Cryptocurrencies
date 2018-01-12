# === API Data - Binance =========
# === built by Etienne Mirland == 
options(scipen=200) 
library(httr) ; library(jsonlite)

#Function to obtain the server time
binance_server_time<- function(){
  url <- paste0("https://api.binance.com/api/v1/time")
  
  server_time_raw <- GET(url)
  server_time_raw <- rawToChar(server_time_raw$content)
  server_time_raw <- fromJSON(server_time_raw)
  server_time_raw <- server_time_raw$serverTime
  server_time <- as.POSIXct(server_time_raw/1000, origin="1970-01-01")
  return(server_time)
}

#This function retrieves the complete order book for a specific pair
binance_order_book_ticker <- function(symbol = "ETHBTC", limit = 100) {
  url <- paste0("https://api.binance.com/api/v1/depth?symbol=", symbol, "&limit=", limit)
  
  order_book_raw <- GET(url)
  order_book_raw <- rawToChar(order_book_raw$content)
  order_book <- fromJSON(order_book_raw)
  
  binance_asks <- order_book$asks
  binance_bids <- order_book$bids
  binance_asks <- data.frame(t(as.data.frame(matrix(unlist(binance_asks), 
                                                    nrow=length(unlist(binance_asks[1]))))))
  colnames(binance_asks) <- c("ask_price", "ask_quantity")
  binance_bids <- data.frame(t(as.data.frame(matrix(unlist(binance_bids), 
                                                    nrow=length(unlist(binance_bids[1]))))))
  colnames(binance_bids) <- c("bid_price", "bid_quantity")
  
  binance_data <- list(binance_asks, binance_bids)
  names(binance_data) <- c("ask_orders", "bid_orders")
  
  return(binance_data)
}

#Function to obtain aggregate trades list for a specific pair
binance_trade_list <- function(symbol = "ETHBTC", fromId, limit, start_time, end_time) {
  
  url <- paste0("https://api.binance.com/api/v1/aggTrades?symbol=", symbol)
  
  if(!missing(limit)){ #if limit is set
    if(!missing(fromId)){
      url <- paste0(url, "&fromId=", fromId, "&limit=", limit)
    }else{
      url <- paste0(url, "&limit=", limit) 
    }
  }else{ #if limit is not set
    
    if(missing(start_time)){
      return("Correct your parameters.")
    }
    
    if(missing(end_time)){
      return("Correct your parameters.")
    }
    
    start_time <- start_time #as.character(as.numeric(as.POSIXct(start_time)) * 1000)
    end_time <- end_time #as.character(as.numeric(as.POSIXct(end_time)) * 1000)
    url <- paste0(url,"&startTime=",start_time, "&endTime=",end_time)
  }
  
  trade_list_raw <- GET(url)
  trade_list_raw <- rawToChar(trade_list_raw$content)
  trade_list_raw <- fromJSON(trade_list_raw)
  trade_list <- data.frame(trade_list_raw)
  
  trade_list[,1:6] <- lapply(trade_list[,1:6], function(x) as.numeric((x)))
  trade_list[,6] <- as.POSIXct(trade_list[,6]/1000, origin = "1970-01-01")
  
  colnames(trade_list) <- c("agg_tradeID", "price", "quantity", "first_tradeID", 
                            "last_tradeID", "time", "was_buyer_maker", "was_trade_best_price_match")
  return(trade_list)
}

#Function to obtain OHLC for a specific pair
binance_OHLC<- function(symbol = "ETHBTC", interval = "1m", limit, start_time, end_time){
  
  url <- paste0("https://api.binance.com/api/v1/klines?symbol=", symbol,"&interval=", interval)
  
  available_intervals <- c("1m","3m", "5m","15m","30m","1h",
                           "2h", "4h","6h","8h","12h","1d",
                           "3d","1w","1M")
  
  if ((interval %in% available_intervals) == FALSE){
    print("Please choose an interval among these ones:")
    return(available_intervals)
  }
  
  
  if(!missing(limit)){ #if limit is set
    if(!missing(end_time)){ # if both limit and endtime are set
      end_time <- as.character(as.numeric(as.POSIXct(end_time)) * 1000)
      if(!missing(start_time)){ #if limit, start_time and end_time are set
        return("Please don't input start_time, end_time and limit at the same time")
        #url <- paste0(url,"&limit=", limit,"&startTime=",start_time, "&endTime=",end_time)
      }else{ #if limit and end_time are set
        url <- paste0(url,"&limit=", limit,"&endTime=",end_time) 
      }
      
    }else{   #limit is set but end_time isn't
      
      if(!missing(start_time)){ #if limit and start_time are set but end_time isn't
        start_time <- as.character(as.numeric(as.POSIXct(start_time)) * 1000)
        url <- paste0(url,"&limit=", limit,"&startTime=",start_time) 
      }else{ #if only limit is set
        url <- paste0(url,"&limit=", limit)
      }
    }
    
  }else{ #if limit is not set
    
    if(missing(start_time)){
      return("Correct your parameters.")
    }
    
    if(missing(end_time)){
      return("Correct your parameters.")
    }
    
    start_time <- as.character(start_time)#as.character(as.numeric(as.POSIXct(start_time)) * 1000)
    end_time <- as.character(end_time)#as.character(as.numeric(as.POSIXct(end_time)) * 1000)
    url <- paste0(url,"&startTime=",start_time, "&endTime=",end_time)
  }
  
  
  OHLC_raw <- GET(url)
  OHLC_raw <- rawToChar(OHLC_raw$content)
  OHLC_raw <- fromJSON(OHLC_raw)
  
  OHLC <- data.frame(OHLC_raw)
  OHLC <- OHLC[,-12]
  
  OHLC[,1:11] <- lapply(OHLC[,1:11], function(x) as.numeric(as.character(x)))
  OHLC[,c(1,7)] <- lapply(OHLC[,c(1,7)], function(x) as.POSIXct(x/1000, origin = "1970/01/01"))
  colnames(OHLC) <- c("open_time","open","high","low","close",
                      "volume","close_time","quote_asset_volume",
                      "number_trades", "taker_buy_base_asset_volume",
                      "taker_buy_quote_asset_volume")
  return((OHLC))
  
}


#Function to obtain 24h-data for a specific pair
binance_24h_ticker_data<- function(symbol = "ETHBTC"){
  url <- paste0("https://api.binance.com/api/v1/ticker/24hr?symbol=", symbol)
  ticker_price_raw <- GET(url)
  ticker_price_raw <- rawToChar(ticker_price_raw$content)
  ticker_price <- fromJSON(ticker_price_raw)
  ticker_price <- sapply(ticker_price, function(x) as.numeric(as.character(x)))
  
  ticker_price <- data.frame(t(ticker_price))
  rownames(ticker_price) <- c(as.character(symbol))
  
  ticker_price[,16:17] <- lapply(ticker_price[,16:17], function(x) as.POSIXct(x/1000, origin = "1970/01/01"))
  return(ticker_price)
}


#Function to retrieve the market prices for all traded pairs
binance_current_price <- function(){
  url <- paste0("https://api.binance.com/api/v1/ticker/allPrices")
  market_price_raw <- GET(url)
  market_price_raw <- rawToChar(market_price_raw$content)
  market_price <- fromJSON(market_price_raw)
  return(market_price)
  
}

#Function to obtain names of all traded pairs
binance_traded_symbols <- function(){
  binance_data <- binance_current_price()
  traded_symbols <- binance_data[,1]
  traded_symbols <- c(traded_symbols)
  print("These are the different pairs traded on Binance:")
  return(traded_symbols)
}

#Function to obtain the narrowest ask/ bid for all traded pairs
binance_best_order_book_all <- function(){
  url <- paste0("https://api.binance.com/api/v1/ticker/allBookTickers")
  order_book_raw <- GET(url)
  order_book_raw <- rawToChar(order_book_raw$content)
  order_book_raw <- fromJSON(order_book_raw)
  order_book <- data.frame(order_book_raw)
  order_book[,2:5] <- lapply(order_book[,2:5], function(x) as.numeric(as.character(x)))
  colnames(order_book) <- c("symbol", "bid_price", "bid_quantity", "ask_price", "ask_quantity")
  return(order_book)
  
}
