from conexaoAPI import request_api
from extracao import parsing_data
from db_configs.data_manipulation import insert_all
from db_configs.connection import Base, engine
import logging
import schedule
import time


logging.basicConfig(level=logging.INFO, filename="log.log", filemode="a",
                    format="%(asctime)s - %(levelname)s - %(message)s")


NUMBER_OF_CRYPTOS = 200  # Define quantas cryptos serão extraídas via API. 200 cryptos = 1 token da API.
CURRENCY = "BRL"  # Define qual moeda será utilizada para os dados da API. Padrão é dólar USD.
SCHEDULE_MINUTES_INTERVAL = 30  # Define de quantos em quantos minutos o script roda.
CHECK_DELAY_FOR_SCHEDULE = 60  # Define de quanto em quanto tempo o script vai checar o tempo para ver se passaram 30m.


def main():
    try:
        Base.metadata.create_all(bind=engine)

        logging.info("Iniciando coleta de dados da API...")
        api_data = request_api(NUMBER_OF_CRYPTOS, CURRENCY)
        logging.info(f"{len(api_data)} coletados com sucesso!")

        logging.info("Iniciando limpeza dos dados...")
        clean_data = parsing_data(api_data)
        logging.info("Dados limpos com sucesso!")

        logging.info("Iniciando insercao de dados no Banco...")
        insert_all(clean_data)
        logging.info("Dados inseridos com sucesso!")

    except Exception as e:
        logging.error(e, exc_info=True)

    finally:
        logging.info("-" * 50)


if __name__ == '__main__':
    main()
    schedule.every(SCHEDULE_MINUTES_INTERVAL).minutes.do(main)

    while True:
        schedule.run_pending()
        time.sleep(CHECK_DELAY_FOR_SCHEDULE)