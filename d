[33mcommit 71c4daf86569b728171d491506c317af97ba6ced[m[33m ([m[1;36mHEAD[m[33m -> [m[1;32mmain[m[33m, [m[1;31morigin/main[m[33m, [m[1;31morigin/HEAD[m[33m)[m
Author: Diego <kharontees@gmail.com>
Date:   Fri Sep 26 02:09:50 2025 -0300

    readme

[1mdiff --git a/README.md b/README.md[m
[1mindex 7bc9f28..b42e97f 100644[m
[1m--- a/README.md[m
[1m+++ b/README.md[m
[36m@@ -1,73 +1,208 @@[m
[31m-# Sistema Académico de Inscripción[m
[32m+[m[32m# Sistema Académico de Inscripción (CLI)[m
 [m
[31m-Este proyecto es una aplicación de consola en Python que permite gestionar estudiantes, profesores, cursos e inscripciones en una base de datos SQL Server El sistema está diseñado para ser simple, robusto y fácil de usar desde la terminal.[m
[32m+[m[32mAplicación de consola en Python para gestionar estudiantes, profesores, cursos e inscripciones sobre SQL Server. Incluye autenticación segura con contraseña hasheada y validaciones para mantener la integridad de los datos.[m
 [m
[31m-- **Login seguro** para acceso al sistema (usuario y contraseña requeridos al iniciar el programa).[m
[31m-## Login[m
[31m-Al iniciar el sistema, se solicitará un usuario y una contraseña para acceder al menú principal. Por defecto, el usuario es `admin` y la contraseña es `1234` (puedes modificar estos valores en el código si lo deseas).[m
[32m+[m[32m## ✅ Funcionalidades Principales[m
[32m+[m[32m- Login seguro (hash SHA-256 + salt, 3 intentos máximos)[m
[32m+[m[32m- CRUD básico de estudiantes (alta, listado, búsqueda por prefijo, modificación de edad, eliminación)[m
[32m+[m[32m- Registro y listado de profesores (protege eliminación si tienen cursos asignados)[m
[32m+[m[32m- Creación de cursos con semestre y profesor responsable[m
[32m+[m[32m- Inscripción de estudiantes en cursos (evita duplicados)[m
[32m+[m[32m- Listado de:[m
[32m+[m	[32m- Estudiantes junto a los cursos que cursan (sin usar JOIN directamente, armado en Python)[m
[32m+[m	[32m- Profesores y sus cursos[m
[32m+[m	[32m- Cursos (con semestre y profesor, si la columna existe)[m
[32m+[m	[32m- Estudiantes por curso[m
[32m+[m[32m- Validaciones de formato (semestre: YYYY-1 / YYYY-2), longitudes, edades y existencia de registros[m
[32m+[m[32m- Manejo de errores y mensajes claros[m
[32m+[m[32m- Soporte opcional de RUT en estudiantes y fecha de inscripción (fecha_inscripcion) en la tabla inscripciones[m
 [m
[31m-Si el login falla tres veces, el programa se cerrará automáticamente.[m
[31m-- **Gestión de estudiantes**: alta, baja, modificación, búsqueda y listado con cursos inscritos.[m
[31m-- **Gestión de profesores**: listado, eliminación (con validación de cursos asignados).[m
[31m-- **Gestión de cursos**: listado de cursos y asignación de estudiantes.[m
[31m-- **Inscripción de estudiantes a cursos** con validación para evitar duplicados.[m
[31m-- **Manejo de errores** y mensajes claros para el usuario.[m
[31m-- **Variables de entorno** para credenciales de base de datos (usando `.env`).[m
[32m+[m[32m## 🔐 Autenticación[m
[32m+[m[32mEl sistema requiere login antes de mostrar el menú.[m
 [m
[31m-## Requisitos[m
[32m+[m[32mVariables de entorno usadas:[m
[32m+[m[32m```[m
[32m+[m[32mADMIN_USER=usuario_admin[m
[32m+[m[32mADMIN_SALT=SALT_UNICO[m
[32m+[m[32mADMIN_PASSWORD_HASH=<hash_sha256_de(SALT_UNICO + contraseña)>[m
[32m+[m[32m```[m
[32m+[m[32mSi no se encuentran `ADMIN_USER` o `ADMIN_PASSWORD_HASH`, el programa cae en modo inseguro mostrando un aviso y usa credenciales por defecto: `admin` / `admin` (no recomendado para producción).[m
[32m+[m
[32m+[m[32m### Cómo generar el hash de la contraseña[m
[32m+[m[32mEjemplo (en Python interactivo):[m
[32m+[m[32m```python[m
[32m+[m[32mimport hashlib[m
[32m+[m[32msalt = "S4LT_2025"          # Debe coincidir con ADMIN_SALT[m
[32m+[m[32mpassword = "MiClaveSegura"  # Tu contraseña real[m
[32m+[m[32mprint(hashlib.sha256((salt + password).encode()).hexdigest())[m
[32m+[m[32m```[m
[32m+[m[32mCopias el resultado en `ADMIN_PASSWORD_HASH`.[m
[32m+[m
[32m+[m[32m## 🗂 Menú (Opciones 1–13)[m
[32m+[m[32m1. Listar estudiantes[m
[32m+[m[32m2. Agregar estudiante[m
[32m+[m[32m3. Buscar estudiante por nombre (prefijo)[m
[32m+[m[32m4. Eliminar estudiante por ID[m
[32m+[m[32m5. Modificar edad de estudiante por ID[m
[32m+[m[32m6. Listar profesores y sus cursos[m
[32m+[m[32m7. Eliminar profesor (bloqueado si tiene cursos)[m
[32m+[m[32m8. Agregar estudiante a curso (inscripción)[m
[32m+[m[32m9. Crear curso (con semestre y profesor)[m
[32m+[m[32m10. Crear profesor[m
[32m+[m[32m11. Listar cursos (detalle, intenta mostrar semestre)[m
[32m+[m[32m12. Listar estudiantes por curso[m
[32m+[m[32m13. Salir[m
[32m+[m
[32m+[m[32m## 🛠 Requisitos[m
 - Python 3.7+[m
 - SQL Server (local o remoto)[m
[32m+[m[32m- Controlador ODBC Driver 17 for SQL Server instalado[m
 - Paquetes Python:[m
[31m-	- `pyodbc`[m
[31m-	- `python-dotenv`[m
[31m-	- `pwinput`[m
[32m+[m	[32m- pyodbc[m
[32m+[m	[32m- python-dotenv[m
[32m+[m	[32m- pwinput[m
 [m
[31m-Instala los paquetes necesarios con:[m
[32m+[m[32mInstalación de dependencias (entorno virtual recomendado):[m
 ```bash[m
 pip install pyodbc python-dotenv pwinput[m
 ```[m
 [m
[31m-## Configuración[m
[31m-1. Crea un archivo `.env` en la raíz del proyecto con el siguiente contenido:[m
[31m-	 ```env[m
[31m-	 DB_SERVER=tu_servidor_sql[m
[31m-	 DB_NAME=tu_BD[m
[31m-	 DB_USER=tu_usuario[m
[31m-	 DB_PASSWORD=tu_contraseña[m
[31m-	 ```[m
[32m+[m[32m## ⚙️ Archivo `.env` Ejemplo[m
[32m+[m[32m```env[m
[32m+[m[32mDB_SERVER=DESKTOP_MI_SQL[m
[32m+[m[32mDB_NAME=CASO[m
[32m+[m[32mDB_USER=usuario_sql[m
[32m+[m[32mDB_PASSWORD=tu_password_sql[m
[32m+[m
[32m+[m[32mADMIN_USER=admin[m
[32m+[m[32mADMIN_SALT=S4LT_2025[m
[32m+[m[32mADMIN_PASSWORD_HASH=f6fcf397919a6e23d5892d7ec83c5276245becd194a7260cfa060999a2cf7489  # Ejemplo[m
[32m+[m[32m```[m
[32m+[m[32m> IMPORTANTE: No subas `.env` al repositorio (agregado a `.gitignore`). Cambia la sal y vuelve a generar el hash en tu entorno real.[m
[32m+[m
[32m+[m[32m## 🗄 Esquema de Base de Datos (Sugerido / Actualizado)[m
[32m+[m[32m```sql[m
[32m+[m[32mCREATE DATABASE CASO;[m
[32m+[m[32mGO[m
[32m+[m[32mUSE CASO;[m
[32m+[m[32mGO[m
[32m+[m
[32m+[m[32m-- Estudiantes[m
[32m+[m[32mCREATE TABLE estudiantes ([m
[32m+[m		[32mid INT IDENTITY(1,1) PRIMARY KEY,[m
[32m+[m		[32mnombre NVARCHAR(100) NOT NULL,[m
[32m+[m		[32medad INT NOT NULL,[m
[32m+[m		[32mRUT NVARCHAR(20) NULL  -- Opcional (el código lo mostrará si existe)[m
[32m+[m[32m);[m
[32m+[m
[32m+[m[32m-- Profesores[m
[32m+[m[32mCREATE TABLE profesores ([m
[32m+[m		[32mid INT IDENTITY(1,1) PRIMARY KEY,[m
[32m+[m		[32mnombre NVARCHAR(100) NOT NULL[m
[32m+[m[32m);[m
[32m+[m
[32m+[m[32m-- Cursos (incluir columna semestre)[m
[32m+[m[32mCREATE TABLE cursos ([m
[32m+[m		[32mid INT IDENTITY(1,1) PRIMARY KEY,[m
[32m+[m		[32mnombre NVARCHAR(120) NOT NULL,[m
[32m+[m		[32msemestre NVARCHAR(10) NULL,  -- Formato: YYYY-1 o YYYY-2[m
[32m+[m		[32mprofesor_id INT NULL REFERENCES profesores(id)[m
[32m+[m[32m);[m
[32m+[m
[32m+[m[32m-- Inscripciones (evita duplicado estudiante-curso)[m
[32m+[m[32mCREATE TABLE inscripciones ([m
[32m+[m		[32mestudiante_id INT NOT NULL REFERENCES estudiantes(id) ON DELETE CASCADE,[m
[32m+[m		[32mcurso_id INT NOT NULL REFERENCES cursos(id) ON DELETE CASCADE,[m
[32m+[m		[32mfecha_inscripcion DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE),[m
[32m+[m		[32mCONSTRAINT UQ_estudiante_curso UNIQUE (estudiante_id, curso_id)[m
[32m+[m[32m);[m
[32m+[m[32m```[m
[32m+[m
[32m+[m[32mSi tu tabla `cursos` no tiene la columna `semestre` y las opciones 9 u 11 muestran aviso, puedes agregarla con:[m
[32m+[m[32m```sql[m
[32m+[m[32mALTER TABLE cursos ADD semestre NVARCHAR(10);[m
[32m+[m[32m```[m
 [m
[31m-2. Asegúrate de tener la base de datos y las tablas creadas. Puedes usar el script `crear_base_datos.sql` incluido en el repositorio.[m
[32m+[m[32mSi tu tabla `inscripciones` no tiene la columna `fecha_inscripcion` y quieres incorporarla:[m
[32m+[m[32m```sql[m
[32m+[m[32mALTER TABLE inscripciones ADD fecha_inscripcion DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE);[m
[32m+[m[32m```[m
 [m
[31m-## Uso[m
[31m-Ejecuta el archivo principal desde la terminal:[m
[32m+[m[32mSi tu tabla `estudiantes` todavía no tiene la columna `RUT` y deseas agregarla:[m
[32m+[m[32m```sql[m
[32m+[m[32mALTER TABLE estudiantes ADD RUT NVARCHAR(20) NULL;[m
[32m+[m[32m```[m
[32m+[m
[32m+[m[32m## ▶️ Ejecución[m
 ```bash[m
 python conexion_estudiantes.py[m
 ```[m
[32m+[m[32mIngresa tus credenciales cuando se soliciten. Tras login exitoso, se limpia la pantalla y aparece el menú.[m
[32m+[m
[32m+[m[32m## 🔍 Lógica Destacada[m
[32m+[m[32m- Generación de hash: SHA-256(salt + password)[m
[32m+[m[32m- Validación de semestre: patrón estricto YYYY-1 / YYYY-2[m
[32m+[m[32m- Listado de estudiantes con cursos: armado sin usar JOIN (consultas separadas + procesamiento en memoria)[m
[32m+[m[32m- Protección de integridad: no elimina profesores con cursos asignados[m
[32m+[m[32m- Prevención de duplicados: verificación antes de insertar en `inscripciones`[m
[32m+[m
[32m+[m[32m## 📊 Datos de Ejemplo (Opcional)[m
[32m+[m[32mLos datos observados en la captura pueden generarse con:[m
[32m+[m[32m```sql[m
[32m+[m[32m-- Estudiantes[m
[32m+[m[32mINSERT INTO estudiantes (nombre, edad, RUT) VALUES[m
[32m+[m[32m ('Ana Torres', 20, '12.345.678-9'),[m
[32m+[m[32m ('Jesus', 15, '26.739.596-9'),[m
[32m+[m[32m ('Diego', 19, NULL),[m
[32m+[m[32m ('Alejandro', 20, NULL);[m
[32m+[m
[32m+[m[32m-- Profesores[m
[32m+[m[32mINSERT INTO profesores (nombre) VALUES[m
[32m+[m[32m ('Carlos Ramirez'),[m
[32m+[m[32m ('Maria López'),[m
[32m+[m[32m ('Joaquin cubillos');[m
[32m+[m
[32m+[m[32m-- Cursos (asumiendo IDs de profesores 1,2,3)[m
[32m+[m[32mINSERT INTO cursos (nombre, semestre, profesor_id) VALUES[m
[32m+[m[32m ('Matemáticas I', '2025-2', 1),[m
[32m+[m[32m ('Historia Universal', '2025-2', 2);[m
[32m+[m
[32m+[m[32m-- Inscripciones (usa las llaves reales de tus inserts)[m
[32m+[m[32mINSERT INTO inscripciones (estudiante_id, curso_id) VALUES[m
[32m+[m[32m (1, 1),[m
[32m+[m[32m (6, 2),  -- Ajustar si los IDs no coinciden[m
[32m+[m[32m (8, 1),[m
[32m+[m[32m (9, 1),[m
[32m+[m[32m (11, 2);  -- Ejemplos ilustrativos; reemplaza con IDs existentes[m
[32m+[m[32m```[m
[32m+[m[32mAdapta los IDs a los que efectivamente generó tu ambiente (IDENTITY). Si ya existen inscripciones, elimina las filas o ajusta para evitar la restricción UNIQUE.[m
[32m+[m
[32m+[m[32m### Nota sobre RUT[m
[32m+[m[32mNo se valida formalmente el dígito verificador en el script actual. Si necesitas validación chilena completa (módulo 11), se puede agregar una función helper en Python posteriormente.[m
[32m+[m
[32m+[m[32m## 🧪 Posibles Mejoras Futuras[m
[32m+[m[32m- Exportar reportes a CSV / JSON[m
[32m+[m[32m- Reasignar cursos a otro profesor antes de eliminarlo[m
[32m+[m[32m- Agregar autenticación multiusuario (tabla usuarios)[m
[32m+[m[32m- Añadir pruebas unitarias (pytest) para helpers (`validar_semestre`, login)[m
[32m+[m
[32m+[m[32m## 🛡 Buenas Prácticas de Seguridad[m
[32m+[m[32m- Usa una SALT distinta por entorno[m
[32m+[m[32m- No reutilices contraseñas reales en desarrollo[m
[32m+[m[32m- Restringe permisos del usuario SQL (`DB_USER`) al mínimo necesario[m
[32m+[m[32m- Considera mover las credenciales a un gestor seguro (Vault/Azure Key Vault) en producción[m
 [m
[31m-Sigue las instrucciones del menú para realizar las operaciones disponibles:[m
[31m-- Listar, agregar, buscar, eliminar y modificar estudiantes[m
[31m-- Listar profesores y sus cursos[m
[31m-- Eliminar profesor (solo si no tiene cursos asignados)[m
[31m-- Inscribir estudiantes en cursos (sin duplicados)[m
[31m-- Listar cursos[m
[31m-- Salir del sistema[m
[31m-[m
[31m-## Notas de implementación[m
[31m-- El sistema valida que los nombres ingresados comiencen con mayúscula.[m
[31m-- No permite eliminar profesores con cursos asignados.[m
[31m-- No permite inscribir dos veces al mismo estudiante en el mismo curso.[m
[31m-- El archivo `.env` debe estar en `.gitignore` para no exponer credenciales.[m
[31m-[m
[31m-## Estructura del proyecto[m
[32m+[m[32m## 📁 Estructura del Proyecto[m
 ```[m
 CASO/[m
[31m-	├─ conexion_estudiantes.py[m
[31m-	├─ crear_base_datos.sql[m
[31m-	├─ README.md[m
[31m-	└─ .env (no incluido en el repo)[m
[32m+[m	[32mconexion_estudiantes.py[m
[32m+[m	[32mcrear_base_datos.sql (puede actualizarse con el esquema sugerido)[m
[32m+[m	[32mREADME.md[m
[32m+[m	[32m.env (excluido del repo)[m
 ```[m
 [m
[31m-## Autor[m
[31m-- Desarrollado por Diego Ceballos[m
[32m+[m[32m## 👤 Autor[m
[32m+[m[32mDesarrollado por: Diego Ceballos[m
 [m
[31m----[m
\ No newline at end of file[m
[32m+[m[32m---[m
[32m+[m[32m¿Necesitas que actualice también `crear_base_datos.sql` automáticamente con el esquema completo? Pídelo y lo preparo.[m
\ No newline at end of file[m
