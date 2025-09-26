# Conexión a base de datos MSSQL

Este proyecto muestra cómo conectar Python con una base de datos Microsoft SQL Server utilizando la librería `pyodbc` y manejando las credenciales de forma segura con `python-dotenv`.

## Librerías necesarias

```bash
pip install pyodbc python-dotenv
```

## Archivos del proyecto

- `.env`: Variables de entorno con credenciales de conexión.
- `conexion_estudiantes.py`: Script interactivo en consola para listar y agregar estudiantes.
- `crear_base_datos.sql`: Script SQL para crear la base de datos `EstudiantesDB` y la tabla `estudiantes` con algunos datos iniciales.

---

## Ejercicios sugeridos para estudiantes

### 1. Agregar Validaciones
Modifica el código para que no se puedan insertar estudiantes con:
- Edad menor a 15 o mayor a 99.
- Nombre vacío o menor a 3 caracteres.

### 2. Buscar Estudiante por Nombre
Agrega una opción al menú para buscar estudiantes por nombre (uso de `LIKE` en SQL).

### 3. Eliminar Estudiante
Agrega una opción al menú para eliminar estudiantes por su ID.

### 4. Modificar Edad de un Estudiante
Agrega una opción para actualizar la edad de un estudiante existente.

### 5. Reporte de Estudiantes Mayores de Edad
Agrega una opción para mostrar estudiantes con edad ≥ 18.

---

## Recomendaciones

- No subas el archivo `.env` a tu repositorio GitHub.
- Usa `try/except` para capturar errores de conexión o SQL.
- Siempre cierra la conexión con `cerrar_conexion()` al final del programa.

## Opciones
- 1. Listar Estudiantes
- 2. Agregar estudiante
- 3. Buscar estudiante por nombre
- 4. Eliminar estudiante por ID
- 5. Modificar estudiante por ID
- 6. Reporte de estudiantes por edad
- 7. Salir