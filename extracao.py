import json
import os
from datetime import datetime, timedelta
from conexaoAPI import request_api


def transform_data(raw_data, currency="BRL"):
    final_data = []

    for coin in raw_data:
        date = datetime.strptime(coin["quote"][currency]["last_updated"], "%Y-%m-%dT%H:%M:%S.%fZ")
        date_gmt3 = date - timedelta(hours=3)
        final_date = date_gmt3.strftime("%d/%m/%Y %H:%M:%S")

        coin_dict = {
            "name": coin["name"],
            "symbol": coin["symbol"],
            "rank": coin["cmc_rank"],
            "max_supply": coin["max_supply"],
            "circulating_supply": coin["circulating_supply"],
            "infinite_supply": coin["infinite_supply"],
            "price": coin["quote"][currency]["price"],
            "market_cap": coin["quote"][currency]["market_cap"],
            "percent_change_24h": coin["quote"][currency]["percent_change_24h"],
            "volume_24h": coin["quote"][currency]["volume_24h"],
            "timestamp": final_date
        }
        final_data.append(coin_dict)

    return final_data


data = request_api(100, "BRL")
full_data = transform_data(data)
print(json.dumps(full_data, indent=4))

