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

CREATE ROLE replicador WITH LOGIN REPLICATION PASSWORD 'repl_pass';
CREATE ROLE consulta WITH LOGIN PASSWORD 'consulta_pass';
CREATE ROLE administracion WITH LOGIN PASSWORD 'admin_pass';
GRANT SELECT ON ALL TABLES IN SCHEMA public TO consulta;
GRANT INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO administracion;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO consulta;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT INSERT, UPDATE, DELETE ON TABLES TO administracion;
