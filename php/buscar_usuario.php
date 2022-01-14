<?php
 $auth=$_POST['authentificacion'];
 
 

$mysqli = new mysqli("localhost", "id18047679_root", "xbb2-A2+C27A2", "id18047679_medicalf_och_test_2021");
if ($mysqli->connect_errno) {
    echo "Fallo al conectar a MySQL: (" . $mysqli->connect_errno . ") " . $mysqli->connect_error;
}

$mysqli->set_charset('utf-8');

$queryinsertar = "SELECT * FROM usuarios_rh ";
$resultado=$mysqli->query($queryinsertar);

foreach($resultado->fetch_all() as $valor){
    if($valor[4]==$auth){
      echo $valor[3];
      return;
    }
}
?>