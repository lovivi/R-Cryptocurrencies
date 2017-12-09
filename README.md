# R-Cryptocurrencies

The purpose of this project is to create several functions in R, easy-to use, using some public APIs for cryptocurrencies.
As of September 16th 2017, two public APIs are being used: CoinMarketCap and Kraken.

In December 2017, a third API will be fully supported: Binance.

## Getting Started

### Prerequisites

You need to have two packages installed in R: JSON and httr.
```
library(JSON)
library(httr)
```

## Functions
### CoinMarketCap's API
#### coinmarketcap_ticker()
This function retrieves several indicators for a pair of currencies.
Three arguments: basecurrency, pricecurrency, field.

```
coinmarketcap_ticker(basecurrency = "bitcoin", pricecurrency = "EUR", field = "all")
coinmarketcap_ticker("NEO", "EUR", field = "total_supply")
```

#### coinmarketcap_global()
This function retrieves several indicators for all currencies listed on CoinMarketCap.com (more than 1300 currencies).
Three arguments: pricecurrency, field, limit.

```
coinmarketcap_global(pricecurrency = "EUR", field = "all", limit = 200)
coinmarketcap_global(pricecurrency ="JPY", field = "total_supply", limit = 50)
```

---------------------------------------


![alt text](http://bitcoinx.com/wp-content/uploads/2014/02/Kraken.jpg)
### Kraken's public API
#### kraken_currency_list()
This function retrieves the list of currencies supported by Kraken.
No argument.

#### kraken_live()
This function retrieves several indicators (e.g. ask price, bid price, 24-h volume) for a pair of currencies (e.g. ETH/EUR).
Four arguments: basecurrency, pricecurrency, field, check_pair (enables the user to check if both currencies are supported by Kraken).

```
kraken_live(basecurrency = "XBT", pricecurrency = "EUR", field = "all", check_pair = FALSE)
kraken_live(basecurrency = "ETH", pricecurrency = "EUR", field = "ask_price")
```
#### kraken_OHLC()
This function retrieves OHLC + Volume for a pair of currencies.
Five arguments: basecurrency, pricecurrency, interval (in minutes), start_time, check_pair.

```
kraken_OHLC(basecurrency = "XBT", pricecurrency = "USD", interval = 1)
kraken_OHLC("EOS", "XBT", interval = 1, check_pair = FALSE)
```
#### kraken_order_book()
This function retrieves the order book for a pair of currencies and results in a list with two dataframes (ask and bid).
Four arguments: basecurrency, pricecurrency, order (the maximum amount of orders to retrieve), check_pair.
```
kraken_order_book(basecurrency = "XBT", pricecurrency = "USD")
kraken_order_book(basecurrency = "XBT", pricecurrency = "USD", order = 10)
```

#### kraken_recent_trades()
This function retrieves the latest trades for a pair of currencies.
Four arguments: basecurrency, pricecurrency, start_time, check_pair.
```
kraken_recent_trades(basecurrency = "ETH", pricecurrency = "USD", start_time = "2017-09-14 13:00")
kraken_recent_trades(basecurrency = "ETH", pricecurrency = "XBT", check_pair = FALSE)
```

#### kraken_recent_spread()
This function retrieves the latest spread for a pair of currencies.
Four arguments: basecurrency, pricecurrency, start_time, check_pair.
```
kraken_recent_spread(basecurrency = "XBT", pricecurrency = "USD", check_pair = TRUE)
kraken_recent_spread("ETH", "EUR", "2017-09-14 13:00", FALSE)
```

---------------------------------------


![alt text](https://p13.zdassets.com/hc/settings_assets/1938355/115000012391/vDJ3jjZnVdU1CzsxaiuY6w-logo-en_svg-01.svg)

### Binance's public API - Beta
#### binance_server_time()
This function retrieves the server time.

#### binance_order_book_ticker()
This function retrieves the complete order book for a specific pair.
Two arguments: symbol, limit.
Limit must be inferior to 100.

The output is a list with two elements: ask_orders and bid_orders.

```
binance_order_book_ticker("BTCUSDT", limit = 100) 
binance_order_book_ticker("WTCETH", 20) 
```
#### binance_trade_list() 
This function retrieves aggregate trades list for a specific pair. <br />
Four arguments: symbol, fromId, start_time, end_time, limit.<br />
If both start_time and end_time are inputed, limit and fromId should not be sent. Furthermore the distance between startTime and endTime must be less than 24 hours. <br />
If fromId is inputed, don't input start_time or end_time. However you must input the limit parameter.

```
binance_trade_list("WTCBTC", start_time = "2017/11/10 06:00", end_time = "2017/11/10 07:00")
binance_trade_list("LRCETH", limit = 100)
binance_trade_list("WTCBTC", fromId = "543120", limit = 50)
```

#### binance_OHLC()
This function retrieves OHLC and other specific information such as volume for a specific pair.<br />
Five arguments: symbol, interval, limit, start_time, end_time.<br />
If both start_time and end_time are sent, limit should not be sent.<br />

```
binance_OHLC("WTCBTC", interval = "5m", limit = 100)
binance_OHLC("WTCETH", interval = "1m", start_time = "2017-11-28 09:00:00", end_time =  "2017-11-28 10:00:00")
```
#### binance_24h_ticker_data()
This function retrieves 24-hour data for a specific pair.
One argument: symbol.
```
binance_24h_ticker_data("WTCBTC")
```
#### binance_current_price()
This function retrieves latest market prices for all traded pairs.
No argument.
```
binance_current_price()
```

#### binance_traded_symbols()
This function retrieves names of all traded pairs.
No argument.
```
binance_traded_symbols()
```
#### binance_best_order_book_all()
This function retrieves the narrowest ask/bid for all traded pairs.
No argument.
```
binance_best_order_book_all()
```

## Authors

* **Etienne Mirland**  // Contact me: etienne.mirland (at) ieseg.fr
## Acknowledgments

* Thanks a lot to CoinMarketCap, Kraken and Binance for providing very useful APIs
* CoinMarketCap API: https://coinmarketcap.com/api/
* Kraken API: https://www.kraken.com/help/api
* Binance API: https://www.binance.com/restapipub.html 
