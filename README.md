# Sistema Académico de Inscripción (CLI)

Aplicación de consola en Python para gestionar estudiantes, profesores, cursos e inscripciones sobre SQL Server. Incluye autenticación segura con contraseña hasheada y validaciones para mantener la integridad de los datos.

## ✅ Funcionalidades Principales
- Login seguro (hash SHA-256 + salt, 3 intentos máximos)
- CRUD básico de estudiantes (alta, listado, búsqueda por prefijo, modificación de edad, eliminación)
- Registro y listado de profesores (protege eliminación si tienen cursos asignados)
- Creación de cursos con semestre y profesor responsable
- Inscripción de estudiantes en cursos (evita duplicados)
- Listado de:
	- Estudiantes junto a los cursos que cursan (sin usar JOIN directamente, armado en Python)
	- Profesores y sus cursos
	- Cursos (con semestre y profesor, si la columna existe)
	- Estudiantes por curso
- Validaciones de formato (semestre: YYYY-1 / YYYY-2), longitudes, edades y existencia de registros
- Manejo de errores y mensajes claros
- Soporte opcional de RUT en estudiantes y fecha de inscripción (fecha_inscripcion) en la tabla inscripciones

## 🔐 Autenticación
El sistema requiere login antes de mostrar el menú.

Variables de entorno usadas:
```
ADMIN_USER=usuario_admin
ADMIN_SALT=SALT_UNICO
ADMIN_PASSWORD_HASH=<hash_sha256_de(SALT_UNICO + contraseña)>
```
Si no se encuentran `ADMIN_USER` o `ADMIN_PASSWORD_HASH`, el programa cae en modo inseguro mostrando un aviso y usa credenciales por defecto: `admin` / `admin` (no recomendado para producción).

### Cómo generar el hash de la contraseña
Ejemplo (en Python interactivo):
```python
import hashlib
salt = "S4LT_2025"          # Debe coincidir con ADMIN_SALT
password = "MiClaveSegura"  # Tu contraseña real
print(hashlib.sha256((salt + password).encode()).hexdigest())
```
Copias el resultado en `ADMIN_PASSWORD_HASH`.

## 🗂 Menú (Opciones 1–13)
1. Listar estudiantes
2. Agregar estudiante
3. Buscar estudiante por nombre (prefijo)
4. Eliminar estudiante por ID
5. Modificar edad de estudiante por ID
6. Listar profesores y sus cursos
7. Eliminar profesor (bloqueado si tiene cursos)
8. Agregar estudiante a curso (inscripción)
9. Crear curso (con semestre y profesor)
10. Crear profesor
11. Listar cursos (detalle, intenta mostrar semestre)
12. Listar estudiantes por curso
13. Salir

## 🛠 Requisitos
- Python 3.7+
- SQL Server (local o remoto)
- Controlador ODBC Driver 17 for SQL Server instalado
- Paquetes Python:
	- pyodbc
	- python-dotenv
	- pwinput

Instalación de dependencias (entorno virtual recomendado):
```bash
pip install pyodbc python-dotenv pwinput
```

## ⚙️ Archivo `.env` Ejemplo
```env
DB_SERVER=DESKTOP_MI_SQL
DB_NAME=CASO
DB_USER=usuario_sql
DB_PASSWORD=tu_password_sql

ADMIN_USER=admin
ADMIN_SALT=S4LT_2025
ADMIN_PASSWORD_HASH=f6fcf397919a6e23d5892d7ec83c5276245becd194a7260cfa060999a2cf7489  # Ejemplo
```
> IMPORTANTE: No subas `.env` al repositorio (agregado a `.gitignore`). Cambia la sal y vuelve a generar el hash en tu entorno real.

## 🗄 Esquema de Base de Datos (Sugerido / Actualizado)
```sql
CREATE DATABASE CASO;
GO
USE CASO;
GO

-- Estudiantes
CREATE TABLE estudiantes (
		id INT IDENTITY(1,1) PRIMARY KEY,
		nombre NVARCHAR(100) NOT NULL,
		edad INT NOT NULL,
		RUT NVARCHAR(20) NULL  -- Opcional (el código lo mostrará si existe)
);

-- Profesores
CREATE TABLE profesores (
		id INT IDENTITY(1,1) PRIMARY KEY,
		nombre NVARCHAR(100) NOT NULL
);

-- Cursos (incluir columna semestre)
CREATE TABLE cursos (
		id INT IDENTITY(1,1) PRIMARY KEY,
		nombre NVARCHAR(120) NOT NULL,
		semestre NVARCHAR(10) NULL,  -- Formato: YYYY-1 o YYYY-2
		profesor_id INT NULL REFERENCES profesores(id)
);

-- Inscripciones (evita duplicado estudiante-curso)
CREATE TABLE inscripciones (
		estudiante_id INT NOT NULL REFERENCES estudiantes(id) ON DELETE CASCADE,
		curso_id INT NOT NULL REFERENCES cursos(id) ON DELETE CASCADE,
		fecha_inscripcion DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE),
		CONSTRAINT UQ_estudiante_curso UNIQUE (estudiante_id, curso_id)
);
```

Si tu tabla `cursos` no tiene la columna `semestre` y las opciones 9 u 11 muestran aviso, puedes agregarla con:
```sql
ALTER TABLE cursos ADD semestre NVARCHAR(10);
```

Si tu tabla `inscripciones` no tiene la columna `fecha_inscripcion` y quieres incorporarla:
```sql
ALTER TABLE inscripciones ADD fecha_inscripcion DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE);
```

Si tu tabla `estudiantes` todavía no tiene la columna `RUT` y deseas agregarla:
```sql
ALTER TABLE estudiantes ADD RUT NVARCHAR(20) NULL;
```

## ▶️ Ejecución
```bash
python conexion_estudiantes.py
```
Ingresa tus credenciales cuando se soliciten. Tras login exitoso, se limpia la pantalla y aparece el menú.

## 🔍 Lógica Destacada
- Generación de hash: SHA-256(salt + password)
- Validación de semestre: patrón estricto YYYY-1 / YYYY-2
- Listado de estudiantes con cursos: armado sin usar JOIN (consultas separadas + procesamiento en memoria)
- Protección de integridad: no elimina profesores con cursos asignados
- Prevención de duplicados: verificación antes de insertar en `inscripciones`

## 📊 Datos de Ejemplo (Opcional)
Los datos observados en la captura pueden generarse con:
```sql
-- Estudiantes
INSERT INTO estudiantes (nombre, edad, RUT) VALUES
 ('Ana Torres', 20, '12.345.678-9'),
 ('Jesus', 15, '26.739.596-9'),
 ('Diego', 19, NULL),
 ('Alejandro', 20, NULL);

-- Profesores
INSERT INTO profesores (nombre) VALUES
 ('Carlos Ramirez'),
 ('Maria López'),
 ('Joaquin cubillos');

-- Cursos (asumiendo IDs de profesores 1,2,3)
INSERT INTO cursos (nombre, semestre, profesor_id) VALUES
 ('Matemáticas I', '2025-2', 1),
 ('Historia Universal', '2025-2', 2);

-- Inscripciones (usa las llaves reales de tus inserts)
INSERT INTO inscripciones (estudiante_id, curso_id) VALUES
 (1, 1),
 (6, 2),  -- Ajustar si los IDs no coinciden
 (8, 1),
 (9, 1),
 (11, 2);  -- Ejemplos ilustrativos; reemplaza con IDs existentes
```
Adapta los IDs a los que efectivamente generó tu ambiente (IDENTITY). Si ya existen inscripciones, elimina las filas o ajusta para evitar la restricción UNIQUE.

### Nota sobre RUT
No se valida formalmente el dígito verificador en el script actual. Si necesitas validación chilena completa (módulo 11), se puede agregar una función helper en Python posteriormente.

## 🧪 Posibles Mejoras Futuras
- Exportar reportes a CSV / JSON
- Reasignar cursos a otro profesor antes de eliminarlo
- Agregar autenticación multiusuario (tabla usuarios)
- Añadir pruebas unitarias (pytest) para helpers (`validar_semestre`, login)

## 🛡 Buenas Prácticas de Seguridad
- Usa una SALT distinta por entorno
- No reutilices contraseñas reales en desarrollo
- Restringe permisos del usuario SQL (`DB_USER`) al mínimo necesario
- Considera mover las credenciales a un gestor seguro (Vault/Azure Key Vault) en producción

## 📁 Estructura del Proyecto
```
CASO/
	conexion_estudiantes.py
	crear_base_datos.sql (puede actualizarse con el esquema sugerido)
	README.md
	.env (excluido del repo)
```

## 👤 Autor
Desarrollado por: Diego Ceballos

---
