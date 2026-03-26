from db_configs.connection import Session
from db_configs.tables import Cryptos, Monitoring


def insert_crypto(session, coin):
    crypto = session.query(Cryptos).filter_by(id=coin['id']).first()

    if not crypto:
        crypto = Cryptos(
            id=coin['id'],
            name=coin["name"],
            symbol=coin["symbol"],
            infinite_supply=coin["infinite_supply"],
            is_stablecoin=coin["is_stablecoin"],
            max_supply=coin["max_supply"],
        )
        session.add(crypto)
        session.flush()
    else:
        if crypto.infinite_supply != coin["infinite_supply"]:
            crypto.infinite_supply = coin["infinite_supply"]

        if crypto.is_stablecoin != coin["is_stablecoin"]:
            crypto.is_stablecoin = coin["is_stablecoin"]

        if (crypto.max_supply is None) != (coin["max_supply"] is None):
            crypto.max_supply = coin["max_supply"]
        # O round foi necessário pois usamos 2 casas no banco. Tentei inúmeras formas, mesmo com ambos sendo floats
        # sempre dava algum erro e alguns valores identicos davam triger na condição. Assim funcionou nos testes.
        # Ideal é escrever alguns testes com valores arredondados e testar melhor.
        elif coin["max_supply"] is not None and round(float(crypto.max_supply), 2) != round(float(coin["max_supply"]), 2):
            crypto.max_supply = coin["max_supply"]

    return crypto.id


def insert_monitoring(session, crypto_id, coin):
    monitoring = Monitoring(
        crypto_id=crypto_id,
        price=coin["price"],
        rank=coin["rank"],
        circulating_supply=coin["circulating_supply"],
        market_cap=coin["market_cap"],
        volume_24h=coin["volume_24h"],
        percent_change_24h=coin["percent_change_24h"],
        timestamp=coin["timestamp"],
    )
    session.add(monitoring)


def insert_all(data):
    with Session() as session:
        for coin in data:
            crypto_id = insert_crypto(session, coin)
            insert_monitoring(session, crypto_id, coin)

        session.commit()