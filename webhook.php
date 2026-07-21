<?php
// Define una clave para validar la petición
$secreto_esperado = "mi_clave_secreta_123";

// Validar que sea POST y que el secreto coincida
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['secreto']) && $_POST['secreto'] === $secreto_esperado) {
    
    // Ruta absoluta donde está tu proyecto enlazado a Git y PM2
    $directorio_proyecto = "/ruta/absoluta/a/tu/proyecto";
    
    $salida = [];
    
    // Ejecutamos los comandos concatenados. Usamos 2>&1 para capturar posibles errores.
    // OJO: El usuario que ejecuta PHP (ej. www-data) necesita permisos sobre esta carpeta y sobre PM2.
    $comando = "cd {$directorio_proyecto} && git pull 2>&1 && pm2 restart app 2>&1";
    $salida[] = shell_exec($comando);
    
    http_response_code(200);
    echo "Despliegue finalizado:\n" . implode("\n", $salida);
} else {
    http_response_code(403);
    echo "Acceso denegado o método incorrecto.";
}
?>
