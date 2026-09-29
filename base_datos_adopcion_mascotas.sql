CREATE DATABASE IF NOT EXISTS adopcion_mascotas;
USE adopcion_mascotas;

-- 1. TABLA: usuarios
CREATE TABLE IF NOT EXISTS usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombres VARCHAR(150) NOT NULL,
    correo VARCHAR(150) UNIQUE NOT NULL,
    telefono VARCHAR(20),
    ciudad VARCHAR(100),
    contrasena_hash VARCHAR(255) NOT NULL,
    rol ENUM('Visitante', 'Adoptante', 'Gestor', 'Admin_Institucional') NOT NULL,
    estado_cuenta ENUM('Pendiente', 'Verificada', 'Suspendida', 'Activa') DEFAULT 'Activa',
    acepta_terminos BOOLEAN DEFAULT FALSE NOT NULL,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. TABLA: mascotas
CREATE TABLE IF NOT EXISTS mascotas (
    id_mascota INT AUTO_INCREMENT PRIMARY KEY,
    id_gestor INT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    especie VARCHAR(50) NOT NULL,
    sexo VARCHAR(20) NOT NULL,
    edad_aproximada VARCHAR(50),
    tamano VARCHAR(50),
    ubicacion_general VARCHAR(150),
    estado ENUM('Borrador', 'Publicada', 'En proceso', 'Adoptada', 'Archivada') DEFAULT 'Borrador',
    historia TEXT,
    comportamiento TEXT,
    salud_vacunacion TEXT,
    esterilizado BOOLEAN DEFAULT FALSE,
    requisitos_especiales TEXT,
    fecha_publicacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_mascota_gestor FOREIGN KEY (id_gestor) REFERENCES usuarios(id_usuario) ON DELETE CASCADE
);

-- 3. TABLA: imagenes_mascota
CREATE TABLE IF NOT EXISTS imagenes_mascota (
    id_imagen INT AUTO_INCREMENT PRIMARY KEY,
    id_mascota INT NOT NULL,
    url_imagen VARCHAR(255) NOT NULL,
    CONSTRAINT fk_imagen_mascota FOREIGN KEY (id_mascota) REFERENCES mascotas(id_mascota) ON DELETE CASCADE
);

-- 4. TABLA: solicitudes_adopcion
CREATE TABLE IF NOT EXISTS solicitudes_adopcion (
    id_solicitud INT AUTO_INCREMENT PRIMARY KEY,
    codigo_radicado VARCHAR(50) UNIQUE NOT NULL,
    id_adoptante INT NOT NULL,
    id_mascota INT NOT NULL,
    documento_identidad VARCHAR(30) NOT NULL,
    tipo_vivienda VARCHAR(50) NOT NULL,
    composicion_hogar TEXT NOT NULL,
    tiene_otros_animales BOOLEAN NOT NULL,
    capacidad_economica VARCHAR(50) NOT NULL,
    motivacion TEXT NOT NULL,
    estado_actual ENUM('Recibida', 'En revisión', 'Entrevista agendada', 'Aprobada', 'Rechazada', 'Formalizada') DEFAULT 'Recibida',
    fecha_radicacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_solicitud_adoptante FOREIGN KEY (id_adoptante) REFERENCES usuarios(id_usuario) ON DELETE CASCADE,
    CONSTRAINT fk_solicitud_mascota FOREIGN KEY (id_mascota) REFERENCES mascotas(id_mascota) ON DELETE CASCADE
);

-- 5. TABLA: historial_solicitud
CREATE TABLE IF NOT EXISTS historial_solicitud (
    id_historial INT AUTO_INCREMENT PRIMARY KEY,
    id_solicitud INT NOT NULL,
    estado_anterior VARCHAR(30),
    estado_nuevo VARCHAR(30) NOT NULL,
    comentario_publico TEXT,
    nota_interna TEXT,
    fecha_cambio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    id_usuario_cambio INT NOT NULL,
    CONSTRAINT fk_historial_solicitud FOREIGN KEY (id_solicitud) REFERENCES solicitudes_adopcion(id_solicitud) ON DELETE CASCADE,
    CONSTRAINT fk_historial_usuario FOREIGN KEY (id_usuario_cambio) REFERENCES usuarios(id_usuario)
);

-- 6. TABLA: entrevistas
CREATE TABLE IF NOT EXISTS entrevistas (
    id_entrevista INT AUTO_INCREMENT PRIMARY KEY,
    id_solicitud INT NOT NULL,
    fecha_hora TIMESTAMP NOT NULL,
    modalidad ENUM('Presencial', 'Virtual') NOT NULL,
    instrucciones TEXT,
    resultado TEXT,
    CONSTRAINT fk_entrevista_solicitud FOREIGN KEY (id_solicitud) REFERENCES solicitudes_adopcion(id_solicitud) ON DELETE CASCADE
);

-- 7. TABLA: seguimientos_posadopcion
CREATE TABLE IF NOT EXISTS seguimientos_posadopcion (
    id_seguimiento INT AUTO_INCREMENT PRIMARY KEY,
    id_solicitud INT NOT NULL,
    hito VARCHAR(100) NOT NULL,
    estado ENUM('Pendiente', 'Enviado', 'Revisado', 'Cerrado') DEFAULT 'Pendiente',
    reporte_salud_comportamiento TEXT,
    fecha_envio TIMESTAMP,
    CONSTRAINT fk_seguimiento_solicitud FOREIGN KEY (id_solicitud) REFERENCES solicitudes_adopcion(id_solicitud) ON DELETE CASCADE
);

-- 8. TABLA: evidencias_seguimiento
CREATE TABLE IF NOT EXISTS evidencias_seguimiento (
    id_evidencia INT AUTO_INCREMENT PRIMARY KEY,
    id_seguimiento INT NOT NULL,
    url_imagen VARCHAR(255) NOT NULL,
    CONSTRAINT fk_evidencia_seguimiento FOREIGN KEY (id_seguimiento) REFERENCES seguimientos_posadopcion(id_seguimiento) ON DELETE CASCADE
);

USE adopcion_mascotas;
SHOW TABLES;
USE adopcion_mascotas;
SELECT * FROM mascotas;
USE adopcion_mascotas;
ALTER TABLE mascotas
ADD COLUMN raza VARCHAR(100) AFTER especie;
DESCRIBE mascotas;