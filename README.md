# R-Cryptocurrencies

The purpose of this project was to make several functions, easy-to use for a beginner, using some APIs for cryptocurrencies.

As of September 16th 2017, two APIs were used: CoinMarketCap and Kraken.

## Getting Started

You will need 

### Prerequisites

You need to have these two packages installed in R.

```
JSON
httr
```

## Functions
#### coinmarketcap_ticker()
This function allows to retrieve several indicators for a pair of currencies.
Three arguments: basecurrency, pricecurrency, field.

```
coinmarketcap_ticker("bitcoin", "EUR", field = "all")
coinmarketcap_ticker("NEO", "EUR", field = "total_supply")
```

#### coinmarketcap_global()
This function allows to retrieve several indicators for all currencies listed on CoinMarketCap.com (more than 1300 currencies).
Three arguments: pricecurrency, field, limit.

```
coinmarketcap_global("EUR", field = "all", limit = 200)
coinmarketcap_global("JPY", field = "total_supply", limit = 50)
```
## Authors

* **Etienne Mirland** - *Initial work* - 


## Acknowledgments

* Thanks to Kraken and CoinMarketCap for providing very useful APis

