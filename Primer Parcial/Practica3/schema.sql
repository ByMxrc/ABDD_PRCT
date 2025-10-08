CREATE TABLE propiedades (
  id SERIAL PRIMARY KEY,
  direccion TEXT NOT NULL,
  ciudad TEXT NOT NULL CHECK (ciudad IN ('Quito', 'Guayaquil')),
  tipo TEXT NOT NULL CHECK (tipo IN ('Departamento', 'Casa', 'Local', 'Oficina')),
  estado TEXT NOT NULL CHECK (estado IN ('disponible', 'ocupado', 'mantenimiento'))
);

CREATE TABLE inquilinos (
  id SERIAL PRIMARY KEY,
  nombre TEXT NOT NULL,
  cedula TEXT UNIQUE NOT NULL,
  email TEXT UNIQUE NOT NULL
);

CREATE TABLE contratos (
  id SERIAL PRIMARY KEY,
  propiedad_id INTEGER NOT NULL REFERENCES propiedades(id) ON DELETE CASCADE,
  inquilino_id INTEGER NOT NULL REFERENCES inquilinos(id) ON DELETE CASCADE,
  fecha_inicio DATE NOT NULL,
  fecha_fin DATE NOT NULL,
  origen TEXT NOT NULL CHECK (origen IN ('quito', 'guayaquil'))
);

CREATE INDEX idx_contratos_origen ON contratos(origen);
CREATE INDEX idx_contratos_propiedad ON contratos(propiedad_id);

