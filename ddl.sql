CREATE DATABASE uni;

USE uni;

CREATE TABLE departamento (
    id_departamento INT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);

CREATE TABLE alumno (
    id_alumno INT PRIMARY KEY,
    nif VARCHAR(9) UNIQUE NOT NULL,
    nombre VARCHAR(25),
    apellido1 VARCHAR(50),
    apellido2 VARCHAR(50),
    ciudad VARCHAR(25),
    direccion VARCHAR(50),
    telefono VARCHAR(9),
    fecha_nacimiento DATE,
    sexo ENUM('H','M')
);

CREATE TABLE profesor (
    id_profesor INT PRIMARY KEY,
    nif VARCHAR(9) UNIQUE NOT NULL,
    nombre VARCHAR(25),
    apellido1 VARCHAR(25),
    apellido2 VARCHAR(50),
    ciudad VARCHAR(25),
    direccion VARCHAR(50),
    telefono VARCHAR(9),
    fecha_nacimiento DATE,
    sexo ENUM('H','M'),
    id_departamento INT,
    FOREIGN KEY (id_departamento) REFERENCES departamento(id_departamento)
);

CREATE TABLE grado (
    id_grado INT PRIMARY KEY,
    nombre_grado VARCHAR(100) NOT NULL
);

CREATE TABLE asignatura (
    id_asignatura INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    creditos FLOAT,
    tipo ENUM('básica','obligatoria','optativa'),
    curso INT,
    semestre INT,
    id_grado_fk INT,
    id_departamento_fk INT,
    FOREIGN KEY (id_grado_fk) REFERENCES grado(id_grado),
    FOREIGN KEY (id_departamento_fk) REFERENCES departamento(id_departamento)
);

CREATE TABLE curso_escolar (
    id_curso_escolar INT PRIMARY KEY,
    ano_inicio YEAR,
    ano_fin YEAR
);

CREATE TABLE alumno_se_matricula_asignatura (
    id_alumno INT,
    id_asignatura INT,
    id_curso_escolar INT,
    PRIMARY KEY (id_alumno, id_asignatura, id_curso_escolar),
    FOREIGN KEY (id_alumno) REFERENCES alumno(id_alumno),
    FOREIGN KEY (id_asignatura) REFERENCES asignatura(id_asignatura),
    FOREIGN KEY (id_curso_escolar) REFERENCES curso_escolar(id_curso_escolar)
);

CREATE TABLE auditoria_alumno (
    id_auditoria INT AUTO_INCREMENT PRIMARY KEY,
    id_alumno INT,
    campo_modificado VARCHAR(100),
    valor_anterior VARCHAR(255),
    valor_nuevo VARCHAR(255),
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_alumno) REFERENCES alumno(id_alumno)
);

CREATE TABLE historial_creditos (
    id_historial INT AUTO_INCREMENT PRIMARY KEY,
    id_asignatura INT,
    creditos_anterior DECIMAL(3,1),
    creditos_nuevos DECIMAL(3,1),
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_asignatura) REFERENCES asignatura(id_asignatura)
);

CREATE TABLE notificaciones (
    id_notificacion INT AUTO_INCREMENT PRIMARY KEY,
    id_alumno INT,
    mensaje VARCHAR(255),
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_alumno) REFERENCES alumno(id_alumno)
);
