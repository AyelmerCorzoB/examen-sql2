-- 1. Encuentra el profesor que ha impartido más asignaturas en el último año académico.

SELECT p.id_profesor,
       CONCAT(p.nombre, ' ', p.apellido1) AS nombre_profesor,
       COUNT(a.id_asignatura) AS num_asignaturas
FROM profesor p
JOIN asignatura a ON a.id_departamento_fk = p.id_departamento
JOIN alumno_se_matricula_asignatura am ON am.id_asignatura = a.id_asignatura
WHERE am.id_curso_escolar = (SELECT MAX(id_curso_escolar) FROM curso_escolar)
GROUP BY p.id_profesor
ORDER BY num_asignaturas DESC
LIMIT 1;
-- 2. Lista los cinco departamentos con mayor cantidad de asignaturas asignadas.

SELECT d.id_departamento, 
       d.nombre, 
       COUNT(a.id_asignatura) AS num_asignaturas
FROM departamento d
LEFT JOIN asignatura a ON a.id_departamento_fk = d.id_departamento
GROUP BY d.id_departamento, d.nombre
ORDER BY num_asignaturas DESC
LIMIT 5;
-- 3. Obtén el total de alumnos y docentes por departamento.

SELECT d.id_departamento,
       d.nombre,
       COUNT(DISTINCT a.id_alumno) AS total_alumnos,
       COUNT(DISTINCT p.id_profesor) AS total_profesores
FROM departamento d
LEFT JOIN asignatura s ON s.id_departamento_fk = d.id_departamento
LEFT JOIN alumno_se_matricula_asignatura am ON am.id_asignatura = s.id_asignatura
LEFT JOIN alumno a ON a.id_alumno = am.id_alumno
LEFT JOIN profesor p ON p.id_departamento = d.id_departamento
GROUP BY d.id_departamento, d.nombre;
-- 4. Calcula el número total de alumnos matriculados en asignaturas de un género específico en un semestre determinado.

SELECT COUNT(DISTINCT am.id_alumno) AS total_alumnos
FROM alumno a
JOIN alumno_se_matricula_asignatura am ON am.id_alumno = a.id_alumno
JOIN asignatura s ON s.id_asignatura = am.id_asignatura
WHERE a.sexo = 'H' AND s.semestre = 2;
-- 5. Encuentra los alumnos que han cursado todas las asignaturas de un grado específico.

SELECT a.id_alumno, 
       a.nombre, 
       a.apellido1, 
       a.apellido2
FROM alumno a
JOIN alumno_se_matricula_asignatura asm ON a.id_alumno = asm.id_alumno
JOIN asignatura asig ON asm.id_asignatura = asig.id_asignatura
WHERE asig.id_grado_fk = 3 
GROUP BY a.id_alumno
HAVING COUNT(DISTINCT asig.id_asignatura) = (SELECT COUNT(*) FROM asignatura asig2 WHERE asig2.id_grado_fk = 3);
-- 6. Lista los tres grados con mayor número de asignaturas cursadas en el último semestre (2017-2018).

SELECT g.nombre_grado, 
       COUNT(am.id_asignatura) AS num_asignaturas
FROM grado g
JOIN asignatura sa ON g.id_grado = sa.id_grado_fk
JOIN alumno_se_matricula_asignatura am ON sa.id_asignatura = am.id_asignatura
JOIN curso_escolar ce ON am.id_curso_escolar = ce.id_curso_escolar
WHERE ce.ano_fin = 2018 AND ce.ano_inicio = 2017
GROUP BY g.id_grado
ORDER BY num_asignaturas DESC
LIMIT 3;
-- 7. Muestra los cinco profesores con menos asignaturas impartidas en el último año académico (2017-2018).

-- 8. Calcula el promedio de edad de los alumnos al momento de su primera matrícula.

SELECT AVG(YEAR(ano_inicio) - YEAR(ano_fin)) AS promedio_edad
FROM alumno a
JOIN alumno_se_matricula_asignatura am ON a.id_alumno = am.id_alumno
JOIN curso_escolar ce ON am.id_curso_escolar = ce.id_curso_escolar
GROUP BY a.id_alumno;
-- 9. Encuentra los cinco profesores que han impartido más clases de un mismo grado.

-- 10. Genera un informe con los alumnos que han cursado más de 10 asignaturas en el último año (2017-2018).

SELECT a.id_alumno, 
       a.nombre, 
       a.apellido1, 
       a.apellido2, 
       COUNT(am.id_asignatura) AS num_asignaturas
FROM alumno a
JOIN alumno_se_matricula_asignatura am ON a.id_alumno = am.id_alumno
JOIN curso_escolar ce ON am.id_curso_escolar = ce.id_curso_escolar
WHERE ce.ano_inicio = 2017 AND ce.ano_fin = 2018
GROUP BY a.id_alumno
HAVING num_asignaturas > 10;
-- 11. Calcula el promedio de créditos de las asignaturas por grado.

SELECT g.nombre_grado, 
       AVG(sa.creditos) AS promedio_creditos
FROM grado g
JOIN asignatura sa ON g.id_grado = sa.id_grado_fk
GROUP BY g.id_grado;
-- 12. Lista las cinco asignaturas más largas (en horas) impartidas en el último semestre (2017-2018).

-- 13. Muestra los alumnos que han cursado más asignaturas de un género específico.

SELECT a.id_alumno, 
       a.nombre, 
       a.apellido1, 
       a.apellido2, 
       COUNT(am.id_asignatura) AS num_asignaturas
FROM alumno a
JOIN alumno_se_matricula_asignatura am ON a.id_alumno = am.id_alumno
JOIN asignatura sa ON am.id_asignatura = sa.id_asignatura
WHERE a.sexo = 'M'
GROUP BY a.id_alumno
ORDER BY num_asignaturas DESC;
-- 14. Encuentra la cantidad total de horas cursadas por cada alumno en el último semestre.

SELECT a.id_alumno, 
       a.nombre, 
       a.apellido1, 
       a.apellido2, 
       SUM(sa.creditos) AS total_horas
FROM alumno a
JOIN alumno_se_matricula_asignatura am ON a.id_alumno = am.id_alumno
JOIN asignatura sa ON am.id_asignatura = sa.id_asignatura
JOIN curso_escolar ce ON am.id_curso_escolar = ce.id_curso_escolar
WHERE ce.ano_fin = 2018 AND ce.ano_inicio = 2017
GROUP BY a.id_alumno;
-- 15. Muestra el número de asignaturas impartidas diariamente en cada mes del último trimestre (asumiendo el año 2018).

-- 16. Calcula el total de asignaturas impartidas por cada profesor en el último semestre (2017-2018).

-- 17. Encuentra al alumno con la matrícula más reciente.

SELECT a.id_alumno, 
       a.nombre, 
       a.apellido1, 
       a.apellido2
FROM alumno a
JOIN alumno_se_matricula_asignatura am ON a.id_alumno = am.id_alumno
ORDER BY am.id_curso_escolar DESC
LIMIT 1;
-- 18. Lista los cinco grados con mayor número de alumnos matriculados durante los últimos tres meses.

-- 19. Obtén la cantidad de asignaturas cursadas por cada alumno en el último semestre.

SELECT a.id_alumno, 
       a.nombre, 
       a.apellido1, 
       a.apellido2, 
       COUNT(am.id_asignatura) AS num_asignaturas
FROM alumno a
JOIN alumno_se_matricula_asignatura am ON a.id_alumno = am.id_alumno
JOIN curso_escolar ce ON am.id_curso_escolar = ce.id_curso_escolar
WHERE ce.ano_fin = 2018 AND ce.ano_inicio = 2017
GROUP BY a.id_alumno;
-- 20. Lista los profesores que no han impartido clases en el último año académico.
