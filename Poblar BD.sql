CREATE SEQUENCE seq_usuarios_id
START WITH 1
INCREMENT BY 1;

CREATE TABLE Usuarios (
    idUsuarios NUMBER PRIMARY KEY,
    nombre VARCHAR2(50) NOT NULL,
    apellido VARCHAR2(150) NOT NULL,
    correoElectronico VARCHAR2(255) NOT NULL,
    contraseña VARCHAR2(255) NOT NULL,
    tipoUsuario VARCHAR2(20) CHECK (tipoUsuario IN ('Estudiante', 'Docente')) NOT NULL
);

CREATE OR REPLACE TRIGGER trg_usuarios_id
BEFORE INSERT ON Usuarios
FOR EACH ROW
BEGIN
    IF :NEW.idUsuarios IS NULL THEN
        SELECT seq_usuarios_id.NEXTVAL INTO :NEW.idUsuarios FROM dual;
    END IF;
END;
/

CREATE SEQUENCE seq_docente_id
START WITH 1
INCREMENT BY 1;

CREATE TABLE Docente (
    idDocente NUMBER PRIMARY KEY,
    idUsuario NUMBER NOT NULL,
    FOREIGN KEY (idUsuario) REFERENCES Usuarios(idUsuarios)
);

CREATE OR REPLACE TRIGGER trg_docente_id
BEFORE INSERT ON Docente
FOR EACH ROW
BEGIN
    IF :NEW.idDocente IS NULL THEN
        SELECT seq_docente_id.NEXTVAL INTO :NEW.idDocente FROM dual;
    END IF;
END;
/

CREATE SEQUENCE seq_curso_id
START WITH 1
INCREMENT BY 1;

CREATE TABLE Curso (
    idCurso NUMBER PRIMARY KEY,
    nombre VARCHAR2(50),
    descripcion VARCHAR2(250)
);

CREATE OR REPLACE TRIGGER trg_curso_id
BEFORE INSERT ON Curso
FOR EACH ROW
BEGIN
    IF :NEW.idCurso IS NULL THEN
        SELECT seq_curso_id.NEXTVAL INTO :NEW.idCurso FROM dual;
    END IF;
END;
/

CREATE SEQUENCE seq_grupo_id
START WITH 1
INCREMENT BY 1;

CREATE TABLE Grupo (
    idGrupo NUMBER PRIMARY KEY,
    nombre VARCHAR2(50),
    idCurso NUMBER,
    FOREIGN KEY (idCurso) REFERENCES Curso (idCurso)
);

CREATE OR REPLACE TRIGGER trg_grupo_id
BEFORE INSERT ON Grupo
FOR EACH ROW
BEGIN
    IF :NEW.idCurso IS NULL THEN
        SELECT seq_grupo_id.NEXTVAL INTO :NEW.idCurso FROM dual;
    END IF;
END;
/

CREATE SEQUENCE seq_examen_id
START WITH 1
INCREMENT BY 1;

CREATE TABLE Examen (
    idExamen NUMBER PRIMARY KEY,
    nombre VARCHAR2(50) NOT NULL,
    fecha DATE NOT NULL,
    tiempoLimite INT NOT NULL,
    numPreguntas INT NOT NULL,
    idDocente INT,
    FOREIGN KEY (idDocente) REFERENCES Docente(idDocente)
);

CREATE OR REPLACE TRIGGER trg_examen_id
BEFORE INSERT ON Examen
FOR EACH ROW
BEGIN
    IF :NEW.idExamen IS NULL THEN
        SELECT seq_examen_id.NEXTVAL INTO :NEW.idExamen FROM dual;
    END IF;
END;
/

CREATE SEQUENCE seq_estudiante_id
START WITH 1
INCREMENT BY 1;

CREATE TABLE Estudiantes (
    idEstudiante NUMBER PRIMARY KEY,
    idUsuarios NUMBER NOT NULL,
    idGrupo NUMBER  NOT NULL,
    idExamen NUMBER NOT NULL,
    FOREIGN KEY (idUsuarios) REFERENCES Usuarios(idUsuarios),
    FOREIGN KEY (idGrupo) REFERENCES Grupo(idGrupo),
    FOREIGN KEY (idExamen) REFERENCES Examen(idExamen)
);

CREATE OR REPLACE TRIGGER trg_estudiante_id
BEFORE INSERT ON Estudiantes
FOR EACH ROW
BEGIN 
    IF :NEW.idEstudiante IS NULL THEN
        SELECT seq_estudiante_id.NEXTVAL INTO :NEW.idEstudiante FROM dual;
    END IF;
END;
/

CREATE SEQUENCE seq_tema_id
START WITH 1
INCREMENT BY 1;

CREATE TABLE Tema (
    idTema NUMBER PRIMARY KEY NOT NULL,
    nombre VARCHAR2(50) NOT NULL
);

CREATE OR REPLACE TRIGGER trg_tema_id
BEFORE INSERT ON Tema
FOR EACH ROW
BEGIN
    IF :NEW.idTema IS NULL THEN
        SELECT seq_tema_id.NEXTVAL INTO :NEW.idTema FROM dual;
    END IF;
END;
/

CREATE SEQUENCE seq_bancoPreguntas_id
START WITH 1
INCREMENT BY 1;

CREATE TABLE BancoPreguntas (
    idBancoPreguntas NUMBER PRIMARY KEY NOT NULL,
    esPublico CHAR(1) NOT NULL CHECK (esPublico IN ('0', '1')),
    idDocente NUMBER NOT NULL,
    idTema NUMBER NOT NULL,
    FOREIGN KEY (idDocente) REFERENCES Docente(idDocente),
    FOREIGN KEY (idTema) REFERENCES Tema(idTema)
);

CREATE OR REPLACE TRIGGER trg_bancoPreguntas_id
BEFORE INSERT ON BancoPreguntas
FOR EACH ROW
BEGIN
    IF :NEW.idBancoPreguntas IS NULL THEN
        SELECT seq_bancoPreguntas_id.NEXTVAL INTO :NEW.idBancoPreguntas FROM dual;
    END IF;
END;
/

CREATE SEQUENCE seq_preguntas_id
START WITH 1
INCREMENT BY 1;

CREATE TABLE Preguntas (
    idPreguntas NUMBER PRIMARY KEY NOT NULL,
    enunciado VARCHAR2(255) NOT NULL,
    tipoPregunta VARCHAR2(20) NOT NULL CHECK (tipoPregunta IN ('Abierta', 'OpcionMultiple', 'VerdaderoFalso')),
    respuestaCorrecta CLOB NOT NULL,
    opcionesRespuesta CLOB,
    idExamen NUMBER,
    idBancoPreguntas NUMBER,
    idTema NUMBER,
    FOREIGN KEY (idExamen) REFERENCES Examen(idExamen),
    FOREIGN KEY (idBancoPreguntas) REFERENCES BancoPreguntas(idBancoPreguntas),
    FOREIGN KEY (idTema) REFERENCES Tema(idTema)
);

CREATE OR REPLACE TRIGGER trg_preguntas_id
BEFORE INSERT ON Preguntas
FOR EACH ROW
BEGIN
    IF :NEW.idPreguntas IS NULL THEN 
        SELECT seq_preguntas_id.NEXTVAL INTO :NEW.idPreguntas FROM dual;
    END IF;
END;
/

CREATE SEQUENCE seq_unidad_id
START WITH 1
INCREMENT BY 1;

CREATE TABLE Unidad (
    idUnidad NUMBER PRIMARY KEY NOT NULL,
    nombre VARCHAR2(50) NOT NULL,
    idCurso NUMBER NOT NULL,
    FOREIGN KEY (idCurso) REFERENCES Curso(idCurso)
);

CREATE OR REPLACE TRIGGER trg_unidad_id
BEFORE INSERT ON Unidad
FOR EACH ROW
BEGIN
    IF :NEW.idUnidad IS NULL THEN
        SELECT seq_unidad_id.NEXTVAL INTO :NEW.idUnidad FROM dual;
    END IF;
END;
/

CREATE SEQUENCE seq_contenido_id
START WITH 1
INCREMENT BY 1;

CREATE TABLE Contenido (
    idContenido NUMBER PRIMARY KEY NOT NULL,
    nombre VARCHAR2(50),
    idUnidad NUMBER,
    FOREIGN KEY (idUnidad) REFERENCES Unidad(idUnidad)
);

CREATE OR REPLACE TRIGGER trg_contenido_id
BEFORE INSERT ON Contenido
FOR EACH ROW
BEGIN 
    IF :NEW.idContenido IS NULL THEN 
        SELECT seq_contenido_id.NEXTVAL INTO :NEW.idContenido FROM dual;
    END IF;
END;
/

CREATE SEQUENCE seq_resultadoExamen_id
START WITH 1
INCREMENT BY 1;

CREATE TABLE ResultadoExamen (
    idResultadoExamen NUMBER PRIMARY KEY NOT NULL,
    nota NUMBER NOT NULL,
    idExamen NUMBER NOT NULL,
    idEstudiante NUMBER NOT NULL,
    FOREIGN KEY (idExamen) REFERENCES Examen(idExamen),
    FOREIGN KEY (idEstudiante) REFERENCES Estudiantes(idEstudiante)
);

CREATE OR REPLACE TRIGGER trg_resultadoExamen_id
BEFORE INSERT ON ResultadoExamen
FOR EACH ROW
BEGIN
    IF :NEW.idResultadoExamen IS NULL THEN
        SELECT seq_resultadoExamen_id.NEXTVAL INTO :NEW.idResultadoExamen FROM dual;
    END IF;
END;
/

-- Creación de secuencias
CREATE SEQUENCE HorarioClases_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE CategoriaReporte_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE Reporte_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE DetalleReporte_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE RespuestasExamen_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE PreguntasExamen_seq START WITH 1 INCREMENT BY 1;

-- Creación de tablas
CREATE TABLE HorarioClases (
    idHorarioClases INT PRIMARY KEY,
    fecha TIMESTAMP NOT NULL, 
    lugar VARCHAR2(125),
    idGrupo INT NOT NULL,
    idCurso INT NOT NULL
);

CREATE TABLE CategoriaReporte (
    idCategoriaReporte INT PRIMARY KEY,
    nombre VARCHAR2(255) NOT NULL
);

CREATE TABLE Reporte (
    idReporte INT PRIMARY KEY,
    nombre VARCHAR2(255),
    tipoReporte VARCHAR2(125),
    fechaGeneracion TIMESTAMP NOT NULL,
    contenidoReporte VARCHAR2(255),
    idCategoriaReporte INT NOT NULL,
    FOREIGN KEY (idCategoriaReporte) REFERENCES CategoriaReporte(idCategoriaReporte)
);

CREATE TABLE DetalleReporte (
    idDetalleReporte INT PRIMARY KEY,
    idReporte INT NOT NULL,
    idExamen INT,
    idTema INT,
    idGrupo INT,
    idEstudiante INT,
    FOREIGN KEY (idReporte) REFERENCES Reporte(idReporte),
    FOREIGN KEY (idExamen) REFERENCES Examen(idExamen),
    FOREIGN KEY (idTema) REFERENCES Tema(idTema),
    FOREIGN KEY (idGrupo) REFERENCES Grupo(idGrupo),
    FOREIGN KEY (idEstudiante) REFERENCES Estudiantes(idEstudiante)
);

CREATE TABLE RespuestasExamen (
    idRespuestaExamen INT PRIMARY KEY,
    idExamen INT NOT NULL,
    idEstudiante INT NOT NULL,
    idPregunta INT NOT NULL,
    respuestaEstudiante CLOB NOT NULL,
    FOREIGN KEY (idExamen) REFERENCES Examen(idExamen),
    FOREIGN KEY (idEstudiante) REFERENCES Estudiantes(idEstudiante),
    FOREIGN KEY (idPregunta) REFERENCES Preguntas(idPreguntas)
);

CREATE TABLE PreguntasExamen (
    idPreguntaExamen INT PRIMARY KEY,
    idExamen INT NOT NULL,
    idPregunta INT NOT NULL,
    FOREIGN KEY (idExamen) REFERENCES Examen(idExamen),
    FOREIGN KEY (idPregunta) REFERENCES Preguntas(idPreguntas)
);

-- Creación de triggers para autoincremento
CREATE OR REPLACE TRIGGER HorarioClases_trigger
BEFORE INSERT ON HorarioClases
FOR EACH ROW
BEGIN
    SELECT HorarioClases_seq.NEXTVAL INTO :NEW.idHorarioClases FROM dual;
END;
/

CREATE OR REPLACE TRIGGER CategoriaReporte_trigger
BEFORE INSERT ON CategoriaReporte
FOR EACH ROW
BEGIN
    SELECT CategoriaReporte_seq.NEXTVAL INTO :NEW.idCategoriaReporte FROM dual;
END;
/

CREATE OR REPLACE TRIGGER Reporte_trigger
BEFORE INSERT ON Reporte
FOR EACH ROW
BEGIN
    SELECT Reporte_seq.NEXTVAL INTO :NEW.idReporte FROM dual;
END;
/

CREATE OR REPLACE TRIGGER DetalleReporte_trigger
BEFORE INSERT ON DetalleReporte
FOR EACH ROW
BEGIN
    SELECT DetalleReporte_seq.NEXTVAL INTO :NEW.idDetalleReporte FROM dual;
END;
/

CREATE OR REPLACE TRIGGER RespuestasExamen_trigger
BEFORE INSERT ON RespuestasExamen
FOR EACH ROW
BEGIN
    SELECT RespuestasExamen_seq.NEXTVAL INTO :NEW.idRespuestaExamen FROM dual;
END;
/

CREATE OR REPLACE TRIGGER PreguntasExamen_trigger
BEFORE INSERT ON PreguntasExamen
FOR EACH ROW
BEGIN
    SELECT PreguntasExamen_seq.NEXTVAL INTO :NEW.idPreguntaExamen FROM dual;
END;
/



-- Creación del paquete para las operaciones
CREATE OR REPLACE PACKAGE ExamenPackage AS
    -- Procedimiento para crear un examen con preguntas aleatorias del banco de preguntas
    PROCEDURE CrearExamen(
        nombreExamen IN VARCHAR2,
        fechaExamen IN DATE,
        tiempoLimite IN NUMBER,
        numPreguntas IN NUMBER,
        idDocente IN NUMBER,
        idBancoPreguntas IN NUMBER
    );
END ExamenPackage;
/

CREATE OR REPLACE PACKAGE BODY ExamenPackage AS
    PROCEDURE CrearExamen(
        nombreExamen IN VARCHAR2,
        fechaExamen IN DATE,
        tiempoLimite IN NUMBER,
        numPreguntas IN NUMBER,
        idDocente IN NUMBER,
        idBancoPreguntas IN NUMBER
    ) IS
        v_idExamen NUMBER;
    BEGIN
        -- Crear el examen
        INSERT INTO Examen (nombre, fecha, tiempoLimite, numPreguntas, idDocente)
        VALUES (nombreExamen, fechaExamen, tiempoLimite, numPreguntas, idDocente)
        RETURNING idExamen INTO v_idExamen;

        -- Seleccionar preguntas aleatorias del banco de preguntas
        FOR pregunta IN (
            SELECT enunciado, tipoPregunta, respuestaCorrecta, opcionesRespuesta, idBancoPreguntas
            FROM BancoPreguntas
            WHERE idBancoPreguntas = idBancoPreguntas
            ORDER BY DBMS_RANDOM.VALUE  -- Ordena aleatoriamente
        )
        LOOP
            -- Insertar pregunta en el examen
            INSERT INTO Preguntas (enunciado, tipoPregunta, respuestaCorrecta, opcionesRespuesta, idExamen, idBancoPreguntas)
            VALUES (pregunta.enunciado, pregunta.tipoPregunta, pregunta.respuestaCorrecta, pregunta.opcionesRespuesta, v_idExamen, pregunta.idBancoPreguntas);

            numPreguntas := numPreguntas - 1;
            IF numPreguntas = 0 THEN
                EXIT; -- Salir del bucle cuando se han seleccionado todas las preguntas
            END IF;
        END LOOP;
    END CrearExamen;
END ExamenPackage;
/



    
