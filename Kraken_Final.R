# === API Data - Kraken =========
# === built by Etienne Mirland == 

library(httr) ; library(jsonlite)

#Function to obtain the list of currencies used on Kraken
kraken_currency_list<- function(){
  url <- paste0("https://api.kraken.com/0/public/Assets")
  kraken_assets_raw <- GET(url)
  kraken_assets_raw <- rawToChar(kraken_assets_raw$content)
  kraken_assets_raw <- fromJSON(kraken_assets_raw)
  kraken_assets <- kraken_assets_raw$result
  
  kraken_assets <- c(as.character(unlist(sapply(kraken_assets, `[`, 2))))

  return(kraken_assets)
}


#Function check if our pair of currencies is valid
kraken_check_pair <- function(basecurrency, pricecurrency){
  #Exit function
  exit <- function() {
    .Internal(.invokeRestart(list(NULL, NULL), NULL))
  }
  
  #define accepted currencies to obtain a quotation
  kraken_assets <- kraken_currency_list()
  
  if ((basecurrency %in% kraken_assets) == FALSE){
    print("Please input a pair of currencies among these ones:")
    print(kraken_assets)
    exit()
  }
  
  if ((pricecurrency %in% kraken_assets) == FALSE){
    print("Please input a pair of currencies among these ones:")
    print(kraken_assets)
    exit()
  }
}


#Obtain OHLC for a pair of currencies
kraken_live <- function(basecurrency = "XBT", pricecurrency = "USD", field = "all", check_pair = TRUE){

  #Exit function
  exit <- function() {
    .Internal(.invokeRestart(list(NULL, NULL), NULL))
  }
  
  #Check if our pair of currencies exist
  if(check_pair == TRUE){kraken_check_pair(basecurrency, pricecurrency)}
  
  kraken_data_rownames <- c("ask_price", "ask_whole_vol", "ask_volume", 
                            "bid_price", "bid_whole_vol", "bid_volume",
                            "last_price", "last_volume",
                            "today_volume", "24h_volume",
                            "today_price_avg", "24_price__avg",
                            "today_count_trades", "24h_count_trades",
                            "today_price_low", "24h_price_low",
                            "today_price_high", "24h_price_high",
                            "open_price")
  
  #Check if the requested field exists
  if (field %in% c("all", kraken_data_rownames) == FALSE){
    print("This field is not available. Available fields are:")
    print(c("all", kraken_data_rownames))
    exit()
  }
  
  
  url <- paste0("https://api.kraken.com/0/public/Ticker?pair=", basecurrency, pricecurrency)
  kraken_raw <- GET(url)
  kraken_raw <- rawToChar(kraken_raw$content)
  kraken_raw <- fromJSON(kraken_raw)
  kraken_data <- kraken_raw$result

  
  #subset based on the type of price
  kraken_data <- data.frame(unlist(kraken_data), row.names = kraken_data_rownames)
  
  #Convert all to numeric
  kraken_data<- sapply(kraken_data, function(x) as.numeric(as.character(x)))
  #redefine the rownames
  rownames(kraken_data) <- kraken_data_rownames
  
  if (field == "all"){  #subset if field is not equal to "all"
    kraken_data <- kraken_data
    colnames(kraken_data_subset) <- paste0(basecurrency, pricecurrency)
  }else{
    kraken_data <- kraken_data[field,]
  }
  
  return(kraken_data)
}


#Obtain OHLC for a pair of currencies
kraken_OHLC <- function(basecurrency = "XBT", pricecurrency = "USD", interval = "1", start_time, check_pair = TRUE){
  
  #Exit function
  exit <- function() {
    .Internal(.invokeRestart(list(NULL, NULL), NULL))
  }
  
  #Check if our pair of currencies exist
  if(check_pair == TRUE){kraken_check_pair(basecurrency, pricecurrency)}
  
  available_intervals <- c(1, 5, 15, 30, 60, 240, 1440, 10080, 21600)
  if ((interval %in% available_intervals) == FALSE){
    print("Please input one interval among these ones:")
    print(available_intervals)
    exit()
  }
  
  if (hasArg(start_time)){
    #reconvert back to Epoch time
    start_time <- as.numeric(as.POSIXct(start_time))
     url <- paste0("https://api.kraken.com/0/public/OHLC?pair=", basecurrency, pricecurrency, "&interval=", interval, "&since=", start_time)
  } else{
    url <- paste0("https://api.kraken.com/0/public/OHLC?pair=", basecurrency, pricecurrency, "&interval=", interval)
  }
  
  kraken_raw <- GET(url)
  kraken_raw <- rawToChar(kraken_raw$content)
  kraken_raw <- fromJSON(kraken_raw)
  kraken_data <- kraken_raw$result
  
  kraken_data <- kraken_data[[1]]
  kraken_data <- sapply(kraken_data, function(x) as.numeric(as.character(x)))
  kraken_data <- data.frame(matrix(kraken_data, ncol = 8))
  row.names(kraken_data) <- as.POSIXct(kraken_data[,1] , origin="1970-01-01")
  kraken_data <- kraken_data[,-1]
  colnames(kraken_data) <- c("open", "high", "low", "close", "vwap", "volume", "count")
  
  return(kraken_data)

}

#Obtain OrderBook for a pair of currencies
kraken_order_book <- function(basecurrency = "XBT", pricecurrency = "USD", count, check_pair = TRUE){
  
  #Check if our pair of currencies exist
  if(check_pair == TRUE){kraken_check_pair(basecurrency, pricecurrency)}
  
  if (hasArg(count)){
    url <- paste0("https://api.kraken.com/0/public/Depth", "?pair=", basecurrency, pricecurrency, "&count=", count)
  } else{
    url <- paste0("https://api.kraken.com/0/public/Depth", "?pair=", basecurrency, pricecurrency)
  } 
  
  kraken_raw <- GET(url)
  kraken_raw <- rawToChar(kraken_raw$content)
  kraken_raw <- fromJSON(kraken_raw)
  kraken_data <- kraken_raw$result
  
  kraken_asks <- sapply(kraken_data, `[`, 1)
  kraken_bids <- sapply(kraken_data, `[`, 2)
  
  #Names for columns
  kraken_asks_colnames <- c("ask_price", "ask_volume", "ask_time")
  kraken_bids_colnames <- c("bid_price", "bid_volume", "bid_time")
  
  kraken_asks <- data.frame(kraken_asks)
  colnames(kraken_asks) <- kraken_asks_colnames
  kraken_asks[,1:3]<- sapply(kraken_asks[,1:3], function(x) as.numeric(as.character(x)))
  kraken_asks[,3] <- as.POSIXct(kraken_asks[,3], origin="1970-01-01")
  
  kraken_bids <- data.frame(kraken_bids)
  kraken_bids[,1:3]<- sapply(kraken_bids[,1:3], function(x) as.numeric(as.character(x)))
  kraken_bids[,3] <- as.POSIXct(kraken_bids[,3], origin="1970-01-01")
  colnames(kraken_bids) <- kraken_bids_colnames
  
  kraken_data <- list(kraken_asks, kraken_bids)
  names(kraken_data) <- c("ask_orders", "bid_orders")
  return(kraken_data)
}

#Obtain recent trades for a pair of currencies
kraken_recent_trades <- function(basecurrency = "XBT", pricecurrency = "USD", start_time, check_pair = TRUE){
  
  #Check if our pair of currencies exist
  if(check_pair == TRUE){kraken_check_pair(basecurrency, pricecurrency)}
  
  if (hasArg(start_time)){
    #reconvert back to Epoch time
    start_time <- as.numeric(as.POSIXct(start_time))
    url <- paste0("https://api.kraken.com/0/public/Trades?pair=", basecurrency, pricecurrency, "&since=", start_time)
  } else{
    url <- paste0("https://api.kraken.com/0/public/Trades?pair=", basecurrency, pricecurrency)
  }
  
  kraken_raw <- GET(url)
  kraken_raw <- rawToChar(kraken_raw$content)
  kraken_raw <- fromJSON(kraken_raw)
  kraken_data <- kraken_raw$result
  
  
  kraken_data <- kraken_data[[1]]
  kraken_data <- data.frame(matrix(kraken_data, ncol = 6))
  kraken_data[1:3] <- sapply(kraken_data[1:3], function(x) as.numeric(as.character(x)))
  kraken_data[,3]<- as.POSIXct(kraken_data[,3] , origin="1970-01-01")
  colnames(kraken_data) <- c("price", "volume", "time", "buy/sell", "market/limit", "miscellaneous")
  
  return(kraken_data)
}

#Obtain OrderBook for a pair of currencies
kraken_recent_spread<- function(basecurrency = "XBT", pricecurrency = "USD", start_time, check_pair = TRUE){
  
  #Check if our pair of currencies exist
  if(check_pair == TRUE){kraken_check_pair(basecurrency, pricecurrency)}
  
  if (hasArg(start_time)){
    #reconvert back to Epoch time
    start_time <- as.numeric(as.POSIXct(start_time))
    url <- paste0("https://api.kraken.com/0/public/Spread?pair=", basecurrency, pricecurrency, "&since=", start_time)
  } else{
    url <- paste0("https://api.kraken.com/0/public/Spread?pair=", basecurrency, pricecurrency)
  }
  
  kraken_raw <- GET(url)
  kraken_raw <- rawToChar(kraken_raw$content)
  kraken_raw <- fromJSON(kraken_raw)
  kraken_data <- kraken_raw$result
  
  kraken_data <- kraken_data[[1]]
  kraken_data <- data.frame(matrix(kraken_data, ncol = 3))
  kraken_data[1:3] <- sapply(kraken_data[1:3], function(x) as.numeric(as.character(x)))
  kraken_data[,1]<- as.POSIXct(kraken_data[,1] , origin="1970-01-01")
  colnames(kraken_data) <- c("time", "bid", "ask")
  
  return(kraken_data)
}