# R-Cryptocurrencies

The purpose of this project is to create several functions in R, easy-to use for a beginner, using some APIs for cryptocurrencies.
As of September 16th 2017, two APIs were used: CoinMarketCap and Kraken.

## Getting Started

### Prerequisites

You need to have two packages installed in R.
```
JSON
httr
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
## Authors

* **Etienne Mirland** - *Initial work* - 


## Acknowledgments

* Thanks to Kraken and CoinMarketCap for providing very useful APIs

