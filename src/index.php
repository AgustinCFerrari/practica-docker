<?php
$mysqli = new mysqli("dbserver", "root", "admin", "practica"); // host = nombre del servicio/contendor
if ($mysqli->connect_error) {
  die("Conexión fallida: " . $mysqli->connect_error);
}

$result = $mysqli->query("SELECT id, nombre FROM usuarios");
if (!$result) {
  echo "La tabla 'usuarios' aún no existe o error de query.<br>";
  echo "Error: " . $mysqli->error;
  exit;
}

echo "<h1>Usuarios</h1>";
while ($row = $result->fetch_assoc()) {
  echo $row['id'] . " - " . htmlspecialchars($row['nombre']) . "<br>";
}
