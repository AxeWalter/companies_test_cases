<?php

class bd {
    private $pdo;

    public function criaDB($host, $user, $password, $database) {
        try {
            $tempPdo = new PDO("mysql:host=$host", $user, $password);
            $tempPdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

            $tempPdo->exec("CREATE DATABASE IF NOT EXISTS `$database` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci");

            $this->conectar($host, $user, $password, $database);

            $this->pdo->exec(
            "CREATE TABLE IF NOT EXISTS pessoa (
                id INT AUTO_INCREMENT PRIMARY KEY,
                nome VARCHAR(255) NOT NULL
            ) ENGINE=InnoDB");

            $this->pdo->exec(
            "CREATE TABLE IF NOT EXISTS filho (
                id INT AUTO_INCREMENT PRIMARY KEY,
                pessoa_id INT NOT NULL,
                nome VARCHAR(255) NOT NULL,
                FOREIGN KEY (pessoa_id) REFERENCES pessoa(id) ON DELETE CASCADE
            ) ENGINE=InnoDB");

        } catch (PDOException $e) {
            die("Erro ao criar banco: " . $e->getMessage());
        }
    }

    public function conectar($host, $user, $password, $database) {
        try {
            $this->pdo = new PDO("mysql:host=$host;dbname=$database;charset=utf8", $user, $password);
            $this->pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        } catch (PDOException $e) {
            die("Erro de conexão: " . $e->getMessage());
        }
    }

    public function gravar($json) {
        try {
            $dados = json_decode($json, true);
            if (!$dados || !isset($dados['pessoas'])) return false;

            $this->pdo->beginTransaction();

            $this->pdo->exec("SET FOREIGN_KEY_CHECKS = 0");
            $this->pdo->exec("DELETE FROM filho");
            $this->pdo->exec("DELETE FROM pessoa");
            $this->pdo->exec("SET FOREIGN_KEY_CHECKS = 1");

            $stmtPessoa = $this->pdo->prepare("INSERT INTO pessoa (nome) VALUES (:nome)");
            $stmtFilho = $this->pdo->prepare("INSERT INTO filho (pessoa_id, nome) VALUES (:pai_id, :nome)");

            foreach ($dados['pessoas'] as $p) {
                $stmtPessoa->execute([':nome' => $p['nome']]);
                $paiId = $this->pdo->lastInsertId();

                if (isset($p['filhos']) && is_array($p['filhos'])) {
                    foreach ($p['filhos'] as $nomeFilho) {
                        $stmtFilho->execute([
                            ':pai_id' => $paiId,
                            ':nome'   => $nomeFilho
                        ]);
                    }
                }
            }

            $this->pdo->commit();
            return true;
        } catch (Exception $e) {
            if ($this->pdo->inTransaction()) $this->pdo->rollBack();
            return "Erro ao gravar: " . $e->getMessage();
        }
    }

    public function ler() {
    try {
        $query = "SELECT p.id, p.nome as pai_nome, f.nome as filho_nome 
                  FROM pessoa p 
                  LEFT JOIN filho f ON p.id = f.pessoa_id 
                  ORDER BY p.id ASC, f.id ASC";
        
        $stmt = $this->pdo->query($query);
        $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);

        $estrutura = ['pessoas' => []];
        $tempPessoas = [];

        foreach ($rows as $row) {
            $pid = $row['id'];
            
            if (!isset($tempPessoas[$pid])) {
                $tempPessoas[$pid] = [
                    'nome' => $row['pai_nome'],
                    'filhos' => []
                ];
            }

            if ($row['filho_nome'] !== null) {
                $tempPessoas[$pid]['filhos'][] = $row['filho_nome'];
            }
        }

        $estrutura['pessoas'] = array_values($tempPessoas);

        return json_encode($estrutura, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);
    } catch (PDOException $e) {
        return json_encode(["error" => $e->getMessage()]);
    }
    }
}