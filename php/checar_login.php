<?php
 $usuario=$_POST['usuario'];
 $contraseña=$_POST['contraseña'];
 $direccion=$_POST['direccion'];
 

 $mysqli = new mysqli("localhost", "id18047679_root", "xbb2-A2+C27A2", "id18047679_medicalf_och_test_2021");
if ($mysqli->connect_errno) {
    echo "Fallo al conectar a MySQL: (" . $mysqli->connect_errno . ") " . $mysqli->connect_error;
}

$mysqli->set_charset('utf-8');

$queryinsertar = "SELECT * FROM usuarios_rh ";
$resultado=$mysqli->query($queryinsertar);

foreach($resultado->fetch_all() as $valor){
    if($valor[3]==$usuario){
       if($valor[5]==$contraseña){
           if($valor[4]==$direccion){
            echo "encontre contraseña y usuario";
            return;
           }else{
            echo $direccion;
            return;
           }
        
       }else{
        echo "Contraseña Equivocada";
        return;
       }
    }else{
        echo "El Usuario no Existe";
        return;
    }
}
?>