CREATE SCHEMA dannamurillo_adrianocarrillo.;
SET search_path TO DannaMurillo_AdrianoCarrillo;

-- Tabla de pacientes
CREATE TABLE dannamurillo_adrianocarrillo.paciente (
    id_paciente SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    cedula VARCHAR(10),
    telefono VARCHAR(10)
);

-- Tabla de doctores por clínica
CREATE TABLE dannamurillo_adrianocarrillo.doctores_norte (
    id_doctor SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    especialidad VARCHAR(100)
);

CREATE TABLE dannamurillo_adrianocarrillo.doctores_sur (
    id_doctor SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    especialidad VARCHAR(100)
);

-- Tabla de clínicas (catálogo de sucursales)
CREATE TABLE dannamurillo_adrianocarrillo.clinicas (
    id_clinica SERIAL PRIMARY KEY,
    nombre_clinica VARCHAR(100),
    direccion VARCHAR(200)
);

CREATE TABLE dannamurillo_adrianocarrillo.cita_norte (
    id_cita_n SERIAL PRIMARY KEY,
    fecha DATE,
    id_paciente INT REFERENCES paciente(id_paciente),
    id_doctor INT REFERENCES doctores_norte(id_doctor)
);
CREATE TABLE dannamurillo_adrianocarrillo.cita_sur (
    id_cita_s SERIAL PRIMARY KEY,
    fecha DATE,
    id_paciente INT REFERENCES paciente(id_paciente),
    id_doctor INT REFERENCES doctores_sur(id_doctor)
);

-- Citas centralizadas (replica)
CREATE TABLE dannamurillo_adrianocarrillo.cita_central (
    id_central SERIAL PRIMARY KEY,
    fecha DATE,
    id_paciente INT,
    id_doctor INT,
    id_clinica INT REFERENCES clinicas(id_clinica)
);


CREATE OR REPLACE FUNCTION dannamurillo_adrianocarrillo.replicar_cita_norte()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO dannamurillo_adrianocarrillo.cita_central (fecha, id_paciente, id_doctor, id_clinica)
    VALUES (NEW.fecha, NEW.id_paciente, NEW.id_doctor, 1); -- 1 = Clínica Norte
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_replicar_cita_norte
AFTER INSERT ON dannamurillo_adrianocarrillo.cita_norte
FOR EACH ROW
EXECUTE FUNCTION dannamurillo_adrianocarrillo.replicar_cita_norte();


CREATE OR REPLACE FUNCTION dannamurillo_adrianocarrillo.replicar_cita_sur()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO dannamurillo_adrianocarrillo.cita_central (fecha, id_paciente, id_doctor, id_clinica)
    VALUES (NEW.fecha, NEW.id_paciente, NEW.id_doctor, 2); -- 2 = Clínica Sur
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_replicar_cita_sur
AFTER INSERT ON dannamurillo_adrianocarrillo.cita_sur
FOR EACH ROW
EXECUTE FUNCTION dannamurillo_adrianocarrillo.replicar_cita_sur();

INSERT INTO dannamurillo_adrianocarrillo.clinicas (nombre_clinica, direccion)
VALUES 
('Clínica Norte', 'Av. Los Andes 123'),
('Clínica Sur', 'Av. Las Palmeras 456');

INSERT INTO dannamurillo_adrianocarrillo.paciente (nombre, cedula, telefono)
VALUES
('Carlos Pérez', '0102030405', '0987654321'),
('María Gómez', '0203040506', '0981122334'),
('Juan Rojas', '0304050607', '0984455667'),
('Ana Torres', '0405060708', '0987788990'),
('Luis Ramírez', '0506070809', '0981239876');

INSERT INTO dannamurillo_adrianocarrillo.doctores_norte (nombre, especialidad)
VALUES
('Dr. Herrera', 'Cardiología'),
('Dr. Morales', 'Pediatría'),
('Dr. Díaz', 'Dermatología');

INSERT INTO dannamurillo_adrianocarrillo.doctores_sur (nombre, especialidad)
VALUES
('Dr. Torres', 'Neurología'),
('Dra. López', 'Ginecología'),
('Dr. Ramírez', 'Traumatología');

INSERT INTO dannamurillo_adrianocarrillo.cita_norte (fecha, id_paciente, id_doctor)
VALUES
('2025-09-25', 1, 1), -- Carlos Pérez con Dr. Herrera
('2025-09-26', 2, 2), -- María Gómez con Dr. Morales
('2025-09-27', 3, 3); -- Juan Rojas con Dr. Díaz

INSERT INTO dannamurillo_adrianocarrillo.cita_sur (fecha, id_paciente, id_doctor)
VALUES
('2025-09-25', 4, 1), -- Ana Torres con Dr. Torres
('2025-09-26', 5, 2), -- Luis Ramírez con Dra. López
('2025-09-27', 1, 3); -- Carlos Pérez con Dr. Ramírez

CREATE OR REPLACE VIEW dannamurillo_adrianocarrillo.v_doctores AS
SELECT 
    dn.id_doctor,
    dn.nombre,
    dn.especialidad,
    'NORTE' AS clinica
FROM dannamurillo_adrianocarrillo.doctores_norte dn
UNION
SELECT 
    ds.id_doctor,
    ds.nombre,
    ds.especialidad,
    'SUR' AS clinica
FROM dannamurillo_adrianocarrillo.doctores_sur ds;

SELECT * FROM dannamurillo_adrianocarrillo.v_doctores;

SELECT * FROM dannamurillo_adrianocarrillo.citas_central;
