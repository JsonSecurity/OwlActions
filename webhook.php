<?php
$secreto_esperado = "1234";

if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['secreto']) && $_POST['secreto'] === $secreto_esperado) {
    
    // Ruta absoluta donde está tu proyecto enlazado a Git y PM2
    $directorio_proyecto = "/home/kali/Desktop/github/kupload";

    //$app = "Pelis";

    $salida = [];
    
    //$comando = "cd {$directorio_proyecto} && git pull origin new-napel 2>&1 && pm2 restart ${app} 2>&1";
    $comando = "cd {$directorio_proyecto} && git pull 2>&1";
    $salida[] = shell_exec($comando);
    
    http_response_code(200);
    echo "Despliegue finalizado:\n" . implode("\n", $salida);
} else {
    http_response_code(403);
    echo "Acceso denegado o método incorrecto.";
}
?>
