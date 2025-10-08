CREATE TABLE propietario (
  owner_id SERIAL PRIMARY KEY,
  nombre TEXT NOT NULL,
  telefono TEXT,
  email TEXT UNIQUE
);

CREATE TABLE mascota (
  pet_id SERIAL PRIMARY KEY,
  owner_id INTEGER NOT NULL REFERENCES propietario(owner_id) ON DELETE CASCADE,
  nombre TEXT NOT NULL,
  especie TEXT NOT NULL CHECK (especie IN ('Perro','Gato','Ave','Otro')),
  fecha_nacimiento DATE,
  chip TEXT UNIQUE
);

CREATE TABLE atencion (
  appointment_id SERIAL PRIMARY KEY,
  pet_id INTEGER NOT NULL REFERENCES mascota(pet_id) ON DELETE CASCADE,
  fecha TIMESTAMP NOT NULL DEFAULT now(),
  motivo TEXT NOT NULL,
  profesional TEXT NOT NULL
);

CREATE TABLE tratamiento (
  treatment_id SERIAL PRIMARY KEY,
  appointment_id INTEGER NOT NULL REFERENCES atencion(appointment_id) ON DELETE CASCADE,
  descripcion TEXT NOT NULL,
  medicamento TEXT,
  costo NUMERIC(10,2) DEFAULT 0.00 CHECK (costo >= 0)
);

CREATE INDEX idx_mascota_owner ON mascota(owner_id);
CREATE INDEX idx_atencion_pet ON atencion(pet_id);
CREATE INDEX idx_tratamiento_appointment ON tratamiento(appointment_id);