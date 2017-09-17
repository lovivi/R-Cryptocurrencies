# R-Cryptocurrencies

The purpose of this project is to create several functions in R, easy-to use, using some APIs for cryptocurrencies.
As of September 16th 2017, two APIs are being used: CoinMarketCap and Kraken.

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

### Kraken's public API
#### kraken_currency_list()
This function retrieves the list of currencies supported by Kraken.
No argument.

#### kraken_live()
This function retrieves several indicators (e.g. ask price, bid price, 24-h volume) for a pair of currencies (e.g. ETH/EUR).
Four arguments: basecurrency, pricecurrency, field, check_pair (enables us to check if the two currencies are supported by Kraken).

```
kraken_live(basecurrency = "XBT", pricecurrency = "EUR", field = "all", check_pair = FALSE)
kraken_live(basecurrency = "ETH", pricecurrency = "EUR", field = "ask_price")
```
#### kraken_OHLC()
This function retrieves OHLC + Volume for a pair of currencies.
Five arguments: basecurrency, pricecurrency, interval (in minutes), start_time, check_pair.

```
kraken_OHLC(basecurrency = "XBT", pricecurrency = "USD", interval = "1")
kraken_OHLC(basecurrency = "EOS", pricecurrency = "XBT", interval = "1", check_pair = FALSE)
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
## Authors

* **Etienne Mirland** 

## Acknowledgments

* Thanks a lot to Kraken and CoinMarketCap for providing very useful APIs
* Kraken API: https://www.kraken.com/help/api
* CoinMarketCap API: https://coinmarketcap.com/api/

