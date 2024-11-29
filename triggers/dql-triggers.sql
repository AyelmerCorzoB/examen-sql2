-- 1. ActualizarTotalAsignaturasProfesor: Al asignar una nueva asignatura a un profesor, actualiza el total de asignaturas impartidas por dicho profesor.
DELIMITER $$
CREATE TRIGGER ActualizarTotalAsignaturasProfesor
AFTER INSERT ON alumno_se_matricula_asignatura
FOR EACH ROW
BEGIN
    DECLARE total INT;
    SELECT COUNT(*) INTO total
    FROM asignatura
    WHERE id_profesor = (SELECT id_profesor FROM asignatura WHERE id_asignatura = NEW.id_asignatura);
    UPDATE profesor
    SET total_asignaturas = total
    WHERE id_profesor = (SELECT id_profesor FROM asignatura WHERE id_asignatura = NEW.id_asignatura);
END;
$$
DELIMITER ;

--ejemplo de uso
INSERT INTO alumno_se_matricula_asignatura (id_alumno, id_asignatura) 
VALUES (1, 3);  

-- 2. AuditarActualizacionAlumno: Cada vez que se modifica un registro de un alumno, guarda el cambio en una tabla de auditoría.

DELIMITER $$
CREATE TRIGGER AuditarActualizacionAlumno
AFTER UPDATE ON alumno
FOR EACH ROW
BEGIN
    IF OLD.nif <> NEW.nif THEN
        INSERT INTO auditoria_alumno (id_alumno, campo_modificado, valor_anterior, valor_nuevo)
        VALUES (NEW.id_alumno, 'nif', OLD.nif, NEW.nif);
    END IF;
    
    IF OLD.nombre <> NEW.nombre THEN
        INSERT INTO auditoria_alumno (id_alumno, campo_modificado, valor_anterior, valor_nuevo)
        VALUES (NEW.id_alumno, 'nombre', OLD.nombre, NEW.nombre);
    END IF;
    
    IF OLD.apellido1 <> NEW.apellido1 THEN
        INSERT INTO auditoria_alumno (id_alumno, campo_modificado, valor_anterior, valor_nuevo)
        VALUES (NEW.id_alumno, 'apellido1', OLD.apellido1, NEW.apellido1);
    END IF;

END $$
DELIMITER ;

-- ejemplo de uso
UPDATE alumno
SET nif = '12345678X'
WHERE id_alumno = 1;


-- 3. RegistrarHistorialCreditos: Al modificar los créditos de una asignatura, guarda un historial de los cambios.


DELIMITER $$
CREATE TRIGGER RegistrarHistorialCreditos
AFTER UPDATE ON asignatura
FOR EACH ROW
BEGIN
    IF OLD.creditos <> NEW.creditos THEN
        INSERT INTO historial_creditos (id_asignatura, creditos_anterior, creditos_nuevos)
        VALUES (NEW.id_asignatura, OLD.creditos, NEW.creditos);
    END IF;
END$$ 

DELIMITER ;

-- ejemplo de uso
INSERT INTO auditoria_alumno (id_alumno, campo_modificado, valor_anterior, valor_nuevo)
VALUES (20, 'nif', '10940452', '12345678X');


-- 4. NotificarCancelacionMatricula: Registra una notificación cuando se elimina una matrícula de un alumno.


DELIMITER $$
CREATE TRIGGER NotificarCancelacionMatricula
AFTER DELETE ON alumno_se_matricula_asignatura
FOR EACH ROW
BEGIN
    INSERT INTO notificaciones (id_alumno, mensaje)
    VALUES (OLD.id_alumno, CONCAT('Matrícula cancelada para la asignatura con ID ', OLD.id_asignatura));
END $$
DELIMITER ;

-- ejemplo de uso
DELETE FROM alumno_se_matricula_asignatura 
WHERE id_alumno = 1 AND id_asignatura = 3;

INSERT INTO notificaciones (id_alumno, mensaje)
VALUES (1, 'Matrícula cancelada para la asignatura con ID 3');


-- 5. RestringirAsignacionExcesiva: Evita que un profesor tenga más de 10 asignaturas asignadas en un semestre.


DELIMITER $$
CREATE TRIGGER RestringirAsignacionExcesiva
BEFORE INSERT ON alumno_se_matricula_asignatura
FOR EACH ROW
BEGIN
    DECLARE total_asignaturas INT;
    
    SELECT COUNT(*) INTO total_asignaturas
    FROM asignatura
    WHERE id_profesor = (SELECT id_profesor FROM asignatura WHERE id_asignatura = NEW.id_asignatura)
    AND semestre = (SELECT semestre FROM asignatura WHERE id_asignatura = NEW.id_asignatura)
    AND curso = (SELECT curso FROM asignatura WHERE id_asignatura = NEW.id_asignatura);

    IF total_asignaturas >= 10 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El profesor ya tiene 10 asignaturas asignadas en este semestre.';
    END IF;
END$$ 
DELIMITER ;


-- ejemplo de uso
INSERT INTO alumno_se_matricula_asignatura (id_alumno, id_asignatura) 
VALUES (1, 3);  

