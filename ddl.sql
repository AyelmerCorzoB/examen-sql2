CREATE DATABASE uni;

USE uni;

CREATE TABLE departamento (
    id_departamento INT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL
);


CREATE TABLE alumno (
    id_alumno INT PRIMARY KEY,
    dni VARCHAR(9) UNIQUE NOT NULL,
    nombre VARCHAR(50),
    apellido1 VARCHAR(50),
    apellido2 VARCHAR(50),
    ciudad VARCHAR(50),
    direccion VARCHAR(100),
    telefono VARCHAR(15),
    fecha_nacimiento DATE,
    genero CHAR(1) CHECK (genero IN ('H', 'M'))
);


CREATE TABLE profesor (
    id_profesor INT PRIMARY KEY,
    dni VARCHAR(9) UNIQUE NOT NULL,
    nombre VARCHAR(50),
    apellido1 VARCHAR(50),
    apellido2 VARCHAR(50),
    ciudad VARCHAR(50),
    direccion VARCHAR(100),
    telefono VARCHAR(15),
    fecha_nacimiento DATE,
    genero CHAR(1) CHECK (genero IN ('H', 'M')),
    id_departamento INT,
    FOREIGN KEY (id_departamento) REFERENCES departamento(id_departamento)
);


CREATE TABLE grado (
    id_grado INT PRIMARY KEY,
    nombre_grado VARCHAR(255) NOT NULL
);


CREATE TABLE asignatura (
    id_asignatura INT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    creditos DECIMAL(3, 1),
    tipo VARCHAR(50),
    curso INT,
    semestre INT,
    id_grado INT,
    id_departamento INT,
    FOREIGN KEY (id_grado) REFERENCES grado(id_grado),
    FOREIGN KEY (id_departamento) REFERENCES departamento(id_departamento)
);


CREATE TABLE curso_escolar (
    id_curso_escolar INT PRIMARY KEY,
    ano_inicio INT,
    ano_fin INT
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