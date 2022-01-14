<?php
$comentario=isset($_POST['comentario'])?($_POST['comentario']):(null);
$imagen64=isset($_POST['imagen'])?($_POST['imagen']):(null);
$mysqli = new mysqli("localhost", "id18047679_root", "xbb2-A2+C27A2", "id18047679_medicalf_och_test_2021");
if ($mysqli->connect_errno) {
    echo "Fallo al conectar a MySQL: (" . $mysqli->connect_errno . ") " . $mysqli->connect_error;
}

$mysqli->set_charset('utf-8');
// $queryinsertar = "INSERT INTO incidencias(fechahora,comentario) VALUES ('".$fecha."','".$comentario."')";
$queryinsertar = "SELECT * FROM usuarios_rh";
$resultado=$mysqli->query($queryinsertar);

$cont=0;
foreach($resultado->fetch_all() as $dato){
 echo $dato[1]."<br>";
 $cont+=1;
}

var_dump($resultado);

echo "aqui hay un cambio";
// $querymostrar="SELECT * FROM incidencias";
// $resultado = $mysqli->query($querymostrar);

// echo json_encode($resultado->fetch_all());



?>