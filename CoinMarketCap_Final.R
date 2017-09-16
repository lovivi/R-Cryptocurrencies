# === API Data - CoinMarketCap =========
# ====== built by Etienne Mirland ======

library(httr) ; library(jsonlite) ;library(xts)

coinmarketcap_ticker <- function(basecurrency = "bitcoin", pricecurrency = "USD", field = "all"){
  
  basecurrency <- tolower(basecurrency)
  pricecurrency <- tolower(pricecurrency)

  url  <- paste0("https://api.coinmarketcap.com/v1/ticker/", basecurrency, "/?convert=", pricecurrency)
  marketlive_data_raw <- GET(url)
  marketlive_data_raw <- rawToChar(marketlive_data_raw$content)
  marketlive_data <- fromJSON(marketlive_data_raw)


  #Exit function
  exit <- function() {
    .Internal(.invokeRestart(list(NULL, NULL), NULL))
  }
  
  #Define the available fields
  available_fields <- c("all", "id", "name", "symbol", "rank", "price_usd", "price_btc" , "24h_volume_usd",
                        "market_cap_usd", "available_supply", "total_supply", "percent_change_1h", "percent_change_24h", 
                        "percent_change_7d","last_updated", paste0("price_",pricecurrency), 
                        paste0("24_h_volume_",pricecurrency), paste0("market_cap_", pricecurrency))
  
  
  #Check if the price currency exists (and not USD)
  if (pricecurrency != "usd"){
    if (ncol(marketlive_data) != (length(available_fields) - 1)){ #we add -1 as the first available field is "all"
      print(paste0(pricecurrency, " is not a supported currency."))
      print("Please input another currency such as JPY, EUR or USD")
      exit()
    }
  }
  #Check if the price currency exists
  if (field %in% available_fields == FALSE){
    print("This field is not available. Available fields are:")
    print(available_fields)
    exit()
  }
  
  
  #convert as numeric all fields that are numeric and the last updated column as POSIX
  marketlive_data[-c(1:3)] <- sapply(marketlive_data[-c(1:3)], function(x) as.numeric(as.character(x)))
  marketlive_data[,"last_updated"] <- as.POSIXct(marketlive_data[,"last_updated"], origin="1970-01-01")
  
                    
  if (field == "all"){  #subset if field equalsto "all"
    market_live_data_subset <- marketlive_data
  }else{
    market_live_data_subset <- marketlive_data[, field]
  }

  print(market_live_data_subset)
  
}

#V2

library(httr)
library(jsonlite)
library(xts)

coinmarketcap_global <- function(pricecurrency = "USD", field = "all", limit = 100){
  
  pricecurrency <- tolower(pricecurrency)
  
  url  <- paste0("https://api.coinmarketcap.com/v1/ticker/?convert=", pricecurrency, "&limit=", limit)
  marketlive_data_raw <- GET(url)
  marketlive_data_raw <- rawToChar(marketlive_data_raw$content)
  marketlive_data <- fromJSON(marketlive_data_raw)
  
  rownames(marketlive_data) <- make.names(marketlive_data$name, unique = TRUE)
  #Exit function
  exit <- function() {
    .Internal(.invokeRestart(list(NULL, NULL), NULL))
  }
  
  #Define the available fields
  available_fields <- c("all", "id", "name", "symbol", "rank", "price_usd", "price_btc" , "24h_volume_usd",
                        "market_cap_usd", "available_supply", "total_supply", "percent_change_1h", "percent_change_24h", 
                        "percent_change_7d","last_updated", paste0("price_",pricecurrency), 
                        paste0("24_h_volume_",pricecurrency), paste0("market_cap_", pricecurrency))
  
  
  #Check if the price currency exists (and not USD)
  if (pricecurrency != "usd"){
    if (ncol(marketlive_data) != (length(available_fields) - 1)){ #we add -1 as the first available field is "all"
      print(paste0(pricecurrency, " is not a supported currency."))
      print("Please input another currency such as JPY, EUR or USD")
      exit()
    }
  }
  #Check if the price currency exists
  if (field %in% available_fields == FALSE){
    print("This field is not available. Available fields are:")
    print(available_fields)
    exit()
  }
  
  
  #convert as numeric all fields that are numeric and the last updated column as POSIX
  marketlive_data[-c(1:3)] <- sapply(marketlive_data[-c(1:3)], function(x) as.numeric(as.character(x)))
  marketlive_data[,"last_updated"] <- as.POSIXct(marketlive_data[,"last_updated"], origin="1970-01-01")
  
  if (field == "all"){  #subset if field equals to "all"
    market_live_data_subset <- marketlive_data
  }else{
    market_live_data_subset <- data.frame(marketlive_data[, field], row.names = marketlive_data$name)
    colnames(market_live_data_subset) <- field
  }
  
  print(market_live_data_subset)
  
}