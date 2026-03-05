from conexaoAPI import request_api
from extracao import parsing_data
from db_configs.data_manipulation import insert_all





def main():
    number_of_cryptos = 200  # 200 cryptos = 1 token da API
    currency = "BRL"
    api_data = request_api(number_of_cryptos, "BRL")

    clean_data = parsing_data(api_data)

    insert_all(clean_data)





if __name__ == '__main__':
    main()