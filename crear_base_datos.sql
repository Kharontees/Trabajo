-- Crear base de datos
CREATE DATABASE EstudiantesDB;
GO

USE EstudiantesDB;
GO

-- Crear tabla de estudiantes
CREATE TABLE estudiantes (
    id INT PRIMARY KEY IDENTITY(1,1),
    nombre NVARCHAR(100),
    edad INT
);

-- Insertar registros de prueba
INSERT INTO estudiantes (nombre, edad) VALUES ('Ana Torres', 20);
INSERT INTO estudiantes (nombre, edad) VALUES ('Luis Pérez', 22);
INSERT INTO estudiantes (nombre, edad) VALUES ('Valentina Rojas', 19);
