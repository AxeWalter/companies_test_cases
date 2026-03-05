from requests import Session
from requests.exceptions import ConnectionError, Timeout, TooManyRedirects
import os
from dotenv import load_dotenv

load_dotenv()
API_KEY = os.getenv("API_KEY")


# Para alterar a quantidade de Cryptos extraídas, modificar o parâmetro total_number_of_cryptos
# Para alterar a moeda, alterar a abreviação BRL para moeda desejada (por exemplo, USD para dólar)
def request_api(total_number_of_cryptos, currency):
    url = "https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest"
    parameters = {
        "start": '1',
        "limit": total_number_of_cryptos,
        "convert": currency
    }
    headers = {
        "Accepts": "application/json",
        "X-CMC_PRO_API_KEY": API_KEY,
    }

    session = Session()
    session.headers.update(headers)

    try:
        response = session.get(url, params=parameters)
        return response.json()["data"]
    except (ConnectionError, Timeout, TooManyRedirects) as e:
        print(f"Error: {e}")
        return None

