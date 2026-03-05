from sqlalchemy import Column, String, Integer, Boolean, ForeignKey, Numeric, DateTime, event, DDL
from db_configs.connection import Base


class Cryptos(Base):
    __tablename__ = 'cryptos'

    id = Column(Integer, primary_key=True)
    name = Column(String(255), nullable=False)
    symbol = Column(String(255))
    infinite_supply = Column(Boolean)
    is_stablecoin = Column(Boolean, default=False)
    max_supply = Column(Numeric(20,2)) # Há algumas coins com frações de supply.


class Monitoring(Base):
    __tablename__ = 'monitoring'

    # Os números de precisão parecem aleatórios, mas há um motivo. Usar 20 como máximo de precisão vem do fato que
    # em vários testes o manior número de casas decimais foi 20. Price usa 18 de escala pois há algumas "memecoins" que
    # chegam a 18 casas decimais após a vírgula (por isso o aumento no total de dígitos também). Os demais que usam 2 é
    # devido ao fato que as casas decimais não são tão relevantes.

    id = Column(Integer, primary_key=True)
    crypto_id = Column(Integer, ForeignKey('cryptos.id'))
    price = Column(Numeric(36,18), nullable=False)
    rank = Column(Integer)
    circulating_supply = Column(Numeric(20,2))
    market_cap = Column(Numeric(20,2))
    volume_24h = Column(Numeric(20,2))
    percent_change_24h = Column(Numeric(20,2)) # Uma moeda conseguiu quebrar 10, 2 : )
    timestamp = Column(DateTime, nullable=False)


total_mkt_cap_view = DDL ("""
    CREATE OR REPLACE VIEW total_mkt_cap_view AS
    SELECT SUM(market_cap) AS total_mkt_cap, timestamp
    FROM monitoring
    GROUP BY timestamp;
""")

total_volume_24h_view = DDL("""
    CREATE OR REPLACE VIEW total_volume_24h_view AS
    SELECT SUM(volume_24h) AS total_volume_24h, timestamp
    FROM monitoring
    GROUP BY timestamp;
""")

biggest_winner_view = DDL ("""
    CREATE OR REPLACE VIEW biggest_winner_view AS
    SELECT 
        cryptos.name,
        cryptos.symbol,
        monitoring.percent_change_24h,
        monitoring.timestamp
    FROM monitoring
    JOIN cryptos ON cryptos.id = monitoring.crypto_id
    WHERE monitoring.percent_change_24h = (
        SELECT MAX(percent_change_24h) FROM monitoring m2 WHERE m2.timestamp = monitoring.timestamp
    );
""")

biggest_loser_view = DDL ("""
    CREATE OR REPLACE VIEW biggest_loser_view AS
    SELECT 
        cryptos.name,
        cryptos.symbol,
        monitoring.percent_change_24h,
        monitoring.timestamp
    FROM monitoring
    JOIN cryptos ON cryptos.id = monitoring.crypto_id
    WHERE monitoring.percent_change_24h = (
        SELECT MIN(percent_change_24h) FROM monitoring m2 WHERE m2.timestamp = monitoring.timestamp
    );
""")

market_cap_dominance = DDL ("""
    CREATE OR REPLACE VIEW market_cap_dominance AS
    SELECT * FROM (
        SELECT
            cryptos.name,
            cryptos.symbol,
            monitoring.rank,
            monitoring.market_cap
        FROM cryptos
        JOIN monitoring ON cryptos.id = monitoring.crypto_id
        WHERE monitoring.timestamp = (SELECT MAX(timestamp) FROM monitoring)
        ORDER BY monitoring.rank
        LIMIT 10
    ) top10
        
    
    UNION ALL
    
    SELECT 
        'Others' AS name,
        'Others' AS symbol,
        NULL AS rank,
        SUM(market_cap) AS market_cap
    FROM monitoring
    WHERE rank > 10 AND timestamp = (SELECT MAX(timestamp) FROM monitoring);
""")

event.listen(Base.metadata, "after_create", total_mkt_cap_view)
event.listen(Base.metadata, "after_create", total_volume_24h_view)
event.listen(Base.metadata, "after_create", biggest_winner_view)
event.listen(Base.metadata, "after_create", biggest_loser_view)
event.listen(Base.metadata, "after_create", market_cap_dominance)


