# Desafio Técnico Onetopia

O objetivo principal desse projeto foi desenvolver um programa que consuma dados de uma API de criptomoedas e os 
armazene em um banco de dados.

## Visão Geral

O projeto coleta dados das **Top 200 criptomoedas** da API do CoinMarketCap a cada 30 minutos, armazena em um banco de
dados PostgreSQL e exibe as informações em um dashboard no Power BI.<br>
**Nota:** CoinMarketCap organiza seu "rank" de top moedas de acordo com valor de mercado (market cap). Logo, podemos 
assumir que usamos o **Top 200 Criptomoedas por Valor de Mercado.**

### Funcionalidades

- Coleta automática de dados a cada 30 minutos via scheduler
- Armazenamento de histórico de preços, valores de mercado, quantidade da moeda circulando, volumes nas últimas 24h 
e valorização/desvalorização nas últimas 24h
- Identificação automática, com atributo no banco, de _stablecoins_
- Identificação automática, com atributo no banco, se a moeda possui ou não fornecimento infinito
- Criação de tabelas e views direto no script em Python (`tables.py`)
- Logging de execução e erros em um arquivo `log.log`
- Dashboard interativa no Power BI

## Pré-requisitos Mínimos

- Python 3.13.0
- PostgreSQL 18.1
- Power BI Desktop
- Chave de API do [CoinMarketCap](https://coinmarketcap.com/api/)

## Uso

### 1. Clone o repositório
```
git clone https://github.com/AxeWalter/teste_onetopia.git
cd teste_onetopia
```

### 2. Instale as dependências
`pip install -r requirements.txt`

### 3. Crie um banco de dados PostgreSQL
Crie um banco de dados no PostgreSQL e salve o seu `usuário`, `senha`, `host` e `porta` para utilizarmos no 
próximo passo. <br>
Não é necessário criar as tabelas, essas serão criadas automaticamente ao rodar `main.py`.

### 4. Crie um `.env` e configure as variáveis de ambiente
Crie um arquivo `.env` na raiz do projeto e defina as seguintes variáveis:
```
API_KEY=
DB_USER=
DB_PASSWORD=
DB_HOST=
DB_PORT=
DB_NAME=
```

### 5. Opcional
O comportamento do script pode ser configurado através de quatro variáveis globais localizadas no início do arquivo
`main.py`. Essas variáveis permitem ajustar o volume de dados e a frequência de atualização da pipeline. Por padrão
eles são definidos como:
```
NUMBER_OF_CRYPTOS = 200  # Quantidade de cryptos extraídas por API call
CURRENCY = "BRL"  # Moeda que será utilizada para os dados da API
SCHEDULE_MINUTES_INTERVAL = 30  # Define de quantos em quantos minutos o script roda.
CHECK_DELAY_FOR_SCHEDULE = 60  # Define de quanto em quanto tempo o script vai checar o tempo para ver se passaram 30m.
```

O padrão é executar a cada 30m e extrair 200 criptomoedas por API call formatadas no Real Brasileiro (BRL).

## Execução
`python main.py`

O script irá:
- Criar as tabelas e views no banco de dados caso não existam
- Chamar a API, coletar e limpar os dados
- Inserir os dados no banco de dados
- Agendar a próxima execução para o que for definido em `SCHEDULE_MINUTES_INTERVAL`

Na primeira execução um arquivo `log.log` será gerado na raiz do projeto para manter os logs de execução. O `filemode`
desse arquivo está definido como `a`, logo, os logs são históricos. Caso deseje logs apenas da última execução, alterar
`logging.basicConfig` em `main.py` para `w`.

## Power BI

### Conexão
1. Abra o arquivo `dashEstrutura.pbit` no Power BI Desktop
2. Inicialmente o arquivo vai carregar apenas a estrutura, sem os dados
3. Siga o caminho **Transformar Dados** → **Configurações da Fonte de Dados**
4. Selecione a conexão e clique em **Alterar Fonte**
5. Inserir o servidor e nome do seu banco de dados PostgreSQL
6. Feche essa janela e clique em **Fechar e Aplicar** para salvar as alterações
7. Power BI vai carregar os dados e automaticamente atualizar as visualizações

### Funcionalidades

**Nota: essa dashboard foi projetada para lidar com dados temporais, logo, para funcionalidade ideal é necessário 
ter um histórico de dados. Visualizações como a variação do valor de mercado só funcionarão com dados históricos.**
- Barra superior com informações globais como:
  - Valor de mercado atual agregado (top 200)
  - Variação desse valor de mercado nos últimos 30m
  - Volume total nas últimas 24h
  - Preço atual da Bitcoin em Real
  - Preço atual da Ethereum em Real
  - Criptomoeda com maior valorização nas últimas 24h
  - Criptomoeda com maior desvalorização nas últimas 24h
- Gráfico com últimos 5 valores de mercado agregados
- Gráfico de dominância de mercado, mostrando a porcentagem de valor de mercado das top 10 criptomoedas e agregando as
demais como _Others_ (considera da 11-200)
- Gráfico das 5 maiores valorizações nas últimas 24h
- Gráfico das 5 maiores desvalorizações nas últimas 24h
- Gráfico de histórico de preço filtrado por criptomoeda e período

**Limitação Conhecida**: o _slicer_ de período utilizado para filtrar o gráfico de histórico utiliza horário UTC por
padrão. Logo, considerando GMT-3 (Brasil), o slicer sempre parte de 3h na frente. Para ter precisão, sempre adicione
3h a mais no horário desejado.

## Dependências
```
python-dotenv==1.0.1
requests==2.32.3
schedule==1.2.2
SQLAlchemy==2.0.36
psycopg2==2.9.11
```




