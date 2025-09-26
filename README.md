# Sistema Académico de Inscripción

Este proyecto es una aplicación de consola en Python que permite gestionar estudiantes, profesores, cursos e inscripciones en una base de datos SQL Server El sistema está diseñado para ser simple, robusto y fácil de usar desde la terminal.

## Características principales
- **Login seguro** para acceso al sistema.
- **Gestión de estudiantes**: alta, baja, modificación, búsqueda y listado con cursos inscritos.
- **Gestión de profesores**: listado, eliminación (con validación de cursos asignados).
- **Gestión de cursos**: listado de cursos y asignación de estudiantes.
- **Inscripción de estudiantes a cursos** con validación para evitar duplicados.
- **Manejo de errores** y mensajes claros para el usuario.
- **Variables de entorno** para credenciales de base de datos (usando `.env`).

## Requisitos
- Python 3.7+
- SQL Server (local o remoto)
- Paquetes Python:
	- `pyodbc`
	- `python-dotenv`
	- `pwinput`

Instala los paquetes necesarios con:
```bash
pip install pyodbc python-dotenv pwinput
```

## Configuración
1. Crea un archivo `.env` en la raíz del proyecto con el siguiente contenido:
	 ```env
	 DB_SERVER=tu_servidor_sql
	 DB_NAME=tu_BD
	 DB_USER=tu_usuario
	 DB_PASSWORD=tu_contraseña
	 ```

2. Asegúrate de tener la base de datos y las tablas creadas. Puedes usar el script `crear_base_datos.sql` incluido en el repositorio.

## Uso
Ejecuta el archivo principal desde la terminal:
```bash
python conexion_estudiantes.py
```

Sigue las instrucciones del menú para realizar las operaciones disponibles:
- Listar, agregar, buscar, eliminar y modificar estudiantes
- Listar profesores y sus cursos
- Eliminar profesor (solo si no tiene cursos asignados)
- Inscribir estudiantes en cursos (sin duplicados)
- Listar cursos
- Salir del sistema

## Notas de implementación
- El sistema valida que los nombres ingresados comiencen con mayúscula.
- No permite eliminar profesores con cursos asignados.
- No permite inscribir dos veces al mismo estudiante en el mismo curso.
- El archivo `.env` debe estar en `.gitignore` para no exponer credenciales.

## Estructura del proyecto
```
CASO/
	├─ conexion_estudiantes.py
	├─ crear_base_datos.sql
	├─ README.md
	└─ .env (no incluido en el repo)
```

## Autor
- Desarrollado por Diego Ceballos

---