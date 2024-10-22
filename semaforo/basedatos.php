<?php

class BaseDeDatos {
    private $archivo;

    public function __construct($archivo) {
        $this->archivo = $archivo;
    }

    // Leer el valor actual del archivo
    public function leer() {
        $fp = fopen($this->archivo, "r");
        if (flock($fp, LOCK_SH)) { // Bloqueo compartido para lectura
            $contenido = fread($fp, filesize($this->archivo));
            flock($fp, LOCK_UN); // Liberar el bloqueo
        } else {
            echo "No se pudo bloquear el archivo para leer.\n";
            $contenido = false;
        }
        fclose($fp);
        return intval($contenido);
    }

    // Escribir un nuevo valor en el archivo
    public function escribir($nuevo_valor) {
        $fp = fopen($this->archivo, "w");
        if (flock($fp, LOCK_EX)) { // Bloqueo exclusivo para escritura
            fwrite($fp, $nuevo_valor);
            flock($fp, LOCK_UN); // Liberar el bloqueo
        } else {
            echo "No se pudo bloquear el archivo para escribir.\n";
        }
        fclose($fp);
    }
}

function transaccion($sem, $base_datos, $pagina) {
    echo "Página $pagina esperando acceso a la base de datos...<br>";

    // Bloquear el semáforo (acquire)
    sem_acquire($sem);

    echo "Página $pagina accediendo a la base de datos...<br>";

    // Leer el valor actual
    $valor_actual = $base_datos->leer();
    
    // Simular el tiempo de procesamiento
    sleep(rand(1, 3));

    // Actualizar el valor
    $nuevo_valor = $valor_actual + 1;
    $base_datos->escribir($nuevo_valor);

    echo "Página $pagina ha actualizado el valor a $nuevo_valor<br>";

    // Liberar el semáforo (release)
    sem_release($sem);

    echo "Página $pagina ha terminado y liberado el semáforo.<br>";
}

// Archivo que será modificado por las tres páginas
$archivo = "datos.txt";

// Crear el archivo si no existe y escribir valor inicial de 0
if (!file_exists($archivo)) {
    file_put_contents($archivo, "0");
}

// Crear el semáforo
$key = ftok(__FILE__, 'a');
$sem = sem_get($key, 1);

// Instanciar la "base de datos" (el archivo .txt)
$base_datos = new BaseDeDatos($archivo);

?>
