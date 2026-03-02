<?php
require_once 'turim.php';

$banco = new bd();
$banco->conectar('localhost', 'root', '0321994', 'teste_turim_db');

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $jsonRecebido = file_get_contents('php://input');
    $resultado = $banco->gravar($jsonRecebido);
    echo json_encode(['success' => $resultado === true, 'msg' => $resultado]);
    exit;
}

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    echo $banco->ler();
    exit;
}