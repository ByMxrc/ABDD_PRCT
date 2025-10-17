-- ==========================================
--  SISTEMA DE TORNEOS ARCADE
--  Uso de UUIDs con pgcrypto
-- ==========================================

-- 1️⃣ Extensión para generar UUIDs
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- ==========================================
-- 2️⃣ Tabla: JUGADOR
-- ==========================================
CREATE TABLE jugador (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nombre VARCHAR(100) NOT NULL,
  pais VARCHAR(100),
  fecha_registro TIMESTAMP DEFAULT now()
);

-- ==========================================
-- 3️⃣ Tabla: JUEGO
-- ==========================================
CREATE TABLE juego (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nombre VARCHAR(100) NOT NULL,
  genero VARCHAR(50),
  plataforma VARCHAR(50),
  fecha_lanzamiento DATE
);

-- ==========================================
-- 4️⃣ Tabla: TORNEO
-- ==========================================
CREATE TABLE torneo (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nombre VARCHAR(100) NOT NULL,
  ubicacion VARCHAR(100),
  fecha_inicio DATE NOT NULL,
  fecha_fin DATE,
  premio_total NUMERIC(10,2)
);

-- ==========================================
-- 5️⃣ Tabla: RESULTADO
-- ==========================================
CREATE TABLE resultado (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  jugador_id UUID NOT NULL,
  torneo_id UUID NOT NULL,
  juego_id UUID NOT NULL,
  puntaje INT NOT NULL,
  posicion INT,
  fecha_registro TIMESTAMP DEFAULT now(),

  -- Relaciones
  CONSTRAINT fk_resultado_jugador FOREIGN KEY (jugador_id)
    REFERENCES jugador(id) ON DELETE CASCADE,

  CONSTRAINT fk_resultado_torneo FOREIGN KEY (torneo_id)
    REFERENCES torneo(id) ON DELETE CASCADE,

  CONSTRAINT fk_resultado_juego FOREIGN KEY (juego_id)
    REFERENCES juego(id) ON DELETE CASCADE
);

-- ==========================================
-- 6️⃣ Índices para mejorar el rendimiento
-- ==========================================
CREATE INDEX idx_resultado_jugador ON resultado(jugador_id);
CREATE INDEX idx_resultado_torneo ON resultado(torneo_id);
CREATE INDEX idx_resultado_juego ON resultado(juego_id);
CREATE INDEX idx_resultado_puntaje ON resultado(puntaje);

-- ==========================================
-- 7️⃣ Ejemplo de inserciones iniciales
-- ==========================================

-- Jugadores
INSERT INTO jugador (nombre, pais)
VALUES
('Ana Pérez', 'Ecuador'),
('Luis Torres', 'Perú'),
('Marta Gómez', 'Chile');

-- Juegos
INSERT INTO juego (nombre, genero, plataforma, fecha_lanzamiento)
VALUES
('Street Fighter II', 'Lucha', 'Arcade', '1991-02-06'),
('Pac-Man', 'Clásico', 'Arcade', '1980-05-22'),
('Tekken 7', 'Lucha', 'Consola', '2015-03-18');

-- Torneos
INSERT INTO torneo (nombre, ubicacion, fecha_inicio, premio_total)
VALUES
('Arcade Master 2025', 'Quito', '2025-06-01', 5000.00),
('Retro Cup', 'Guayaquil', '2025-07-10', 3000.00);

-- Resultados (asociaciones)
INSERT INTO resultado (jugador_id, torneo_id, juego_id, puntaje, posicion)
SELECT
  j.id, t.id, g.id, 950, 1
FROM jugador j, torneo t, juego g
WHERE j.nombre = 'Ana Pérez' AND t.nombre = 'Arcade Master 2025' AND g.nombre = 'Street Fighter II';