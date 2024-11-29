-- 1. TotalCreditosAlumno(AlumnoID, Anio): Calcula el total de créditos cursados por un alumno en un año específico.

DELIMITER $$
CREATE FUNCTION TotalCreditosAlumno(AlumnoID INT, Anio YEAR)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE totalCreditos DECIMAL(10,2);

    SELECT SUM(a.creditos) INTO totalCreditos
    FROM alumno_se_matricula_asignatura am
    JOIN asignatura a ON am.id_asignatura = a.id_asignatura
    JOIN curso_escolar c ON am.id_curso_escolar = c.id_curso_escolar
    WHERE am.id_alumno = AlumnoID AND c.ano_inicio = Anio;

    RETURN IFNULL(totalCreditos, 0);
END $$
DELIMITER ;

-- ejemplo de uso 
SELECT TotalCreditosAlumno(123, 2023);


-- 2. PromedioHorasPorAsignatura(AsignaturaID): Retorna el promedio de horas de clases para una asignatura.
DELIMITER $$
CREATE FUNCTION PromedioHorasPorAsignatura(AsignaturaID INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE promedioHoras DECIMAL(10,2);

    SELECT AVG(creditos) INTO promedioHoras
    FROM asignatura
    WHERE id_asignatura = AsignaturaID;

    RETURN IFNULL(promedioHoras, 0);
END 
$$
DELIMITER ;

-- ejemplo 
SELECT PromedioHorasPorAsignatura(101);

-- 3. TotalHorasPorDepartamento(DepartamentoID): Calcula la cantidad total de horas impartidas por un departamento específico.

DELIMITER $$
CREATE FUNCTION TotalHorasPorDepartamento(DepartamentoID INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE totalHoras DECIMAL(10,2);

    SELECT SUM(a.creditos) INTO totalHoras
    FROM asignatura a
    WHERE a.id_departamento_fk = DepartamentoID;

    RETURN IFNULL(totalHoras, 0);
END $$
DELIMITER ;

-- ejemplo de uso
SELECT TotalHorasPorDepartamento(5);

-- 4. VerificarAlumnoActivo(AlumnoID): Verifica si un alumno está activo en el semestre actual basándose en su matrícula.
DELIMITER $$
CREATE FUNCTION VerificarAlumnoActivo(AlumnoID INT)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE esActivo BOOLEAN;

    SELECT COUNT(*) > 0 INTO esActivo
    FROM alumno_se_matricula_asignatura am
    JOIN curso_escolar c ON am.id_curso_escolar = c.id_curso_escolar
    WHERE am.id_alumno = AlumnoID AND c.ano_inicio = YEAR(CURDATE());

    RETURN esActivo;
END 
$$
DELIMITER ;

-- ejemplo de uso
SELECT VerificarAlumnoActivo(123);

-- 5. EsProfesorVIP(ProfesorID): Verifica si un profesor es "VIP" basándose en el número de asignaturas impartidas y evaluaciones de desempeño.
DELIMITER $$
CREATE FUNCTION EsProfesorVIP(ProfesorID INT)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE esVIP BOOLEAN DEFAULT FALSE;
    DECLARE numAsignaturas INT;
    
    DECLARE numEvaluaciones INT;

    SELECT COUNT(*) INTO numAsignaturas
    FROM asignatura
    WHERE id_profesor = ProfesorID;

    SELECT COUNT(*) INTO numEvaluaciones
    FROM evaluacion_profesor
    WHERE id_profesor = ProfesorID AND resultado = 'positivo'; 

    IF numAsignaturas > 3 AND numEvaluaciones > 5 THEN 
        SET esVIP = TRUE;
    END IF;

    RETURN esVIP;
END $$
DELIMITER ;

-- ejemplo de uso 
SELECT EsProfesorVIP(456);
