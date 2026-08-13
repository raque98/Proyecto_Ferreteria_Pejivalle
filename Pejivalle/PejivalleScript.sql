 -- ============================================================
--   TALLER PEJIVALLE 
--   Curso: SC-504 Lenguajes de bases de datos
--   SCRIPT UNIFICADO - Versión Final con todas las correcciones
-- ============================================================

-- 1. ELIMINACIÓN DE TABLAS Y SECUENCIAS

BEGIN EXECUTE IMMEDIATE 'DROP TABLE Devolucion CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Productos_Ventas CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Ventas CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Pago_Trabajadores CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Telefonos CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Trabajadores CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Productos_Sucursales CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Sucursales_Direcciones CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Clientes_Direcciones CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Proveedores_Direcciones CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Productos CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Clientes CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Sucursales CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Proveedores CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Direcciones CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Tipo_Devoluciones CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Tipo_Pagos CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Categoria CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Roles CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Turnos CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Distrito CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Canton CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Provincia CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE AUDITORIA_ROLES_TRABAJADOR CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE seq_auditoria_roles'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
COMMIT;


-- 2. CREACIÓN DE TABLAS

CREATE TABLE provincia (
    id_provincia NUMBER(2) NOT NULL,
    nombre       VARCHAR2(100) NOT NULL,
    CONSTRAINT pk_provincia PRIMARY KEY (id_provincia),
    CONSTRAINT uk_provincia_nombre UNIQUE (nombre)
);

CREATE TABLE canton (
    id_canton    NUMBER(3) NOT NULL,
    id_provincia NUMBER(2) NOT NULL,
    nombre       VARCHAR2(100) NOT NULL,
    CONSTRAINT pk_canton PRIMARY KEY (id_canton),
    CONSTRAINT fk_canton_provincia FOREIGN KEY (id_provincia) REFERENCES provincia(id_provincia)
);

CREATE TABLE distrito (
    id_distrito NUMBER(5) NOT NULL,
    id_canton   NUMBER(3) NOT NULL,
    nombre      VARCHAR2(100) NOT NULL,
    CONSTRAINT pk_distrito PRIMARY KEY (id_distrito),
    CONSTRAINT fk_distrito_canton FOREIGN KEY (id_canton) REFERENCES canton(id_canton)
);

CREATE TABLE direcciones (
    id_direccion NUMBER GENERATED ALWAYS AS IDENTITY,
    id_distrito  NUMBER NOT NULL,
    detalle      VARCHAR2(250) NOT NULL,
    CONSTRAINT pk_direcciones PRIMARY KEY (id_direccion),
    CONSTRAINT fk_dir_distrito FOREIGN KEY (id_distrito) REFERENCES distrito(id_distrito)
);

CREATE TABLE roles (
    id_rol NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    rol    VARCHAR2(100) NOT NULL
);

CREATE TABLE turnos (
    id_turno NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    turno    VARCHAR2(50) NOT NULL
);

CREATE TABLE tipo_pagos (
    id_tipo_pago NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    metodo_pago  VARCHAR2(100) NOT NULL
);

CREATE TABLE tipo_devoluciones (
    id_tipo_devolucion NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    tipo_devolucion    VARCHAR2(100) NOT NULL
);

CREATE TABLE categoria (
    id_categoria NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre       VARCHAR2(100) NOT NULL
);

CREATE TABLE sucursales (
    id_sucursal NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre      VARCHAR2(150) NOT NULL,
    estado      VARCHAR2(20) DEFAULT 'Activo' NOT NULL
);

CREATE TABLE sucursales_direcciones (
    id_sucursal_direccion NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_sucursal           NUMBER NOT NULL,
    id_direccion          NUMBER NOT NULL,
    CONSTRAINT fk_sucdir_sucursal FOREIGN KEY (id_sucursal) REFERENCES sucursales(id_sucursal),
    CONSTRAINT fk_sucdir_dir FOREIGN KEY (id_direccion) REFERENCES direcciones(id_direccion)
);

CREATE TABLE proveedores (
    id_proveedor     NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre_proveedor VARCHAR2(200) NOT NULL,
    nombre_contacto  VARCHAR2(150),
    apellido1        VARCHAR2(100),
    apellido2        VARCHAR2(100),
    correo_electr    VARCHAR2(200),
    telefono         VARCHAR2(20),
    estado           VARCHAR2(20) DEFAULT 'Activo'
);

CREATE TABLE proveedores_direcciones (
    id_proveedores_direcciones NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_proveedor               NUMBER NOT NULL,
    id_direccion               NUMBER NOT NULL,
    CONSTRAINT fk_provdir_prov FOREIGN KEY (id_proveedor) REFERENCES proveedores(id_proveedor),
    CONSTRAINT fk_provdir_dir FOREIGN KEY (id_direccion) REFERENCES direcciones(id_direccion)
);

CREATE TABLE productos (
    id_producto          NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre               VARCHAR2(200) NOT NULL,
    descripcion          VARCHAR2(500),
    precio_venta         NUMBER(12,2) NOT NULL,
    precio_costo         NUMBER(12,2) NOT NULL,
    fecha_ultima_entrada DATE,
    id_proveedor         NUMBER NOT NULL,
    id_categoria         NUMBER NOT NULL,
    CONSTRAINT fk_prod_proveedor FOREIGN KEY (id_proveedor) REFERENCES proveedores(id_proveedor),
    CONSTRAINT fk_prod_categoria FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria)
);

CREATE TABLE productos_sucursales (
    id_productos_sucursales NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    cantidad                NUMBER DEFAULT 0 NOT NULL,
    id_sucursal             NUMBER NOT NULL,
    id_producto             NUMBER NOT NULL,
    CONSTRAINT fk_prodsuc_sucursal FOREIGN KEY (id_sucursal) REFERENCES sucursales(id_sucursal),
    CONSTRAINT fk_prodsuc_producto FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

CREATE TABLE clientes (
    cedula        VARCHAR2(20) PRIMARY KEY,
    nombre        VARCHAR2(150) NOT NULL,
    apellido1     VARCHAR2(100) NOT NULL,
    apellido2     VARCHAR2(100),
    correo_electr VARCHAR2(200),
    telefono      VARCHAR2(20)
);

CREATE TABLE clientes_direcciones (
    id_clientes_direcciones NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    cedula                  VARCHAR2(20) NOT NULL,
    id_direccion            NUMBER NOT NULL,
    CONSTRAINT fk_clidir_cliente FOREIGN KEY (cedula) REFERENCES clientes(cedula),
    CONSTRAINT fk_clidir_dir FOREIGN KEY (id_direccion) REFERENCES direcciones(id_direccion)
);

CREATE TABLE trabajadores (
    id_trabajador      NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre             VARCHAR2(150) NOT NULL,
    apellido1          VARCHAR2(100) NOT NULL,
    apellido2          VARCHAR2(100),
    identificacion     VARCHAR2(20) NOT NULL,
    correo_electronico VARCHAR2(200),
    estado             VARCHAR2(20) DEFAULT 'Activo' NOT NULL,
    id_sucursal        NUMBER NOT NULL,
    id_turno           NUMBER NOT NULL,
    id_rol             NUMBER NOT NULL,
    CONSTRAINT fk_trab_sucursal FOREIGN KEY (id_sucursal) REFERENCES sucursales(id_sucursal),
    CONSTRAINT fk_trab_turno FOREIGN KEY (id_turno) REFERENCES turnos(id_turno),
    CONSTRAINT fk_trab_rol FOREIGN KEY (id_rol) REFERENCES roles(id_rol)
);

CREATE TABLE telefonos (
    id_telefono   NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    telefono      VARCHAR2(20) NOT NULL,
    id_trabajador NUMBER NOT NULL,
    CONSTRAINT fk_tel_trabajador FOREIGN KEY (id_trabajador) REFERENCES trabajadores(id_trabajador)
);

CREATE TABLE pago_trabajadores (
    id_pago         NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    anio            NUMBER(4) NOT NULL,
    mes             NUMBER(2) NOT NULL,
    quincena        NUMBER(1) NOT NULL,
    monto_hora      NUMBER(10,2) NOT NULL,
    horas_laboradas NUMBER(6,2) NOT NULL,
    monto_total     NUMBER(12,2) NOT NULL,
    id_trabajador   NUMBER NOT NULL,
    CONSTRAINT fk_pago_trabajador FOREIGN KEY (id_trabajador) REFERENCES trabajadores(id_trabajador)
);

CREATE TABLE ventas (
    id_venta      NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    fecha_hora    TIMESTAMP DEFAULT systimestamp NOT NULL,
    total         NUMBER(12,2) NOT NULL,
    cedula        VARCHAR2(20) NOT NULL,
    id_trabajador NUMBER NOT NULL,
    id_tipo_pago  NUMBER NOT NULL,
    CONSTRAINT fk_venta_cliente FOREIGN KEY (cedula) REFERENCES clientes(cedula),
    CONSTRAINT fk_venta_trabajador FOREIGN KEY (id_trabajador) REFERENCES trabajadores(id_trabajador),
    CONSTRAINT fk_venta_tipopago FOREIGN KEY (id_tipo_pago) REFERENCES tipo_pagos(id_tipo_pago)
);

CREATE TABLE productos_ventas (
    id_productos_ventas NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    cantidad            NUMBER NOT NULL,
    id_producto         NUMBER NOT NULL,
    id_venta            NUMBER NOT NULL,
    CONSTRAINT fk_prodventa_producto FOREIGN KEY (id_producto) REFERENCES productos(id_producto),
    CONSTRAINT fk_prodventa_venta FOREIGN KEY (id_venta) REFERENCES ventas(id_venta)
);

CREATE TABLE devolucion (
    id_devolucion      NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    motivo             VARCHAR2(500) NOT NULL,
    cantidad_devuelta  NUMBER NOT NULL,
    fecha_hora         TIMESTAMP DEFAULT systimestamp NOT NULL,
    cedula             VARCHAR2(20) NOT NULL,
    id_producto        NUMBER NOT NULL,
    id_venta           NUMBER NOT NULL,
    id_tipo_devolucion NUMBER NOT NULL,
    CONSTRAINT fk_dev_cliente FOREIGN KEY (cedula) REFERENCES clientes(cedula),
    CONSTRAINT fk_dev_producto FOREIGN KEY (id_producto) REFERENCES productos(id_producto),
    CONSTRAINT fk_dev_venta FOREIGN KEY (id_venta) REFERENCES ventas(id_venta),
    CONSTRAINT fk_dev_tipodevol FOREIGN KEY (id_tipo_devolucion) REFERENCES tipo_devoluciones(id_tipo_devolucion)
);

COMMIT;

-- 3. TABLA DE AUDITORÍA Y SECUENCIA

CREATE TABLE AUDITORIA_ROLES_TRABAJADOR (
    AUDIT_ID        NUMBER PRIMARY KEY,
    ID_TRABAJADOR   NUMBER NOT NULL,
    FECHA_CAMBIO    TIMESTAMP NOT NULL,
    USUARIO         VARCHAR2(100) NOT NULL,
    ROL_ANTERIOR    NUMBER NOT NULL,
    ROL_NUEVO       NUMBER NOT NULL,
    CONSTRAINT FK_AUDIT_TRABAJADOR FOREIGN KEY (ID_TRABAJADOR) REFERENCES TRABAJADORES(ID_TRABAJADOR),
    CONSTRAINT FK_AUDIT_ROL_ANTERIOR FOREIGN KEY (ROL_ANTERIOR) REFERENCES ROLES(ID_ROL),
    CONSTRAINT FK_AUDIT_ROL_NUEVO FOREIGN KEY (ROL_NUEVO) REFERENCES ROLES(ID_ROL)
);

CREATE SEQUENCE seq_auditoria_roles START WITH 1 INCREMENT BY 1;


-- 4. INSERTS (Provincias, Cantones, Distritos, Direcciones)


-- Provincias
INSERT ALL 
    INTO provincia (id_provincia, nombre) VALUES (1, 'San José')
    INTO provincia (id_provincia, nombre) VALUES (2, 'Alajuela')
    INTO provincia (id_provincia, nombre) VALUES (3, 'Cartago')
    INTO provincia (id_provincia, nombre) VALUES (4, 'Heredia')
    INTO provincia (id_provincia, nombre) VALUES (5, 'Guanacaste')
    INTO provincia (id_provincia, nombre) VALUES (6, 'Puntarenas')
    INTO provincia (id_provincia, nombre) VALUES (7, 'Limón')
SELECT 1 FROM dual;
COMMIT;

-- Cantones
INSERT ALL
    INTO canton (id_canton, nombre, id_provincia) VALUES (101, 'San José', 1)
    INTO canton (id_canton, nombre, id_provincia) VALUES (102, 'Escazú', 1)
    INTO canton (id_canton, nombre, id_provincia) VALUES (103, 'Desamparados', 1)
    INTO canton (id_canton, nombre, id_provincia) VALUES (104, 'Puriscal', 1)
    INTO canton (id_canton, nombre, id_provincia) VALUES (105, 'Tarrazú', 1)
    INTO canton (id_canton, nombre, id_provincia) VALUES (106, 'Aserrí', 1)
    INTO canton (id_canton, nombre, id_provincia) VALUES (107, 'Mora', 1)
    INTO canton (id_canton, nombre, id_provincia) VALUES (108, 'Goicoechea', 1)
    INTO canton (id_canton, nombre, id_provincia) VALUES (109, 'Santa Ana', 1)
    INTO canton (id_canton, nombre, id_provincia) VALUES (110, 'Alajuelita', 1)
    INTO canton (id_canton, nombre, id_provincia) VALUES (111, 'Vázquez De Coronado', 1)
    INTO canton (id_canton, nombre, id_provincia) VALUES (112, 'Acosta', 1)
    INTO canton (id_canton, nombre, id_provincia) VALUES (113, 'Tibás', 1)
    INTO canton (id_canton, nombre, id_provincia) VALUES (114, 'Moravia', 1)
    INTO canton (id_canton, nombre, id_provincia) VALUES (115, 'Montes De Oca', 1)
    INTO canton (id_canton, nombre, id_provincia) VALUES (116, 'Turrubares', 1)
    INTO canton (id_canton, nombre, id_provincia) VALUES (117, 'Dota', 1)
    INTO canton (id_canton, nombre, id_provincia) VALUES (118, 'Curridabat', 1)
    INTO canton (id_canton, nombre, id_provincia) VALUES (119, 'Pérez Zeledón', 1)
    INTO canton (id_canton, nombre, id_provincia) VALUES (120, 'León Cortés Castro', 1)
    INTO canton (id_canton, nombre, id_provincia) VALUES (201, 'Alajuela', 2)
    INTO canton (id_canton, nombre, id_provincia) VALUES (202, 'San Ramón', 2)
    INTO canton (id_canton, nombre, id_provincia) VALUES (203, 'Grecia', 2)
    INTO canton (id_canton, nombre, id_provincia) VALUES (204, 'San Mateo', 2)
    INTO canton (id_canton, nombre, id_provincia) VALUES (205, 'Atenas', 2)
    INTO canton (id_canton, nombre, id_provincia) VALUES (206, 'Naranjo', 2)
    INTO canton (id_canton, nombre, id_provincia) VALUES (207, 'Palmares', 2)
    INTO canton (id_canton, nombre, id_provincia) VALUES (208, 'Poás', 2)
    INTO canton (id_canton, nombre, id_provincia) VALUES (209, 'Orotina', 2)
    INTO canton (id_canton, nombre, id_provincia) VALUES (210, 'San Carlos', 2)
    INTO canton (id_canton, nombre, id_provincia) VALUES (211, 'Zarcero', 2)
    INTO canton (id_canton, nombre, id_provincia) VALUES (212, 'Valverde Vega', 2)
    INTO canton (id_canton, nombre, id_provincia) VALUES (213, 'Upala', 2)
    INTO canton (id_canton, nombre, id_provincia) VALUES (214, 'Los Chiles', 2)
    INTO canton (id_canton, nombre, id_provincia) VALUES (215, 'Guatuso', 2)
    INTO canton (id_canton, nombre, id_provincia) VALUES (301, 'Cartago', 3)
    INTO canton (id_canton, nombre, id_provincia) VALUES (302, 'Paraíso', 3)
    INTO canton (id_canton, nombre, id_provincia) VALUES (303, 'La Unión', 3)
    INTO canton (id_canton, nombre, id_provincia) VALUES (304, 'Jiménez', 3)
    INTO canton (id_canton, nombre, id_provincia) VALUES (305, 'Turrialba', 3)
    INTO canton (id_canton, nombre, id_provincia) VALUES (306, 'Alvarado', 3)
    INTO canton (id_canton, nombre, id_provincia) VALUES (307, 'Oreamuno', 3)
    INTO canton (id_canton, nombre, id_provincia) VALUES (308, 'El Guarco', 3)
    INTO canton (id_canton, nombre, id_provincia) VALUES (401, 'Heredia', 4)
    INTO canton (id_canton, nombre, id_provincia) VALUES (402, 'Barva', 4)
    INTO canton (id_canton, nombre, id_provincia) VALUES (403, 'Santo Domingo', 4)
    INTO canton (id_canton, nombre, id_provincia) VALUES (404, 'Santa Bárbara', 4)
    INTO canton (id_canton, nombre, id_provincia) VALUES (405, 'San Rafael', 4)
    INTO canton (id_canton, nombre, id_provincia) VALUES (406, 'San Isidro', 4)
    INTO canton (id_canton, nombre, id_provincia) VALUES (407, 'Belén', 4)
    INTO canton (id_canton, nombre, id_provincia) VALUES (408, 'Flores', 4)
    INTO canton (id_canton, nombre, id_provincia) VALUES (409, 'San Pablo', 4)
    INTO canton (id_canton, nombre, id_provincia) VALUES (410, 'Sarapiquí', 4)
    INTO canton (id_canton, nombre, id_provincia) VALUES (501, 'Liberia', 5)
    INTO canton (id_canton, nombre, id_provincia) VALUES (502, 'Nicoya', 5)
    INTO canton (id_canton, nombre, id_provincia) VALUES (503, 'Santa Cruz', 5)
    INTO canton (id_canton, nombre, id_provincia) VALUES (504, 'Bagaces', 5)
    INTO canton (id_canton, nombre, id_provincia) VALUES (505, 'Carrillo', 5)
    INTO canton (id_canton, nombre, id_provincia) VALUES (506, 'Cañas', 5)
    INTO canton (id_canton, nombre, id_provincia) VALUES (507, 'Abangares', 5)
    INTO canton (id_canton, nombre, id_provincia) VALUES (508, 'Tilarán', 5)
    INTO canton (id_canton, nombre, id_provincia) VALUES (509, 'Nandayure', 5)
    INTO canton (id_canton, nombre, id_provincia) VALUES (510, 'La Cruz', 5)
    INTO canton (id_canton, nombre, id_provincia) VALUES (511, 'Hojancha', 5)
    INTO canton (id_canton, nombre, id_provincia) VALUES (601, 'Puntarenas', 6)
    INTO canton (id_canton, nombre, id_provincia) VALUES (602, 'Esparza', 6)
    INTO canton (id_canton, nombre, id_provincia) VALUES (603, 'Buenos Aires', 6)
    INTO canton (id_canton, nombre, id_provincia) VALUES (604, 'Montes De Oro', 6)
    INTO canton (id_canton, nombre, id_provincia) VALUES (605, 'Osa', 6)
    INTO canton (id_canton, nombre, id_provincia) VALUES (606, 'Quepos', 6)
    INTO canton (id_canton, nombre, id_provincia) VALUES (607, 'Golfito', 6)
    INTO canton (id_canton, nombre, id_provincia) VALUES (608, 'Coto Brus', 6)
    INTO canton (id_canton, nombre, id_provincia) VALUES (609, 'Parrita', 6)
    INTO canton (id_canton, nombre, id_provincia) VALUES (610, 'Corredores', 6)
    INTO canton (id_canton, nombre, id_provincia) VALUES (611, 'Garabito', 6)
    INTO canton (id_canton, nombre, id_provincia) VALUES (612, 'Monteverde', 6)
    INTO canton (id_canton, nombre, id_provincia) VALUES (613, 'Puerto Jiménez', 6)
    INTO canton (id_canton, nombre, id_provincia) VALUES (701, 'Limón', 7)
    INTO canton (id_canton, nombre, id_provincia) VALUES (702, 'Pococí', 7)
    INTO canton (id_canton, nombre, id_provincia) VALUES (703, 'Siquirres', 7)
    INTO canton (id_canton, nombre, id_provincia) VALUES (704, 'Talamanca', 7)
    INTO canton (id_canton, nombre, id_provincia) VALUES (705, 'Matina', 7)
    INTO canton (id_canton, nombre, id_provincia) VALUES (706, 'Guácimo', 7)
SELECT 1 FROM dual;
COMMIT;

-- Distritos 
INSERT ALL
    INTO distrito (id_distrito, nombre, id_canton) VALUES (10101, 'Carmen', 101)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (10102, 'Merced', 101)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (10103, 'Hospital', 101)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (10104, 'Catedral', 101)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (10105, 'Zapote', 101)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (10106, 'San Francisco de Dos Ríos', 101)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (10107, 'Uruca', 101)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (10108, 'Mata Redonda', 101)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (10109, 'Pavas', 101)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (10110, 'Hatillo', 101)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (10111, 'San Sebastián', 101)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (10201, 'Escazú', 102)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (10202, 'San Antonio', 102)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (10203, 'San Rafael', 102)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (10301, 'Desamparados', 103)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (10302, 'San Miguel', 103)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (10303, 'San Juan de Dios', 103)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (10304, 'San Rafael Arriba', 103)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (10305, 'San Antonio', 103)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (10306, 'Frailes', 103)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (10307, 'Patarrá', 103)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (10308, 'San Cristóbal', 103)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (10309, 'Rosario', 103)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (10310, 'Damas', 103)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (10311, 'San Rafael Abajo', 103)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (10312, 'Gravilias', 103)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (10313, 'Los Guido', 103)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (10401, 'Santiago', 104)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (10402, 'Mercedes Sur', 104)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (10403, 'Barbacoas', 104)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (10404, 'Grifo Alto', 104)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (10405, 'San Rafael', 104)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (10406, 'Candelarita', 104)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (10407, 'Desamparaditos', 104)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (10408, 'San Antonio', 104)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (10409, 'Chires', 104)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (10501, 'San Marcos', 105)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (10502, 'San Lorenzo', 105)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (10503, 'San Carlos', 105)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (10601, 'Aserrí', 106)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (10602, 'Tarbaca', 106)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (10603, 'Vuelta de Jorco', 106)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (10604, 'San Gabriel', 106)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (10605, 'Legua', 106)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (10606, 'Monterrey', 106)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (10607, 'Salitrillos', 106)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (10701, 'Colón', 107)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (10702, 'Guayabo', 107)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (10703, 'Tabarcia', 107)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (10704, 'Piedras Negras', 107)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (10705, 'Picagres', 107)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (10706, 'Jaris', 107)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (10707, 'Quitirrisí', 107)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (10801, 'Guadalupe', 108)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (10802, 'San Francisco', 108)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (10803, 'Calle Blancos', 108)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (10804, 'Mata de Plátano', 108)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (10805, 'Ipís', 108)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (10806, 'Rancho Redondo', 108)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (10807, 'Purral', 108)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (10901, 'Santa Ana', 109)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (10902, 'Salitral', 109)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (10903, 'Pozos', 109)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (10904, 'Uruca', 109)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (10905, 'Piedades', 109)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (10906, 'Brasil', 109)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (11001, 'Alajuelita', 110)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (11002, 'San Josecito', 110)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (11003, 'San Antonio', 110)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (11004, 'Concepción', 110)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (11005, 'San Felipe', 110)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (11101, 'San Isidro', 111)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (11102, 'San Rafael', 111)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (11103, 'Dulce Nombre de Jesús', 111)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (11104, 'Patalillo', 111)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (11105, 'Cascajal', 111)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (11201, 'San Ignacio', 112)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (11202, 'Guaitil', 112)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (11203, 'Palmichal', 112)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (11204, 'Cangrejal', 112)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (11205, 'Sabanillas', 112)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (11301, 'San Juan', 113)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (11302, 'Cinco Esquinas', 113)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (11303, 'Anselmo Llorente', 113)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (11304, 'León XIII', 113)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (11305, 'Colima', 113)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (11401, 'San Vicente', 114)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (11402, 'San Jerónimo', 114)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (11403, 'La Trinidad', 114)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (11501, 'San Pedro', 115)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (11502, 'Sabanilla', 115)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (11503, 'Mercedes', 115)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (11504, 'San Rafael', 115)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (11601, 'San Pablo', 116)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (11602, 'San Pedro', 116)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (11603, 'San Juan de Mata', 116)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (11604, 'San Luis', 116)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (11605, 'Carara', 116)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (11701, 'Santa María', 117)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (11702, 'Jardín', 117)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (11703, 'Copey', 117)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (11801, 'Curridabat', 118)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (11802, 'Granadilla', 118)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (11803, 'Sánchez', 118)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (11804, 'Tirrases', 118)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (11901, 'San Isidro de El General', 119)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (11902, 'El General', 119)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (11903, 'Daniel Flores', 119)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (11904, 'Rivas', 119)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (11905, 'San Pedro', 119)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (11906, 'Platanares', 119)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (11907, 'Pejibaye', 119)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (11908, 'Cajón', 119)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (11909, 'Barú', 119)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (11910, 'Río Nuevo', 119)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (11911, 'Páramo', 119)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (11912, 'La Amistad', 119)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (12001, 'San Pablo', 120)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (12002, 'San Andrés', 120)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (12003, 'Llano Bonito', 120)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (12004, 'San Isidro', 120)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (12005, 'Santa Cruz', 120)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (12006, 'San Antonio', 120)
    -- Alajuela
    INTO distrito (id_distrito, nombre, id_canton) VALUES (20101, 'Alajuela', 201)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (20102, 'San José', 201)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (20103, 'Carrizal', 201)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (20104, 'San Antonio', 201)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (20105, 'Guácima', 201)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (20106, 'San Isidro', 201)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (20107, 'Sabanilla', 201)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (20108, 'San Rafael', 201)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (20109, 'Río Segundo', 201)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (20110, 'Desamparados', 201)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (20111, 'Turrúcares', 201)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (20112, 'Tambor', 201)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (20113, 'La Garita', 201)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (20114, 'Sarapiquí', 201)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (20201, 'San Ramón', 202)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (20202, 'Santiago', 202)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (20203, 'San Juan', 202)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (20204, 'Piedades Norte', 202)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (20205, 'Piedades Sur', 202)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (20206, 'San Rafael', 202)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (20207, 'San Isidro', 202)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (20208, 'Ángeles', 202)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (20209, 'Alfaro', 202)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (20210, 'Volio', 202)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (20211, 'Concepción', 202)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (20212, 'Zapotal', 202)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (20213, 'Peñas Blancas', 202)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (20214, 'San Lorenzo', 202)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (20301, 'Grecia', 203)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (20302, 'San Isidro', 203)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (20303, 'San José', 203)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (20304, 'San Roque', 203)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (20305, 'Tacares', 203)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (20306, 'Puente de Piedra', 203)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (20307, 'Bolívar', 203)
    -- Cartago
    INTO distrito (id_distrito, nombre, id_canton) VALUES (30101, 'Oriental', 301)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (30102, 'Occidental', 301)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (30103, 'Carmen', 301)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (30104, 'San Nicolás', 301)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (30105, 'Aguacaliente', 301)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (30106, 'Guadalupe', 301)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (30107, 'Corralillo', 301)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (30108, 'Tierra Blanca', 301)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (30109, 'Dulce Nombre', 301)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (30110, 'Llano Grande', 301)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (30111, 'Quebradilla', 301)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (30201, 'Paraíso', 302)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (30202, 'Santiago', 302)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (30203, 'Orosi', 302)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (30204, 'Cervantes', 302)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (30205, 'Llanos de Santa Lucía', 302)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (30206, 'Río Azul', 302)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (30301, 'Tres Ríos', 303)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (30302, 'San Diego', 303)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (30303, 'San Juan', 303)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (30304, 'San Rafael', 303)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (30305, 'Concepción', 303)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (30306, 'Dulce Nombre', 303)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (30307, 'San Ramón', 303)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (30308, 'Santa Rosa', 303)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (30401, 'Juan Viñas', 304)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (30402, 'Tucurrique', 304)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (30403, 'Pejivalle', 304)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (30501, 'Turrialba', 305)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (30502, 'Peralta', 305)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (30503, 'Santa Cruz', 305)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (30504, 'Santa Teresita', 305)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (30505, 'Pavones', 305)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (30506, 'Tuis', 305)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (30507, 'Tayutic', 305)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (30508, 'Santa Rosa', 305)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (30509, 'Tres Equis', 305)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (30510, 'La Isabel', 305)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (30511, 'Chirripó', 305)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (30512, 'La Central', 305)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (30601, 'Pacayas', 306)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (30602, 'Cervantes', 306)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (30603, 'Capellades', 306)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (30701, 'San Rafael', 307)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (30702, 'Cot', 307)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (30703, 'Potrero Cerrado', 307)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (30704, 'Cipreses', 307)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (30705, 'Santa Rosa', 307)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (30801, 'El Tejar', 308)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (30802, 'San Isidro', 308)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (30803, 'Tobosi', 308)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (30804, 'Patio de Agua', 308)
    -- Heredia
    INTO distrito (id_distrito, nombre, id_canton) VALUES (40101, 'Heredia', 401)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (40102, 'Mercedes', 401)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (40103, 'San Francisco', 401)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (40104, 'Ulloa', 401)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (40105, 'Varablanca', 401)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (40201, 'Barva', 402)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (40202, 'San Pedro', 402)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (40203, 'San Pablo', 402)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (40204, 'San Roque', 402)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (40205, 'Santa Lucía', 402)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (40206, 'San José de la Montaña', 402)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (40301, 'Santo Domingo', 403)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (40302, 'San Vicente', 403)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (40303, 'San Miguel', 403)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (40304, 'Paracito', 403)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (40305, 'Santo Tomás', 403)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (40306, 'Santa Rosa', 403)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (40307, 'Tures', 403)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (40308, 'Pará', 403)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (40401, 'Santa Bárbara', 404)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (40402, 'San Pedro', 404)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (40403, 'San Juan', 404)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (40404, 'Jesús', 404)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (40405, 'Santo Domingo', 404)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (40406, 'Purabá', 404)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (40501, 'San Rafael', 405)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (40502, 'San Josecito', 405)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (40503, 'Santiago', 405)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (40504, 'Ángeles', 405)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (40505, 'Concepción', 405)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (40601, 'San Isidro', 406)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (40602, 'San José', 406)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (40603, 'Concepción', 406)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (40604, 'San Francisco', 406)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (40701, 'San Antonio', 407)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (40702, 'La Ribera', 407)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (40703, 'La Asunción', 407)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (40801, 'San Joaquín', 408)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (40802, 'Barrantes', 408)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (40803, 'Llorente', 408)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (40901, 'San Pablo', 409)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (40902, 'Rincón de Sabanilla', 409)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (41001, 'Puerto Viejo', 410)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (41002, 'La Virgen', 410)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (41003, 'Las Horquetas', 410)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (41004, 'Llanuras del Gaspar', 410)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (41005, 'Cureña', 410)
    -- Guanacaste
    INTO distrito (id_distrito, nombre, id_canton) VALUES (50101, 'Liberia', 501)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (50102, 'Cañas Dulces', 501)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (50103, 'Mayorga', 501)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (50104, 'Nacascolo', 501)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (50105, 'Curubandé', 501)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (50201, 'Nicoya', 502)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (50202, 'Mansión', 502)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (50203, 'San Antonio', 502)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (50204, 'Quebrada Honda', 502)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (50205, 'Sámara', 502)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (50206, 'Nosara', 502)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (50207, 'Belén de Nosarita', 502)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (50301, 'Santa Cruz', 503)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (50302, 'Bolsón', 503)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (50303, 'Veintisiete de Abril', 503)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (50304, 'Tempate', 503)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (50305, 'Cartagena', 503)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (50306, 'Cuajiniquil', 503)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (50307, 'Diriá', 503)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (50308, 'Cabo Velas', 503)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (50309, 'Tamarindo', 503)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (50401, 'Bagaces', 504)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (50402, 'La Fortuna', 504)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (50403, 'Mogote', 504)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (50404, 'Río Naranjo', 504)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (50501, 'Filadelfia', 505)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (50502, 'Belén', 505)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (50503, 'Palmira', 505)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (50504, 'Sardinal', 505)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (50601, 'Cañas', 506)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (50602, 'Palmira', 506)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (50603, 'San Miguel', 506)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (50604, 'Bebedero', 506)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (50605, 'Porozal', 506)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (50701, 'Las Juntas', 507)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (50702, 'Sierra', 507)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (50703, 'San Juan', 507)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (50704, 'Colorado', 507)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (50801, 'Tilarán', 508)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (50802, 'Quebrada Grande', 508)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (50803, 'Tronadora', 508)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (50804, 'Santa Rosa', 508)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (50805, 'Líbano', 508)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (50806, 'Tierras Morenas', 508)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (50807, 'Arenal', 508)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (50808, 'Cabeceras', 508)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (50901, 'Carmona', 509)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (50902, 'Santa Rita', 509)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (50903, 'Zapotal', 509)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (50904, 'San Pablo', 509)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (50905, 'Porvenir', 509)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (50906, 'Bejuco', 509)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (51001, 'La Cruz', 510)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (51002, 'Santa Cecilia', 510)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (51003, 'La Garita', 510)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (51004, 'Santa Elena', 510)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (51101, 'Hojancha', 511)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (51102, 'Monte Romo', 511)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (51103, 'Puerto Carrillo', 511)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (51104, 'Huacas', 511)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (51105, 'Matambú', 511)
    -- Puntarenas
    INTO distrito (id_distrito, nombre, id_canton) VALUES (60101, 'Puntarenas', 601)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (60102, 'Pitahaya', 601)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (60103, 'Chomes', 601)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (60104, 'Lepanto', 601)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (60105, 'Paquera', 601)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (60106, 'Manzanillo', 601)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (60107, 'Guacimal', 601)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (60108, 'Barranca', 601)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (60109, 'Isla del Coco', 601)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (60110, 'Cóbano', 601)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (60111, 'Chacarita', 601)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (60112, 'Chira', 601)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (60113, 'Acapulco', 601)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (60114, 'El Roble', 601)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (60115, 'Arancibia', 601)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (60201, 'Espíritu Santo', 602)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (60202, 'San Juan Grande', 602)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (60203, 'Macacona', 602)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (60204, 'San Rafael', 602)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (60205, 'San Jerónimo', 602)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (60206, 'Caldera', 602)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (60301, 'Buenos Aires', 603)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (60302, 'Volcán', 603)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (60303, 'Potrero Grande', 603)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (60304, 'Boruca', 603)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (60305, 'Pilas', 603)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (60306, 'Colinas', 603)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (60307, 'Chánguena', 603)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (60308, 'Biolley', 603)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (60309, 'Brunka', 603)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (60401, 'Miramar', 604)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (60402, 'La Unión', 604)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (60403, 'San Isidro', 604)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (60501, 'Puerto Cortés', 605)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (60502, 'Palmar', 605)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (60503, 'Sierpe', 605)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (60504, 'Piedras Blancas', 605)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (60505, 'Bahía Ballena', 605)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (60506, 'Bahía Drake', 605)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (60601, 'Quepos', 606)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (60602, 'Savegre', 606)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (60603, 'Naranjito', 606)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (60701, 'Golfito', 607)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (60702, 'Guaycará', 607)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (60703, 'Pavón', 607)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (60801, 'San Vito', 608)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (60802, 'Sabalito', 608)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (60803, 'Aguabuena', 608)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (60804, 'Limoncito', 608)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (60805, 'Pittier', 608)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (60806, 'Gutiérrez Braun', 608)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (60901, 'Parrita', 609)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (61001, 'Corredor', 610)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (61002, 'La Cuesta', 610)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (61003, 'Canoas', 610)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (61004, 'Laurel', 610)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (61101, 'Jacó', 611)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (61102, 'Tárcoles', 611)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (61103, 'Lagunillas', 611)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (61201, 'Santa Elena', 612)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (61301, 'Puerto Jiménez', 613)
    -- Limón
    INTO distrito (id_distrito, nombre, id_canton) VALUES (70101, 'Limón', 701)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (70102, 'Valle La Estrella', 701)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (70103, 'Río Blanco', 701)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (70104, 'Matama', 701)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (70201, 'Guápiles', 702)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (70202, 'Jiménez', 702)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (70203, 'Rita', 702)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (70204, 'Roxana', 702)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (70205, 'Cariari', 702)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (70206, 'Colorado', 702)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (70207, 'La Colonia', 702)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (70301, 'Siquirres', 703)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (70302, 'Pacuarito', 703)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (70303, 'Florida', 703)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (70304, 'Germania', 703)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (70305, 'El Cairo', 703)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (70306, 'Alegría', 703)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (70307, 'Reventazón', 703)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (70401, 'Bratsi', 704)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (70402, 'Sixaola', 704)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (70403, 'Cahuita', 704)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (70404, 'Telire', 704)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (70501, 'Matina', 705)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (70502, 'Batán', 705)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (70503, 'Carrandi', 705)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (70601, 'Guácimo', 706)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (70602, 'Mercedes', 706)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (70603, 'Pocora', 706)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (70604, 'Río Jiménez', 706)
    INTO distrito (id_distrito, nombre, id_canton) VALUES (70605, 'Duacarí', 706)
SELECT 1 FROM dual;
COMMIT;

-- Direcciones
INSERT INTO direcciones (id_distrito, detalle) VALUES (10101, '200m norte de la Iglesia del Carmen');
INSERT INTO direcciones (id_distrito, detalle) VALUES (10101, 'Frente al Parque Nacional');
INSERT INTO direcciones (id_distrito, detalle) VALUES (10102, 'Costado sur del Hospital San Juan de Dios');
INSERT INTO direcciones (id_distrito, detalle) VALUES (10103, '100m este del Teatro Nacional');
INSERT INTO direcciones (id_distrito, detalle) VALUES (10104, 'Barrio Escalante, Avenida Central');
INSERT INTO direcciones (id_distrito, detalle) VALUES (10105, '200m oeste del Mall San Pedro');
INSERT INTO direcciones (id_distrito, detalle) VALUES (10201, 'Centro de Desamparados, frente a la Municipalidad');
INSERT INTO direcciones (id_distrito, detalle) VALUES (10202, 'San Miguel, contiguo al BAC');
INSERT INTO direcciones (id_distrito, detalle) VALUES (10203, 'San Juan de Dios, 50m sur del parque');
INSERT INTO direcciones (id_distrito, detalle) VALUES (10301, 'Curridabat centro, costado norte del parque');
INSERT INTO direcciones (id_distrito, detalle) VALUES (10302, 'Granadilla, 300m este de la iglesia');
INSERT INTO direcciones (id_distrito, detalle) VALUES (10303, 'Tirrases, frente al Ebais');
INSERT INTO direcciones (id_distrito, detalle) VALUES (10401, 'Zapote centro, frente a Casa Presidencial');
INSERT INTO direcciones (id_distrito, detalle) VALUES (10402, 'San Francisco, costado oeste del parque');
INSERT INTO direcciones (id_distrito, detalle) VALUES (20101, 'Alajuela centro, frente al Parque Juan Santamaria');
INSERT INTO direcciones (id_distrito, detalle) VALUES (20102, 'El Roble, 200m norte de la escuela');
INSERT INTO direcciones (id_distrito, detalle) VALUES (20103, 'Desamparados de Alajuela, frente al super');
INSERT INTO direcciones (id_distrito, detalle) VALUES (20201, 'San Ramon centro, contiguo a la iglesia');
INSERT INTO direcciones (id_distrito, detalle) VALUES (20202, 'Santiago, 100m oeste del Ebais');
INSERT INTO direcciones (id_distrito, detalle) VALUES (20203, 'Piedades Norte, frente a la plaza');
INSERT INTO direcciones (id_distrito, detalle) VALUES (20301, 'Grecia centro, Avenida Central');
INSERT INTO direcciones (id_distrito, detalle) VALUES (20302, 'San Roque, costado este de la iglesia');
INSERT INTO direcciones (id_distrito, detalle) VALUES (30101, 'Cartago centro, frente a la Basilica');
INSERT INTO direcciones (id_distrito, detalle) VALUES (30102, 'Oriental, 200m sur del TEC');
INSERT INTO direcciones (id_distrito, detalle) VALUES (30103, 'Occidental, frente al parque');
INSERT INTO direcciones (id_distrito, detalle) VALUES (30201, 'Paraiso centro, costado norte del parque');
INSERT INTO direcciones (id_distrito, detalle) VALUES (30202, 'Santiago, frente al colegio');
INSERT INTO direcciones (id_distrito, detalle) VALUES (40101, 'Heredia centro, frente al Fortin');
INSERT INTO direcciones (id_distrito, detalle) VALUES (40102, 'Mercedes, 300m norte de la iglesia');
INSERT INTO direcciones (id_distrito, detalle) VALUES (40103, 'San Francisco, frente al parque');
INSERT INTO direcciones (id_distrito, detalle) VALUES (40201, 'Barva centro, contiguo al banco');
INSERT INTO direcciones (id_distrito, detalle) VALUES (40202, 'San Pedro, frente al Ebais');
INSERT INTO direcciones (id_distrito, detalle) VALUES (50101, 'Liberia centro, frente al parque');
INSERT INTO direcciones (id_distrito, detalle) VALUES (50102, 'Cañas Dulces, costado sur de la plaza');
INSERT INTO direcciones (id_distrito, detalle) VALUES (50201, 'Nicoya centro, Avenida Central');
INSERT INTO direcciones (id_distrito, detalle) VALUES (50202, 'Samara, frente a la playa');
INSERT INTO direcciones (id_distrito, detalle) VALUES (60101, 'Puntarenas centro, frente al muelle');
INSERT INTO direcciones (id_distrito, detalle) VALUES (60102, 'El Roble, costado norte de la iglesia');
INSERT INTO direcciones (id_distrito, detalle) VALUES (60201, 'Esparza centro, frente al parque');
INSERT INTO direcciones (id_distrito, detalle) VALUES (70101, 'Limon centro, frente al parque Vargas');
INSERT INTO direcciones (id_distrito, detalle) VALUES (70102, 'Valle La Estrella, frente a la escuela');
INSERT INTO direcciones (id_distrito, detalle) VALUES (70201, 'Guapiles centro, Avenida Central');
INSERT INTO direcciones (id_distrito, detalle) VALUES (70202, 'Jimenez, frente al colegio');
INSERT INTO direcciones (id_distrito, detalle) VALUES (70301, 'Siquirres centro, contiguo al banco');
INSERT INTO direcciones (id_distrito, detalle) VALUES (70302, 'Florida, frente a la iglesia');
INSERT INTO direcciones (id_distrito, detalle) VALUES (70401, 'Talamanca, frente al parque');
INSERT INTO direcciones (id_distrito, detalle) VALUES (70402, 'Bratsi, costado oeste del Ebais');
INSERT INTO direcciones (id_distrito, detalle) VALUES (70501, 'Matina centro, frente a la municipalidad');
INSERT INTO direcciones (id_distrito, detalle) VALUES (70502, 'Batán, contiguo a la plaza');
COMMIT;


-- 5. INSERTS DE ROLES, TURNOS, TIPOS DE PAGO, Y TIPOS DE DEVOLUCIONES


-- Roles
INSERT INTO roles (rol) VALUES ('Administrador');
INSERT INTO roles (rol) VALUES ('Recursos Humanos');
INSERT INTO roles (rol) VALUES ('Cajero');
COMMIT;

-- Turnos
INSERT INTO turnos (turno) VALUES ('Mañana');
INSERT INTO turnos (turno) VALUES ('Tarde');
COMMIT;

-- Tipo de Pagos
INSERT INTO tipo_pagos (metodo_pago) VALUES ('Efectivo');
INSERT INTO tipo_pagos (metodo_pago) VALUES ('Tarjeta');
INSERT INTO tipo_pagos (metodo_pago) VALUES ('SINPE Móvil');
COMMIT;

-- Tipo de Devoluciones
INSERT INTO tipo_devoluciones (tipo_devolucion) VALUES ('Producto defectuoso');
INSERT INTO tipo_devoluciones (tipo_devolucion) VALUES ('Error de compra');
INSERT INTO tipo_devoluciones (tipo_devolucion) VALUES ('Garantía');
INSERT INTO tipo_devoluciones (tipo_devolucion) VALUES ('Producto no compatible');
INSERT INTO tipo_devoluciones (tipo_devolucion) VALUES ('Otro');
COMMIT;

-- Categorías
INSERT INTO categoria (nombre) VALUES ('Lubricantes');
INSERT INTO categoria (nombre) VALUES ('Filtros');
INSERT INTO categoria (nombre) VALUES ('Aditivos');
INSERT INTO categoria (nombre) VALUES ('Refrigerantes');
INSERT INTO categoria (nombre) VALUES ('Frenos');
INSERT INTO categoria (nombre) VALUES ('Limpieza');
INSERT INTO categoria (nombre) VALUES ('Accesorios');
INSERT INTO categoria (nombre) VALUES ('Iluminación');
INSERT INTO categoria (nombre) VALUES ('Neumáticos');
INSERT INTO categoria (nombre) VALUES ('Herramientas');
COMMIT;


-- 6. INSERTS DE DATOS DE NEGOCIO (Sucursales, Proveedores, Clientes, Trabajadores, Productos, etc.)

-- Sucursales
INSERT INTO sucursales (nombre, estado) VALUES ('Pejivalle Distrito de Carmen', 'Activo');
INSERT INTO sucursales (nombre, estado) VALUES ('Pejivalle Distrito de Carmen', 'Activo');
INSERT INTO sucursales (nombre, estado) VALUES ('Pejivalle Distrito de Merced', 'Activo');
INSERT INTO sucursales (nombre, estado) VALUES ('Pejivalle Distrito de Hospital', 'Activo');
INSERT INTO sucursales (nombre, estado) VALUES ('Pejivalle Distrito de Catedral', 'Activo');
INSERT INTO sucursales (nombre, estado) VALUES ('Pejivalle Distrito de Zapote,}', 'Activo');
INSERT INTO sucursales (nombre, estado) VALUES ('Pejivalle Distrito de Desamparados', 'Activo');
INSERT INTO sucursales (nombre, estado) VALUES ('Pejivalle Distrito de San Miguel', 'Activo');
INSERT INTO sucursales (nombre, estado) VALUES ('Pejivalle Distrito de San Juan de Dios', 'Activo');
INSERT INTO sucursales (nombre, estado) VALUES ('Pejivalle Distrito de Curridabat', 'Activo');
INSERT INTO sucursales (nombre, estado) VALUES ('Pejivalle Distrito de Granadilla', 'Activo');
INSERT INTO sucursales (nombre, estado) VALUES ('Pejivalle Distrito de Tirrases', 'Activo');
INSERT INTO sucursales (nombre, estado) VALUES ('Pejivalle Distrito de Zapote', 'Activo');
INSERT INTO sucursales (nombre, estado) VALUES ('Pejivalle Distrito de San Francisco de Dos Ríos', 'Activo');
INSERT INTO sucursales (nombre, estado) VALUES ('Pejivalle Distrito de Alajuela', 'Activo');
INSERT INTO sucursales (nombre, estado) VALUES ('Pejivalle Distrito de San José', 'Activo');
INSERT INTO sucursales (nombre, estado) VALUES ('Pejivalle Distrito de Desamparados de Alajuela', 'Activo');
INSERT INTO sucursales (nombre, estado) VALUES ('Pejivalle Distrito de San Ramón', 'Activo');
INSERT INTO sucursales (nombre, estado) VALUES ('Pejivalle Distrito de Santiago', 'Activo');
INSERT INTO sucursales (nombre, estado) VALUES ('Pejivalle Distrito de Piedades Norte', 'Activo');
INSERT INTO sucursales (nombre, estado) VALUES ('Pejivalle Distrito de Grecia', 'Activo');
INSERT INTO sucursales (nombre, estado) VALUES ('Pejivalle Distrito de San Roque', 'Activo');
INSERT INTO sucursales (nombre, estado) VALUES ('Pejivalle Distrito de Cartago', 'Activo');
INSERT INTO sucursales (nombre, estado) VALUES ('Pejivalle Distrito de Oriental', 'Activo');
INSERT INTO sucursales (nombre, estado) VALUES ('Pejivalle Distrito de Occidental', 'Activo');
INSERT INTO sucursales (nombre, estado) VALUES ('Pejivalle Distrito de Paraíso', 'Activo');
INSERT INTO sucursales (nombre, estado) VALUES ('Pejivalle Distrito de Santiago', 'Activo');
INSERT INTO sucursales (nombre, estado) VALUES ('Pejivalle Distrito de Heredia', 'Activo');
INSERT INTO sucursales (nombre, estado) VALUES ('Pejivalle Distrito de Mercedes)', 'Activo');
INSERT INTO sucursales (nombre, estado) VALUES ('Pejivalle Distrito de San Francisco', 'Activo');
INSERT INTO sucursales (nombre, estado) VALUES ('Pejivalle Distrito de Barva', 'Activo');
INSERT INTO sucursales (nombre, estado) VALUES ('Pejivalle Distrito de San Pedro', 'Activo');
INSERT INTO sucursales (nombre, estado) VALUES ('Pejivalle Distrito de Liberia', 'Activo');
INSERT INTO sucursales (nombre, estado) VALUES ('Pejivalle Distrito de Cañas Dulces', 'Activo');
INSERT INTO sucursales (nombre, estado) VALUES ('Pejivalle Distrito de Nicoya', 'Activo');
INSERT INTO sucursales (nombre, estado) VALUES ('Pejivalle Distrito de Sámara', 'Activo');
INSERT INTO sucursales (nombre, estado) VALUES ('Pejivalle Distrito de Puntarenas', 'Activo');
INSERT INTO sucursales (nombre, estado) VALUES ('Pejivalle Distrito de El Roble', 'Activo');
INSERT INTO sucursales (nombre, estado) VALUES ('Pejivalle Distrito de Esparza', 'Activo');
INSERT INTO sucursales (nombre, estado) VALUES ('Pejivalle Distrito de Limón', 'Activo');
INSERT INTO sucursales (nombre, estado) VALUES ('Pejivalle Distrito de Valle La Estrella', 'Activo');
INSERT INTO sucursales (nombre, estado) VALUES ('Pejivalle Distrito de Guápiles', 'Activo');
INSERT INTO sucursales (nombre, estado) VALUES ('Pejivalle Distrito de Jiménez', 'Activo');
INSERT INTO sucursales (nombre, estado) VALUES ('Pejivalle Distrito de Siquirres', 'Activo');
INSERT INTO sucursales (nombre, estado) VALUES ('Pejivalle Distrito de Florida', 'Activo');
INSERT INTO sucursales (nombre, estado) VALUES ('Pejivalle Distrito de Talamanca', 'Activo');
INSERT INTO sucursales (nombre, estado) VALUES ('Pejivalle Distrito de Bratsi,', 'Activo');
INSERT INTO sucursales (nombre, estado) VALUES ('Pejivalle Distrito de Matina,', 'Activo');
INSERT INTO sucursales (nombre, estado) VALUES ('Pejivalle Distrito de Batán,', 'Activo');
COMMIT;

-- Sucursales_Direcciones 
INSERT INTO sucursales_direcciones (id_sucursal, id_direccion) VALUES (1,1);
INSERT INTO sucursales_direcciones (id_sucursal, id_direccion) VALUES (2,2);
INSERT INTO sucursales_direcciones (id_sucursal, id_direccion) VALUES (3,3);
INSERT INTO sucursales_direcciones (id_sucursal, id_direccion) VALUES (4,4);
INSERT INTO sucursales_direcciones (id_sucursal, id_direccion) VALUES (5,5);
INSERT INTO sucursales_direcciones (id_sucursal, id_direccion) VALUES (6,6);
INSERT INTO sucursales_direcciones (id_sucursal, id_direccion) VALUES (7,7);
INSERT INTO sucursales_direcciones (id_sucursal, id_direccion) VALUES (8,8);
INSERT INTO sucursales_direcciones (id_sucursal, id_direccion) VALUES (9,9);
INSERT INTO sucursales_direcciones (id_sucursal, id_direccion) VALUES (10,10);
INSERT INTO sucursales_direcciones (id_sucursal, id_direccion) VALUES (11,11);
INSERT INTO sucursales_direcciones (id_sucursal, id_direccion) VALUES (12,12);
INSERT INTO sucursales_direcciones (id_sucursal, id_direccion) VALUES (13,13);
INSERT INTO sucursales_direcciones (id_sucursal, id_direccion) VALUES (14,14);
INSERT INTO sucursales_direcciones (id_sucursal, id_direccion) VALUES (15,15);
INSERT INTO sucursales_direcciones (id_sucursal, id_direccion) VALUES (16,16);
INSERT INTO sucursales_direcciones (id_sucursal, id_direccion) VALUES (17,17);
INSERT INTO sucursales_direcciones (id_sucursal, id_direccion) VALUES (18,18);
INSERT INTO sucursales_direcciones (id_sucursal, id_direccion) VALUES (19,19);
INSERT INTO sucursales_direcciones (id_sucursal, id_direccion) VALUES (20,20);
INSERT INTO sucursales_direcciones (id_sucursal, id_direccion) VALUES (21,21);
INSERT INTO sucursales_direcciones (id_sucursal, id_direccion) VALUES (22,22);
INSERT INTO sucursales_direcciones (id_sucursal, id_direccion) VALUES (23,23);
INSERT INTO sucursales_direcciones (id_sucursal, id_direccion) VALUES (24,24);
INSERT INTO sucursales_direcciones (id_sucursal, id_direccion) VALUES (25,25);
INSERT INTO sucursales_direcciones (id_sucursal, id_direccion) VALUES (26,26);
INSERT INTO sucursales_direcciones (id_sucursal, id_direccion) VALUES (27,27);
INSERT INTO sucursales_direcciones (id_sucursal, id_direccion) VALUES (28,28);
INSERT INTO sucursales_direcciones (id_sucursal, id_direccion) VALUES (29,29);
INSERT INTO sucursales_direcciones (id_sucursal, id_direccion) VALUES (30,30);
INSERT INTO sucursales_direcciones (id_sucursal, id_direccion) VALUES (31,31);
INSERT INTO sucursales_direcciones (id_sucursal, id_direccion) VALUES (32,32);
INSERT INTO sucursales_direcciones (id_sucursal, id_direccion) VALUES (33,33);
INSERT INTO sucursales_direcciones (id_sucursal, id_direccion) VALUES (34,34);
INSERT INTO sucursales_direcciones (id_sucursal, id_direccion) VALUES (35,35);
INSERT INTO sucursales_direcciones (id_sucursal, id_direccion) VALUES (36,36);
INSERT INTO sucursales_direcciones (id_sucursal, id_direccion) VALUES (37,37);
INSERT INTO sucursales_direcciones (id_sucursal, id_direccion) VALUES (38,38);
INSERT INTO sucursales_direcciones (id_sucursal, id_direccion) VALUES (39,39);
INSERT INTO sucursales_direcciones (id_sucursal, id_direccion) VALUES (40,40);
INSERT INTO sucursales_direcciones (id_sucursal, id_direccion) VALUES (41,41);
INSERT INTO sucursales_direcciones (id_sucursal, id_direccion) VALUES (42,42);
INSERT INTO sucursales_direcciones (id_sucursal, id_direccion) VALUES (43,43);
INSERT INTO sucursales_direcciones (id_sucursal, id_direccion) VALUES (44,44);
INSERT INTO sucursales_direcciones (id_sucursal, id_direccion) VALUES (45,45);
INSERT INTO sucursales_direcciones (id_sucursal, id_direccion) VALUES (46,46);
INSERT INTO sucursales_direcciones (id_sucursal, id_direccion) VALUES (47,47);
INSERT INTO sucursales_direcciones (id_sucursal, id_direccion) VALUES (48,48);
INSERT INTO sucursales_direcciones (id_sucursal, id_direccion) VALUES (49,49);
INSERT INTO sucursales_direcciones (id_sucursal, id_direccion) VALUES (50,50);
COMMIT;

-- Proveedores 
INSERT INTO proveedores (nombre_proveedor, nombre_contacto, apellido1, apellido2, correo_electr, telefono) 
VALUES ('Motul Costa Rica', 'Carlos', 'Ramírez', 'Vargas', 'motul.cr@example.com', '22221101');
INSERT INTO proveedores (nombre_proveedor, nombre_contacto, apellido1, apellido2, correo_electr, telefono) 
VALUES ('Castrol Distribución', 'Andrea', 'Soto', 'Mora', 'castrol.cr@example.com', '22221102');
INSERT INTO proveedores (nombre_proveedor, nombre_contacto, apellido1, apellido2, correo_electr, telefono) 
VALUES ('Shell Helix CR', 'Jorge', 'Hernández', 'Soto', 'shell.cr@example.com', '22221103');
INSERT INTO proveedores (nombre_proveedor, nombre_contacto, apellido1, apellido2, correo_electr, telefono) 
VALUES ('Valvoline CR', 'Paula', 'González', 'Vega', 'valvoline.cr@example.com', '22221104');
INSERT INTO proveedores (nombre_proveedor, nombre_contacto, apellido1, apellido2, correo_electr, telefono) 
VALUES ('TotalEnergies CR', 'Luis', 'Jiménez', 'Araya', 'total.cr@example.com', '22221105');
INSERT INTO proveedores (nombre_proveedor, nombre_contacto, apellido1, apellido2, correo_electr, telefono) 
VALUES ('MANN-FILTER', 'Sofía', 'Rodríguez', 'Chacón', 'mann.cr@example.com', '22221106');
INSERT INTO proveedores (nombre_proveedor, nombre_contacto, apellido1, apellido2, correo_electr, telefono) 
VALUES ('Bosch Autopartes', 'Daniel', 'Pérez', 'Segura', 'bosch.cr@example.com', '22221107');
INSERT INTO proveedores (nombre_proveedor, nombre_contacto, apellido1, apellido2, correo_electr, telefono) 
VALUES ('FRAM Filtros', 'Natalia', 'Sánchez', 'Ureña', 'fram.cr@example.com', '22221108');
INSERT INTO proveedores (nombre_proveedor, nombre_contacto, apellido1, apellido2, correo_electr, telefono) 
VALUES ('Mobil 1', 'Ricardo', 'Vargas', 'Méndez', 'mobil1.cr@example.com', '22221109');
INSERT INTO proveedores (nombre_proveedor, nombre_contacto, apellido1, apellido2, correo_electr, telefono) 
VALUES ('Liqui Moly', 'Fernanda', 'Castro', 'Valverde', 'liquimoly.cr@example.com', '22221110');
COMMIT;

-- Proveedores_Direcciones
INSERT INTO proveedores_direcciones (id_proveedor, id_direccion) VALUES (1,1);
INSERT INTO proveedores_direcciones (id_proveedor, id_direccion) VALUES (2,2);
INSERT INTO proveedores_direcciones (id_proveedor, id_direccion) VALUES (3,3);
INSERT INTO proveedores_direcciones (id_proveedor, id_direccion) VALUES (4,4);
INSERT INTO proveedores_direcciones (id_proveedor, id_direccion) VALUES (5,5);
INSERT INTO proveedores_direcciones (id_proveedor, id_direccion) VALUES (6,6);
INSERT INTO proveedores_direcciones (id_proveedor, id_direccion) VALUES (7,7);
INSERT INTO proveedores_direcciones (id_proveedor, id_direccion) VALUES (8,8);
INSERT INTO proveedores_direcciones (id_proveedor, id_direccion) VALUES (9,9);
INSERT INTO proveedores_direcciones (id_proveedor, id_direccion) VALUES (10,10);
COMMIT;

-- Clientes 
INSERT INTO clientes VALUES ('110002000', 'María', 'González', 'Soto', 'maria.gonzalez01@gmail.com', '86000000');
INSERT INTO clientes VALUES ('210012001', 'Ana', 'Rodríguez', 'Méndez', 'ana.rodriguez02@hotmail.com', '86000001');
INSERT INTO clientes VALUES ('310022002', 'Sofía', 'Hernández', 'Vega', 'sofia.hernandez03@icloud.com', '86000002');
INSERT INTO clientes VALUES ('410032003', 'Valeria', 'Pérez', 'Cordero', 'valeria.perez04@outlook.com', '86000003');
INSERT INTO clientes VALUES ('510042004', 'Camila', 'Sánchez', 'Madrigal', 'camila.sanchez05@yahoo.com', '86000004');
INSERT INTO clientes VALUES ('610052005', 'Isabella', 'Ramírez', 'Segura', 'isabella.ramirez06@gmail.com', '86000005');
INSERT INTO clientes VALUES ('710062006', 'Daniela', 'Cruz', 'Araya', 'daniela.cruz07@hotmail.com', '86000006');
INSERT INTO clientes VALUES ('110072007', 'Gabriela', 'Vargas', 'Chacón', 'gabriela.vargas08@icloud.com', '86000007');
INSERT INTO clientes VALUES ('210082008', 'Paula', 'Jiménez', 'Villalobos', 'paula.jimenez09@outlook.com', '86000008');
INSERT INTO clientes VALUES ('310092009', 'Lucía', 'Mora', 'Valverde', 'lucia.mora10@yahoo.com', '86000009');
INSERT INTO clientes VALUES ('410102010', 'Karla', 'Castro', 'Ureña', 'karla.castro11@gmail.com', '86000010');
INSERT INTO clientes VALUES ('510112011', 'Andrea', 'Rojas', 'Zúñiga', 'andrea.rojas12@hotmail.com', '86000011');
INSERT INTO clientes VALUES ('610122012', 'Laura', 'Alvarado', 'Brenes', 'laura.alvarado13@icloud.com', '86000012');
INSERT INTO clientes VALUES ('710132013', 'Natalia', 'Solís', 'Pacheco', 'natalia.solis14@outlook.com', '86000013');
INSERT INTO clientes VALUES ('110142014', 'Fernanda', 'Arias', 'Muñoz', 'fernanda.arias15@yahoo.com', '86000014');
INSERT INTO clientes VALUES ('210152015', 'Diana', 'Aguilar', 'Fonseca', 'diana.aguilar16@gmail.com', '86000015');
INSERT INTO clientes VALUES ('310162016', 'Melanie', 'Navarro', 'Núñez', 'melanie.navarro17@hotmail.com', '86000016');
INSERT INTO clientes VALUES ('410172017', 'Alejandra', 'Campos', 'Guzmán', 'alejandra.campos18@icloud.com', '86000017');
INSERT INTO clientes VALUES ('510182018', 'Carolina', 'Quesada', 'Céspedes', 'carolina.quesada19@outlook.com', '86000018');
INSERT INTO clientes VALUES ('610192019', 'Victoria', 'Salas', 'Soto', 'victoria.salas20@yahoo.com', '86000019');
INSERT INTO clientes VALUES ('710202020', 'José', 'González', 'Méndez', 'jose.gonzalez21@gmail.com', '86000020');
INSERT INTO clientes VALUES ('110212021', 'Juan', 'Rodríguez', 'Vega', 'juan.rodriguez22@hotmail.com', '86000021');
INSERT INTO clientes VALUES ('210222022', 'Carlos', 'Hernández', 'Cordero', 'carlos.hernandez23@icloud.com', '86000022');
INSERT INTO clientes VALUES ('310232023', 'Luis', 'Pérez', 'Madrigal', 'luis.perez24@outlook.com', '86000023');
INSERT INTO clientes VALUES ('410242024', 'Daniel', 'Sánchez', 'Segura', 'daniel.sanchez25@yahoo.com', '86000024');
INSERT INTO clientes VALUES ('510252025', 'Andrés', 'Ramírez', 'Araya', 'andres.ramirez26@gmail.com', '86000025');
INSERT INTO clientes VALUES ('610262026', 'Jorge', 'Cruz', 'Chacón', 'jorge.cruz27@hotmail.com', '86000026');
INSERT INTO clientes VALUES ('710272027', 'David', 'Vargas', 'Villalobos', 'david.vargas28@icloud.com', '86000027');
INSERT INTO clientes VALUES ('110282028', 'Kevin', 'Jiménez', 'Valverde', 'kevin.jimenez29@outlook.com', '86000028');
INSERT INTO clientes VALUES ('210292029', 'Fernando', 'Mora', 'Ureña', 'fernando.mora30@yahoo.com', '86000029');
INSERT INTO clientes VALUES ('310302030', 'Ricardo', 'Castro', 'Zúñiga', 'ricardo.castro31@gmail.com', '86000030');
INSERT INTO clientes VALUES ('410312031', 'Sebastián', 'Rojas', 'Brenes', 'sebastian.rojas32@hotmail.com', '86000031');
INSERT INTO clientes VALUES ('510322032', 'Diego', 'Alvarado', 'Pacheco', 'diego.alvarado33@icloud.com', '86000032');
INSERT INTO clientes VALUES ('610332033', 'Pablo', 'Solís', 'Muñoz', 'pablo.solis34@outlook.com', '86000033');
INSERT INTO clientes VALUES ('710342034', 'Marco', 'Arias', 'Fonseca', 'marco.arias35@yahoo.com', '86000034');
INSERT INTO clientes VALUES ('110352035', 'Esteban', 'Aguilar', 'Núñez', 'esteban.aguilar36@gmail.com', '86000035');
INSERT INTO clientes VALUES ('210362036', 'Emilio', 'Navarro', 'Guzmán', 'emilio.navarro37@hotmail.com', '86000036');
INSERT INTO clientes VALUES ('310372037', 'Mateo', 'Campos', 'Céspedes', 'mateo.campos38@icloud.com', '86000037');
INSERT INTO clientes VALUES ('410382038', 'Alejandro', 'Quesada', 'Soto', 'alejandro.quesada39@outlook.com', '86000038');
INSERT INTO clientes VALUES ('510392039', 'Héctor', 'Salas', 'Méndez', 'hector.salas40@yahoo.com', '86000039');
INSERT INTO clientes VALUES ('610402040', 'Vanessa', 'González', 'Vega', 'vanessa.gonzalez41@gmail.com', '86000040');
INSERT INTO clientes VALUES ('710412041', 'Monserrat', 'Rodríguez', 'Cordero', 'monserrat.rodriguez42@hotmail.com', '86000041');
INSERT INTO clientes VALUES ('110422042', 'Rocío', 'Hernández', 'Madrigal', 'rocio.hernandez43@icloud.com', '86000042');
INSERT INTO clientes VALUES ('210432043', 'Karen', 'Pérez', 'Segura', 'karen.perez44@outlook.com', '86000043');
INSERT INTO clientes VALUES ('310442044', 'Cristina', 'Sánchez', 'Araya', 'cristina.sanchez45@yahoo.com', '86000044');
INSERT INTO clientes VALUES ('410452045', 'Patricia', 'Ramírez', 'Chacón', 'patricia.ramirez46@gmail.com', '86000045');
INSERT INTO clientes VALUES ('510462046', 'Mónica', 'Cruz', 'Villalobos', 'monica.cruz47@hotmail.com', '86000046');
INSERT INTO clientes VALUES ('610472047', 'Lorena', 'Vargas', 'Valverde', 'lorena.vargas48@icloud.com', '86000047');
INSERT INTO clientes VALUES ('710482048', 'Paola', 'Jiménez', 'Ureña', 'paola.jimenez49@outlook.com', '86000048');
INSERT INTO clientes VALUES ('110492049', 'Jimena', 'Mora', 'Zúñiga', 'jimena.mora50@yahoo.com', '86000049');
COMMIT;

-- Clientes_Direcciones 
INSERT INTO clientes_direcciones (cedula, id_direccion) VALUES ('110002000',1);
INSERT INTO clientes_direcciones (cedula, id_direccion) VALUES ('210012001',2);
INSERT INTO clientes_direcciones (cedula, id_direccion) VALUES ('310022002',3);
INSERT INTO clientes_direcciones (cedula, id_direccion) VALUES ('410032003',4);
INSERT INTO clientes_direcciones (cedula, id_direccion) VALUES ('510042004',5);
INSERT INTO clientes_direcciones (cedula, id_direccion) VALUES ('610052005',6);
INSERT INTO clientes_direcciones (cedula, id_direccion) VALUES ('710062006',7);
INSERT INTO clientes_direcciones (cedula, id_direccion) VALUES ('110072007',8);
INSERT INTO clientes_direcciones (cedula, id_direccion) VALUES ('210082008',9);
INSERT INTO clientes_direcciones (cedula, id_direccion) VALUES ('310092009',10);
INSERT INTO clientes_direcciones (cedula, id_direccion) VALUES ('410102010',11);
INSERT INTO clientes_direcciones (cedula, id_direccion) VALUES ('510112011',12);
INSERT INTO clientes_direcciones (cedula, id_direccion) VALUES ('610122012',13);
INSERT INTO clientes_direcciones (cedula, id_direccion) VALUES ('710132013',14);
INSERT INTO clientes_direcciones (cedula, id_direccion) VALUES ('110142014',15);
INSERT INTO clientes_direcciones (cedula, id_direccion) VALUES ('210152015',16);
INSERT INTO clientes_direcciones (cedula, id_direccion) VALUES ('310162016',17);
INSERT INTO clientes_direcciones (cedula, id_direccion) VALUES ('410172017',18);
INSERT INTO clientes_direcciones (cedula, id_direccion) VALUES ('510182018',19);
INSERT INTO clientes_direcciones (cedula, id_direccion) VALUES ('610192019',20);
INSERT INTO clientes_direcciones (cedula, id_direccion) VALUES ('710202020',21);
INSERT INTO clientes_direcciones (cedula, id_direccion) VALUES ('110212021',22);
INSERT INTO clientes_direcciones (cedula, id_direccion) VALUES ('210222022',23);
INSERT INTO clientes_direcciones (cedula, id_direccion) VALUES ('310232023',24);
INSERT INTO clientes_direcciones (cedula, id_direccion) VALUES ('410242024',25);
INSERT INTO clientes_direcciones (cedula, id_direccion) VALUES ('510252025',26);
INSERT INTO clientes_direcciones (cedula, id_direccion) VALUES ('610262026',27);
INSERT INTO clientes_direcciones (cedula, id_direccion) VALUES ('710272027',28);
INSERT INTO clientes_direcciones (cedula, id_direccion) VALUES ('110282028',29);
INSERT INTO clientes_direcciones (cedula, id_direccion) VALUES ('210292029',30);
INSERT INTO clientes_direcciones (cedula, id_direccion) VALUES ('310302030',31);
INSERT INTO clientes_direcciones (cedula, id_direccion) VALUES ('410312031',32);
INSERT INTO clientes_direcciones (cedula, id_direccion) VALUES ('510322032',33);
INSERT INTO clientes_direcciones (cedula, id_direccion) VALUES ('610332033',34);
INSERT INTO clientes_direcciones (cedula, id_direccion) VALUES ('710342034',35);
INSERT INTO clientes_direcciones (cedula, id_direccion) VALUES ('110352035',36);
INSERT INTO clientes_direcciones (cedula, id_direccion) VALUES ('210362036',37);
INSERT INTO clientes_direcciones (cedula, id_direccion) VALUES ('310372037',38);
INSERT INTO clientes_direcciones (cedula, id_direccion) VALUES ('410382038',39);
INSERT INTO clientes_direcciones (cedula, id_direccion) VALUES ('510392039',40);
INSERT INTO clientes_direcciones (cedula, id_direccion) VALUES ('610402040',41);
INSERT INTO clientes_direcciones (cedula, id_direccion) VALUES ('710412041',42);
INSERT INTO clientes_direcciones (cedula, id_direccion) VALUES ('110422042',43);
INSERT INTO clientes_direcciones (cedula, id_direccion) VALUES ('210432043',44);
INSERT INTO clientes_direcciones (cedula, id_direccion) VALUES ('310442044',45);
INSERT INTO clientes_direcciones (cedula, id_direccion) VALUES ('410452045',46);
INSERT INTO clientes_direcciones (cedula, id_direccion) VALUES ('510462046',47);
INSERT INTO clientes_direcciones (cedula, id_direccion) VALUES ('610472047',48);
INSERT INTO clientes_direcciones (cedula, id_direccion) VALUES ('710482048',49);
INSERT INTO clientes_direcciones (cedula, id_direccion) VALUES ('110492049',50);
COMMIT;

-- Trabajadores
INSERT INTO trabajadores (nombre, apellido1, apellido2, identificacion, correo_electronico, estado, id_sucursal, id_turno, id_rol) 
VALUES ('Karla', 'Pérez', 'Chacón', 'T-3000', 'karla.perez01@pejivalle.cr', 'Activo', 1, 2, 2);
INSERT INTO trabajadores (nombre, apellido1, apellido2, identificacion, correo_electronico, estado, id_sucursal, id_turno, id_rol) 
VALUES ('Andrea', 'Sánchez', 'Villalobos', 'T-3001', 'andrea.sanchez02@pejivalle.cr', 'Activo', 2, 1, 3);
INSERT INTO trabajadores (nombre, apellido1, apellido2, identificacion, correo_electronico, estado, id_sucursal, id_turno, id_rol) 
VALUES ('Laura', 'Ramírez', 'Valverde', 'T-3002', 'laura.ramirez03@pejivalle.cr', 'Activo', 3, 2, 3);
INSERT INTO trabajadores (nombre, apellido1, apellido2, identificacion, correo_electronico, estado, id_sucursal, id_turno, id_rol) 
VALUES ('Natalia', 'Cruz', 'Ureña', 'T-3003', 'natalia.cruz04@pejivalle.cr', 'Activo', 4, 1, 2);
INSERT INTO trabajadores (nombre, apellido1, apellido2, identificacion, correo_electronico, estado, id_sucursal, id_turno, id_rol) 
VALUES ('Fernanda', 'Vargas', 'Zúñiga', 'T-3004', 'fernanda.vargas05@pejivalle.cr', 'Activo', 5, 2, 3);
INSERT INTO trabajadores (nombre, apellido1, apellido2, identificacion, correo_electronico, estado, id_sucursal, id_turno, id_rol) 
VALUES ('Diana', 'Jiménez', 'Brenes', 'T-3005', 'diana.jimenez06@pejivalle.cr', 'Activo', 1, 1, 3);
INSERT INTO trabajadores (nombre, apellido1, apellido2, identificacion, correo_electronico, estado, id_sucursal, id_turno, id_rol) 
VALUES ('Melanie', 'Mora', 'Pacheco', 'T-3006', 'melanie.mora07@pejivalle.cr', 'Activo', 2, 2, 2);
INSERT INTO trabajadores (nombre, apellido1, apellido2, identificacion, correo_electronico, estado, id_sucursal, id_turno, id_rol) 
VALUES ('Alejandra', 'Castro', 'Muñoz', 'T-3007', 'alejandra.castro08@pejivalle.cr', 'Activo', 3, 2, 3);
INSERT INTO trabajadores (nombre, apellido1, apellido2, identificacion, correo_electronico, estado, id_sucursal, id_turno, id_rol) 
VALUES ('Carolina', 'Rojas', 'Fonseca', 'T-3008', 'carolina.rojas09@pejivalle.cr', 'Activo', 4, 2, 3);
INSERT INTO trabajadores (nombre, apellido1, apellido2, identificacion, correo_electronico, estado, id_sucursal, id_turno, id_rol) 
VALUES ('Victoria', 'Alvarado', 'Núñez', 'T-3009', 'victoria.alvarado10@pejivalle.cr', 'Activo', 5, 1, 2);
INSERT INTO trabajadores (nombre, apellido1, apellido2, identificacion, correo_electronico, estado, id_sucursal, id_turno, id_rol) 
VALUES ('José', 'Solís', 'Guzmán', 'T-3010', 'jose.solis11@pejivalle.cr', 'Activo', 1, 2, 3);
INSERT INTO trabajadores (nombre, apellido1, apellido2, identificacion, correo_electronico, estado, id_sucursal, id_turno, id_rol) 
VALUES ('Juan', 'Arias', 'Céspedes', 'T-3011', 'juan.arias12@pejivalle.cr', 'Activo', 2, 1, 3);
INSERT INTO trabajadores (nombre, apellido1, apellido2, identificacion, correo_electronico, estado, id_sucursal, id_turno, id_rol) 
VALUES ('Carlos', 'Aguilar', 'Soto', 'T-3012', 'carlos.aguilar13@pejivalle.cr', 'Activo', 3, 2, 2);
INSERT INTO trabajadores (nombre, apellido1, apellido2, identificacion, correo_electronico, estado, id_sucursal, id_turno, id_rol) 
VALUES ('Luis', 'Navarro', 'Méndez', 'T-3013', 'luis.navarro14@pejivalle.cr', 'Activo', 4, 1, 3);
INSERT INTO trabajadores (nombre, apellido1, apellido2, identificacion, correo_electronico, estado, id_sucursal, id_turno, id_rol) 
VALUES ('Daniel', 'Campos', 'Vega', 'T-3014', 'daniel.campos15@pejivalle.cr', 'Activo', 5, 2, 3);
INSERT INTO trabajadores (nombre, apellido1, apellido2, identificacion, correo_electronico, estado, id_sucursal, id_turno, id_rol) 
VALUES ('Andrés', 'Quesada', 'Cordero', 'T-3015', 'andres.quesada16@pejivalle.cr', 'Activo', 1, 2, 2);
INSERT INTO trabajadores (nombre, apellido1, apellido2, identificacion, correo_electronico, estado, id_sucursal, id_turno, id_rol) 
VALUES ('Jorge', 'Salas', 'Madrigal', 'T-3016', 'jorge.salas17@pejivalle.cr', 'Activo', 2, 2, 3);
INSERT INTO trabajadores (nombre, apellido1, apellido2, identificacion, correo_electronico, estado, id_sucursal, id_turno, id_rol) 
VALUES ('David', 'González', 'Segura', 'T-3017', 'david.gonzalez18@pejivalle.cr', 'Activo', 3, 1, 2);
INSERT INTO trabajadores (nombre, apellido1, apellido2, identificacion, correo_electronico, estado, id_sucursal, id_turno, id_rol) 
VALUES ('Kevin', 'Rodríguez', 'Araya', 'T-3018', 'kevin.rodriguez19@pejivalle.cr', 'Activo', 4, 2, 2);
INSERT INTO trabajadores (nombre, apellido1, apellido2, identificacion, correo_electronico, estado, id_sucursal, id_turno, id_rol) 
VALUES ('Fernando', 'Hernández', 'Chacón', 'T-3019', 'fernando.hernandez20@pejivalle.cr', 'Activo', 5, 1, 3);
INSERT INTO trabajadores (nombre, apellido1, apellido2, identificacion, correo_electronico, estado, id_sucursal, id_turno, id_rol) 
VALUES ('Ricardo', 'Pérez', 'Villalobos', 'T-3020', 'ricardo.perez21@pejivalle.cr', 'Activo', 1, 2, 1);
INSERT INTO trabajadores (nombre, apellido1, apellido2, identificacion, correo_electronico, estado, id_sucursal, id_turno, id_rol) 
VALUES ('Sebastián', 'Sánchez', 'Valverde', 'T-3021', 'sebastian.sanchez22@pejivalle.cr', 'Activo', 2, 1, 2);
INSERT INTO trabajadores (nombre, apellido1, apellido2, identificacion, correo_electronico, estado, id_sucursal, id_turno, id_rol) 
VALUES ('Diego', 'Ramírez', 'Ureña', 'T-3022', 'diego.ramirez23@pejivalle.cr', 'Activo', 3, 2, 2);
INSERT INTO trabajadores (nombre, apellido1, apellido2, identificacion, correo_electronico, estado, id_sucursal, id_turno, id_rol) 
VALUES ('Pablo', 'Cruz', 'Zúñiga', 'T-3023', 'pablo.cruz24@pejivalle.cr', 'Activo', 4, 2, 1);
INSERT INTO trabajadores (nombre, apellido1, apellido2, identificacion, correo_electronico, estado, id_sucursal, id_turno, id_rol) 
VALUES ('Marco', 'Vargas', 'Brenes', 'T-3024', 'marco.vargas25@pejivalle.cr', 'Activo', 5, 2, 2);
INSERT INTO trabajadores (nombre, apellido1, apellido2, identificacion, correo_electronico, estado, id_sucursal, id_turno, id_rol) 
VALUES ('Esteban', 'Jiménez', 'Pacheco', 'T-3025', 'esteban.jimenez26@pejivalle.cr', 'Activo', 1, 2, 3);
INSERT INTO trabajadores (nombre, apellido1, apellido2, identificacion, correo_electronico, estado, id_sucursal, id_turno, id_rol) 
VALUES ('Emilio', 'Mora', 'Muñoz', 'T-3026', 'emilio.mora27@pejivalle.cr', 'Activo', 2, 2, 3);
INSERT INTO trabajadores (nombre, apellido1, apellido2, identificacion, correo_electronico, estado, id_sucursal, id_turno, id_rol) 
VALUES ('Mateo', 'Castro', 'Fonseca', 'T-3027', 'mateo.castro28@pejivalle.cr', 'Activo', 3, 1, 2);
INSERT INTO trabajadores (nombre, apellido1, apellido2, identificacion, correo_electronico, estado, id_sucursal, id_turno, id_rol) 
VALUES ('Alejandro', 'Rojas', 'Núñez', 'T-3028', 'alejandro.rojas29@pejivalle.cr', 'Activo', 4, 2, 3);
INSERT INTO trabajadores (nombre, apellido1, apellido2, identificacion, correo_electronico, estado, id_sucursal, id_turno, id_rol) 
VALUES ('Héctor', 'Alvarado', 'Guzmán', 'T-3029', 'hector.alvarado30@pejivalle.cr', 'Activo', 5, 1, 3);
INSERT INTO trabajadores (nombre, apellido1, apellido2, identificacion, correo_electronico, estado, id_sucursal, id_turno, id_rol) 
VALUES ('Vanessa', 'Solís', 'Céspedes', 'T-3030', 'vanessa.solis31@pejivalle.cr', 'Activo', 1, 2, 2);
INSERT INTO trabajadores (nombre, apellido1, apellido2, identificacion, correo_electronico, estado, id_sucursal, id_turno, id_rol) 
VALUES ('Monserrat', 'Arias', 'Soto', 'T-3031', 'monserrat.arias32@pejivalle.cr', 'Activo', 2, 1, 3);
INSERT INTO trabajadores (nombre, apellido1, apellido2, identificacion, correo_electronico, estado, id_sucursal, id_turno, id_rol) 
VALUES ('Rocío', 'Aguilar', 'Méndez', 'T-3032', 'rocio.aguilar33@pejivalle.cr', 'Activo', 3, 2, 3);
INSERT INTO trabajadores (nombre, apellido1, apellido2, identificacion, correo_electronico, estado, id_sucursal, id_turno, id_rol) 
VALUES ('Karen', 'Navarro', 'Vega', 'T-3033', 'karen.navarro34@pejivalle.cr', 'Activo', 4, 1, 2);
INSERT INTO trabajadores (nombre, apellido1, apellido2, identificacion, correo_electronico, estado, id_sucursal, id_turno, id_rol) 
VALUES ('Cristina', 'Campos', 'Cordero', 'T-3034', 'cristina.campos35@pejivalle.cr', 'Activo', 5, 2, 3);
INSERT INTO trabajadores (nombre, apellido1, apellido2, identificacion, correo_electronico, estado, id_sucursal, id_turno, id_rol) 
VALUES ('Patricia', 'Quesada', 'Madrigal', 'T-3035', 'patricia.quesada36@pejivalle.cr', 'Activo', 1, 2, 3);
INSERT INTO trabajadores (nombre, apellido1, apellido2, identificacion, correo_electronico, estado, id_sucursal, id_turno, id_rol) 
VALUES ('Mónica', 'Salas', 'Segura', 'T-3036', 'monica.salas37@pejivalle.cr', 'Activo', 2, 2, 2);
INSERT INTO trabajadores (nombre, apellido1, apellido2, identificacion, correo_electronico, estado, id_sucursal, id_turno, id_rol) 
VALUES ('Lorena', 'González', 'Araya', 'T-3037', 'lorena.gonzalez38@pejivalle.cr', 'Activo', 3, 1, 3);
INSERT INTO trabajadores (nombre, apellido1, apellido2, identificacion, correo_electronico, estado, id_sucursal, id_turno, id_rol) 
VALUES ('Paola', 'Rodríguez', 'Chacón', 'T-3038', 'paola.rodriguez39@pejivalle.cr', 'Activo', 4, 2, 1);
INSERT INTO trabajadores (nombre, apellido1, apellido2, identificacion, correo_electronico, estado, id_sucursal, id_turno, id_rol) 
VALUES ('Jimena', 'Hernández', 'Villalobos', 'T-3039', 'jimena.hernandez40@pejivalle.cr', 'Activo', 5, 1, 2);
INSERT INTO trabajadores (nombre, apellido1, apellido2, identificacion, correo_electronico, estado, id_sucursal, id_turno, id_rol) 
VALUES ('María', 'Pérez', 'Valverde', 'T-3040', 'maria.perez41@pejivalle.cr', 'Activo', 1, 2, 3);
INSERT INTO trabajadores (nombre, apellido1, apellido2, identificacion, correo_electronico, estado, id_sucursal, id_turno, id_rol) 
VALUES ('Ana', 'Sánchez', 'Ureña', 'T-3041', 'ana.sanchez42@pejivalle.cr', 'Activo', 2, 2, 3);
INSERT INTO trabajadores (nombre, apellido1, apellido2, identificacion, correo_electronico, estado, id_sucursal, id_turno, id_rol) 
VALUES ('Sofía', 'Ramírez', 'Zúñiga', 'T-3042', 'sofia.ramirez43@pejivalle.cr', 'Activo', 3, 2, 2);
INSERT INTO trabajadores (nombre, apellido1, apellido2, identificacion, correo_electronico, estado, id_sucursal, id_turno, id_rol) 
VALUES ('Valeria', 'Cruz', 'Brenes', 'T-3043', 'valeria.cruz44@pejivalle.cr', 'Activo', 4, 2, 3);
INSERT INTO trabajadores (nombre, apellido1, apellido2, identificacion, correo_electronico, estado, id_sucursal, id_turno, id_rol) 
VALUES ('Camila', 'Vargas', 'Pacheco', 'T-3044', 'camila.vargas45@pejivalle.cr', 'Activo', 5, 2, 3);
INSERT INTO trabajadores (nombre, apellido1, apellido2, identificacion, correo_electronico, estado, id_sucursal, id_turno, id_rol) 
VALUES ('Isabella', 'Jiménez', 'Muñoz', 'T-3045', 'isabella.jimenez46@pejivalle.cr', 'Activo', 1, 1, 2);
INSERT INTO trabajadores (nombre, apellido1, apellido2, identificacion, correo_electronico, estado, id_sucursal, id_turno, id_rol) 
VALUES ('Daniela', 'Mora', 'Fonseca', 'T-3046', 'daniela.mora47@pejivalle.cr', 'Activo', 2, 2, 3);
INSERT INTO trabajadores (nombre, apellido1, apellido2, identificacion, correo_electronico, estado, id_sucursal, id_turno, id_rol) 
VALUES ('Gabriela', 'Castro', 'Núñez', 'T-3047', 'gabriela.castro48@pejivalle.cr', 'Activo', 3, 2, 3);
INSERT INTO trabajadores (nombre, apellido1, apellido2, identificacion, correo_electronico, estado, id_sucursal, id_turno, id_rol) 
VALUES ('Paula', 'Rojas', 'Guzmán', 'T-3048', 'paula.rojas49@pejivalle.cr', 'Activo', 4, 2, 2);
INSERT INTO trabajadores (nombre, apellido1, apellido2, identificacion, correo_electronico, estado, id_sucursal, id_turno, id_rol) 
VALUES ('Lucía', 'Alvarado', 'Céspedes', 'T-3049', 'lucia.alvarado50@pejivalle.cr', 'Activo', 5, 2, 3);
COMMIT;


-- 7. VISTAS


CREATE OR REPLACE VIEW vw_vista_clientes_compras AS
SELECT
    c.cedula,
    c.nombre,
    COUNT(v.id_venta) AS cantidad_compras,
    NVL(SUM(v.total), 0) AS total_comprado
FROM clientes c
LEFT JOIN ventas v ON c.cedula = v.cedula
GROUP BY c.cedula, c.nombre;

CREATE OR REPLACE VIEW vw_productos_proveedores AS
SELECT
    p.id_producto,
    p.nombre AS nombre_producto,
    pr.nombre_proveedor,
    pr.nombre_contacto || ' ' || pr.apellido1 || ' ' || pr.apellido2 AS contacto_proveedor
FROM productos p
JOIN proveedores pr ON p.id_proveedor = pr.id_proveedor;

CREATE OR REPLACE VIEW VW_PRODUCTOS AS
SELECT ID_PRODUCTO, NOMBRE, PRECIO_VENTA, PRECIO_COSTO, ID_CATEGORIA FROM PRODUCTOS;

CREATE OR REPLACE VIEW VW_INVENTARIO AS
SELECT ID_PRODUCTOS_SUCURSALES, CANTIDAD, ID_SUCURSAL, ID_PRODUCTO FROM PRODUCTOS_SUCURSALES;

CREATE OR REPLACE VIEW VW_DETALLE_VENTAS AS
SELECT
    v.ID_Venta,
    v.Fecha_Hora,
    v.Cedula,
    c.Nombre || ' ' || c.Apellido1 || ' ' || NVL(c.Apellido2, '') AS Cliente,
    v.ID_Trabajador,
    t.Nombre || ' ' || t.Apellido1 AS Trabajador,
    tp.ID_Tipo_Pago,
    tp.Metodo_Pago,
    v.Total
FROM Ventas v
INNER JOIN Clientes c ON c.Cedula = v.Cedula
INNER JOIN Trabajadores t ON t.ID_Trabajador = v.ID_Trabajador
INNER JOIN Tipo_Pagos tp ON tp.ID_Tipo_Pago = v.ID_Tipo_Pago;

CREATE OR REPLACE VIEW VW_DETALLE_DEVOLUCIONES AS
SELECT
    D.FECHA_HORA,
    D.CEDULA,
    C.NOMBRE || ' ' || C.APELLIDO1 || CASE WHEN C.APELLIDO2 IS NOT NULL THEN ' ' || C.APELLIDO2 ELSE '' END AS CLIENTE,
    P.NOMBRE AS PRODUCTO,
    D.CANTIDAD_DEVUELTA,
    D.MOTIVO,
    TD.TIPO_DEVOLUCION
FROM DEVOLUCION D
INNER JOIN CLIENTES C ON C.CEDULA = D.CEDULA
INNER JOIN PRODUCTOS P ON P.ID_PRODUCTO = D.ID_PRODUCTO
INNER JOIN TIPO_DEVOLUCIONES TD ON TD.ID_TIPO_DEVOLUCION = D.ID_TIPO_DEVOLUCION;

CREATE OR REPLACE VIEW VW_TRABAJADORES_DETALLE AS
SELECT
    T.ID_TRABAJADOR,
    T.IDENTIFICACION,
    T.NOMBRE || ' ' || T.APELLIDO1 || CASE WHEN T.APELLIDO2 IS NOT NULL THEN ' ' || T.APELLIDO2 ELSE '' END AS NOMBRE_COMPLETO,
    T.CORREO_ELECTRONICO,
    T.ESTADO,
    S.ID_SUCURSAL,
    S.NOMBRE AS SUCURSAL,
    TU.ID_TURNO,
    TU.TURNO,
    R.ID_ROL,
    R.ROL
FROM TRABAJADORES T
INNER JOIN SUCURSALES S ON S.ID_SUCURSAL = T.ID_SUCURSAL
INNER JOIN TURNOS TU ON TU.ID_TURNO = T.ID_TURNO
INNER JOIN ROLES R ON R.ID_ROL = T.ID_ROL;

CREATE OR REPLACE VIEW VW_CANTIDAD_TRABAJADORES_ROL AS
SELECT R.ID_ROL, R.ROL, COUNT(T.ID_TRABAJADOR) AS CANTIDAD_TRABAJADORES
FROM ROLES R
LEFT JOIN TRABAJADORES T ON R.ID_ROL = T.ID_ROL
GROUP BY R.ID_ROL, R.ROL
ORDER BY R.ID_ROL;

CREATE OR REPLACE VIEW VW_VENTAS_POR_TRABAJADOR AS
SELECT
    T.IDENTIFICACION,
    T.NOMBRE || ' ' || T.APELLIDO1 || CASE WHEN T.APELLIDO2 IS NOT NULL THEN ' ' || T.APELLIDO2 ELSE '' END AS NOMBRE_COMPLETO,
    R.ROL,
    COUNT(V.ID_VENTA) AS CANTIDAD_VENTAS,
    NVL(SUM(V.TOTAL), 0) AS TOTAL_VENDIDO
FROM TRABAJADORES T
INNER JOIN ROLES R ON R.ID_ROL = T.ID_ROL
LEFT JOIN VENTAS V ON V.ID_TRABAJADOR = T.ID_TRABAJADOR
GROUP BY T.ID_TRABAJADOR, T.IDENTIFICACION, T.NOMBRE, T.APELLIDO1, T.APELLIDO2, R.ROL
ORDER BY TOTAL_VENDIDO DESC;


-- 8. PAQUETES

--  PK_CATEGORIA
CREATE OR REPLACE PACKAGE PK_CATEGORIA AS

    PROCEDURE SP_LISTAR_CATEGORIAS (
        p_cursor OUT SYS_REFCURSOR
    );

    PROCEDURE SP_REGISTRAR_CATEGORIA (
        p_nombre IN CATEGORIA.NOMBRE%TYPE
    );

    PROCEDURE SP_ACTUALIZAR_CATEGORIA (
        p_id_categoria IN CATEGORIA.ID_CATEGORIA%TYPE,
        p_nombre       IN CATEGORIA.NOMBRE%TYPE
    );

    PROCEDURE SP_ELIMINAR_CATEGORIA (
        p_id_categoria IN CATEGORIA.ID_CATEGORIA%TYPE
    );

END PK_CATEGORIA;
/

CREATE OR REPLACE PACKAGE BODY PK_CATEGORIA AS

    PROCEDURE SP_LISTAR_CATEGORIAS (
        p_cursor OUT SYS_REFCURSOR
    )
    AS
    BEGIN
        OPEN p_cursor FOR
            SELECT
                ID_CATEGORIA,
                NOMBRE
            FROM CATEGORIA
            ORDER BY NOMBRE;
    END SP_LISTAR_CATEGORIAS;

    PROCEDURE SP_REGISTRAR_CATEGORIA (
        p_nombre IN CATEGORIA.NOMBRE%TYPE
    )
    AS
    BEGIN
        INSERT INTO CATEGORIA (NOMBRE) VALUES (p_nombre);
        COMMIT;
    END SP_REGISTRAR_CATEGORIA;

    PROCEDURE SP_ACTUALIZAR_CATEGORIA (
        p_id_categoria IN CATEGORIA.ID_CATEGORIA%TYPE,
        p_nombre       IN CATEGORIA.NOMBRE%TYPE
    )
    AS
    BEGIN
        UPDATE CATEGORIA
        SET NOMBRE = NVL(p_nombre, NOMBRE)
        WHERE ID_CATEGORIA = p_id_categoria;

        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20650, 'La categoría indicada no existe.');
        END IF;

        COMMIT;
    END SP_ACTUALIZAR_CATEGORIA;


    PROCEDURE SP_ELIMINAR_CATEGORIA (
        p_id_categoria IN CATEGORIA.ID_CATEGORIA%TYPE
    )
    AS
        v_cantidad NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO v_cantidad
        FROM PRODUCTOS
        WHERE ID_CATEGORIA = p_id_categoria;

        IF v_cantidad > 0 THEN
            RAISE_APPLICATION_ERROR(-20651, 'No se puede eliminar la categoría porque tiene productos asociados.');
        END IF;

        DELETE FROM CATEGORIA WHERE ID_CATEGORIA = p_id_categoria;

        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20652, 'La categoría indicada no existe.');
        END IF;

        COMMIT;
    END SP_ELIMINAR_CATEGORIA;

END PK_CATEGORIA;
/

--  PK_CLIENTES
CREATE OR REPLACE PACKAGE PK_CLIENTES AS
    PROCEDURE registrar_cliente (
        p_cedula IN clientes.cedula%TYPE,
        p_nombre IN clientes.nombre%TYPE,
        p_apellido1 IN clientes.apellido1%TYPE,
        p_apellido2 IN clientes.apellido2%TYPE,
        p_correo IN clientes.correo_electr%TYPE,
        p_telefono IN clientes.telefono%TYPE
    );
    PROCEDURE consultar_clientes (p_resultado OUT SYS_REFCURSOR);
    PROCEDURE editar_correo_telefono_cliente (
        p_cedula IN clientes.cedula%TYPE,
        p_correo IN clientes.correo_electr%TYPE,
        p_telefono IN clientes.telefono%TYPE
    );
    PROCEDURE eliminar_cliente (p_cedula IN clientes.cedula%TYPE);
    FUNCTION existe_cliente (p_cedula IN clientes.cedula%TYPE) RETURN NUMBER;
    PROCEDURE mostrar_vw_clientes_compras (p_resultado OUT SYS_REFCURSOR);
END PK_CLIENTES;
/

CREATE OR REPLACE PACKAGE BODY PK_CLIENTES AS

    PROCEDURE registrar_cliente (
        p_cedula IN clientes.cedula%TYPE,
        p_nombre IN clientes.nombre%TYPE,
        p_apellido1 IN clientes.apellido1%TYPE,
        p_apellido2 IN clientes.apellido2%TYPE,
        p_correo IN clientes.correo_electr%TYPE,
        p_telefono IN clientes.telefono%TYPE
    ) IS
        v_cedula clientes.cedula%TYPE := TRIM(p_cedula);
        v_correo clientes.correo_electr%TYPE := LOWER(TRIM(p_correo));
        v_telefono clientes.telefono%TYPE := TRIM(p_telefono);
        v_cantidad NUMBER;
    BEGIN
        IF v_cedula IS NULL OR TRIM(p_nombre) IS NULL OR TRIM(p_apellido1) IS NULL OR v_correo IS NULL OR v_telefono IS NULL THEN
            RAISE_APPLICATION_ERROR(-20001, 'Debe indicar todos los datos obligatorios del cliente.');
        END IF;
        IF NOT REGEXP_LIKE(v_cedula, '^[0-9]+$') THEN RAISE_APPLICATION_ERROR(-20002, 'La cédula solamente debe contener números.'); END IF;
        IF LENGTH(v_cedula) < 9 THEN RAISE_APPLICATION_ERROR(-20003, 'La cédula debe contener al menos 9 dígitos.'); END IF;
        IF NOT REGEXP_LIKE(v_correo, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$') THEN
            RAISE_APPLICATION_ERROR(-20004, 'El correo electrónico no tiene un formato válido.');
        END IF;
        IF NOT REGEXP_LIKE(v_telefono, '^[0-9]+$') THEN RAISE_APPLICATION_ERROR(-20005, 'El teléfono solamente debe contener números.'); END IF;
        IF LENGTH(v_telefono) < 8 THEN RAISE_APPLICATION_ERROR(-20006, 'El teléfono debe contener al menos 8 dígitos.'); END IF;

        SELECT COUNT(*) INTO v_cantidad FROM clientes WHERE TRIM(cedula) = v_cedula;
        IF v_cantidad > 0 THEN RAISE_APPLICATION_ERROR(-20007, 'Ya existe un cliente registrado con esa cédula.'); END IF;
        SELECT COUNT(*) INTO v_cantidad FROM clientes WHERE LOWER(TRIM(correo_electr)) = v_correo;
        IF v_cantidad > 0 THEN RAISE_APPLICATION_ERROR(-20008, 'Ya existe un cliente registrado con ese correo electrónico.'); END IF;
        SELECT COUNT(*) INTO v_cantidad FROM clientes WHERE TRIM(telefono) = v_telefono;
        IF v_cantidad > 0 THEN RAISE_APPLICATION_ERROR(-20009, 'Ya existe un cliente registrado con ese teléfono.'); END IF;

        INSERT INTO clientes (cedula, nombre, apellido1, apellido2, correo_electr, telefono)
        VALUES (v_cedula, INITCAP(TRIM(p_nombre)), INITCAP(TRIM(p_apellido1)), INITCAP(TRIM(p_apellido2)), v_correo, v_telefono);
        COMMIT;
    END registrar_cliente;

    PROCEDURE consultar_clientes (p_resultado OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_resultado FOR SELECT cedula, nombre, apellido1, apellido2, correo_electr, telefono FROM clientes ORDER BY nombre;
    END consultar_clientes;

    PROCEDURE editar_correo_telefono_cliente (
        p_cedula IN clientes.cedula%TYPE,
        p_correo IN clientes.correo_electr%TYPE,
        p_telefono IN clientes.telefono%TYPE
    ) IS
        v_existe NUMBER;
        v_correo clientes.correo_electr%TYPE := LOWER(TRIM(p_correo));
        v_telefono clientes.telefono%TYPE := TRIM(p_telefono);
    BEGIN
        IF TRIM(p_cedula) IS NULL THEN RAISE_APPLICATION_ERROR(-20020, 'Debe indicar la cédula del cliente.'); END IF;
        IF v_correo IS NULL AND v_telefono IS NULL THEN RAISE_APPLICATION_ERROR(-20021, 'Debe indicar al menos el correo o el teléfono.'); END IF;

        SELECT COUNT(*) INTO v_existe FROM clientes WHERE cedula = TRIM(p_cedula);
        IF v_existe = 0 THEN RAISE_APPLICATION_ERROR(-20022, 'No existe un cliente con esa cédula.'); END IF;

        IF v_correo IS NOT NULL AND NOT REGEXP_LIKE(v_correo, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$') THEN
            RAISE_APPLICATION_ERROR(-20023, 'El correo electrónico no tiene un formato válido.');
        END IF;
        IF v_telefono IS NOT NULL AND NOT REGEXP_LIKE(v_telefono, '^[0-9]+$') THEN RAISE_APPLICATION_ERROR(-20024, 'El teléfono debe contener solo números.'); END IF;
        IF v_telefono IS NOT NULL AND LENGTH(v_telefono) < 8 THEN RAISE_APPLICATION_ERROR(-20025, 'El teléfono debe contener al menos 8 dígitos.'); END IF;

        UPDATE clientes SET correo_electr = NVL(v_correo, correo_electr), telefono = NVL(v_telefono, telefono) WHERE cedula = TRIM(p_cedula);
        COMMIT;
    END editar_correo_telefono_cliente;

    PROCEDURE eliminar_cliente (p_cedula IN clientes.cedula%TYPE) IS
        v_existe_cliente NUMBER;
        v_cant_direcciones NUMBER;
        v_cant_ventas NUMBER;
        v_cant_devoluciones NUMBER;
    BEGIN
        IF TRIM(p_cedula) IS NULL THEN RAISE_APPLICATION_ERROR(-20030, 'Debe indicar la cédula del cliente.'); END IF;
        SELECT COUNT(*) INTO v_existe_cliente FROM clientes WHERE cedula = TRIM(p_cedula);
        IF v_existe_cliente = 0 THEN RAISE_APPLICATION_ERROR(-20031, 'No existe un cliente con esa cédula.'); END IF;
        SELECT COUNT(*) INTO v_cant_direcciones FROM clientes_direcciones WHERE cedula = TRIM(p_cedula);
        SELECT COUNT(*) INTO v_cant_ventas FROM ventas WHERE cedula = TRIM(p_cedula);
        SELECT COUNT(*) INTO v_cant_devoluciones FROM devolucion WHERE cedula = TRIM(p_cedula);
        IF v_cant_direcciones > 0 OR v_cant_ventas > 0 OR v_cant_devoluciones > 0 THEN
            RAISE_APPLICATION_ERROR(-20032, 'No se puede eliminar el cliente porque tiene registros asociados.');
        END IF;
        DELETE FROM clientes WHERE cedula = TRIM(p_cedula);
        COMMIT;
    END eliminar_cliente;

    FUNCTION existe_cliente (p_cedula IN clientes.cedula%TYPE) RETURN NUMBER IS
        v_cantidad NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_cantidad FROM clientes WHERE cedula = p_cedula;
        RETURN v_cantidad;
    END existe_cliente;

    PROCEDURE mostrar_vw_clientes_compras (p_resultado OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_resultado FOR SELECT * FROM vw_vista_clientes_compras ORDER BY nombre;
    END mostrar_vw_clientes_compras;

END PK_CLIENTES;
/

--  PK_PROVEEDORES
CREATE OR REPLACE PACKAGE PK_PROVEEDORES AS

PROCEDURE registrar_proveedor (
    p_nombre_proveedor IN proveedores.nombre_proveedor%TYPE,
    p_nombre_contacto  IN proveedores.nombre_contacto%TYPE,
    p_apellido1        IN proveedores.apellido1%TYPE,
    p_apellido2        IN proveedores.apellido2%TYPE,
    p_correo           IN proveedores.correo_electr%TYPE,
    p_telefono         IN proveedores.telefono%TYPE
);

PROCEDURE EDITAR_CONTACTO_PROVEEDOR (
    P_ID_PROVEEDOR    IN PROVEEDORES.ID_PROVEEDOR%TYPE,
    P_NOMBRE_CONTACTO IN PROVEEDORES.NOMBRE_CONTACTO%TYPE DEFAULT NULL,
    P_APELLIDO1       IN PROVEEDORES.APELLIDO1%TYPE DEFAULT NULL,
    P_APELLIDO2       IN PROVEEDORES.APELLIDO2%TYPE DEFAULT NULL,
    P_CORREO          IN PROVEEDORES.CORREO_ELECTR%TYPE DEFAULT NULL,
    P_TELEFONO        IN PROVEEDORES.TELEFONO%TYPE DEFAULT NULL
);

 PROCEDURE ELIMINAR_PROVEEDOR (
    P_ID_PROVEEDOR IN PROVEEDORES.ID_PROVEEDOR%TYPE
);

 PROCEDURE consultar_proveedores(
    p_resultado OUT SYS_REFCURSOR
);

 FUNCTION cantidad_productos_proveedor (
    p_id_proveedor IN proveedores.id_proveedor%TYPE
) RETURN NUMBER;

FUNCTION estado_proveedor (
    p_id_proveedor IN proveedores.id_proveedor%TYPE
) RETURN VARCHAR2;

PROCEDURE mostrar_vw_productos_proveedores (
    p_resultado OUT SYS_REFCURSOR
);

PROCEDURE SP_ACTUALIZAR_ESTADO_PROVEEDOR (
    P_ID_PROVEEDOR IN PROVEEDORES.ID_PROVEEDOR%TYPE,
    P_ESTADO       IN PROVEEDORES.ESTADO%TYPE
);

 END PK_PROVEEDORES;
/

CREATE OR REPLACE PACKAGE BODY PK_PROVEEDORES AS

 PROCEDURE registrar_proveedor (
    p_nombre_proveedor IN proveedores.nombre_proveedor%TYPE,
    p_nombre_contacto  IN proveedores.nombre_contacto%TYPE,
    p_apellido1        IN proveedores.apellido1%TYPE,
    p_apellido2        IN proveedores.apellido2%TYPE,
    p_correo           IN proveedores.correo_electr%TYPE,
    p_telefono         IN proveedores.telefono%TYPE
) IS
    v_correo          proveedores.correo_electr%TYPE;
    v_cantidad        NUMBER;
    v_posicion_arroba NUMBER;
BEGIN
    v_correo := lower(trim(p_correo));
    IF TRIM(p_nombre_proveedor) IS NULL
       OR TRIM(p_nombre_contacto) IS NULL
    OR TRIM(p_apellido1) IS NULL
    OR v_correo IS NULL
    OR TRIM(p_telefono) IS NULL THEN
        raise_application_error(-20001, 'Debe indicar todos los datos obligatorios.');
    END IF;

    v_posicion_arroba := instr(v_correo, '@');
    IF v_posicion_arroba <= 1 THEN
        raise_application_error(-20002, 'El correo electrónico no tiene un formato válido.');
    END IF;
    SELECT
        COUNT(*)
    INTO v_cantidad
    FROM
        proveedores
    WHERE
        lower(trim(correo_electr)) = v_correo;

    IF v_cantidad > 0 THEN
        raise_application_error(-20005, 'El correo electrónico ya está registrado.');
    END IF;
    SELECT
        COUNT(*)
    INTO v_cantidad
    FROM
        proveedores
    WHERE
        TRIM(telefono) = TRIM(p_telefono);

    IF v_cantidad > 0 THEN
        raise_application_error(-20006, 'El teléfono ya está registrado.');
    END IF;
    INSERT INTO proveedores (
        nombre_proveedor,
        nombre_contacto,
        apellido1,
        apellido2,
        correo_electr,
        telefono
    ) VALUES ( TRIM(p_nombre_proveedor),
               TRIM(p_nombre_contacto),
               TRIM(p_apellido1),
               TRIM(p_apellido2),
               v_correo,
               TRIM(p_telefono) );

    dbms_output.put_line('Proveedor registrado correctamente.');
EXCEPTION
    WHEN dup_val_on_index THEN
        raise_application_error(-20007, 'El correo electrónico o teléfono ya está registrado.');
END registrar_proveedor;

 PROCEDURE EDITAR_CONTACTO_PROVEEDOR (
    P_ID_PROVEEDOR    IN PROVEEDORES.ID_PROVEEDOR%TYPE,
    P_NOMBRE_CONTACTO IN PROVEEDORES.NOMBRE_CONTACTO%TYPE DEFAULT NULL,
    P_APELLIDO1       IN PROVEEDORES.APELLIDO1%TYPE DEFAULT NULL,
    P_APELLIDO2       IN PROVEEDORES.APELLIDO2%TYPE DEFAULT NULL,
    P_CORREO          IN PROVEEDORES.CORREO_ELECTR%TYPE DEFAULT NULL,
    P_TELEFONO        IN PROVEEDORES.TELEFONO%TYPE DEFAULT NULL
)
IS
    V_EXISTE    NUMBER;
    V_CORREO    PROVEEDORES.CORREO_ELECTR%TYPE;
    V_TELEFONO  PROVEEDORES.TELEFONO%TYPE;
BEGIN
 
    V_CORREO   := LOWER(TRIM(P_CORREO));
    V_TELEFONO := TRIM(P_TELEFONO);

    IF P_ID_PROVEEDOR IS NULL THEN
        RAISE_APPLICATION_ERROR( -20040, 'Debe indicar el identificador del proveedor.' );
    END IF;

    SELECT COUNT(*)
    INTO V_EXISTE
    FROM PROVEEDORES
    WHERE ID_PROVEEDOR = P_ID_PROVEEDOR;

    IF V_EXISTE = 0 THEN
        RAISE_APPLICATION_ERROR(-20041,'No existe el proveedor indicado.' );
    END IF;

    IF TRIM(P_NOMBRE_CONTACTO) IS NULL
       AND TRIM(P_APELLIDO1) IS NULL
       AND TRIM(P_APELLIDO2) IS NULL
       AND V_CORREO IS NULL
       AND V_TELEFONO IS NULL THEN

        RAISE_APPLICATION_ERROR( -20042, 'Debe indicar al menos un dato para modificar.' );
    END IF;

    IF V_CORREO IS NOT NULL THEN
        IF NOT REGEXP_LIKE(
            V_CORREO,
            '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'
        ) THEN
            RAISE_APPLICATION_ERROR( -20043, 'El correo electrónico no tiene un formato válido.');
        END IF;
    END IF;

    IF V_TELEFONO IS NOT NULL THEN
        IF NOT REGEXP_LIKE(V_TELEFONO, '^[0-9]+$') THEN
            RAISE_APPLICATION_ERROR( -20044,'El teléfono solamente debe contener números.' );
        END IF;

        IF LENGTH(V_TELEFONO) < 8 THEN
            RAISE_APPLICATION_ERROR( -20045, 'El teléfono debe contener al menos 8 dígitos.'  );
        END IF;
    END IF;

    UPDATE PROVEEDORES
    SET NOMBRE_CONTACTO = NVL(INITCAP(TRIM(P_NOMBRE_CONTACTO)), NOMBRE_CONTACTO ),
        APELLIDO1 = NVL( INITCAP(TRIM(P_APELLIDO1)), APELLIDO1 ),
        APELLIDO2 = NVL( INITCAP(TRIM(P_APELLIDO2)), APELLIDO2),
        CORREO_ELECTR = NVL( V_CORREO, CORREO_ELECTR ),
        TELEFONO = NVL(V_TELEFONO,TELEFONO)
    WHERE ID_PROVEEDOR = P_ID_PROVEEDOR;

    DBMS_OUTPUT.PUT_LINE(  'Datos del proveedor actualizados correctamente.'  );

EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        RAISE_APPLICATION_ERROR(-20046,'Ya existe otro proveedor con ese correo o teléfono.');

    WHEN OTHERS THEN
        IF SQLCODE BETWEEN -20999 AND -20000 THEN
            RAISE;
        ELSE
            DBMS_OUTPUT.PUT_LINE(  'Código: ' || SQLCODE );

            DBMS_OUTPUT.PUT_LINE( 'Mensaje: ' || SQLERRM );

            RAISE_APPLICATION_ERROR( -20047, 'Error al editar los datos del proveedor.' );
        END IF;
END EDITAR_CONTACTO_PROVEEDOR;

 PROCEDURE ELIMINAR_PROVEEDOR (
    P_ID_PROVEEDOR IN PROVEEDORES.ID_PROVEEDOR%TYPE
)
IS
    V_EXISTE_PROVEEDOR  NUMBER;
    V_CANT_PRODUCTOS    NUMBER;
BEGIN
    
    IF P_ID_PROVEEDOR IS NULL THEN
        RAISE_APPLICATION_ERROR( -20050, 'Debe indicar el ID del proveedor.' );
    END IF;

    SELECT COUNT(*)
    INTO V_EXISTE_PROVEEDOR
    FROM PROVEEDORES
    WHERE ID_PROVEEDOR = P_ID_PROVEEDOR;

    IF V_EXISTE_PROVEEDOR = 0 THEN
        RAISE_APPLICATION_ERROR( -20051, 'No existe un proveedor registrado con ese ID.' );
    END IF;

    SELECT COUNT(*)
    INTO V_CANT_PRODUCTOS
    FROM PRODUCTOS
    WHERE ID_PROVEEDOR = P_ID_PROVEEDOR;

    IF V_CANT_PRODUCTOS > 0 THEN
        RAISE_APPLICATION_ERROR( -20052, 'No se puede eliminar el proveedor porque tiene ' ||V_CANT_PRODUCTOS ||  ' producto(s) asociado(s).'  );
    END IF;

    DELETE FROM PROVEEDORES
    WHERE ID_PROVEEDOR = P_ID_PROVEEDOR;

    DBMS_OUTPUT.PUT_LINE( 'Proveedor eliminado correctamente.');

EXCEPTION
    WHEN OTHERS THEN

        IF SQLCODE BETWEEN -20999 AND -20000 THEN
            RAISE;
        ELSE
            DBMS_OUTPUT.PUT_LINE(
                'Código del error: ' || SQLCODE
            );

            DBMS_OUTPUT.PUT_LINE(
                'Mensaje del error: ' || SQLERRM
            );

            RAISE_APPLICATION_ERROR( -20053, 'Ocurrió un error al eliminar el proveedor.');
        END IF;
END ELIMINAR_PROVEEDOR;

 PROCEDURE consultar_proveedores(
    p_resultado OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN p_resultado FOR
        SELECT
         ID_PROVEEDOR,
         nombre_proveedor,
        nombre_contacto,
        apellido1,
        apellido2,
        correo_electr,
        telefono,
        estado
        FROM proveedores;

END;

 FUNCTION cantidad_productos_proveedor (
    p_id_proveedor IN proveedores.id_proveedor%TYPE
) RETURN NUMBER
IS
    v_cantidad NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_cantidad
    FROM productos
    WHERE id_proveedor = p_id_proveedor;

    RETURN v_cantidad;
END;

FUNCTION estado_proveedor (
    p_id_proveedor IN proveedores.id_proveedor%TYPE
) RETURN VARCHAR2
IS
    v_estado proveedores.estado%TYPE;
BEGIN
    SELECT estado
    INTO v_estado
    FROM proveedores
    WHERE id_proveedor = p_id_proveedor;

    RETURN v_estado;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'El proveedor no existe';
END;

PROCEDURE editar_estado_proveedor (
    p_id_proveedor    IN proveedores.id_proveedor%TYPE,
    p_estado          IN proveedores.estado%type
)
IS
BEGIN
    UPDATE proveedores
    SET estado = p_estado
        
    WHERE id_proveedor = p_id_proveedor;

    IF SQL%ROWCOUNT > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Estado actualizado correctamente');
    ELSE
        DBMS_OUTPUT.PUT_LINE('No existe el proveedor indicado');
    END IF;

EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE(
            'Ya existe un contacto de proveedor con ese teléfono o correo'
        );

    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(
            'Error al editar los datos: ');
END;

 PROCEDURE mostrar_vw_productos_proveedores (
    p_resultado OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN p_resultado FOR
        SELECT * 
        FROM vw_productos_proveedores
        ORDER BY nombre_producto;
END;

PROCEDURE SP_ACTUALIZAR_ESTADO_PROVEEDOR (
    P_ID_PROVEEDOR IN PROVEEDORES.ID_PROVEEDOR%TYPE,
    P_ESTADO       IN PROVEEDORES.ESTADO%TYPE
)
AS
    V_EXISTE NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO V_EXISTE
    FROM PROVEEDORES
    WHERE ID_PROVEEDOR = P_ID_PROVEEDOR;

    IF V_EXISTE = 0 THEN
        RAISE_APPLICATION_ERROR(-20500, 'El proveedor indicado no existe.');
    END IF;

    UPDATE PROVEEDORES
    SET ESTADO = NVL(P_ESTADO, ESTADO)
    WHERE ID_PROVEEDOR = P_ID_PROVEEDOR;

    COMMIT;
END SP_ACTUALIZAR_ESTADO_PROVEEDOR;

 END PK_PROVEEDORES;
/

--  PK_PRODUCTOS
CREATE OR REPLACE PACKAGE PK_PRODUCTOS AS

    PROCEDURE SP_REGISTRAR_PRODUCTO (
        p_nombre         IN PRODUCTOS.NOMBRE%TYPE,
        p_descripcion    IN PRODUCTOS.DESCRIPCION%TYPE,
        p_precio_venta   IN PRODUCTOS.PRECIO_VENTA%TYPE,
        p_precio_costo   IN PRODUCTOS.PRECIO_COSTO%TYPE,
        p_fecha_entrada  IN VARCHAR2,
        p_id_proveedor   IN PRODUCTOS.ID_PROVEEDOR%TYPE,
        p_id_categoria   IN PRODUCTOS.ID_CATEGORIA%TYPE
    );

    PROCEDURE SP_ACTUALIZAR_PRODUCTO (
        p_id_producto    IN PRODUCTOS.ID_PRODUCTO%TYPE,
        p_nombre         IN PRODUCTOS.NOMBRE%TYPE,
        p_descripcion    IN PRODUCTOS.DESCRIPCION%TYPE,
        p_precio_venta   IN PRODUCTOS.PRECIO_VENTA%TYPE,
        p_precio_costo   IN PRODUCTOS.PRECIO_COSTO%TYPE,
        p_fecha_entrada  IN VARCHAR2,
        p_id_proveedor   IN PRODUCTOS.ID_PROVEEDOR%TYPE,
        p_id_categoria   IN PRODUCTOS.ID_CATEGORIA%TYPE
    );

    PROCEDURE SP_ELIMINAR_PRODUCTO (
        p_id_producto IN PRODUCTOS.ID_PRODUCTO%TYPE
    );

    PROCEDURE SP_LISTAR_PRODUCTOS (
        p_cursor OUT SYS_REFCURSOR
    );

    PROCEDURE SP_VISTA_PRODUCTOS (
        p_cursor OUT SYS_REFCURSOR
    );

    PROCEDURE SP_BUSCAR_PRODUCTO_POR_ID (
        p_id_producto IN PRODUCTOS.ID_PRODUCTO%TYPE,
        p_cursor OUT SYS_REFCURSOR
    );

    PROCEDURE SP_LISTAR_PRODUCTOS_POR_CATEGORIA (
        p_id_categoria IN PRODUCTOS.ID_CATEGORIA%TYPE,
        p_cursor OUT SYS_REFCURSOR
    );

END PK_PRODUCTOS;
/

CREATE OR REPLACE PACKAGE BODY PK_PRODUCTOS AS

PROCEDURE SP_REGISTRAR_PRODUCTO (
    p_nombre         IN PRODUCTOS.NOMBRE%TYPE,
    p_descripcion    IN PRODUCTOS.DESCRIPCION%TYPE,
    p_precio_venta   IN PRODUCTOS.PRECIO_VENTA%TYPE,
    p_precio_costo   IN PRODUCTOS.PRECIO_COSTO%TYPE,
    p_fecha_entrada  IN VARCHAR2,
    p_id_proveedor   IN PRODUCTOS.ID_PROVEEDOR%TYPE,
    p_id_categoria   IN PRODUCTOS.ID_CATEGORIA%TYPE
)
AS
BEGIN

    INSERT INTO PRODUCTOS (
        NOMBRE,
        DESCRIPCION,
        PRECIO_VENTA,
        PRECIO_COSTO,
        FECHA_ULTIMA_ENTRADA,
        ID_PROVEEDOR,
        ID_CATEGORIA
    )
    VALUES (
        p_nombre,
        p_descripcion,
        p_precio_venta,
        p_precio_costo,
        TO_DATE(p_fecha_entrada, 'YYYY-MM-DD'),
        p_id_proveedor,
        p_id_categoria
    );

    COMMIT;

    DBMS_OUTPUT.PUT_LINE(
        'Producto registrado correctamente.'
    );

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;

        DBMS_OUTPUT.PUT_LINE(
            'Error al registrar el producto: ' || SQLERRM
        );

END SP_REGISTRAR_PRODUCTO;

PROCEDURE SP_ACTUALIZAR_PRODUCTO (
    p_id_producto    IN PRODUCTOS.ID_PRODUCTO%TYPE,
    p_nombre         IN PRODUCTOS.NOMBRE%TYPE,
    p_descripcion    IN PRODUCTOS.DESCRIPCION%TYPE,
    p_precio_venta   IN PRODUCTOS.PRECIO_VENTA%TYPE,
    p_precio_costo   IN PRODUCTOS.PRECIO_COSTO%TYPE,
    p_fecha_entrada  IN VARCHAR2,
    p_id_proveedor   IN PRODUCTOS.ID_PROVEEDOR%TYPE,
    p_id_categoria   IN PRODUCTOS.ID_CATEGORIA%TYPE
)
AS
BEGIN

    UPDATE PRODUCTOS
    SET
        NOMBRE = NVL(p_nombre, NOMBRE),
        DESCRIPCION = NVL(p_descripcion, DESCRIPCION),
        PRECIO_VENTA = NVL(p_precio_venta, PRECIO_VENTA),
        PRECIO_COSTO = NVL(p_precio_costo, PRECIO_COSTO),
        FECHA_ULTIMA_ENTRADA = NVL(TO_DATE(p_fecha_entrada, 'YYYY-MM-DD'), FECHA_ULTIMA_ENTRADA),
        ID_PROVEEDOR = NVL(p_id_proveedor, ID_PROVEEDOR),
        ID_CATEGORIA = NVL(p_id_categoria, ID_CATEGORIA)

    WHERE ID_PRODUCTO = p_id_producto;

    IF SQL%ROWCOUNT > 0 THEN

        COMMIT;

        DBMS_OUTPUT.PUT_LINE(
            'Producto actualizado correctamente.'
        );

    ELSE

        DBMS_OUTPUT.PUT_LINE(
            'No existe un producto con el ID indicado.'
        );

    END IF;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;

        DBMS_OUTPUT.PUT_LINE(
            'Error al actualizar el producto: ' || SQLERRM
        );

END SP_ACTUALIZAR_PRODUCTO;

PROCEDURE SP_ELIMINAR_PRODUCTO (
    p_id_producto IN PRODUCTOS.ID_PRODUCTO%TYPE
)
AS
    v_cantidad_inventario NUMBER;
    v_cantidad_ventas     NUMBER;
BEGIN

    SELECT COUNT(*)
    INTO v_cantidad_inventario
    FROM PRODUCTOS_SUCURSALES
    WHERE ID_PRODUCTO = p_id_producto;

    SELECT COUNT(*)
    INTO v_cantidad_ventas
    FROM PRODUCTOS_VENTAS
    WHERE ID_PRODUCTO = p_id_producto;

    IF v_cantidad_inventario > 0
       OR v_cantidad_ventas > 0 THEN

        RAISE_APPLICATION_ERROR(
            -20003,
            'No se puede eliminar el producto porque tiene registros asociados.'
        );

    END IF;

    DELETE FROM PRODUCTOS
    WHERE ID_PRODUCTO = p_id_producto;

    IF SQL%ROWCOUNT > 0 THEN

        COMMIT;

        DBMS_OUTPUT.PUT_LINE(
            'Producto eliminado correctamente.'
        );

    ELSE

        DBMS_OUTPUT.PUT_LINE(
            'No existe un producto con el ID indicado.'
        );

    END IF;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;

        DBMS_OUTPUT.PUT_LINE(
            'Error al eliminar el producto: ' || SQLERRM
        );

END SP_ELIMINAR_PRODUCTO;

PROCEDURE SP_LISTAR_PRODUCTOS (

    p_cursor OUT SYS_REFCURSOR

) AS

BEGIN

    OPEN p_cursor FOR

        SELECT
            ID_PRODUCTO,
            NOMBRE,
            PRECIO_VENTA,
            ID_CATEGORIA
        FROM PRODUCTOS
        ORDER BY ID_PRODUCTO;

END SP_LISTAR_PRODUCTOS;

PROCEDURE SP_VISTA_PRODUCTOS (
    p_cursor OUT SYS_REFCURSOR
)
AS
BEGIN

    OPEN p_cursor FOR
        SELECT
            ID_PRODUCTO,
            NOMBRE,
            PRECIO_VENTA,
            PRECIO_COSTO,
            ID_CATEGORIA
        FROM VW_PRODUCTOS;

END SP_VISTA_PRODUCTOS;

PROCEDURE SP_BUSCAR_PRODUCTO_POR_ID (
    p_id_producto IN PRODUCTOS.ID_PRODUCTO%TYPE,
    p_cursor OUT SYS_REFCURSOR
)
AS
BEGIN
    OPEN p_cursor FOR
        SELECT
            ID_PRODUCTO,
            NOMBRE,
            DESCRIPCION,
            PRECIO_VENTA,
            PRECIO_COSTO,
            ID_CATEGORIA
        FROM PRODUCTOS
        WHERE ID_PRODUCTO = p_id_producto;
END SP_BUSCAR_PRODUCTO_POR_ID;

PROCEDURE SP_LISTAR_PRODUCTOS_POR_CATEGORIA (
    p_id_categoria IN PRODUCTOS.ID_CATEGORIA%TYPE,
    p_cursor OUT SYS_REFCURSOR
)
AS
BEGIN
    OPEN p_cursor FOR
        SELECT
            ID_PRODUCTO,
            NOMBRE,
            PRECIO_VENTA,
            PRECIO_COSTO
        FROM PRODUCTOS
        WHERE ID_CATEGORIA = p_id_categoria
        ORDER BY NOMBRE;
END SP_LISTAR_PRODUCTOS_POR_CATEGORIA;

END PK_PRODUCTOS;
/

-- PK_INVENTARIO
CREATE OR REPLACE PACKAGE PK_INVENTARIO AS

    PROCEDURE SP_REGISTRAR_INVENTARIO (
        p_cantidad      IN PRODUCTOS_SUCURSALES.CANTIDAD%TYPE,
        p_id_sucursal   IN PRODUCTOS_SUCURSALES.ID_SUCURSAL%TYPE,
        p_id_producto   IN PRODUCTOS_SUCURSALES.ID_PRODUCTO%TYPE
    );

    PROCEDURE SP_LISTAR_INVENTARIO (
        p_id_sucursal IN PRODUCTOS_SUCURSALES.ID_SUCURSAL%TYPE,
        p_cursor OUT SYS_REFCURSOR
    );

    PROCEDURE SP_CONSULTAR_INVENTARIO (
        p_cursor OUT SYS_REFCURSOR
    );

    PROCEDURE SP_VISTA_INVENTARIO (
        p_cursor OUT SYS_REFCURSOR
    );

END PK_INVENTARIO;
/

CREATE OR REPLACE PACKAGE BODY PK_INVENTARIO AS

PROCEDURE SP_REGISTRAR_INVENTARIO (
    p_cantidad      IN PRODUCTOS_SUCURSALES.CANTIDAD%TYPE,
    p_id_sucursal   IN PRODUCTOS_SUCURSALES.ID_SUCURSAL%TYPE,
    p_id_producto   IN PRODUCTOS_SUCURSALES.ID_PRODUCTO%TYPE
)
AS
BEGIN

    INSERT INTO PRODUCTOS_SUCURSALES (
        CANTIDAD,
        ID_SUCURSAL,
        ID_PRODUCTO
    )
    VALUES (
        p_cantidad,
        p_id_sucursal,
        p_id_producto
    );

    COMMIT;

    DBMS_OUTPUT.PUT_LINE(
        'Inventario registrado correctamente.'
    );

EXCEPTION
    WHEN OTHERS THEN

        ROLLBACK;

        DBMS_OUTPUT.PUT_LINE(
            'Error al registrar inventario: ' || SQLERRM
        );

END SP_REGISTRAR_INVENTARIO;

PROCEDURE SP_LISTAR_INVENTARIO (
    p_id_sucursal IN PRODUCTOS_SUCURSALES.ID_SUCURSAL%TYPE,
    p_cursor OUT SYS_REFCURSOR
)
AS
BEGIN

    OPEN p_cursor FOR

        SELECT
            ps.ID_PRODUCTOS_SUCURSALES,
            ps.CANTIDAD,
            p.ID_PRODUCTO,
            p.NOMBRE,
            p.PRECIO_VENTA
        FROM PRODUCTOS_SUCURSALES ps
        JOIN PRODUCTOS p ON p.ID_PRODUCTO = ps.ID_PRODUCTO
        WHERE ps.ID_SUCURSAL = p_id_sucursal
        ORDER BY p.NOMBRE;

END SP_LISTAR_INVENTARIO;

PROCEDURE SP_CONSULTAR_INVENTARIO (p_cursor OUT SYS_REFCURSOR) AS
BEGIN
    OPEN p_cursor FOR
        SELECT ID_PRODUCTOS_SUCURSALES, CANTIDAD, ID_SUCURSAL, ID_PRODUCTO
        FROM PRODUCTOS_SUCURSALES
        ORDER BY ID_PRODUCTOS_SUCURSALES;
END SP_CONSULTAR_INVENTARIO;

PROCEDURE SP_VISTA_INVENTARIO (p_cursor OUT SYS_REFCURSOR) AS
BEGIN
    OPEN p_cursor FOR SELECT * FROM VW_INVENTARIO;
END SP_VISTA_INVENTARIO;

END PK_INVENTARIO;
/

-- PK_SUCURSALES
CREATE OR REPLACE PACKAGE PK_SUCURSALES AS

    PROCEDURE SP_LISTAR_SUCURSALES (
        p_cursor OUT SYS_REFCURSOR
    );

    PROCEDURE SP_BUSCAR_SUCURSAL_POR_ID (
        p_id_sucursal IN SUCURSALES.ID_SUCURSAL%TYPE,
        p_cursor OUT SYS_REFCURSOR
    );

    PROCEDURE SP_LISTAR_SUCURSALES_CON_DIRECCION (
        p_cursor OUT SYS_REFCURSOR
    );

END PK_SUCURSALES;
/

CREATE OR REPLACE PACKAGE BODY PK_SUCURSALES AS

    PROCEDURE SP_LISTAR_SUCURSALES (
        p_cursor OUT SYS_REFCURSOR
    )
    AS
    BEGIN
        OPEN p_cursor FOR
            SELECT ID_SUCURSAL, NOMBRE, ESTADO
            FROM SUCURSALES
            WHERE ESTADO = 'Activo'
            ORDER BY NOMBRE;
    END SP_LISTAR_SUCURSALES;

    PROCEDURE SP_BUSCAR_SUCURSAL_POR_ID (
        p_id_sucursal IN SUCURSALES.ID_SUCURSAL%TYPE,
        p_cursor OUT SYS_REFCURSOR
    )
    AS
    BEGIN
        OPEN p_cursor FOR
            SELECT ID_SUCURSAL, NOMBRE, ESTADO
            FROM SUCURSALES
            WHERE ID_SUCURSAL = p_id_sucursal;
    END SP_BUSCAR_SUCURSAL_POR_ID;

    PROCEDURE SP_LISTAR_SUCURSALES_CON_DIRECCION (
        p_cursor OUT SYS_REFCURSOR
    )
    AS
    BEGIN
        OPEN p_cursor FOR
            SELECT
                s.ID_SUCURSAL,
                s.NOMBRE,
                s.ESTADO,
                d.DETALLE AS DIRECCION
            FROM SUCURSALES s
            JOIN SUCURSALES_DIRECCIONES sd ON s.ID_SUCURSAL = sd.ID_SUCURSAL
            JOIN DIRECCIONES d ON sd.ID_DIRECCION = d.ID_DIRECCION
            WHERE s.ESTADO = 'Activo'
            ORDER BY s.NOMBRE;
    END SP_LISTAR_SUCURSALES_CON_DIRECCION;

END PK_SUCURSALES;
/

-- PK_VENTAS
CREATE OR REPLACE PACKAGE PK_VENTAS AS

    PROCEDURE SP_REGISTRAR_VENTA (
        p_cedula          IN  Clientes.Cedula%TYPE,
        p_id_trabajador   IN  Trabajadores.ID_Trabajador%TYPE,
        p_id_tipo_pago    IN  Tipo_Pagos.ID_Tipo_Pago%TYPE,
        p_id_producto     IN  Productos.ID_Producto%TYPE,
        p_cantidad        IN  Productos_Ventas.Cantidad%TYPE,
        p_id_sucursal     IN  Sucursales.ID_Sucursal%TYPE,
        p_id_venta        OUT Ventas.ID_Venta%TYPE,
        p_total           OUT Ventas.Total%TYPE,
        p_mensaje         OUT VARCHAR2
    );

    PROCEDURE SP_LISTAR_VENTAS (
        p_cursor OUT SYS_REFCURSOR
    );

    PROCEDURE SP_LISTAR_INVENTARIO_VENTA (
        p_id_sucursal IN Sucursales.ID_Sucursal%TYPE,
        p_cursor OUT SYS_REFCURSOR
    );

    PROCEDURE SP_MODIFICAR_VENTA (
        p_id_venta       IN Ventas.ID_Venta%TYPE,
        p_cedula         IN Ventas.Cedula%TYPE DEFAULT NULL,
        p_id_trabajador  IN Ventas.ID_Trabajador%TYPE DEFAULT NULL,
        p_id_tipo_pago   IN Ventas.ID_Tipo_Pago%TYPE DEFAULT NULL,
        p_mensaje        OUT VARCHAR2
    );

    PROCEDURE SP_ELIMINAR_VENTA (
        p_id_venta IN Ventas.ID_Venta%TYPE,
        p_mensaje  OUT VARCHAR2
    );

    PROCEDURE SP_CONSULTAR_VENTA_POR_ID (
        p_id_venta IN Ventas.ID_Venta%TYPE,
        p_cursor OUT SYS_REFCURSOR
    );

END PK_VENTAS;
/

CREATE OR REPLACE PACKAGE BODY PK_VENTAS AS

PROCEDURE SP_REGISTRAR_VENTA (
    p_cedula          IN  Clientes.Cedula%TYPE,
    p_id_trabajador   IN  Trabajadores.ID_Trabajador%TYPE,
    p_id_tipo_pago    IN  Tipo_Pagos.ID_Tipo_Pago%TYPE,
    p_id_producto     IN  Productos.ID_Producto%TYPE,
    p_cantidad        IN  Productos_Ventas.Cantidad%TYPE,
    p_id_sucursal     IN  Sucursales.ID_Sucursal%TYPE,
    p_id_venta        OUT Ventas.ID_Venta%TYPE,
    p_total           OUT Ventas.Total%TYPE,
    p_mensaje         OUT VARCHAR2
)
IS
    v_existe_cliente      NUMBER := 0;
    v_existe_trabajador   NUMBER := 0;
    v_existe_pago         NUMBER := 0;
    v_precio_venta        Productos.Precio_Venta%TYPE;
    v_existencia          Productos_Sucursales.Cantidad%TYPE;
BEGIN
    p_id_venta := NULL;
    p_total := 0;

    IF p_cantidad IS NULL OR p_cantidad <= 0 THEN
        p_mensaje := 'La cantidad debe ser mayor que cero.';
        RETURN;
    END IF;

    SELECT COUNT(*)
      INTO v_existe_cliente
      FROM Clientes
     WHERE Cedula = p_cedula;

    IF v_existe_cliente = 0 THEN
        p_mensaje := 'El cliente indicado no existe.';
        RETURN;
    END IF;

    SELECT COUNT(*)
      INTO v_existe_trabajador
      FROM Trabajadores
     WHERE ID_Trabajador = p_id_trabajador
       AND ID_Sucursal = p_id_sucursal
       AND UPPER(Estado) = 'ACTIVO';

    IF v_existe_trabajador = 0 THEN
        p_mensaje := 'El trabajador no existe, esta inactivo o no pertenece a la sucursal.';
        RETURN;
    END IF;

    SELECT COUNT(*)
      INTO v_existe_pago
      FROM Tipo_Pagos
     WHERE ID_Tipo_Pago = p_id_tipo_pago;

    IF v_existe_pago = 0 THEN
        p_mensaje := 'El metodo de pago indicado no existe.';
        RETURN;
    END IF;

    SELECT p.Precio_Venta, ps.Cantidad
      INTO v_precio_venta, v_existencia
      FROM Productos p
      INNER JOIN Productos_Sucursales ps
         ON ps.ID_Producto = p.ID_Producto
     WHERE p.ID_Producto = p_id_producto
       AND ps.ID_Sucursal = p_id_sucursal
       FOR UPDATE OF ps.Cantidad;

    IF v_existencia < p_cantidad THEN
        p_mensaje := 'Inventario insuficiente. Disponible: ' || v_existencia;
        RETURN;
    END IF;

    p_total := v_precio_venta * p_cantidad;

    INSERT INTO Ventas (
        Total,
        Cedula,
        ID_Trabajador,
        ID_Tipo_Pago
    ) VALUES (
        p_total,
        p_cedula,
        p_id_trabajador,
        p_id_tipo_pago
    )
    RETURNING ID_Venta INTO p_id_venta;

    INSERT INTO Productos_Ventas (
        Cantidad,
        ID_Producto,
        ID_Venta
    ) VALUES (
        p_cantidad,
        p_id_producto,
        p_id_venta
    );

    UPDATE Productos_Sucursales
       SET Cantidad = Cantidad - p_cantidad
     WHERE ID_Sucursal = p_id_sucursal
       AND ID_Producto = p_id_producto;

    COMMIT;

    p_mensaje := CASE
        WHEN p_id_tipo_pago = 1 THEN 'Venta registrada con pago en efectivo.'
        WHEN p_id_tipo_pago = 2 THEN 'Venta registrada con pago por tarjeta.'
        WHEN p_id_tipo_pago = 3 THEN 'Venta registrada con pago por SINPE Movil.'
        ELSE 'Venta registrada correctamente.'
    END;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        ROLLBACK;
        p_id_venta := NULL;
        p_total := 0;
        p_mensaje := 'El producto no existe o no esta asignado a la sucursal.';
    WHEN OTHERS THEN
        ROLLBACK;
        p_id_venta := NULL;
        p_total := 0;
        p_mensaje := 'Error al registrar la venta: ' || SQLERRM;
END SP_REGISTRAR_VENTA;

PROCEDURE SP_LISTAR_VENTAS (
    p_cursor OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN p_cursor FOR
        SELECT
            ID_Venta,
            Fecha_Hora,
            Cedula,
            Cliente,
            Trabajador,
            Metodo_Pago,
            Total
        FROM VW_DETALLE_VENTAS
        ORDER BY ID_Venta DESC;
END SP_LISTAR_VENTAS;

PROCEDURE SP_LISTAR_INVENTARIO_VENTA (
    p_id_sucursal IN Sucursales.ID_Sucursal%TYPE,
    p_cursor OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN p_cursor FOR
        SELECT
            p.ID_Producto,
            p.Nombre,
            p.Precio_Venta,
            ps.Cantidad
        FROM Productos p
        INNER JOIN Productos_Sucursales ps
            ON ps.ID_Producto = p.ID_Producto
        WHERE ps.ID_Sucursal = p_id_sucursal
          AND ps.Cantidad > 0
        ORDER BY p.Nombre;
END SP_LISTAR_INVENTARIO_VENTA;

PROCEDURE SP_MODIFICAR_VENTA (
    p_id_venta       IN Ventas.ID_Venta%TYPE,
    p_cedula         IN Ventas.Cedula%TYPE DEFAULT NULL,
    p_id_trabajador  IN Ventas.ID_Trabajador%TYPE DEFAULT NULL,
    p_id_tipo_pago   IN Ventas.ID_Tipo_Pago%TYPE DEFAULT NULL,
    p_mensaje        OUT VARCHAR2
)
IS
    v_existe_venta NUMBER;
BEGIN

    SELECT COUNT(*)
      INTO v_existe_venta
      FROM Ventas
     WHERE ID_Venta = p_id_venta;

    IF v_existe_venta = 0 THEN
        p_mensaje := 'La venta indicada no existe.';
        RETURN;
    END IF;

    UPDATE Ventas
       SET Cedula        = NVL(p_cedula, Cedula),
           ID_Trabajador = NVL(p_id_trabajador, ID_Trabajador),
           ID_Tipo_Pago  = NVL(p_id_tipo_pago, ID_Tipo_Pago)
     WHERE ID_Venta = p_id_venta;

    COMMIT;

    p_mensaje := 'Venta modificada correctamente.';

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        p_mensaje := 'Error al modificar la venta: ' || SQLERRM;

END SP_MODIFICAR_VENTA;

PROCEDURE SP_ELIMINAR_VENTA (
    p_id_venta IN Ventas.ID_Venta%TYPE,
    p_mensaje  OUT VARCHAR2
)
IS
    v_existe_venta NUMBER;
    v_detalles     NUMBER;
BEGIN

    SELECT COUNT(*)
      INTO v_existe_venta
      FROM Ventas
     WHERE ID_Venta = p_id_venta;

    IF v_existe_venta = 0 THEN
        p_mensaje := 'La venta indicada no existe.';
        RETURN;
    END IF;

    SELECT COUNT(*)
      INTO v_detalles
      FROM Productos_Ventas
     WHERE ID_Venta = p_id_venta;

    IF v_detalles > 0 THEN
        p_mensaje :=
            'No se puede eliminar la venta porque tiene productos asociados.';
        RETURN;
    END IF;

    DELETE FROM Ventas
     WHERE ID_Venta = p_id_venta;

    COMMIT;

    p_mensaje := 'Venta eliminada correctamente.';

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        p_mensaje := 'Error al eliminar la venta: ' || SQLERRM;

END SP_ELIMINAR_VENTA;

PROCEDURE SP_CONSULTAR_VENTA_POR_ID (
    p_id_venta IN Ventas.ID_Venta%TYPE,
    p_cursor OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN p_cursor FOR
        SELECT
            ID_Venta,
            Fecha_Hora,
            Cedula,
            Cliente,
            Trabajador,
            Metodo_Pago,
            Total
        FROM VW_DETALLE_VENTAS
        WHERE ID_Venta = p_id_venta;
END SP_CONSULTAR_VENTA_POR_ID;

END PK_VENTAS;
/

-- PK_DEVOLUCIONES
CREATE OR REPLACE PACKAGE PK_DEVOLUCIONES AS

PROCEDURE PD_REGISTRAR_DEVOLUCION (
    P_ID_VENTA          IN DEVOLUCION.ID_VENTA%TYPE,
    P_ID_PRODUCTO       IN DEVOLUCION.ID_PRODUCTO%TYPE,
    P_CEDULA            IN DEVOLUCION.CEDULA%TYPE,
    P_CANTIDAD_DEVUELTA IN DEVOLUCION.CANTIDAD_DEVUELTA%TYPE,
    P_ID_TIPO_DEVOLUCION IN DEVOLUCION.ID_TIPO_DEVOLUCION%TYPE,
    P_MOTIVO            IN DEVOLUCION.MOTIVO%TYPE
);

PROCEDURE PD_CONSULTAR_DEVOLUCIONES_CLIENTE (
    P_CEDULA IN CLIENTES.CEDULA%TYPE,
    P_CURSOR OUT SYS_REFCURSOR
);

PROCEDURE PD_VW_DETALLE_DEVOLUCIONES (
    P_CURSOR OUT SYS_REFCURSOR
);

END PK_DEVOLUCIONES;
/

CREATE OR REPLACE PACKAGE BODY PK_DEVOLUCIONES AS

PROCEDURE PD_REGISTRAR_DEVOLUCION (
    P_ID_VENTA          IN DEVOLUCION.ID_VENTA%TYPE,
    P_ID_PRODUCTO       IN DEVOLUCION.ID_PRODUCTO%TYPE,
    P_CEDULA            IN DEVOLUCION.CEDULA%TYPE,
    P_CANTIDAD_DEVUELTA IN DEVOLUCION.CANTIDAD_DEVUELTA%TYPE,
    P_ID_TIPO_DEVOLUCION IN DEVOLUCION.ID_TIPO_DEVOLUCION%TYPE,
    P_MOTIVO            IN DEVOLUCION.MOTIVO%TYPE
)
IS
    V_EXISTE                 NUMBER;
    V_CANTIDAD_COMPRADA      NUMBER;
    V_CANTIDAD_YA_DEVUELTA   NUMBER;
    V_CANTIDAD_DISPONIBLE    NUMBER;
BEGIN
   

    IF P_ID_VENTA IS NULL
       OR P_ID_PRODUCTO IS NULL
       OR TRIM(P_CEDULA) IS NULL
       OR P_CANTIDAD_DEVUELTA IS NULL
       OR P_ID_TIPO_DEVOLUCION IS NULL
       OR TRIM(P_MOTIVO) IS NULL THEN

        RAISE_APPLICATION_ERROR(-20100, 'Debe indicar todos los datos obligatorios de la devolución.' );
    END IF;

    IF P_CANTIDAD_DEVUELTA <= 0 THEN
        RAISE_APPLICATION_ERROR( -20101, 'La cantidad devuelta debe ser mayor que cero.' );
    END IF;

    SELECT COUNT(*)
    INTO V_EXISTE
    FROM CLIENTES
    WHERE CEDULA = TRIM(P_CEDULA);

    IF V_EXISTE = 0 THEN
        RAISE_APPLICATION_ERROR(-20102, 'No existe un cliente registrado con esa cédula.' );
    END IF;

    SELECT COUNT(*)
    INTO V_EXISTE
    FROM VENTAS
    WHERE ID_VENTA = P_ID_VENTA;

    IF V_EXISTE = 0 THEN
        RAISE_APPLICATION_ERROR( -20103, 'No existe la venta indicada.' );
    END IF;

    SELECT COUNT(*)
    INTO V_EXISTE
    FROM VENTAS
    WHERE ID_VENTA = P_ID_VENTA
      AND CEDULA = TRIM(P_CEDULA);

    IF V_EXISTE = 0 THEN
        RAISE_APPLICATION_ERROR(-20104, 'La venta indicada no pertenece al cliente.' );
    END IF;

    SELECT COUNT(*)
    INTO V_EXISTE
    FROM PRODUCTOS
    WHERE ID_PRODUCTO = P_ID_PRODUCTO;

    IF V_EXISTE = 0 THEN
        RAISE_APPLICATION_ERROR( -20105, 'No existe el producto indicado.' );
    END IF;

    SELECT COUNT(*)
    INTO V_EXISTE
    FROM TIPO_DEVOLUCIONES
    WHERE ID_TIPO_DEVOLUCION = P_ID_TIPO_DEVOLUCION;

    IF V_EXISTE = 0 THEN
        RAISE_APPLICATION_ERROR( -20106, 'No existe el tipo de devolución indicado.'  );
    END IF;

    SELECT NVL(SUM(CANTIDAD), 0)
    INTO V_CANTIDAD_COMPRADA
    FROM PRODUCTOS_VENTAS
    WHERE ID_VENTA = P_ID_VENTA
      AND ID_PRODUCTO = P_ID_PRODUCTO;

    IF V_CANTIDAD_COMPRADA = 0 THEN
        RAISE_APPLICATION_ERROR(-20107, 'El producto indicado no pertenece a esa venta.');
    END IF;

    SELECT NVL(SUM(CANTIDAD_DEVUELTA), 0)
    INTO V_CANTIDAD_YA_DEVUELTA
    FROM DEVOLUCION
    WHERE ID_VENTA = P_ID_VENTA
      AND ID_PRODUCTO = P_ID_PRODUCTO;

    INSERT INTO DEVOLUCION (
        MOTIVO,
        CANTIDAD_DEVUELTA,
        FECHA_HORA,
        CEDULA,
        ID_PRODUCTO,
        ID_VENTA,
        ID_TIPO_DEVOLUCION
    )
    VALUES (
        TRIM(P_MOTIVO),
        P_CANTIDAD_DEVUELTA,
        SYSDATE,
        TRIM(P_CEDULA),
        P_ID_PRODUCTO,
        P_ID_VENTA,
        P_ID_TIPO_DEVOLUCION
    );

    DBMS_OUTPUT.PUT_LINE( 'Devolución registrada correctamente.' );

EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE BETWEEN -20999 AND -20000 THEN
            RAISE;
        ELSE
            DBMS_OUTPUT.PUT_LINE(
                'Código: ' || SQLCODE
            );

            DBMS_OUTPUT.PUT_LINE(
                'Mensaje: ' || SQLERRM
            );

            RAISE_APPLICATION_ERROR(
                -20109,
                'No se logró registrar la devolución.'
            );
        END IF;
END PD_REGISTRAR_DEVOLUCION;

PROCEDURE PD_CONSULTAR_DEVOLUCIONES_CLIENTE (
    P_CEDULA IN CLIENTES.CEDULA%TYPE,
    P_CURSOR OUT SYS_REFCURSOR
)
IS
    V_EXISTE NUMBER;
BEGIN
    
    IF TRIM(P_CEDULA) IS NULL THEN
        RAISE_APPLICATION_ERROR(-20510, 'Debe indicar la cédula del cliente.' );
    END IF;

    SELECT COUNT(*)
    INTO V_EXISTE
    FROM CLIENTES
    WHERE CEDULA = TRIM(P_CEDULA);

    IF V_EXISTE = 0 THEN
        RAISE_APPLICATION_ERROR(
            -20511,
            'No existe un cliente registrado con esa cédula.'
        );
    END IF;

    OPEN P_CURSOR FOR
        SELECT
            D.ID_DEVOLUCION,
            D.FECHA_HORA,
            D.CEDULA,
            C.NOMBRE || ' ' ||
            C.APELLIDO1 ||
            CASE
                WHEN C.APELLIDO2 IS NOT NULL
                THEN ' ' || C.APELLIDO2
                ELSE ''
            END AS NOMBRE_CLIENTE,
            D.ID_VENTA,
            D.ID_PRODUCTO,
            P.NOMBRE AS NOMBRE_PRODUCTO,
            D.CANTIDAD_DEVUELTA,
            D.MOTIVO,
            D.ID_TIPO_DEVOLUCION,
            TD.TIPO_DEVOLUCION
        FROM DEVOLUCION D
        INNER JOIN CLIENTES C
            ON C.CEDULA = D.CEDULA
        INNER JOIN PRODUCTOS P
            ON P.ID_PRODUCTO = D.ID_PRODUCTO
        INNER JOIN TIPO_DEVOLUCIONES TD
            ON TD.ID_TIPO_DEVOLUCION =
               D.ID_TIPO_DEVOLUCION
        WHERE D.CEDULA = TRIM(P_CEDULA)
        ORDER BY D.FECHA_HORA DESC;

EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE BETWEEN -20999 AND -20000 THEN
            RAISE;
        ELSE
            DBMS_OUTPUT.PUT_LINE(
                'Código: ' || SQLCODE
            );

            DBMS_OUTPUT.PUT_LINE(
                'Mensaje: ' || SQLERRM
            );

            RAISE_APPLICATION_ERROR(-20512,'No se lograron consultar las devoluciones del cliente.' );
        END IF;
END PD_CONSULTAR_DEVOLUCIONES_CLIENTE;

PROCEDURE PD_VW_DETALLE_DEVOLUCIONES (
    P_CURSOR OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN P_CURSOR FOR
        SELECT *
        FROM VW_DETALLE_DEVOLUCIONES
        ORDER BY FECHA_HORA DESC;
END PD_VW_DETALLE_DEVOLUCIONES;
 
END PK_DEVOLUCIONES;
/

-- PK_TRABAJADORES
CREATE OR REPLACE PACKAGE PK_TRABAJADORES AS

PROCEDURE PD_REGISTRAR_TRABAJADOR (
    P_NOMBRE             IN TRABAJADORES.NOMBRE%TYPE,
    P_APELLIDO1          IN TRABAJADORES.APELLIDO1%TYPE,
    P_APELLIDO2          IN TRABAJADORES.APELLIDO2%TYPE,
    P_IDENTIFICACION     IN TRABAJADORES.IDENTIFICACION%TYPE,
    P_CORREO_ELECTRONICO IN TRABAJADORES.CORREO_ELECTRONICO%TYPE,
    P_ID_SUCURSAL        IN TRABAJADORES.ID_SUCURSAL%TYPE,
    P_ID_TURNO           IN TRABAJADORES.ID_TURNO%TYPE,
    P_ID_ROL             IN TRABAJADORES.ID_ROL%TYPE
);

PROCEDURE pd_editar_trabajador (
    p_identificacion     IN trabajadores.identificacion%TYPE,
    p_nombre             IN trabajadores.nombre%TYPE DEFAULT NULL,
    p_apellido1          IN trabajadores.apellido1%TYPE DEFAULT NULL,
    p_apellido2          IN trabajadores.apellido2%TYPE DEFAULT NULL,
    p_correo_electronico IN trabajadores.correo_electronico%TYPE DEFAULT NULL,
    p_id_sucursal        IN trabajadores.id_sucursal%TYPE DEFAULT NULL,
    p_id_turno           IN trabajadores.id_turno%TYPE DEFAULT NULL
);

PROCEDURE pd_asignar_rol_trabajador (
    p_identificacion IN trabajadores.identificacion%TYPE,
    p_id_rol         IN roles.id_rol%TYPE
);

PROCEDURE pd_desactivar_trabajador (
    p_identificacion IN trabajadores.identificacion%TYPE
);

PROCEDURE PD_CONSULTAR_VW_TRABAJADORES (
    P_CURSOR OUT SYS_REFCURSOR
);

 PROCEDURE PD_CONSULTAR_VW_CANT_TRAB_ROL (
    P_CURSOR OUT SYS_REFCURSOR
);

PROCEDURE PD_CONSULTAR_VW_VENTAS_TRAB (
    P_CURSOR OUT SYS_REFCURSOR
);

PROCEDURE PD_BUSCAR_TRABAJADOR_POR_ID (
    P_ID_TRABAJADOR IN TRABAJADORES.ID_TRABAJADOR%TYPE,
    P_CURSOR OUT SYS_REFCURSOR
);

PROCEDURE PD_LISTAR_TRABAJADORES_POR_SUCURSAL (
    P_ID_SUCURSAL IN TRABAJADORES.ID_SUCURSAL%TYPE,
    P_CURSOR OUT SYS_REFCURSOR
);

END PK_TRABAJADORES;
/

CREATE OR REPLACE PACKAGE BODY PK_TRABAJADORES AS

PROCEDURE PD_REGISTRAR_TRABAJADOR (
    P_NOMBRE             IN TRABAJADORES.NOMBRE%TYPE,
    P_APELLIDO1          IN TRABAJADORES.APELLIDO1%TYPE,
    P_APELLIDO2          IN TRABAJADORES.APELLIDO2%TYPE,
    P_IDENTIFICACION     IN TRABAJADORES.IDENTIFICACION%TYPE,
    P_CORREO_ELECTRONICO IN TRABAJADORES.CORREO_ELECTRONICO%TYPE,
    P_ID_SUCURSAL        IN TRABAJADORES.ID_SUCURSAL%TYPE,
    P_ID_TURNO           IN TRABAJADORES.ID_TURNO%TYPE,
    P_ID_ROL             IN TRABAJADORES.ID_ROL%TYPE
)
IS
    V_EXISTE NUMBER;
    V_CORREO TRABAJADORES.CORREO_ELECTRONICO%TYPE;
BEGIN
    V_CORREO := LOWER(TRIM(P_CORREO_ELECTRONICO));

    IF TRIM(P_NOMBRE) IS NULL
       OR TRIM(P_APELLIDO1) IS NULL
       OR TRIM(P_IDENTIFICACION) IS NULL
       OR V_CORREO IS NULL
       OR P_ID_SUCURSAL IS NULL
       OR P_ID_TURNO IS NULL
       OR P_ID_ROL IS NULL THEN

        RAISE_APPLICATION_ERROR( -20300, 'Debe indicar todos los datos obligatorios del trabajador.' );
    END IF;

   IF NOT REGEXP_LIKE(
    UPPER(TRIM(P_IDENTIFICACION)),
    '^T-[0-9]{4}$'
) THEN
    RAISE_APPLICATION_ERROR(
        -20301,
        'La identificación debe tener el formato T-0000. Ejemplo: T-3013.'
    );
END IF;

    IF NOT REGEXP_LIKE(
        V_CORREO,
        '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'
    ) THEN
        RAISE_APPLICATION_ERROR( -20302, 'El correo electrónico no tiene un formato válido.' );
    END IF;

    SELECT COUNT(*)
    INTO V_EXISTE
    FROM TRABAJADORES
    WHERE TRIM(IDENTIFICACION) = TRIM(P_IDENTIFICACION);

    IF V_EXISTE > 0 THEN
        RAISE_APPLICATION_ERROR( -20303, 'Ya existe un trabajador con esa identificación.' );
    END IF;

    SELECT COUNT(*)
    INTO V_EXISTE
    FROM TRABAJADORES
    WHERE LOWER(TRIM(CORREO_ELECTRONICO)) = V_CORREO;

    IF V_EXISTE > 0 THEN
        RAISE_APPLICATION_ERROR(-20304,'Ya existe un trabajador con ese correo electrónico.');
    END IF;

    SELECT COUNT(*)
    INTO V_EXISTE
    FROM ROLES
    WHERE ID_ROL = P_ID_ROL;

    IF V_EXISTE = 0 THEN
        RAISE_APPLICATION_ERROR( -20305, 'El rol indicado no existe.' );
    END IF;

    SELECT COUNT(*)
    INTO V_EXISTE
    FROM TURNOS
    WHERE ID_TURNO = P_ID_TURNO;

    IF V_EXISTE = 0 THEN
        RAISE_APPLICATION_ERROR(
            -20306,
            'El turno indicado no existe.'
        );
    END IF;

    SELECT COUNT(*)
    INTO V_EXISTE
    FROM SUCURSALES
    WHERE ID_SUCURSAL = P_ID_SUCURSAL;

    IF V_EXISTE = 0 THEN
        RAISE_APPLICATION_ERROR(-20307, 'La sucursal indicada no existe.' );
    END IF;

    INSERT INTO TRABAJADORES (
        NOMBRE,
        APELLIDO1,
        APELLIDO2,
        IDENTIFICACION,
        CORREO_ELECTRONICO,
        ESTADO,
        ID_SUCURSAL,
        ID_TURNO,
        ID_ROL
    )
    VALUES (
        INITCAP(TRIM(P_NOMBRE)),
        INITCAP(TRIM(P_APELLIDO1)),
        INITCAP(TRIM(P_APELLIDO2)),
        TRIM(P_IDENTIFICACION),
        V_CORREO,
        'ACTIVO',
        P_ID_SUCURSAL,
        P_ID_TURNO,
        P_ID_ROL
    );

    DBMS_OUTPUT.PUT_LINE('Trabajador registrado correctamente.' );

EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        RAISE_APPLICATION_ERROR( -20308, 'La identificación o el correo ya están registrados.' );

    WHEN OTHERS THEN
        IF SQLCODE BETWEEN -20999 AND -20000 THEN
            RAISE;
        ELSE
            DBMS_OUTPUT.PUT_LINE('Código: ' || SQLCODE);
            DBMS_OUTPUT.PUT_LINE('Mensaje: ' || SQLERRM);

            RAISE_APPLICATION_ERROR(-20309, 'No se logró registrar el trabajador.' );
        END IF;
END PD_REGISTRAR_TRABAJADOR;

PROCEDURE pd_editar_trabajador (
    p_identificacion     IN trabajadores.identificacion%TYPE,
    p_nombre             IN trabajadores.nombre%TYPE DEFAULT NULL,
    p_apellido1          IN trabajadores.apellido1%TYPE DEFAULT NULL,
    p_apellido2          IN trabajadores.apellido2%TYPE DEFAULT NULL,
    p_correo_electronico IN trabajadores.correo_electronico%TYPE DEFAULT NULL,
    p_id_sucursal        IN trabajadores.id_sucursal%TYPE DEFAULT NULL,
    p_id_turno           IN trabajadores.id_turno%TYPE DEFAULT NULL
) IS
    v_existe        NUMBER;
    v_id_trabajador trabajadores.id_trabajador%TYPE;
    v_correo        trabajadores.correo_electronico%TYPE;
BEGIN
    IF TRIM(p_identificacion) IS NULL THEN
        raise_application_error(-20310, 'Debe indicar la identificación del trabajador.');
    END IF;

    v_correo := lower(trim(p_correo_electronico));
    BEGIN
        SELECT
            id_trabajador
        INTO v_id_trabajador
        FROM
            trabajadores
        WHERE
            TRIM(identificacion) = TRIM(p_identificacion);

    EXCEPTION
        WHEN no_data_found THEN
            raise_application_error(-20311, 'No existe un trabajador con esa identificación.');
    END;

    IF
        TRIM(p_nombre) IS NULL
        AND TRIM(p_apellido1) IS NULL
    AND TRIM(p_apellido2) IS NULL
          AND v_correo IS NULL
 AND p_id_sucursal IS NULL
           AND p_id_turno IS NULL
    THEN
        raise_application_error(-20312, 'Debe indicar al menos un dato para modificar.');
    END IF;

    IF v_correo IS NOT NULL THEN
        IF NOT regexp_like(v_correo, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$') THEN
            raise_application_error(-20313, 'El correo electrónico no tiene un formato válido.');
        END IF;

        SELECT
            COUNT(*)
        INTO v_existe
        FROM
            trabajadores
        WHERE
                lower(trim(correo_electronico)) = v_correo
            AND id_trabajador <> v_id_trabajador;

        IF v_existe > 0 THEN
            raise_application_error(-20314, 'El correo electrónico pertenece a otro trabajador.');
        END IF;
    END IF;

    IF p_id_sucursal IS NOT NULL THEN
        SELECT
            COUNT(*)
        INTO v_existe
        FROM
            sucursales
        WHERE
            id_sucursal = p_id_sucursal;

        IF v_existe = 0 THEN
            raise_application_error(-20315, 'La sucursal indicada no existe.');
        END IF;
    END IF;

    IF p_id_turno IS NOT NULL THEN
        SELECT
            COUNT(*)
        INTO v_existe
        FROM
            turnos
        WHERE
            id_turno = p_id_turno;

        IF v_existe = 0 THEN
            raise_application_error(-20316, 'El turno indicado no existe.');
        END IF;
    END IF;

    UPDATE trabajadores
    SET
        nombre = nvl(
            initcap(trim(p_nombre)),
            nombre
        ),
        apellido1 = nvl(
            initcap(trim(p_apellido1)),
            apellido1
        ),
        apellido2 = nvl(
            initcap(trim(p_apellido2)),
            apellido2
        ),
        correo_electronico = nvl(v_correo, correo_electronico),
        id_sucursal = nvl(p_id_sucursal, id_sucursal),
        id_turno = nvl(p_id_turno, id_turno)
    WHERE
        id_trabajador = v_id_trabajador;

    dbms_output.put_line('Datos del trabajador actualizados correctamente.');
EXCEPTION
    WHEN dup_val_on_index THEN
        raise_application_error(-20317, 'El correo electrónico ya está registrado.');
    WHEN OTHERS THEN
        IF sqlcode BETWEEN - 20999 AND - 20000 THEN
            RAISE;
        ELSE
            raise_application_error(-20318, 'No se lograron actualizar los datos del trabajador.');
        END IF;
END pd_editar_trabajador;

PROCEDURE pd_asignar_rol_trabajador (
    p_identificacion IN trabajadores.identificacion%TYPE,
    p_id_rol         IN roles.id_rol%TYPE
) IS
    v_id_trabajador trabajadores.id_trabajador%TYPE;
    v_rol_actual    trabajadores.id_rol%TYPE;
    v_existe        NUMBER;
BEGIN
    IF TRIM(p_identificacion) IS NULL
       OR p_id_rol IS NULL THEN
        raise_application_error(-20320, 'Debe indicar la identificación y el rol.');
    END IF;

    BEGIN
        SELECT
            id_trabajador,
            id_rol
        INTO
            v_id_trabajador,
            v_rol_actual
        FROM
            trabajadores
        WHERE
            TRIM(identificacion) = TRIM(p_identificacion);

    EXCEPTION
        WHEN no_data_found THEN
            raise_application_error(-20321, 'No existe un trabajador con esa identificación.');
    END;

    SELECT
        COUNT(*)
    INTO v_existe
    FROM
        roles
    WHERE
        id_rol = p_id_rol;

    IF v_existe = 0 THEN
        raise_application_error(-20322, 'El rol indicado no existe.');
    END IF;
    IF v_rol_actual = p_id_rol THEN
        raise_application_error(-20323, 'El trabajador ya tiene asignado ese rol.');
    END IF;
    UPDATE trabajadores
    SET
        id_rol = p_id_rol
    WHERE
        id_trabajador = v_id_trabajador;

    dbms_output.put_line('Rol asignado correctamente al trabajador.');
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode BETWEEN - 20999 AND - 20000 THEN
            RAISE;
        ELSE
            raise_application_error(-20324, 'No se logró asignar el rol al trabajador.');
        END IF;
END pd_asignar_rol_trabajador;

PROCEDURE pd_desactivar_trabajador (
    p_identificacion IN trabajadores.identificacion%TYPE
) IS
    v_id_trabajador trabajadores.id_trabajador%TYPE;
    v_estado        trabajadores.estado%TYPE;
    v_cant_ventas   NUMBER;
BEGIN
    IF TRIM(p_identificacion) IS NULL THEN
        raise_application_error(-20330, 'Debe indicar la identificación del trabajador.');
    END IF;

    BEGIN
        SELECT
            id_trabajador,
            estado
        INTO
            v_id_trabajador,
            v_estado
        FROM
            trabajadores
        WHERE
            TRIM(identificacion) = TRIM(p_identificacion);

    EXCEPTION
        WHEN no_data_found THEN
            raise_application_error(-20331, 'No existe un trabajador con esa identificación.');
    END;

    IF upper(trim(v_estado)) = 'INACTIVO' THEN
        raise_application_error(-20332, 'El trabajador ya se encuentra inactivo.');
    END IF;

    SELECT
        COUNT(*)
    INTO v_cant_ventas
    FROM
        ventas
    WHERE
        id_trabajador = v_id_trabajador;

    UPDATE trabajadores
    SET
        estado = 'INACTIVO'
    WHERE
        id_trabajador = v_id_trabajador;

    dbms_output.put_line('Trabajador desactivado correctamente.');
    IF v_cant_ventas > 0 THEN
        dbms_output.put_line('Se conservaron '
                             || v_cant_ventas
                             || ' venta(s) asociada(s) al trabajador.');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode BETWEEN - 20999 AND - 20000 THEN
            RAISE;
        ELSE
            raise_application_error(-20333, 'No se logró desactivar el trabajador.');
        END IF;
END pd_desactivar_trabajador;

PROCEDURE PD_CONSULTAR_VW_TRABAJADORES (
    P_CURSOR OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN P_CURSOR FOR
        SELECT *
        FROM VW_TRABAJADORES_DETALLE;
END PD_CONSULTAR_VW_TRABAJADORES;

PROCEDURE PD_CONSULTAR_VW_CANT_TRAB_ROL (
    P_CURSOR OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN P_CURSOR FOR
        SELECT *
        FROM VW_CANTIDAD_TRABAJADORES_ROL;
END PD_CONSULTAR_VW_CANT_TRAB_ROL;

PROCEDURE PD_CONSULTAR_VW_VENTAS_TRAB (
    P_CURSOR OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN P_CURSOR FOR
        SELECT *
        FROM VW_VENTAS_POR_TRABAJADOR;
END PD_CONSULTAR_VW_VENTAS_TRAB;

PROCEDURE PD_BUSCAR_TRABAJADOR_POR_ID (
    P_ID_TRABAJADOR IN TRABAJADORES.ID_TRABAJADOR%TYPE,
    P_CURSOR OUT SYS_REFCURSOR
)
AS
BEGIN
    OPEN P_CURSOR FOR
        SELECT
            ID_TRABAJADOR,
            NOMBRE,
            APELLIDO1,
            APELLIDO2,
            CORREO_ELECTRONICO,
            ESTADO
        FROM TRABAJADORES
        WHERE ID_TRABAJADOR = P_ID_TRABAJADOR;
END PD_BUSCAR_TRABAJADOR_POR_ID;

PROCEDURE PD_LISTAR_TRABAJADORES_POR_SUCURSAL (
    P_ID_SUCURSAL IN TRABAJADORES.ID_SUCURSAL%TYPE,
    P_CURSOR OUT SYS_REFCURSOR
)
AS
BEGIN
    OPEN P_CURSOR FOR
        SELECT
            ID_TRABAJADOR,
            NOMBRE,
            APELLIDO1,
            APELLIDO2,
            CORREO_ELECTRONICO,
            ESTADO
        FROM TRABAJADORES
        WHERE ID_SUCURSAL = P_ID_SUCURSAL
          AND ESTADO = 'Activo'
        ORDER BY NOMBRE;
END PD_LISTAR_TRABAJADORES_POR_SUCURSAL;

END PK_TRABAJADORES;
/

-- PK_ROLES
CREATE OR REPLACE PACKAGE PK_ROLES AS

    PROCEDURE SP_REGISTRAR_ROL (
        p_rol IN ROLES.ROL%TYPE
    );

    PROCEDURE SP_LISTAR_ROLES (
        p_cursor OUT SYS_REFCURSOR
    );

    PROCEDURE SP_ACTUALIZAR_ROL (
        p_id_rol IN ROLES.ID_ROL%TYPE,
        p_rol    IN ROLES.ROL%TYPE
    );

    PROCEDURE SP_ELIMINAR_ROL (
        p_id_rol IN ROLES.ID_ROL%TYPE
    );

END PK_ROLES;
/

CREATE OR REPLACE PACKAGE BODY PK_ROLES AS

    PROCEDURE SP_REGISTRAR_ROL (
        p_rol IN ROLES.ROL%TYPE
    )
    AS
    BEGIN
        INSERT INTO ROLES (ROL) VALUES (p_rol);
        COMMIT;
    END SP_REGISTRAR_ROL;

    PROCEDURE SP_LISTAR_ROLES (
        p_cursor OUT SYS_REFCURSOR
    )
    AS
    BEGIN
        OPEN p_cursor FOR
            SELECT ID_ROL, ROL
            FROM ROLES
            ORDER BY ROL;
    END SP_LISTAR_ROLES;

    PROCEDURE SP_ACTUALIZAR_ROL (
        p_id_rol IN ROLES.ID_ROL%TYPE,
        p_rol    IN ROLES.ROL%TYPE
    )
    AS
    BEGIN
        UPDATE ROLES
        SET ROL = NVL(p_rol, ROL)
        WHERE ID_ROL = p_id_rol;

        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20600, 'El rol indicado no existe.');
        END IF;

        COMMIT;
    END SP_ACTUALIZAR_ROL;

    PROCEDURE SP_ELIMINAR_ROL (
        p_id_rol IN ROLES.ID_ROL%TYPE
    )
    AS
        v_cantidad NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO v_cantidad
        FROM TRABAJADORES
        WHERE ID_ROL = p_id_rol;

        IF v_cantidad > 0 THEN
            RAISE_APPLICATION_ERROR(-20601, 'No se puede eliminar el rol porque tiene trabajadores asociados.');
        END IF;

        DELETE FROM ROLES WHERE ID_ROL = p_id_rol;

        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20602, 'El rol indicado no existe.');
        END IF;

        COMMIT;
    END SP_ELIMINAR_ROL;

END PK_ROLES;
/

-- PK_TURNOS
CREATE OR REPLACE PACKAGE PK_TURNOS AS

    PROCEDURE SP_REGISTRAR_TURNO (
        p_turno IN TURNOS.TURNO%TYPE
    );

    PROCEDURE SP_LISTAR_TURNOS (
        p_cursor OUT SYS_REFCURSOR
    );

    PROCEDURE SP_ACTUALIZAR_TURNO (
        p_id_turno IN TURNOS.ID_TURNO%TYPE,
        p_turno    IN TURNOS.TURNO%TYPE
    );

    PROCEDURE SP_ELIMINAR_TURNO (
        p_id_turno IN TURNOS.ID_TURNO%TYPE
    );

END PK_TURNOS;
/

CREATE OR REPLACE PACKAGE BODY PK_TURNOS AS

    PROCEDURE SP_REGISTRAR_TURNO (
        p_turno IN TURNOS.TURNO%TYPE
    )
    AS
    BEGIN
        INSERT INTO TURNOS (TURNO) VALUES (p_turno);
        COMMIT;
    END SP_REGISTRAR_TURNO;

    PROCEDURE SP_LISTAR_TURNOS (
        p_cursor OUT SYS_REFCURSOR
    )
    AS
    BEGIN
        OPEN p_cursor FOR
            SELECT ID_TURNO, TURNO
            FROM TURNOS
            ORDER BY TURNO;
    END SP_LISTAR_TURNOS;

    PROCEDURE SP_ACTUALIZAR_TURNO (
        p_id_turno IN TURNOS.ID_TURNO%TYPE,
        p_turno    IN TURNOS.TURNO%TYPE
    )
    AS
    BEGIN
        UPDATE TURNOS
        SET TURNO = NVL(p_turno, TURNO)
        WHERE ID_TURNO = p_id_turno;

        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20610, 'El turno indicado no existe.');
        END IF;

        COMMIT;
    END SP_ACTUALIZAR_TURNO;

    PROCEDURE SP_ELIMINAR_TURNO (
        p_id_turno IN TURNOS.ID_TURNO%TYPE
    )
    AS
        v_cantidad NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO v_cantidad
        FROM TRABAJADORES
        WHERE ID_TURNO = p_id_turno;

        IF v_cantidad > 0 THEN
            RAISE_APPLICATION_ERROR(-20611, 'No se puede eliminar el turno porque tiene trabajadores asociados.');
        END IF;

        DELETE FROM TURNOS WHERE ID_TURNO = p_id_turno;

        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20612, 'El turno indicado no existe.');
        END IF;

        COMMIT;
    END SP_ELIMINAR_TURNO;

END PK_TURNOS;
/

-- PK_TIPO_DEVOLUCIONES
CREATE OR REPLACE PACKAGE PK_TIPO_DEVOLUCIONES AS

    PROCEDURE SP_REGISTRAR_TIPO_DEVOLUCION (
        p_tipo_devolucion IN TIPO_DEVOLUCIONES.TIPO_DEVOLUCION%TYPE
    );

    PROCEDURE SP_LISTAR_TIPOS_DEVOLUCION (
        p_cursor OUT SYS_REFCURSOR
    );

    PROCEDURE SP_ACTUALIZAR_TIPO_DEVOLUCION (
        p_id_tipo_devolucion IN TIPO_DEVOLUCIONES.ID_TIPO_DEVOLUCION%TYPE,
        p_tipo_devolucion    IN TIPO_DEVOLUCIONES.TIPO_DEVOLUCION%TYPE
    );

    PROCEDURE SP_ELIMINAR_TIPO_DEVOLUCION (
        p_id_tipo_devolucion IN TIPO_DEVOLUCIONES.ID_TIPO_DEVOLUCION%TYPE
    );

END PK_TIPO_DEVOLUCIONES;
/

CREATE OR REPLACE PACKAGE BODY PK_TIPO_DEVOLUCIONES AS

    PROCEDURE SP_REGISTRAR_TIPO_DEVOLUCION (
        p_tipo_devolucion IN TIPO_DEVOLUCIONES.TIPO_DEVOLUCION%TYPE
    )
    AS
    BEGIN
        INSERT INTO TIPO_DEVOLUCIONES (TIPO_DEVOLUCION) VALUES (p_tipo_devolucion);
        COMMIT;
    END SP_REGISTRAR_TIPO_DEVOLUCION;

    PROCEDURE SP_LISTAR_TIPOS_DEVOLUCION (
        p_cursor OUT SYS_REFCURSOR
    )
    AS
    BEGIN
        OPEN p_cursor FOR
            SELECT ID_TIPO_DEVOLUCION, TIPO_DEVOLUCION
            FROM TIPO_DEVOLUCIONES
            ORDER BY TIPO_DEVOLUCION;
    END SP_LISTAR_TIPOS_DEVOLUCION;

    PROCEDURE SP_ACTUALIZAR_TIPO_DEVOLUCION (
        p_id_tipo_devolucion IN TIPO_DEVOLUCIONES.ID_TIPO_DEVOLUCION%TYPE,
        p_tipo_devolucion    IN TIPO_DEVOLUCIONES.TIPO_DEVOLUCION%TYPE
    )
    AS
    BEGIN
        UPDATE TIPO_DEVOLUCIONES
        SET TIPO_DEVOLUCION = NVL(p_tipo_devolucion, TIPO_DEVOLUCION)
        WHERE ID_TIPO_DEVOLUCION = p_id_tipo_devolucion;

        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20620, 'El tipo de devolución indicado no existe.');
        END IF;

        COMMIT;
    END SP_ACTUALIZAR_TIPO_DEVOLUCION;

    PROCEDURE SP_ELIMINAR_TIPO_DEVOLUCION (
        p_id_tipo_devolucion IN TIPO_DEVOLUCIONES.ID_TIPO_DEVOLUCION%TYPE
    )
    AS
        v_cantidad NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO v_cantidad
        FROM DEVOLUCION
        WHERE ID_TIPO_DEVOLUCION = p_id_tipo_devolucion;

        IF v_cantidad > 0 THEN
            RAISE_APPLICATION_ERROR(-20621, 'No se puede eliminar: hay devoluciones asociadas a este tipo.');
        END IF;

        DELETE FROM TIPO_DEVOLUCIONES WHERE ID_TIPO_DEVOLUCION = p_id_tipo_devolucion;

        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20622, 'El tipo de devolución indicado no existe.');
        END IF;

        COMMIT;
    END SP_ELIMINAR_TIPO_DEVOLUCION;

END PK_TIPO_DEVOLUCIONES;
/

-- PK_TIPO_PAGOS
CREATE OR REPLACE PACKAGE PK_TIPO_PAGOS AS

    PROCEDURE SP_REGISTRAR_TIPO_PAGO (
        p_metodo_pago IN TIPO_PAGOS.METODO_PAGO%TYPE
    );

    PROCEDURE SP_LISTAR_TIPOS_PAGO (
        p_cursor OUT SYS_REFCURSOR
    );

    PROCEDURE SP_ACTUALIZAR_TIPO_PAGO (
        p_id_tipo_pago IN TIPO_PAGOS.ID_TIPO_PAGO%TYPE,
        p_metodo_pago  IN TIPO_PAGOS.METODO_PAGO%TYPE
    );

    PROCEDURE SP_ELIMINAR_TIPO_PAGO (
        p_id_tipo_pago IN TIPO_PAGOS.ID_TIPO_PAGO%TYPE
    );

END PK_TIPO_PAGOS;
/

CREATE OR REPLACE PACKAGE BODY PK_TIPO_PAGOS AS

    PROCEDURE SP_REGISTRAR_TIPO_PAGO (
        p_metodo_pago IN TIPO_PAGOS.METODO_PAGO%TYPE
    )
    AS
    BEGIN
        INSERT INTO TIPO_PAGOS (METODO_PAGO) VALUES (p_metodo_pago);
        COMMIT;
    END SP_REGISTRAR_TIPO_PAGO;

    PROCEDURE SP_LISTAR_TIPOS_PAGO (
        p_cursor OUT SYS_REFCURSOR
    )
    AS
    BEGIN
        OPEN p_cursor FOR
            SELECT ID_TIPO_PAGO, METODO_PAGO
            FROM TIPO_PAGOS
            ORDER BY ID_TIPO_PAGO;
    END SP_LISTAR_TIPOS_PAGO;

    PROCEDURE SP_ACTUALIZAR_TIPO_PAGO (
        p_id_tipo_pago IN TIPO_PAGOS.ID_TIPO_PAGO%TYPE,
        p_metodo_pago  IN TIPO_PAGOS.METODO_PAGO%TYPE
    )
    AS
    BEGIN
        UPDATE TIPO_PAGOS
        SET METODO_PAGO = NVL(p_metodo_pago, METODO_PAGO)
        WHERE ID_TIPO_PAGO = p_id_tipo_pago;

        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20640, 'El método de pago indicado no existe.');
        END IF;

        COMMIT;
    END SP_ACTUALIZAR_TIPO_PAGO;

    PROCEDURE SP_ELIMINAR_TIPO_PAGO (
        p_id_tipo_pago IN TIPO_PAGOS.ID_TIPO_PAGO%TYPE
    )
    AS
        v_cantidad NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO v_cantidad
        FROM VENTAS
        WHERE ID_TIPO_PAGO = p_id_tipo_pago;

        IF v_cantidad > 0 THEN
            RAISE_APPLICATION_ERROR(-20641, 'No se puede eliminar: hay ventas asociadas a este método de pago.');
        END IF;

        DELETE FROM TIPO_PAGOS WHERE ID_TIPO_PAGO = p_id_tipo_pago;

        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20642, 'El método de pago indicado no existe.');
        END IF;

        COMMIT;
    END SP_ELIMINAR_TIPO_PAGO;

END PK_TIPO_PAGOS;
/

-- PK_PAGOS_TRABAJADORES
CREATE OR REPLACE PACKAGE PK_PAGOS_TRABAJADORES AS

    PROCEDURE SP_REGISTRAR_PAGO_TRABAJADOR (
        p_anio            IN PAGO_TRABAJADORES.ANIO%TYPE,
        p_mes             IN PAGO_TRABAJADORES.MES%TYPE,
        p_quincena        IN PAGO_TRABAJADORES.QUINCENA%TYPE,
        p_monto_hora      IN PAGO_TRABAJADORES.MONTO_HORA%TYPE,
        p_horas_laboradas IN PAGO_TRABAJADORES.HORAS_LABORADAS%TYPE,
        p_id_trabajador   IN PAGO_TRABAJADORES.ID_TRABAJADOR%TYPE
    );

    PROCEDURE SP_ACTUALIZAR_PAGO_TRABAJADOR (
        p_id_pago         IN PAGO_TRABAJADORES.ID_PAGO%TYPE,
        p_anio            IN PAGO_TRABAJADORES.ANIO%TYPE,
        p_mes             IN PAGO_TRABAJADORES.MES%TYPE,
        p_quincena        IN PAGO_TRABAJADORES.QUINCENA%TYPE,
        p_monto_hora      IN PAGO_TRABAJADORES.MONTO_HORA%TYPE,
        p_horas_laboradas IN PAGO_TRABAJADORES.HORAS_LABORADAS%TYPE,
        p_id_trabajador   IN PAGO_TRABAJADORES.ID_TRABAJADOR%TYPE
    );

    PROCEDURE SP_ELIMINAR_PAGO_TRABAJADOR (
        p_id_pago IN PAGO_TRABAJADORES.ID_PAGO%TYPE
    );

    PROCEDURE SP_LISTAR_PAGOS_TRABAJADOR (
        p_id_trabajador IN PAGO_TRABAJADORES.ID_TRABAJADOR%TYPE,
        p_cursor        OUT SYS_REFCURSOR
    );

END PK_PAGOS_TRABAJADORES;
/

CREATE OR REPLACE PACKAGE BODY PK_PAGOS_TRABAJADORES AS

PROCEDURE SP_REGISTRAR_PAGO_TRABAJADOR (
    p_anio            IN PAGO_TRABAJADORES.ANIO%TYPE,
    p_mes             IN PAGO_TRABAJADORES.MES%TYPE,
    p_quincena        IN PAGO_TRABAJADORES.QUINCENA%TYPE,
    p_monto_hora      IN PAGO_TRABAJADORES.MONTO_HORA%TYPE,
    p_horas_laboradas IN PAGO_TRABAJADORES.HORAS_LABORADAS%TYPE,
    p_id_trabajador   IN PAGO_TRABAJADORES.ID_TRABAJADOR%TYPE
)
AS
    v_trabajador NUMBER;
    v_monto_total PAGO_TRABAJADORES.MONTO_TOTAL%TYPE;
BEGIN

    SELECT COUNT(*)
    INTO v_trabajador
    FROM TRABAJADORES
    WHERE ID_TRABAJADOR = p_id_trabajador;

    IF v_trabajador = 0 THEN
        RAISE_APPLICATION_ERROR(
            -20010,
            'El trabajador indicado no existe.'
        );
    END IF;

    v_monto_total := p_monto_hora * p_horas_laboradas;

    INSERT INTO PAGO_TRABAJADORES (
        ANIO,
        MES,
        QUINCENA,
        MONTO_HORA,
        HORAS_LABORADAS,
        MONTO_TOTAL,
        ID_TRABAJADOR
    )
    VALUES (
        p_anio,
        p_mes,
        p_quincena,
        p_monto_hora,
        p_horas_laboradas,
        v_monto_total,
        p_id_trabajador
    );

    COMMIT;

    DBMS_OUTPUT.PUT_LINE(
        'Pago registrado correctamente.'
    );

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;

        DBMS_OUTPUT.PUT_LINE(
            'Error al registrar el pago: ' || SQLERRM
        );

END SP_REGISTRAR_PAGO_TRABAJADOR;

PROCEDURE SP_ACTUALIZAR_PAGO_TRABAJADOR (
    p_id_pago         IN PAGO_TRABAJADORES.ID_PAGO%TYPE,
    p_anio            IN PAGO_TRABAJADORES.ANIO%TYPE,
    p_mes             IN PAGO_TRABAJADORES.MES%TYPE,
    p_quincena        IN PAGO_TRABAJADORES.QUINCENA%TYPE,
    p_monto_hora      IN PAGO_TRABAJADORES.MONTO_HORA%TYPE,
    p_horas_laboradas IN PAGO_TRABAJADORES.HORAS_LABORADAS%TYPE,
    p_id_trabajador   IN PAGO_TRABAJADORES.ID_TRABAJADOR%TYPE
)
AS
BEGIN

    UPDATE PAGO_TRABAJADORES
    SET ANIO = NVL(p_anio, ANIO),
        MES = NVL(p_mes, MES),
        QUINCENA = NVL(p_quincena, QUINCENA),
        MONTO_HORA = NVL(p_monto_hora, MONTO_HORA),
        HORAS_LABORADAS =
            NVL(p_horas_laboradas, HORAS_LABORADAS),
        ID_TRABAJADOR =
            NVL(p_id_trabajador, ID_TRABAJADOR),
        MONTO_TOTAL =
            NVL(p_monto_hora, MONTO_HORA)
            *
            NVL(p_horas_laboradas, HORAS_LABORADAS)

    WHERE ID_PAGO = p_id_pago;

    IF SQL%ROWCOUNT > 0 THEN
        COMMIT;

        DBMS_OUTPUT.PUT_LINE(
            'Pago actualizado correctamente.'
        );
    ELSE
        DBMS_OUTPUT.PUT_LINE(
            'No existe el pago indicado.'
        );
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;

        DBMS_OUTPUT.PUT_LINE(
            'Error al actualizar el pago: ' || SQLERRM
        );

END SP_ACTUALIZAR_PAGO_TRABAJADOR;

PROCEDURE SP_ELIMINAR_PAGO_TRABAJADOR (
    p_id_pago IN PAGO_TRABAJADORES.ID_PAGO%TYPE
)
AS
    v_existe NUMBER;
BEGIN

    SELECT COUNT(*)
    INTO v_existe
    FROM PAGO_TRABAJADORES
    WHERE ID_PAGO = p_id_pago;

    IF v_existe = 0 THEN
        RAISE_APPLICATION_ERROR(
            -20011,
            'El pago indicado no existe.'
        );
    END IF;

    DELETE FROM PAGO_TRABAJADORES
    WHERE ID_PAGO = p_id_pago;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE(
        'Pago eliminado correctamente.'
    );

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;

        DBMS_OUTPUT.PUT_LINE(
            'Error al eliminar el pago: ' || SQLERRM
        );

END SP_ELIMINAR_PAGO_TRABAJADOR;

PROCEDURE SP_LISTAR_PAGOS_TRABAJADOR (
    p_id_trabajador IN PAGO_TRABAJADORES.ID_TRABAJADOR%TYPE,
    p_cursor        OUT SYS_REFCURSOR
)
AS
BEGIN

    OPEN p_cursor FOR
        SELECT
            P.ID_PAGO,
            P.ANIO,
            P.MES,
            P.QUINCENA,
            P.MONTO_HORA,
            P.HORAS_LABORADAS,
            P.MONTO_TOTAL,
            P.ID_TRABAJADOR
        FROM PAGO_TRABAJADORES P
        WHERE P.ID_TRABAJADOR = p_id_trabajador
        ORDER BY P.ANIO, P.MES, P.QUINCENA;

END SP_LISTAR_PAGOS_TRABAJADOR;

END PK_PAGOS_TRABAJADORES;
/

-- PK_CONSULTAS_GENERALES
CREATE OR REPLACE PACKAGE PK_CONSULTAS_GENERALES AS

    PROCEDURE SP_CONSULTAR_VENTAS (
        p_cursor OUT SYS_REFCURSOR
    );

    PROCEDURE SP_CONSULTAR_INVENTARIO (
        p_cursor OUT SYS_REFCURSOR
    );

    PROCEDURE SP_CONSULTAR_PROVEEDORES (
        p_cursor OUT SYS_REFCURSOR
    );

    PROCEDURE SP_CONSULTAR_CLIENTES (
        p_cursor OUT SYS_REFCURSOR
    );

END PK_CONSULTAS_GENERALES;
/

CREATE OR REPLACE PACKAGE BODY PK_CONSULTAS_GENERALES AS

PROCEDURE SP_CONSULTAR_VENTAS (
    p_cursor OUT SYS_REFCURSOR
)
AS
BEGIN

    OPEN p_cursor FOR
        SELECT
            ID_VENTA,
            FECHA_HORA,
            TOTAL,
            CEDULA,
            ID_TRABAJADOR,
            ID_TIPO_PAGO
        FROM VENTAS
        ORDER BY ID_VENTA;

END SP_CONSULTAR_VENTAS;

PROCEDURE SP_CONSULTAR_INVENTARIO (
    p_cursor OUT SYS_REFCURSOR
)
AS
BEGIN

    OPEN p_cursor FOR
        SELECT
            ID_PRODUCTOS_SUCURSALES,
            CANTIDAD,
            ID_SUCURSAL,
            ID_PRODUCTO
        FROM PRODUCTOS_SUCURSALES
        ORDER BY ID_PRODUCTOS_SUCURSALES;

END SP_CONSULTAR_INVENTARIO;

PROCEDURE SP_CONSULTAR_PROVEEDORES (
    p_cursor OUT SYS_REFCURSOR
)
AS
BEGIN

    OPEN p_cursor FOR
        SELECT
            ID_PROVEEDOR,
            NOMBRE_PROVEEDOR,
            NOMBRE_CONTACTO,
            APELLIDO1,
            APELLIDO2,
            CORREO_ELECTR,
            TELEFONO,
            ESTADO
        FROM PROVEEDORES
        ORDER BY ID_PROVEEDOR;

END SP_CONSULTAR_PROVEEDORES;

PROCEDURE SP_CONSULTAR_CLIENTES (
    p_cursor OUT SYS_REFCURSOR
)
AS
BEGIN

    OPEN p_cursor FOR
        SELECT
            CEDULA,
            NOMBRE,
            APELLIDO1,
            APELLIDO2,
            CORREO_ELECTR,
            TELEFONO
        FROM CLIENTES
        ORDER BY CEDULA;

END SP_CONSULTAR_CLIENTES;

END PK_CONSULTAS_GENERALES;
/


-- 9. TRIGGERS

CREATE OR REPLACE TRIGGER TRG_ESTADO_PROVEEDOR
BEFORE INSERT
ON PROVEEDORES
FOR EACH ROW
BEGIN
    IF :NEW.ESTADO IS NULL THEN
        :NEW.ESTADO := 'ACTIVO';
    END IF;
END TRG_ESTADO_PROVEEDOR;
/

CREATE OR REPLACE TRIGGER TRG_NO_ELIMINAR_PROV_CON_PRODUCTOS
BEFORE DELETE
ON PROVEEDORES
FOR EACH ROW
DECLARE
    V_CANTIDAD_PRODUCTOS NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO V_CANTIDAD_PRODUCTOS
    FROM PRODUCTOS
    WHERE ID_PROVEEDOR = :OLD.ID_PROVEEDOR;

    IF V_CANTIDAD_PRODUCTOS > 0 THEN
        RAISE_APPLICATION_ERROR(-20710, 'No se puede eliminar el proveedor porque tiene ' ||V_CANTIDAD_PRODUCTOS || ' producto(s) asociado(s).' );
    END IF;
END TRG_NO_ELIMINAR_PROV_CON_PRODUCTOS;
/

CREATE OR REPLACE TRIGGER TRG_VALIDAR_PRECIOS_PRODUCTO
BEFORE INSERT OR UPDATE ON PRODUCTOS
FOR EACH ROW
BEGIN
    IF :NEW.PRECIO_VENTA <= 0 THEN
        RAISE_APPLICATION_ERROR(-20020, 'El precio de venta debe ser mayor que cero.');
    END IF;
    IF :NEW.PRECIO_COSTO <= 0 THEN
        RAISE_APPLICATION_ERROR(-20021, 'El precio de costo debe ser mayor que cero.');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER TRG_VALIDAR_CANTIDAD_INVENTARIO
BEFORE INSERT OR UPDATE ON PRODUCTOS_SUCURSALES
FOR EACH ROW
BEGIN
    IF :NEW.CANTIDAD < 0 THEN
        RAISE_APPLICATION_ERROR(-20022, 'La cantidad de inventario no puede ser negativa.');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER TRG_CALCULAR_PAGO_TRABAJADOR
BEFORE INSERT OR UPDATE ON PAGO_TRABAJADORES
FOR EACH ROW
BEGIN
    IF :NEW.MONTO_HORA <= 0 THEN
        RAISE_APPLICATION_ERROR(-20023, 'El monto por hora debe ser mayor que cero.');
    END IF;
    IF :NEW.HORAS_LABORADAS < 0 THEN
        RAISE_APPLICATION_ERROR(-20024, 'Las horas laboradas no pueden ser negativas.');
    END IF;
    IF :NEW.MES < 1 OR :NEW.MES > 12 THEN
        RAISE_APPLICATION_ERROR(-20025, 'El mes debe estar entre 1 y 12.');
    END IF;
    IF :NEW.QUINCENA < 1 OR :NEW.QUINCENA > 2 THEN
        RAISE_APPLICATION_ERROR(-20026, 'La quincena debe ser 1 o 2.');
    END IF;
    :NEW.MONTO_TOTAL := :NEW.MONTO_HORA * :NEW.HORAS_LABORADAS;
END;
/

CREATE OR REPLACE TRIGGER TRG_FECHA_DEVOLUCION
BEFORE INSERT
ON DEVOLUCION
FOR EACH ROW
BEGIN
    IF :NEW.FECHA_HORA IS NULL THEN
        :NEW.FECHA_HORA := SYSDATE;
    END IF;
END TRG_FECHA_DEVOLUCION;
/

CREATE OR REPLACE TRIGGER TRG_VALIDAR_CANT_DEVOLUCION
BEFORE INSERT OR UPDATE OF CANTIDAD_DEVUELTA
ON DEVOLUCION
FOR EACH ROW
BEGIN
    IF :NEW.CANTIDAD_DEVUELTA IS NULL
       OR :NEW.CANTIDAD_DEVUELTA <= 0 THEN
        RAISE_APPLICATION_ERROR( -20120, 'La cantidad devuelta debe ser mayor que cero.' );
    END IF;
END;
/

CREATE OR REPLACE TRIGGER TRG_ESTADO_TRABAJADOR
BEFORE INSERT
ON TRABAJADORES
FOR EACH ROW
BEGIN
    IF :NEW.ESTADO IS NULL THEN
        :NEW.ESTADO := 'ACTIVO';
    END IF;
END TRG_ESTADO_TRABAJADOR;
/

CREATE OR REPLACE TRIGGER TRG_NO_ELIMINAR_TRABAJADOR_CON_VENTAS
BEFORE DELETE
ON TRABAJADORES
FOR EACH ROW
DECLARE
    V_CANTIDAD_VENTAS NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO V_CANTIDAD_VENTAS
    FROM VENTAS
    WHERE ID_TRABAJADOR = :OLD.ID_TRABAJADOR;

    IF V_CANTIDAD_VENTAS > 0 THEN
        RAISE_APPLICATION_ERROR(-20400,'No se puede eliminar el trabajador porque tiene ' ||
            V_CANTIDAD_VENTAS || ' venta(s) registrada(s). Debe desactivarlo en lugar de eliminarlo.'
        );
    END IF;
END TRG_NO_ELIMINAR_TRABAJADOR_CON_VENTAS;
/

CREATE OR REPLACE TRIGGER trg_auditar_cambio_rol
AFTER
    UPDATE OF id_rol ON trabajadores
    FOR EACH ROW
    WHEN ( old.id_rol <> new.id_rol )
BEGIN
    INSERT INTO auditoria_roles_trabajador (
        audit_id,
        id_trabajador,
        fecha_cambio,
        usuario,
        rol_anterior,
        rol_nuevo
    ) VALUES ( seq_auditoria_roles.NEXTVAL,
               :new.id_trabajador,
               systimestamp,
               user,
               :old.id_rol,
               :new.id_rol );
END trg_auditar_cambio_rol;
/