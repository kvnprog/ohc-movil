<?php
$comentario=isset($_POST['comentario'])?($_POST['comentario']):(null);
$imagen64=isset($_POST['imagen'])?($_POST['imagen']):(null);
$usuario=isset($_POST['usuario'])?($_POST['usuario']):(null);
$mysqli = new mysqli("localhost", "id18047679_root", "xbb2-A2+C27A2", "id18047679_medicalf_och_test_2021");
if ($mysqli->connect_errno) {
    echo "Fallo al conectar a MySQL: (" . $mysqli->connect_errno . ") " . $mysqli->connect_error;
}
 $dir= '../Evidencias';
            if (!is_dir($dir)) {
                mkdir($dir, 0777, true);
                umask(0);
                chmod($dir, 0777);
            }


$fecha=date('Y-m-d h:i:s');

$fecha=date('Y-m-d-h-i-s');
$rutaImagenSalida ="../Evidencias/Evidencia".$fecha.".jpg";
$imagenBinaria = base64_decode($imagen64);
$bytes = file_put_contents($rutaImagenSalida, $imagenBinaria);



$mysqli->set_charset('utf-8');
// $queryinsertar = "INSERT INTO incidencias(fechahora,comentario) VALUES ('".$fecha."','".$comentario."')";
$queryinsertar = "INSERT INTO incidencias(quien_capturo,fechahora,comentario,evidencia) VALUES ('".$usuario."','".$fecha."','".$comentario."','".$rutaImagenSalida."')";
$mysqli->query($queryinsertar);



// $querymostrar="SELECT * FROM incidencias";
// $resultado = $mysqli->query($querymostrar);

// echo json_encode($resultado->fetch_all());



?>