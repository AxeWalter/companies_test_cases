-- Alguns INDEX para melhorar a performance

CREATE INDEX idx_km_chave_valor ON km (Chave, KM);
CREATE INDEX idx_imposto_chave_valor ON imposto (Chave, Aliquota);

-- Exercício 1. Utilizando como chave principal a junção do UF de origem e UF de destino, desenvolva uma query trazendo a distância entre ambos estados seguindo modelo do Excel. 

SELECT 
    compra.*, 
    (SELECT MAX(KM) FROM km WHERE Chave = CONCAT(compra.UFOrigem, 'SP')) AS KM_PARA_SP,
    (SELECT MAX(KM) FROM km WHERE Chave = CONCAT(compra.UFOrigem, 'MG')) AS KM_PARA_MG,
    (SELECT MAX(KM) FROM km WHERE Chave = CONCAT(compra.UFOrigem, 'ES')) AS KM_PARA_ES,
    (SELECT MAX(KM) FROM km WHERE Chave = CONCAT(compra.UFOrigem, 'SC')) AS KM_PARA_SC,
    (SELECT MAX(KM) FROM km WHERE Chave = CONCAT(compra.UFOrigem, 'RJ')) AS KM_PARA_RJ,
    (SELECT MAX(KM) FROM km WHERE Chave = CONCAT(compra.UFOrigem, 'PR')) AS KM_PARA_PR,
    (SELECT MAX(KM) FROM km WHERE Chave = CONCAT(compra.UFOrigem, 'AM')) AS KM_PARA_AM
FROM compra;


-- Exercício 2. Utilizando o mesmo método da tarefa 1, desenvolva uma query que traga como resultado a alíquota entre ambos estados seguindo modelo do Excel. 
-- Essa query poderia ser ignorada pois as alíquotas são todas 0.
SELECT 
    compra.*, 
    (SELECT MAX(Aliquota) FROM imposto WHERE Chave = CONCAT(compra.UFOrigem, 'SP')) AS Aliquota_SP,
    (SELECT MAX(Aliquota) FROM imposto WHERE Chave = CONCAT(compra.UFOrigem, 'MG')) AS Aliquota_MG,
    (SELECT MAX(Aliquota) FROM imposto WHERE Chave = CONCAT(compra.UFOrigem, 'ES')) AS Aliquota_ES,
    (SELECT MAX(Aliquota) FROM imposto WHERE Chave = CONCAT(compra.UFOrigem, 'SC')) AS Aliquota_SC,
    (SELECT MAX(Aliquota) FROM imposto WHERE Chave = CONCAT(compra.UFOrigem, 'RJ')) AS Aliquota_RJ,
    (SELECT MAX(Aliquota) FROM imposto WHERE Chave = CONCAT(compra.UFOrigem, 'PR')) AS Aliquota_PR,
    (SELECT MAX(Aliquota) FROM imposto WHERE Chave = CONCAT(compra.UFOrigem, 'AM')) AS Aliquota_AM
FROM compra;

-- Exercício 3. Desenvolva uma query para calcular o valor bruto utilizando através da seguinte fórmula: (valor liquido + KM * 0,1) / (1 – alíquota da UF) seguindo modelo do Excel. 


SELECT 
	compra.*,
	((compra.ValorLiquido + (SELECT MAX(KM) FROM km WHERE Chave = CONCAT(compra.UFOrigem, 'SP')) * 0.1) / (1 - (SELECT MAX(Aliquota) FROM imposto WHERE Chave = CONCAT(compra.UFOrigem, 'SP')))) AS Bruto_Para_SP,
	((compra.ValorLiquido + (SELECT MAX(KM) FROM km WHERE Chave = CONCAT(compra.UFOrigem, 'MG')) * 0.1) / (1 - (SELECT MAX(Aliquota) FROM imposto WHERE Chave = CONCAT(compra.UFOrigem, 'MG')))) AS Bruto_Para_MG,
	((compra.ValorLiquido + (SELECT MAX(KM) FROM km WHERE Chave = CONCAT(compra.UFOrigem, 'ES')) * 0.1) / (1 - (SELECT MAX(Aliquota) FROM imposto WHERE Chave = CONCAT(compra.UFOrigem, 'ES')))) AS Bruto_Para_ES,
	((compra.ValorLiquido + (SELECT MAX(KM) FROM km WHERE Chave = CONCAT(compra.UFOrigem, 'SC')) * 0.1) / (1 - (SELECT MAX(Aliquota) FROM imposto WHERE Chave = CONCAT(compra.UFOrigem, 'SC')))) AS Bruto_Para_SC,
	((compra.ValorLiquido + (SELECT MAX(KM) FROM km WHERE Chave = CONCAT(compra.UFOrigem, 'RJ')) * 0.1) / (1 - (SELECT MAX(Aliquota) FROM imposto WHERE Chave = CONCAT(compra.UFOrigem, 'RJ')))) AS Bruto_Para_RJ,
	((compra.ValorLiquido + (SELECT MAX(KM) FROM km WHERE Chave = CONCAT(compra.UFOrigem, 'PR')) * 0.1) / (1 - (SELECT MAX(Aliquota) FROM imposto WHERE Chave = CONCAT(compra.UFOrigem, 'PR')))) AS Bruto_Para_PR,
	((compra.ValorLiquido + (SELECT MAX(KM) FROM km WHERE Chave = CONCAT(compra.UFOrigem, 'AM')) * 0.1) / (1 - (SELECT MAX(Aliquota) FROM imposto WHERE Chave = CONCAT(compra.UFOrigem, 'AM')))) AS Bruto_Para_AM
FROM compra;


-- Exercício 4. Desenvolva uma query que traga as tarefas 1, 2 e 3 juntas seguindo modelo do Excel. 

SELECT 
    compra.*, 
    (SELECT MAX(KM) FROM km WHERE Chave = CONCAT(compra.UFOrigem, 'SP')) AS KM_PARA_SP,
    (SELECT MAX(KM) FROM km WHERE Chave = CONCAT(compra.UFOrigem, 'MG')) AS KM_PARA_MG,
    (SELECT MAX(KM) FROM km WHERE Chave = CONCAT(compra.UFOrigem, 'ES')) AS KM_PARA_ES,
    (SELECT MAX(KM) FROM km WHERE Chave = CONCAT(compra.UFOrigem, 'SC')) AS KM_PARA_SC,
    (SELECT MAX(KM) FROM km WHERE Chave = CONCAT(compra.UFOrigem, 'RJ')) AS KM_PARA_RJ,
    (SELECT MAX(KM) FROM km WHERE Chave = CONCAT(compra.UFOrigem, 'PR')) AS KM_PARA_PR,
    (SELECT MAX(KM) FROM km WHERE Chave = CONCAT(compra.UFOrigem, 'AM')) AS KM_PARA_AM,
    (SELECT MAX(Aliquota) FROM imposto WHERE Chave = CONCAT(compra.UFOrigem, 'SP')) AS Aliquota_SP,
    (SELECT MAX(Aliquota) FROM imposto WHERE Chave = CONCAT(compra.UFOrigem, 'MG')) AS Aliquota_MG,
    (SELECT MAX(Aliquota) FROM imposto WHERE Chave = CONCAT(compra.UFOrigem, 'ES')) AS Aliquota_ES,
    (SELECT MAX(Aliquota) FROM imposto WHERE Chave = CONCAT(compra.UFOrigem, 'SC')) AS Aliquota_SC,
    (SELECT MAX(Aliquota) FROM imposto WHERE Chave = CONCAT(compra.UFOrigem, 'RJ')) AS Aliquota_RJ,
    (SELECT MAX(Aliquota) FROM imposto WHERE Chave = CONCAT(compra.UFOrigem, 'PR')) AS Aliquota_PR,
    (SELECT MAX(Aliquota) FROM imposto WHERE Chave = CONCAT(compra.UFOrigem, 'AM')) AS Aliquota_AM,
    ((compra.ValorLiquido + (SELECT MAX(KM) FROM km WHERE Chave = CONCAT(compra.UFOrigem, 'SP')) * 0.1) / (1 - (SELECT MAX(Aliquota) FROM imposto WHERE Chave = CONCAT(compra.UFOrigem, 'SP')))) AS Bruto_Para_SP,
	((compra.ValorLiquido + (SELECT MAX(KM) FROM km WHERE Chave = CONCAT(compra.UFOrigem, 'MG')) * 0.1) / (1 - (SELECT MAX(Aliquota) FROM imposto WHERE Chave = CONCAT(compra.UFOrigem, 'MG')))) AS Bruto_Para_MG,
	((compra.ValorLiquido + (SELECT MAX(KM) FROM km WHERE Chave = CONCAT(compra.UFOrigem, 'ES')) * 0.1) / (1 - (SELECT MAX(Aliquota) FROM imposto WHERE Chave = CONCAT(compra.UFOrigem, 'ES')))) AS Bruto_Para_ES,
	((compra.ValorLiquido + (SELECT MAX(KM) FROM km WHERE Chave = CONCAT(compra.UFOrigem, 'SC')) * 0.1) / (1 - (SELECT MAX(Aliquota) FROM imposto WHERE Chave = CONCAT(compra.UFOrigem, 'SC')))) AS Bruto_Para_SC,
	((compra.ValorLiquido + (SELECT MAX(KM) FROM km WHERE Chave = CONCAT(compra.UFOrigem, 'RJ')) * 0.1) / (1 - (SELECT MAX(Aliquota) FROM imposto WHERE Chave = CONCAT(compra.UFOrigem, 'RJ')))) AS Bruto_Para_RJ,
	((compra.ValorLiquido + (SELECT MAX(KM) FROM km WHERE Chave = CONCAT(compra.UFOrigem, 'PR')) * 0.1) / (1 - (SELECT MAX(Aliquota) FROM imposto WHERE Chave = CONCAT(compra.UFOrigem, 'PR')))) AS Bruto_Para_PR,
	((compra.ValorLiquido + (SELECT MAX(KM) FROM km WHERE Chave = CONCAT(compra.UFOrigem, 'AM')) * 0.1) / (1 - (SELECT MAX(Aliquota) FROM imposto WHERE Chave = CONCAT(compra.UFOrigem, 'AM')))) AS Bruto_Para_AM
FROM compra;

-- Exerício 5: Criar uma tabela com nome “total” e com as colunas “total SP”, “total MG”, “total ES”, “total SC”, “total RJ”, “total PR” e “total AM”. 


CREATE TABLE total (
	`total_SP` DECIMAL(15,2),
	`total_MG` DECIMAL(15,2),
	`total_ES` DECIMAL(15,2),
	`total_SC` DECIMAL(15,2),
	`total_RJ` DECIMAL(15,2),
	`total_PR` DECIMAL(15,2),
	`total_AM` DECIMAL(15,2)
);

-- Para testes!!!
-- DROP TABLE total;

-- Exercício 5: Criar query para preencher as colunas criadas na tarefa 5 com a soma dos valores brutos de cada estado calculados na tarefa 4. 

INSERT INTO total (`total_SP`, `total_MG`, `total_ES`, `total_SC`, `total_RJ`, `total_PR`, `total_AM`)
SELECT
    SUM(total.Bruto_Para_SP),
    SUM(total.Bruto_Para_MG),
    SUM(total.Bruto_Para_ES),
    SUM(total.Bruto_Para_SC),
    SUM(total.Bruto_Para_RJ),
    SUM(total.Bruto_Para_PR),
    SUM(total.Bruto_Para_AM)
FROM (
    SELECT 
	((compra.ValorLiquido + (SELECT MAX(KM) FROM km WHERE Chave = CONCAT(compra.UFOrigem, 'SP')) * 0.1) / (1 - (SELECT MAX(Aliquota) FROM imposto WHERE Chave = CONCAT(compra.UFOrigem, 'SP')))) AS Bruto_Para_SP,
	((compra.ValorLiquido + (SELECT MAX(KM) FROM km WHERE Chave = CONCAT(compra.UFOrigem, 'MG')) * 0.1) / (1 - (SELECT MAX(Aliquota) FROM imposto WHERE Chave = CONCAT(compra.UFOrigem, 'MG')))) AS Bruto_Para_MG,
	((compra.ValorLiquido + (SELECT MAX(KM) FROM km WHERE Chave = CONCAT(compra.UFOrigem, 'ES')) * 0.1) / (1 - (SELECT MAX(Aliquota) FROM imposto WHERE Chave = CONCAT(compra.UFOrigem, 'ES')))) AS Bruto_Para_ES,
	((compra.ValorLiquido + (SELECT MAX(KM) FROM km WHERE Chave = CONCAT(compra.UFOrigem, 'SC')) * 0.1) / (1 - (SELECT MAX(Aliquota) FROM imposto WHERE Chave = CONCAT(compra.UFOrigem, 'SC')))) AS Bruto_Para_SC,
	((compra.ValorLiquido + (SELECT MAX(KM) FROM km WHERE Chave = CONCAT(compra.UFOrigem, 'RJ')) * 0.1) / (1 - (SELECT MAX(Aliquota) FROM imposto WHERE Chave = CONCAT(compra.UFOrigem, 'RJ')))) AS Bruto_Para_RJ,
	((compra.ValorLiquido + (SELECT MAX(KM) FROM km WHERE Chave = CONCAT(compra.UFOrigem, 'PR')) * 0.1) / (1 - (SELECT MAX(Aliquota) FROM imposto WHERE Chave = CONCAT(compra.UFOrigem, 'PR')))) AS Bruto_Para_PR,
	((compra.ValorLiquido + (SELECT MAX(KM) FROM km WHERE Chave = CONCAT(compra.UFOrigem, 'AM')) * 0.1) / (1 - (SELECT MAX(Aliquota) FROM imposto WHERE Chave = CONCAT(compra.UFOrigem, 'AM')))) AS Bruto_Para_AM
    FROM compra
) AS total;


