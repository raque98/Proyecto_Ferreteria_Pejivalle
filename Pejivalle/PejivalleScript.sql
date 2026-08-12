-- ---------------------------
--   TALLER PEJIVALLE 
--   Curso: SC-504 Lenguajes de bases de datos
-- ---------------------------

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Devolucion        CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        NULL;
END;

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Productos_Ventas  CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        NULL;
END;

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Ventas            CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        NULL;
END;

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Pago_Trabajadores CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        NULL;
END;

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Telefonos         CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        NULL;
END;

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Trabajadores      CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        NULL;
END;

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Productos_Sucursales  CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        NULL;
END;

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Sucursales_Direcciones CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        NULL;
END;

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Clientes_Direcciones  CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        NULL;
END;

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Proveedores_Direcciones CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        NULL;
END;

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Productos         CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        NULL;
END;

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Clientes          CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        NULL;
END;

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Sucursales        CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        NULL;
END;

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Proveedores       CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        NULL;
END;

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Direcciones       CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        NULL;
END;


BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Tipo_Devoluciones CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        NULL;
END;


BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Tipo_Pagos        CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        NULL;
END;


BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Categoria         CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        NULL;
END;


BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Roles             CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        NULL;
END;


BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Turnos            CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        NULL;
END;


BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Distrito          CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        NULL;
END;


BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Canton            CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        NULL;
END;


BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Provincia         CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        NULL;
END;


COMMIT;

--Crear tablas

CREATE TABLE provincia (
    id_provincia NUMBER(2) NOT NULL,
    nombre       VARCHAR2(100) NOT NULL,
    CONSTRAINT pk_provincia PRIMARY KEY ( id_provincia ),
    CONSTRAINT uk_provincia_nombre UNIQUE ( nombre )
);

CREATE TABLE canton (
    id_canton    NUMBER(3) NOT NULL,
    id_provincia NUMBER(2) NOT NULL,
    nombre       VARCHAR2(100) NOT NULL,
    CONSTRAINT pk_canton PRIMARY KEY ( id_canton ),
    CONSTRAINT fk_canton_provincia FOREIGN KEY ( id_provincia )
        REFERENCES provincia ( id_provincia )
);

CREATE TABLE distrito (
    id_distrito NUMBER(5) NOT NULL,
    id_canton   NUMBER(3) NOT NULL,
    nombre      VARCHAR2(100) NOT NULL,
    CONSTRAINT pk_distrito PRIMARY KEY ( id_distrito ),
    CONSTRAINT fk_distrito_canton FOREIGN KEY ( id_canton )
        REFERENCES canton ( id_canton )
);

CREATE TABLE direcciones (
    id_direccion NUMBER
        GENERATED ALWAYS AS IDENTITY,
    id_distrito  NUMBER NOT NULL,
    detalle      VARCHAR2(250) NOT NULL,
    CONSTRAINT pk_direcciones PRIMARY KEY ( id_direccion ),
    CONSTRAINT fk_dir_distrito FOREIGN KEY ( id_distrito )
        REFERENCES distrito ( id_distrito )
);

CREATE TABLE roles (
    id_rol NUMBER
        GENERATED ALWAYS AS IDENTITY
    PRIMARY KEY,
    rol    VARCHAR2(100) NOT NULL
);

CREATE TABLE turnos (
    id_turno NUMBER
        GENERATED ALWAYS AS IDENTITY
    PRIMARY KEY,
    turno    VARCHAR2(50) NOT NULL
);

CREATE TABLE tipo_pagos (
    id_tipo_pago NUMBER
        GENERATED ALWAYS AS IDENTITY
    PRIMARY KEY,
    metodo_pago  VARCHAR2(100) NOT NULL
);

CREATE TABLE tipo_devoluciones (
    id_tipo_devolucion NUMBER
        GENERATED ALWAYS AS IDENTITY
    PRIMARY KEY,
    tipo_devolucion    VARCHAR2(100) NOT NULL
);

CREATE TABLE categoria (
    id_categoria NUMBER
        GENERATED ALWAYS AS IDENTITY
    PRIMARY KEY,
    nombre       VARCHAR2(100) NOT NULL
);

CREATE TABLE sucursales (
    id_sucursal NUMBER
        GENERATED ALWAYS AS IDENTITY
    PRIMARY KEY,
    nombre      VARCHAR2(150) NOT NULL,
    estado      VARCHAR2(20) DEFAULT 'Activo' NOT NULL
);

CREATE TABLE sucursales_direcciones (
    id_sucursal_direccion NUMBER
        GENERATED ALWAYS AS IDENTITY
    PRIMARY KEY,
    id_sucursal           NUMBER NOT NULL,
    id_direccion          NUMBER NOT NULL,
    CONSTRAINT fk_sucdir_sucursal FOREIGN KEY ( id_sucursal )
        REFERENCES sucursales ( id_sucursal ),
    CONSTRAINT fk_sucdir_dir FOREIGN KEY ( id_direccion )
        REFERENCES direcciones ( id_direccion )
);

CREATE TABLE proveedores (
    id_proveedor     NUMBER
        GENERATED ALWAYS AS IDENTITY
    PRIMARY KEY,
    nombre_proveedor VARCHAR2(200) NOT NULL,
    nombre_contacto  VARCHAR2(150),
    apellido1        VARCHAR2(100),
    apellido2        VARCHAR2(100),
    correo_electr    VARCHAR2(200),
    telefono         VARCHAR2(20),
    estado           VARCHAR2(20) DEFAULT 'Activo'
);

CREATE TABLE proveedores_direcciones (
    id_proveedores_direcciones NUMBER
        GENERATED ALWAYS AS IDENTITY
    PRIMARY KEY,
    id_proveedor               NUMBER NOT NULL,
    id_direccion               NUMBER NOT NULL,
    CONSTRAINT fk_provdir_prov FOREIGN KEY ( id_proveedor )
        REFERENCES proveedores ( id_proveedor ),
    CONSTRAINT fk_provdir_dir FOREIGN KEY ( id_direccion )
        REFERENCES direcciones ( id_direccion )
);

CREATE TABLE productos (
    id_producto          NUMBER
        GENERATED ALWAYS AS IDENTITY
    PRIMARY KEY,
    nombre               VARCHAR2(200) NOT NULL,
    descripcion          VARCHAR2(500),
    precio_venta         NUMBER(12, 2) NOT NULL,
    precio_costo         NUMBER(12, 2) NOT NULL,
    fecha_ultima_entrada DATE,
    id_proveedor         NUMBER NOT NULL,
    id_categoria         NUMBER NOT NULL,
    CONSTRAINT fk_prod_proveedor FOREIGN KEY ( id_proveedor )
        REFERENCES proveedores ( id_proveedor ),
    CONSTRAINT fk_prod_categoria FOREIGN KEY ( id_categoria )
        REFERENCES categoria ( id_categoria )
);

CREATE TABLE productos_sucursales (
    id_productos_sucursales NUMBER
        GENERATED ALWAYS AS IDENTITY
    PRIMARY KEY,
    cantidad                NUMBER DEFAULT 0 NOT NULL,
    id_sucursal             NUMBER NOT NULL,
    id_producto             NUMBER NOT NULL,
    CONSTRAINT fk_prodsuc_sucursal FOREIGN KEY ( id_sucursal )
        REFERENCES sucursales ( id_sucursal ),
    CONSTRAINT fk_prodsuc_producto FOREIGN KEY ( id_producto )
        REFERENCES productos ( id_producto )
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
    id_clientes_direcciones NUMBER
        GENERATED ALWAYS AS IDENTITY
    PRIMARY KEY,
    cedula                  VARCHAR2(20) NOT NULL,
    id_direccion            NUMBER NOT NULL,
    CONSTRAINT fk_clidir_cliente FOREIGN KEY ( cedula )
        REFERENCES clientes ( cedula ),
    CONSTRAINT fk_clidir_dir FOREIGN KEY ( id_direccion )
        REFERENCES direcciones ( id_direccion )
);

CREATE TABLE trabajadores (
    id_trabajador      NUMBER
        GENERATED ALWAYS AS IDENTITY
    PRIMARY KEY,
    nombre             VARCHAR2(150) NOT NULL,
    apellido1          VARCHAR2(100) NOT NULL,
    apellido2          VARCHAR2(100),
    identificacion     VARCHAR2(20) NOT NULL,
    correo_electronico VARCHAR2(200),
    estado             VARCHAR2(20) DEFAULT 'Activo' NOT NULL,
    id_sucursal        NUMBER NOT NULL,
    id_turno           NUMBER NOT NULL,
    id_rol             NUMBER NOT NULL,
    CONSTRAINT fk_trab_sucursal FOREIGN KEY ( id_sucursal )
        REFERENCES sucursales ( id_sucursal ),
    CONSTRAINT fk_trab_turno FOREIGN KEY ( id_turno )
        REFERENCES turnos ( id_turno ),
    CONSTRAINT fk_trab_rol FOREIGN KEY ( id_rol )
        REFERENCES roles ( id_rol )
);

CREATE TABLE telefonos (
    id_telefono   NUMBER
        GENERATED ALWAYS AS IDENTITY
    PRIMARY KEY,
    telefono      VARCHAR2(20) NOT NULL,
    id_trabajador NUMBER NOT NULL,
    CONSTRAINT fk_tel_trabajador FOREIGN KEY ( id_trabajador )
        REFERENCES trabajadores ( id_trabajador )
);

CREATE TABLE pago_trabajadores (
    id_pago         NUMBER
        GENERATED ALWAYS AS IDENTITY
    PRIMARY KEY,
    anio            NUMBER(4) NOT NULL,
    mes             NUMBER(2) NOT NULL,
    quincena        NUMBER(1) NOT NULL,
    monto_hora      NUMBER(10, 2) NOT NULL,
    horas_laboradas NUMBER(6, 2) NOT NULL,
    monto_total     NUMBER(12, 2) NOT NULL,
    id_trabajador   NUMBER NOT NULL,
    CONSTRAINT fk_pago_trabajador FOREIGN KEY ( id_trabajador )
        REFERENCES trabajadores ( id_trabajador )
);

CREATE TABLE ventas (
    id_venta      NUMBER
        GENERATED ALWAYS AS IDENTITY
    PRIMARY KEY,
    fecha_hora    TIMESTAMP DEFAULT systimestamp NOT NULL,
    total         NUMBER(12, 2) NOT NULL,
    cedula        VARCHAR2(20) NOT NULL,
    id_trabajador NUMBER NOT NULL,
    id_tipo_pago  NUMBER NOT NULL,
    CONSTRAINT fk_venta_cliente FOREIGN KEY ( cedula )
        REFERENCES clientes ( cedula ),
    CONSTRAINT fk_venta_trabajador FOREIGN KEY ( id_trabajador )
        REFERENCES trabajadores ( id_trabajador ),
    CONSTRAINT fk_venta_tipopago FOREIGN KEY ( id_tipo_pago )
        REFERENCES tipo_pagos ( id_tipo_pago )
);

CREATE TABLE productos_ventas (
    id_productos_ventas NUMBER
        GENERATED ALWAYS AS IDENTITY
    PRIMARY KEY,
    cantidad            NUMBER NOT NULL,
    id_producto         NUMBER NOT NULL,
    id_venta            NUMBER NOT NULL,
    CONSTRAINT fk_prodventa_producto FOREIGN KEY ( id_producto )
        REFERENCES productos ( id_producto ),
    CONSTRAINT fk_prodventa_venta FOREIGN KEY ( id_venta )
        REFERENCES ventas ( id_venta )
);

CREATE TABLE devolucion (
    id_devolucion      NUMBER
        GENERATED ALWAYS AS IDENTITY
    PRIMARY KEY,
    motivo             VARCHAR2(500) NOT NULL,
    cantidad_devuelta  NUMBER NOT NULL,
    fecha_hora         TIMESTAMP DEFAULT systimestamp NOT NULL,
    cedula             VARCHAR2(20) NOT NULL,
    id_producto        NUMBER NOT NULL,
    id_venta           NUMBER NOT NULL,
    id_tipo_devolucion NUMBER NOT NULL,
    CONSTRAINT fk_dev_cliente FOREIGN KEY ( cedula )
        REFERENCES clientes ( cedula ),
    CONSTRAINT fk_dev_producto FOREIGN KEY ( id_producto )
        REFERENCES productos ( id_producto ),
    CONSTRAINT fk_dev_venta FOREIGN KEY ( id_venta )
        REFERENCES ventas ( id_venta ),
    CONSTRAINT fk_dev_tipodevol FOREIGN KEY ( id_tipo_devolucion )
        REFERENCES tipo_devoluciones ( id_tipo_devolucion )
);

COMMIT;




-- INSERTS


INSERT ALL INTO provincia (
    id_provincia,
    nombre
) VALUES ( 1,
           'San José' ) INTO provincia (
    id_provincia,
    nombre
) VALUES ( 2,
           'Alajuela' ) INTO provincia (
    id_provincia,
    nombre
) VALUES ( 3,
           'Cartago' ) INTO provincia (
    id_provincia,
    nombre
) VALUES ( 4,
           'Heredia' ) INTO provincia (
    id_provincia,
    nombre
) VALUES ( 5,
           'Guanacaste' ) INTO provincia (
    id_provincia,
    nombre
) VALUES ( 6,
           'Puntarenas' ) INTO provincia (
    id_provincia,
    nombre
) VALUES ( 7,
           'Limón' ) SELECT
              1
          FROM
              dual;

SELECT
    *
FROM
    provincia;

COMMIT;

INSERT ALL INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 101,
           'San José',
           1 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 102,
           'Escazú',
           1 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 103,
           'Desamparados',
           1 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 104,
           'Puriscal',
           1 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 105,
           'Tarrazú',
           1 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 106,
           'Aserrí',
           1 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 107,
           'Mora',
           1 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 108,
           'Goicoechea',
           1 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 109,
           'Santa Ana',
           1 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 110,
           'Alajuelita',
           1 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 111,
           'Vázquez De Coronado',
           1 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 112,
           'Acosta',
           1 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 113,
           'Tibás',
           1 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 114,
           'Moravia',
           1 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 115,
           'Montes De Oca',
           1 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 116,
           'Turrubares',
           1 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 117,
           'Dota',
           1 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 118,
           'Curridabat',
           1 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 119,
           'Pérez Zeledón',
           1 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 120,
           'León Cortés Castro',
           1 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 201,
           'Alajuela',
           2 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 202,
           'San Ramón',
           2 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 203,
           'Grecia',
           2 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 204,
           'San Mateo',
           2 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 205,
           'Atenas',
           2 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 206,
           'Naranjo',
           2 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 207,
           'Palmares',
           2 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 208,
           'Poás',
           2 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 209,
           'Orotina',
           2 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 210,
           'San Carlos',
           2 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 211,
           'Zarcero',
           2 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 212,
           'Valverde Vega',
           2 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 213,
           'Upala',
           2 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 214,
           'Los Chiles',
           2 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 215,
           'Guatuso',
           2 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 301,
           'Cartago',
           3 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 302,
           'Paraíso',
           3 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 303,
           'La Unión',
           3 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 304,
           'Jiménez',
           3 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 305,
           'Turrialba',
           3 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 306,
           'Alvarado',
           3 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 307,
           'Oreamuno',
           3 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 308,
           'El Guarco',
           3 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 401,
           'Heredia',
           4 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 402,
           'Barva',
           4 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 403,
           'Santo Domingo',
           4 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 404,
           'Santa Bárbara',
           4 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 405,
           'San Rafael',
           4 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 406,
           'San Isidro',
           4 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 407,
           'Belén',
           4 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 408,
           'Flores',
           4 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 409,
           'San Pablo',
           4 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 410,
           'Sarapiquí',
           4 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 501,
           'Liberia',
           5 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 502,
           'Nicoya',
           5 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 503,
           'Santa Cruz',
           5 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 504,
           'Bagaces',
           5 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 505,
           'Carrillo',
           5 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 506,
           'Cañas',
           5 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 507,
           'Abangares',
           5 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 508,
           'Tilarán',
           5 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 509,
           'Nandayure',
           5 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 510,
           'La Cruz',
           5 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 511,
           'Hojancha',
           5 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 601,
           'Puntarenas',
           6 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 602,
           'Esparza',
           6 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 603,
           'Buenos Aires',
           6 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 604,
           'Montes De Oro',
           6 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 605,
           'Osa',
           6 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 606,
           'Quepos',
           6 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 607,
           'Golfito',
           6 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 608,
           'Coto Brus',
           6 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 609,
           'Parrita',
           6 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 610,
           'Corredores',
           6 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 611,
           'Garabito',
           6 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 612,
           'Monteverde',
           6 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 613,
           'Puerto Jiménez',
           6 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 701,
           'Limón',
           7 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 702,
           'Pococí',
           7 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 703,
           'Siquirres',
           7 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 704,
           'Talamanca',
           7 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 705,
           'Matina',
           7 ) INTO canton (
    id_canton,
    nombre,
    id_provincia
) VALUES ( 706,
           'Guácimo',
           7 ) SELECT
        1
    FROM
        dual;

SELECT
    *
FROM
    canton;

COMMIT;

INSERT ALL INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 10101,
           'Carmen',
           101 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 10102,
           'Merced',
           101 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 10103,
           'Hospital',
           101 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 10104,
           'Catedral',
           101 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 10105,
           'Zapote',
           101 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 10106,
           'San Francisco de Dos Ríos',
           101 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 10107,
           'Uruca',
           101 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 10108,
           'Mata Redonda',
           101 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 10109,
           'Pavas',
           101 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 10110,
           'Hatillo',
           101 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 10111,
           'San Sebastián',
           101 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 10201,
           'Escazú',
           102 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 10202,
           'San Antonio',
           102 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 10203,
           'San Rafael',
           102 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 10301,
           'Desamparados',
           103 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 10302,
           'San Miguel',
           103 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 10303,
           'San Juan de Dios',
           103 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 10304,
           'San Rafael Arriba',
           103 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 10305,
           'San Antonio',
           103 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 10306,
           'Frailes',
           103 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 10307,
           'Patarrá',
           103 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 10308,
           'San Cristóbal',
           103 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 10309,
           'Rosario',
           103 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 10310,
           'Damas',
           103 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 10311,
           'San Rafael Abajo',
           103 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 10312,
           'Gravilias',
           103 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 10313,
           'Los Guido',
           103 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 10401,
           'Santiago',
           104 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 10402,
           'Mercedes Sur',
           104 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 10403,
           'Barbacoas',
           104 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 10404,
           'Grifo Alto',
           104 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 10405,
           'San Rafael',
           104 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 10406,
           'Candelarita',
           104 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 10407,
           'Desamparaditos',
           104 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 10408,
           'San Antonio',
           104 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 10409,
           'Chires',
           104 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 10501,
           'San Marcos',
           105 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 10502,
           'San Lorenzo',
           105 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 10503,
           'San Carlos',
           105 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 10601,
           'Aserrí',
           106 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 10602,
           'Tarbaca',
           106 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 10603,
           'Vuelta de Jorco',
           106 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 10604,
           'San Gabriel',
           106 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 10605,
           'Legua',
           106 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 10606,
           'Monterrey',
           106 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 10607,
           'Salitrillos',
           106 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 10701,
           'Colón',
           107 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 10702,
           'Guayabo',
           107 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 10703,
           'Tabarcia',
           107 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 10704,
           'Piedras Negras',
           107 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 10705,
           'Picagres',
           107 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 10706,
           'Jaris',
           107 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 10707,
           'Quitirrisí',
           107 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 10801,
           'Guadalupe',
           108 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 10802,
           'San Francisco',
           108 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 10803,
           'Calle Blancos',
           108 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 10804,
           'Mata de Plátano',
           108 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 10805,
           'Ipís',
           108 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 10806,
           'Rancho Redondo',
           108 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 10807,
           'Purral',
           108 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 10901,
           'Santa Ana',
           109 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 10902,
           'Salitral',
           109 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 10903,
           'Pozos',
           109 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 10904,
           'Uruca',
           109 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 10905,
           'Piedades',
           109 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 10906,
           'Brasil',
           109 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 11001,
           'Alajuelita',
           110 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 11002,
           'San Josecito',
           110 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 11003,
           'San Antonio',
           110 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 11004,
           'Concepción',
           110 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 11005,
           'San Felipe',
           110 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 11101,
           'San Isidro',
           111 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 11102,
           'San Rafael',
           111 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 11103,
           'Dulce Nombre de Jesús',
           111 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 11104,
           'Patalillo',
           111 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 11105,
           'Cascajal',
           111 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 11201,
           'San Ignacio',
           112 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 11202,
           'Guaitil',
           112 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 11203,
           'Palmichal',
           112 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 11204,
           'Cangrejal',
           112 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 11205,
           'Sabanillas',
           112 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 11301,
           'San Juan',
           113 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 11302,
           'Cinco Esquinas',
           113 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 11303,
           'Anselmo Llorente',
           113 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 11304,
           'León XIII',
           113 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 11305,
           'Colima',
           113 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 11401,
           'San Vicente',
           114 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 11402,
           'San Jerónimo',
           114 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 11403,
           'La Trinidad',
           114 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 11501,
           'San Pedro',
           115 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 11502,
           'Sabanilla',
           115 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 11503,
           'Mercedes',
           115 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 11504,
           'San Rafael',
           115 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 11601,
           'San Pablo',
           116 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 11602,
           'San Pedro',
           116 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 11603,
           'San Juan de Mata',
           116 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 11604,
           'San Luis',
           116 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 11605,
           'Carara',
           116 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 11701,
           'Santa María',
           117 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 11702,
           'Jardín',
           117 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 11703,
           'Copey',
           117 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 11801,
           'Curridabat',
           118 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 11802,
           'Granadilla',
           118 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 11803,
           'Sánchez',
           118 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 11804,
           'Tirrases',
           118 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 11901,
           'San Isidro de El General',
           119 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 11902,
           'El General',
           119 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 11903,
           'Daniel Flores',
           119 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 11904,
           'Rivas',
           119 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 11905,
           'San Pedro',
           119 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 11906,
           'Platanares',
           119 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 11907,
           'Pejibaye',
           119 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 11908,
           'Cajón',
           119 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 11909,
           'Barú',
           119 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 11910,
           'Río Nuevo',
           119 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 11911,
           'Páramo',
           119 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 11912,
           'La Amistad',
           119 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 12001,
           'San Pablo',
           120 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 12002,
           'San Andrés',
           120 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 12003,
           'Llano Bonito',
           120 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 12004,
           'San Isidro',
           120 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 12005,
           'Santa Cruz',
           120 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 12006,
           'San Antonio',
           120 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 20101,
           'Alajuela',
           201 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 20102,
           'San José',
           201 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 20103,
           'Carrizal',
           201 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 20104,
           'San Antonio',
           201 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 20105,
           'Guácima',
           201 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 20106,
           'San Isidro',
           201 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 20107,
           'Sabanilla',
           201 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 20108,
           'San Rafael',
           201 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 20109,
           'Río Segundo',
           201 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 20110,
           'Desamparados',
           201 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 20111,
           'Turrúcares',
           201 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 20112,
           'Tambor',
           201 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 20113,
           'La Garita',
           201 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 20114,
           'Sarapiquí',
           201 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 20201,
           'San Ramón',
           202 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 20202,
           'Santiago',
           202 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 20203,
           'San Juan',
           202 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 20204,
           'Piedades Norte',
           202 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 20205,
           'Piedades Sur',
           202 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 20206,
           'San Rafael',
           202 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 20207,
           'San Isidro',
           202 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 20208,
           'Ángeles',
           202 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 20209,
           'Alfaro',
           202 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 20210,
           'Volio',
           202 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 20211,
           'Concepción',
           202 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 20212,
           'Zapotal',
           202 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 20213,
           'Peñas Blancas',
           202 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 20214,
           'San Lorenzo',
           202 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 20301,
           'Grecia',
           203 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 20302,
           'San Isidro',
           203 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 20303,
           'San José',
           203 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 20304,
           'San Roque',
           203 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 20305,
           'Tacares',
           203 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 20306,
           'Puente de Piedra',
           203 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 20307,
           'Bolívar',
           203 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 30101,
           'Oriental',
           301 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 30102,
           'Occidental',
           301 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 30103,
           'Carmen',
           301 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 30104,
           'San Nicolás',
           301 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 30105,
           'Aguacaliente',
           301 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 30106,
           'Guadalupe',
           301 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 30107,
           'Corralillo',
           301 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 30108,
           'Tierra Blanca',
           301 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 30109,
           'Dulce Nombre',
           301 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 30110,
           'Llano Grande',
           301 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 30111,
           'Quebradilla',
           301 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 30201,
           'Paraíso',
           302 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 30202,
           'Santiago',
           302 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 30203,
           'Orosi',
           302 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 30204,
           'Cervantes',
           302 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 30205,
           'Llanos de Santa Lucía',
           302 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 30206,
           'Río Azul',
           302 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 30301,
           'Tres Ríos',
           303 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 30302,
           'San Diego',
           303 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 30303,
           'San Juan',
           303 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 30304,
           'San Rafael',
           303 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 30305,
           'Concepción',
           303 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 30306,
           'Dulce Nombre',
           303 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 30307,
           'San Ramón',
           303 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 30308,
           'Santa Rosa',
           303 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 30401,
           'Juan Viñas',
           304 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 30402,
           'Tucurrique',
           304 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 30403,
           'Pejivalle',
           304 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 30501,
           'Turrialba',
           305 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 30502,
           'Peralta',
           305 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 30503,
           'Santa Cruz',
           305 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 30504,
           'Santa Teresita',
           305 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 30505,
           'Pavones',
           305 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 30506,
           'Tuis',
           305 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 30507,
           'Tayutic',
           305 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 30508,
           'Santa Rosa',
           305 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 30509,
           'Tres Equis',
           305 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 30510,
           'La Isabel',
           305 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 30511,
           'Chirripó',
           305 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 30512,
           'La Central',
           305 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 30601,
           'Pacayas',
           306 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 30602,
           'Cervantes',
           306 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 30603,
           'Capellades',
           306 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 30701,
           'San Rafael',
           307 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 30702,
           'Cot',
           307 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 30703,
           'Potrero Cerrado',
           307 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 30704,
           'Cipreses',
           307 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 30705,
           'Santa Rosa',
           307 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 30801,
           'El Tejar',
           308 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 30802,
           'San Isidro',
           308 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 30803,
           'Tobosi',
           308 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 30804,
           'Patio de Agua',
           308 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 40101,
           'Heredia',
           401 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 40102,
           'Mercedes',
           401 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 40103,
           'San Francisco',
           401 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 40104,
           'Ulloa',
           401 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 40105,
           'Varablanca',
           401 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 40201,
           'Barva',
           402 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 40202,
           'San Pedro',
           402 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 40203,
           'San Pablo',
           402 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 40204,
           'San Roque',
           402 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 40205,
           'Santa Lucía',
           402 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 40206,
           'San José de la Montaña',
           402 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 40301,
           'Santo Domingo',
           403 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 40302,
           'San Vicente',
           403 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 40303,
           'San Miguel',
           403 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 40304,
           'Paracito',
           403 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 40305,
           'Santo Tomás',
           403 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 40306,
           'Santa Rosa',
           403 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 40307,
           'Tures',
           403 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 40308,
           'Pará',
           403 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 40401,
           'Santa Bárbara',
           404 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 40402,
           'San Pedro',
           404 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 40403,
           'San Juan',
           404 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 40404,
           'Jesús',
           404 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 40405,
           'Santo Domingo',
           404 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 40406,
           'Purabá',
           404 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 40501,
           'San Rafael',
           405 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 40502,
           'San Josecito',
           405 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 40503,
           'Santiago',
           405 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 40504,
           'Ángeles',
           405 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 40505,
           'Concepción',
           405 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 40601,
           'San Isidro',
           406 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 40602,
           'San José',
           406 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 40603,
           'Concepción',
           406 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 40604,
           'San Francisco',
           406 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 40701,
           'San Antonio',
           407 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 40702,
           'La Ribera',
           407 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 40703,
           'La Asunción',
           407 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 40801,
           'San Joaquín',
           408 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 40802,
           'Barrantes',
           408 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 40803,
           'Llorente',
           408 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 40901,
           'San Pablo',
           409 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 40902,
           'Rincón de Sabanilla',
           409 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 41001,
           'Puerto Viejo',
           410 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 41002,
           'La Virgen',
           410 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 41003,
           'Las Horquetas',
           410 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 41004,
           'Llanuras del Gaspar',
           410 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 41005,
           'Cureña',
           410 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 50101,
           'Liberia',
           501 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 50102,
           'Cañas Dulces',
           501 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 50103,
           'Mayorga',
           501 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 50104,
           'Nacascolo',
           501 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 50105,
           'Curubandé',
           501 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 50201,
           'Nicoya',
           502 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 50202,
           'Mansión',
           502 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 50203,
           'San Antonio',
           502 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 50204,
           'Quebrada Honda',
           502 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 50205,
           'Sámara',
           502 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 50206,
           'Nosara',
           502 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 50207,
           'Belén de Nosarita',
           502 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 50301,
           'Santa Cruz',
           503 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 50302,
           'Bolsón',
           503 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 50303,
           'Veintisiete de Abril',
           503 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 50304,
           'Tempate',
           503 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 50305,
           'Cartagena',
           503 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 50306,
           'Cuajiniquil',
           503 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 50307,
           'Diriá',
           503 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 50308,
           'Cabo Velas',
           503 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 50309,
           'Tamarindo',
           503 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 50401,
           'Bagaces',
           504 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 50402,
           'La Fortuna',
           504 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 50403,
           'Mogote',
           504 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 50404,
           'Río Naranjo',
           504 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 50501,
           'Filadelfia',
           505 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 50502,
           'Belén',
           505 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 50503,
           'Palmira',
           505 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 50504,
           'Sardinal',
           505 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 50601,
           'Cañas',
           506 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 50602,
           'Palmira',
           506 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 50603,
           'San Miguel',
           506 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 50604,
           'Bebedero',
           506 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 50605,
           'Porozal',
           506 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 50701,
           'Las Juntas',
           507 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 50702,
           'Sierra',
           507 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 50703,
           'San Juan',
           507 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 50704,
           'Colorado',
           507 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 50801,
           'Tilarán',
           508 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 50802,
           'Quebrada Grande',
           508 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 50803,
           'Tronadora',
           508 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 50804,
           'Santa Rosa',
           508 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 50805,
           'Líbano',
           508 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 50806,
           'Tierras Morenas',
           508 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 50807,
           'Arenal',
           508 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 50808,
           'Cabeceras',
           508 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 50901,
           'Carmona',
           509 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 50902,
           'Santa Rita',
           509 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 50903,
           'Zapotal',
           509 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 50904,
           'San Pablo',
           509 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 50905,
           'Porvenir',
           509 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 50906,
           'Bejuco',
           509 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 51001,
           'La Cruz',
           510 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 51002,
           'Santa Cecilia',
           510 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 51003,
           'La Garita',
           510 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 51004,
           'Santa Elena',
           510 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 51101,
           'Hojancha',
           511 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 51102,
           'Monte Romo',
           511 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 51103,
           'Puerto Carrillo',
           511 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 51104,
           'Huacas',
           511 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 51105,
           'Matambú',
           511 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 60101,
           'Puntarenas',
           601 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 60102,
           'Pitahaya',
           601 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 60103,
           'Chomes',
           601 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 60104,
           'Lepanto',
           601 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 60105,
           'Paquera',
           601 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 60106,
           'Manzanillo',
           601 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 60107,
           'Guacimal',
           601 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 60108,
           'Barranca',
           601 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 60109,
           'Isla del Coco',
           601 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 60110,
           'Cóbano',
           601 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 60111,
           'Chacarita',
           601 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 60112,
           'Chira',
           601 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 60113,
           'Acapulco',
           601 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 60114,
           'El Roble',
           601 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 60115,
           'Arancibia',
           601 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 60201,
           'Espíritu Santo',
           602 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 60202,
           'San Juan Grande',
           602 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 60203,
           'Macacona',
           602 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 60204,
           'San Rafael',
           602 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 60205,
           'San Jerónimo',
           602 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 60206,
           'Caldera',
           602 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 60301,
           'Buenos Aires',
           603 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 60302,
           'Volcán',
           603 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 60303,
           'Potrero Grande',
           603 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 60304,
           'Boruca',
           603 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 60305,
           'Pilas',
           603 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 60306,
           'Colinas',
           603 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 60307,
           'Chánguena',
           603 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 60308,
           'Biolley',
           603 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 60309,
           'Brunka',
           603 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 60401,
           'Miramar',
           604 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 60402,
           'La Unión',
           604 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 60403,
           'San Isidro',
           604 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 60501,
           'Puerto Cortés',
           605 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 60502,
           'Palmar',
           605 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 60503,
           'Sierpe',
           605 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 60504,
           'Piedras Blancas',
           605 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 60505,
           'Bahía Ballena',
           605 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 60506,
           'Bahía Drake',
           605 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 60601,
           'Quepos',
           606 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 60602,
           'Savegre',
           606 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 60603,
           'Naranjito',
           606 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 60701,
           'Golfito',
           607 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 60702,
           'Guaycará',
           607 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 60703,
           'Pavón',
           607 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 60801,
           'San Vito',
           608 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 60802,
           'Sabalito',
           608 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 60803,
           'Aguabuena',
           608 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 60804,
           'Limoncito',
           608 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 60805,
           'Pittier',
           608 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 60806,
           'Gutiérrez Braun',
           608 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 60901,
           'Parrita',
           609 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 61001,
           'Corredor',
           610 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 61002,
           'La Cuesta',
           610 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 61003,
           'Canoas',
           610 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 61004,
           'Laurel',
           610 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 61101,
           'Jacó',
           611 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 61102,
           'Tárcoles',
           611 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 61103,
           'Lagunillas',
           611 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 61201,
           'Santa Elena',
           612 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 61301,
           'Puerto Jiménez',
           613 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 70101,
           'Limón',
           701 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 70102,
           'Valle La Estrella',
           701 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 70103,
           'Río Blanco',
           701 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 70104,
           'Matama',
           701 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 70201,
           'Guápiles',
           702 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 70202,
           'Jiménez',
           702 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 70203,
           'Rita',
           702 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 70204,
           'Roxana',
           702 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 70205,
           'Cariari',
           702 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 70206,
           'Colorado',
           702 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 70207,
           'La Colonia',
           702 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 70301,
           'Siquirres',
           703 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 70302,
           'Pacuarito',
           703 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 70303,
           'Florida',
           703 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 70304,
           'Germania',
           703 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 70305,
           'El Cairo',
           703 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 70306,
           'Alegría',
           703 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 70307,
           'Reventazón',
           703 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 70401,
           'Bratsi',
           704 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 70402,
           'Sixaola',
           704 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 70403,
           'Cahuita',
           704 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 70404,
           'Telire',
           704 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 70501,
           'Matina',
           705 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 70502,
           'Batán',
           705 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 70503,
           'Carrandi',
           705 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 70601,
           'Guácimo',
           706 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 70602,
           'Mercedes',
           706 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 70603,
           'Pocora',
           706 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 70604,
           'Río Jiménez',
           706 ) INTO distrito (
    id_distrito,
    nombre,
    id_canton
) VALUES ( 70605,
           'Duacarí',
           706 ) SELECT
          1
      FROM
          dual;

COMMIT;

INSERT INTO direcciones (
    id_distrito,
    detalle
) VALUES ( 10101,
           '200m norte de la Iglesia del Carmen' );

INSERT INTO direcciones (
    id_distrito,
    detalle
) VALUES ( 10101,
           'Frente al Parque Nacional' );

INSERT INTO direcciones (
    id_distrito,
    detalle
) VALUES ( 10102,
           'Costado sur del Hospital San Juan de Dios' );

INSERT INTO direcciones (
    id_distrito,
    detalle
) VALUES ( 10103,
           '100m este del Teatro Nacional' );

INSERT INTO direcciones (
    id_distrito,
    detalle
) VALUES ( 10104,
           'Barrio Escalante, Avenida Central' );

INSERT INTO direcciones (
    id_distrito,
    detalle
) VALUES ( 10105,
           '200m oeste del Mall San Pedro' );

INSERT INTO direcciones (
    id_distrito,
    detalle
) VALUES ( 10201,
           'Centro de Desamparados, frente a la Municipalidad' );

INSERT INTO direcciones (
    id_distrito,
    detalle
) VALUES ( 10202,
           'San Miguel, contiguo al BAC' );

INSERT INTO direcciones (
    id_distrito,
    detalle
) VALUES ( 10203,
           'San Juan de Dios, 50m sur del parque' );

INSERT INTO direcciones (
    id_distrito,
    detalle
) VALUES ( 10301,
           'Curridabat centro, costado norte del parque' );

INSERT INTO direcciones (
    id_distrito,
    detalle
) VALUES ( 10302,
           'Granadilla, 300m este de la iglesia' );

INSERT INTO direcciones (
    id_distrito,
    detalle
) VALUES ( 10303,
           'Tirrases, frente al Ebais' );

INSERT INTO direcciones (
    id_distrito,
    detalle
) VALUES ( 10401,
           'Zapote centro, frente a Casa Presidencial' );

INSERT INTO direcciones (
    id_distrito,
    detalle
) VALUES ( 10402,
           'San Francisco, costado oeste del parque' );

INSERT INTO direcciones (
    id_distrito,
    detalle
) VALUES ( 20101,
           'Alajuela centro, frente al Parque Juan Santamaria' );

INSERT INTO direcciones (
    id_distrito,
    detalle
) VALUES ( 20102,
           'El Roble, 200m norte de la escuela' );

INSERT INTO direcciones (
    id_distrito,
    detalle
) VALUES ( 20103,
           'Desamparados de Alajuela, frente al super' );

INSERT INTO direcciones (
    id_distrito,
    detalle
) VALUES ( 20201,
           'San Ramon centro, contiguo a la iglesia' );

INSERT INTO direcciones (
    id_distrito,
    detalle
) VALUES ( 20202,
           'Santiago, 100m oeste del Ebais' );

INSERT INTO direcciones (
    id_distrito,
    detalle
) VALUES ( 20203,
           'Piedades Norte, frente a la plaza' );

INSERT INTO direcciones (
    id_distrito,
    detalle
) VALUES ( 20301,
           'Grecia centro, Avenida Central' );

INSERT INTO direcciones (
    id_distrito,
    detalle
) VALUES ( 20302,
           'San Roque, costado este de la iglesia' );

INSERT INTO direcciones (
    id_distrito,
    detalle
) VALUES ( 30101,
           'Cartago centro, frente a la Basilica' );

INSERT INTO direcciones (
    id_distrito,
    detalle
) VALUES ( 30102,
           'Oriental, 200m sur del TEC' );

INSERT INTO direcciones (
    id_distrito,
    detalle
) VALUES ( 30103,
           'Occidental, frente al parque' );

INSERT INTO direcciones (
    id_distrito,
    detalle
) VALUES ( 30201,
           'Paraiso centro, costado norte del parque' );

INSERT INTO direcciones (
    id_distrito,
    detalle
) VALUES ( 30202,
           'Santiago, frente al colegio' );

INSERT INTO direcciones (
    id_distrito,
    detalle
) VALUES ( 40101,
           'Heredia centro, frente al Fortin' );

INSERT INTO direcciones (
    id_distrito,
    detalle
) VALUES ( 40102,
           'Mercedes, 300m norte de la iglesia' );

INSERT INTO direcciones (
    id_distrito,
    detalle
) VALUES ( 40103,
           'San Francisco, frente al parque' );

INSERT INTO direcciones (
    id_distrito,
    detalle
) VALUES ( 40201,
           'Barva centro, contiguo al banco' );

INSERT INTO direcciones (
    id_distrito,
    detalle
) VALUES ( 40202,
           'San Pedro, frente al Ebais' );

INSERT INTO direcciones (
    id_distrito,
    detalle
) VALUES ( 50101,
           'Liberia centro, frente al parque' );

INSERT INTO direcciones (
    id_distrito,
    detalle
) VALUES ( 50102,
           'Cañas Dulces, costado sur de la plaza' );

INSERT INTO direcciones (
    id_distrito,
    detalle
) VALUES ( 50201,
           'Nicoya centro, Avenida Central' );

INSERT INTO direcciones (
    id_distrito,
    detalle
) VALUES ( 50202,
           'Samara, frente a la playa' );

INSERT INTO direcciones (
    id_distrito,
    detalle
) VALUES ( 60101,
           'Puntarenas centro, frente al muelle' );

INSERT INTO direcciones (
    id_distrito,
    detalle
) VALUES ( 60102,
           'El Roble, costado norte de la iglesia' );

INSERT INTO direcciones (
    id_distrito,
    detalle
) VALUES ( 60201,
           'Esparza centro, frente al parque' );

INSERT INTO direcciones (
    id_distrito,
    detalle
) VALUES ( 70101,
           'Limon centro, frente al parque Vargas' );

INSERT INTO direcciones (
    id_distrito,
    detalle
) VALUES ( 70102,
           'Valle La Estrella, frente a la escuela' );

INSERT INTO direcciones (
    id_distrito,
    detalle
) VALUES ( 70201,
           'Guapiles centro, Avenida Central' );

INSERT INTO direcciones (
    id_distrito,
    detalle
) VALUES ( 70202,
           'Jimenez, frente al colegio' );

INSERT INTO direcciones (
    id_distrito,
    detalle
) VALUES ( 70301,
           'Siquirres centro, contiguo al banco' );

INSERT INTO direcciones (
    id_distrito,
    detalle
) VALUES ( 70302,
           'Florida, frente a la iglesia' );

INSERT INTO direcciones (
    id_distrito,
    detalle
) VALUES ( 70401,
           'Talamanca, frente al parque' );

INSERT INTO direcciones (
    id_distrito,
    detalle
) VALUES ( 70402,
           'Bratsi, costado oeste del Ebais' );

INSERT INTO direcciones (
    id_distrito,
    detalle
) VALUES ( 70501,
           'Matina centro, frente a la municipalidad' );

INSERT INTO direcciones (
    id_distrito,
    detalle
) VALUES ( 70502,
           'Batán, contiguo a la plaza' );

COMMIT;

SELECT
    *
FROM
    direcciones;


--ROLES

INSERT INTO roles ( rol ) VALUES ( 'Administrador' );

INSERT INTO roles ( rol ) VALUES ( 'Recursos Humanos' );

INSERT INTO roles ( rol ) VALUES ( 'Cajero' );

SELECT
    *
FROM
    roles commit;

--TURNOS
INSERT INTO turnos ( turno ) VALUES ( 'Mañana' );

INSERT INTO turnos ( turno ) VALUES ( 'Tarde' );

SELECT
    *
FROM
    turnos commit;

--TIPO DE PAGOS
INSERT INTO tipo_pagos ( metodo_pago ) VALUES ( 'Efectivo' );

INSERT INTO tipo_pagos ( metodo_pago ) VALUES ( 'Tarjeta' );

INSERT INTO tipo_pagos ( metodo_pago ) VALUES ( 'SINPE Móvil' );

SELECT
    *
FROM
    tipo_pagos commit;


--TIPO DE DEVOLUCIONES
INSERT INTO tipo_devoluciones ( tipo_devolucion ) VALUES ( 'Producto defectuoso' );

INSERT INTO tipo_devoluciones ( tipo_devolucion ) VALUES ( 'Error de compra' );

INSERT INTO tipo_devoluciones ( tipo_devolucion ) VALUES ( 'Garantía' );

INSERT INTO tipo_devoluciones ( tipo_devolucion ) VALUES ( 'Producto no compatible' );

INSERT INTO tipo_devoluciones ( tipo_devolucion ) VALUES ( 'Otro' );

SELECT
    *
FROM
    tipo_devoluciones commit;

--CATEGORÍA
INSERT INTO categoria ( nombre ) VALUES ( 'Lubricantes' );

INSERT INTO categoria ( nombre ) VALUES ( 'Filtros' );

INSERT INTO categoria ( nombre ) VALUES ( 'Aditivos' );

INSERT INTO categoria ( nombre ) VALUES ( 'Refrigerantes' );

INSERT INTO categoria ( nombre ) VALUES ( 'Frenos' );

INSERT INTO categoria ( nombre ) VALUES ( 'Limpieza' );

INSERT INTO categoria ( nombre ) VALUES ( 'Accesorios' );

INSERT INTO categoria ( nombre ) VALUES ( 'Iluminación' );

INSERT INTO categoria ( nombre ) VALUES ( 'Neumáticos' );

INSERT INTO categoria ( nombre ) VALUES ( 'Herramientas' );

SELECT
    *
FROM
    categoria;

COMMIT;



--SUCURSALES
INSERT INTO sucursales (
    nombre,
    estado
) VALUES ( 'Pejivalle Distrito de Carmen',
           'Activo' );   -- 10101
INSERT INTO sucursales (
    nombre,
    estado
) VALUES ( 'Pejivalle Distrito de Carmen',
           'Activo' );   -- 10101
INSERT INTO sucursales (
    nombre,
    estado
) VALUES ( 'Pejivalle Distrito de Merced',
           'Activo' );   -- 10102
INSERT INTO sucursales (
    nombre,
    estado
) VALUES ( 'Pejivalle Distrito de Hospital',
           'Activo' );  -- 10103
INSERT INTO sucursales (
    nombre,
    estado
) VALUES ( 'Pejivalle Distrito de Catedral',
           'Activo' );  -- 10104
INSERT INTO sucursales (
    nombre,
    estado
) VALUES ( 'Pejivalle Distrito de Zapote,}',
           'Activo' );    -- 10105
INSERT INTO sucursales (
    nombre,
    estado
) VALUES ( 'Pejivalle Distrito de Desamparados',
           'Activo' );     -- 10201
INSERT INTO sucursales (
    nombre,
    estado
) VALUES ( 'Pejivalle Distrito de San Miguel',
           'Activo' );       -- 10202
INSERT INTO sucursales (
    nombre,
    estado
) VALUES ( 'Pejivalle Distrito de San Juan de Dios',
           'Activo' ); -- 10203
INSERT INTO sucursales (
    nombre,
    estado
) VALUES ( 'Pejivalle Distrito de Curridabat',
           'Activo' );  -- 10301
INSERT INTO sucursales (
    nombre,
    estado
) VALUES ( 'Pejivalle Distrito de Granadilla',
           'Activo' );  -- 10302
INSERT INTO sucursales (
    nombre,
    estado
) VALUES ( 'Pejivalle Distrito de Tirrases',
           'Activo' );    -- 10303
INSERT INTO sucursales (
    nombre,
    estado
) VALUES ( 'Pejivalle Distrito de Zapote',
           'Activo' );               -- 10401
INSERT INTO sucursales (
    nombre,
    estado
) VALUES ( 'Pejivalle Distrito de San Francisco de Dos Ríos',
           'Activo' ); -- 10402
INSERT INTO sucursales (
    nombre,
    estado
) VALUES ( 'Pejivalle Distrito de Alajuela',
           'Activo' );      -- 20101
INSERT INTO sucursales (
    nombre,
    estado
) VALUES ( 'Pejivalle Distrito de San José',
           'Activo' );      -- 20102
INSERT INTO sucursales (
    nombre,
    estado
) VALUES ( 'Pejivalle Distrito de Desamparados de Alajuela',
           'Activo' );   -- 20103
INSERT INTO sucursales (
    nombre,
    estado
) VALUES ( 'Pejivalle Distrito de San Ramón',
           'Activo' );        -- 20201
INSERT INTO sucursales (
    nombre,
    estado
) VALUES ( 'Pejivalle Distrito de Santiago',
           'Activo' );         -- 20202
INSERT INTO sucursales (
    nombre,
    estado
) VALUES ( 'Pejivalle Distrito de Piedades Norte',
           'Activo' );   -- 20203
INSERT INTO sucursales (
    nombre,
    estado
) VALUES ( 'Pejivalle Distrito de Grecia',
           'Activo' );           -- 20301
INSERT INTO sucursales (
    nombre,
    estado
) VALUES ( 'Pejivalle Distrito de San Roque',
           'Activo' );        -- 20302
INSERT INTO sucursales (
    nombre,
    estado
) VALUES ( 'Pejivalle Distrito de Cartago',
           'Activo' );          -- 30101
INSERT INTO sucursales (
    nombre,
    estado
) VALUES ( 'Pejivalle Distrito de Oriental',
           'Activo' );         -- 30102
INSERT INTO sucursales (
    nombre,
    estado
) VALUES ( 'Pejivalle Distrito de Occidental',
           'Activo' );       -- 30103
INSERT INTO sucursales (
    nombre,
    estado
) VALUES ( 'Pejivalle Distrito de Paraíso',
           'Activo' );          -- 30201
INSERT INTO sucursales (
    nombre,
    estado
) VALUES ( 'Pejivalle Distrito de Santiago',
           'Activo' );         -- 30202
INSERT INTO sucursales (
    nombre,
    estado
) VALUES ( 'Pejivalle Distrito de Heredia',
           'Activo' );          -- 40101
INSERT INTO sucursales (
    nombre,
    estado
) VALUES ( 'Pejivalle Distrito de Mercedes)',
           'Activo' );         -- 40102
INSERT INTO sucursales (
    nombre,
    estado
) VALUES ( 'Pejivalle Distrito de San Francisco',
           'Activo' );    -- 40103
INSERT INTO sucursales (
    nombre,
    estado
) VALUES ( 'Pejivalle Distrito de Barva',
           'Activo' );              -- 40201
INSERT INTO sucursales (
    nombre,
    estado
) VALUES ( 'Pejivalle Distrito de San Pedro',
           'Activo' );          -- 40202
INSERT INTO sucursales (
    nombre,
    estado
) VALUES ( 'Pejivalle Distrito de Liberia',
           'Activo' );       -- 50101
INSERT INTO sucursales (
    nombre,
    estado
) VALUES ( 'Pejivalle Distrito de Cañas Dulces',
           'Activo' );   -- 50102
INSERT INTO sucursales (
    nombre,
    estado
) VALUES ( 'Pejivalle Distrito de Nicoya',
           'Activo' );         -- 50201
INSERT INTO sucursales (
    nombre,
    estado
) VALUES ( 'Pejivalle Distrito de Sámara',
           'Activo' );         -- 50202
INSERT INTO sucursales (
    nombre,
    estado
) VALUES ( 'Pejivalle Distrito de Puntarenas',
           'Activo' ); -- 60101
INSERT INTO sucursales (
    nombre,
    estado
) VALUES ( 'Pejivalle Distrito de El Roble',
           'Activo' );   -- 60102
INSERT INTO sucursales (
    nombre,
    estado
) VALUES ( 'Pejivalle Distrito de Esparza',
           'Activo' );       -- 60201
INSERT INTO sucursales (
    nombre,
    estado
) VALUES ( 'Pejivalle Distrito de Limón',
           'Activo' );                -- 70101
INSERT INTO sucursales (
    nombre,
    estado
) VALUES ( 'Pejivalle Distrito de Valle La Estrella',
           'Activo' );    -- 70102
INSERT INTO sucursales (
    nombre,
    estado
) VALUES ( 'Pejivalle Distrito de Guápiles',
           'Activo' );            -- 70201
INSERT INTO sucursales (
    nombre,
    estado
) VALUES ( 'Pejivalle Distrito de Jiménez',
           'Activo' );             -- 70202
INSERT INTO sucursales (
    nombre,
    estado
) VALUES ( 'Pejivalle Distrito de Siquirres',
           'Activo' );        -- 70301
INSERT INTO sucursales (
    nombre,
    estado
) VALUES ( 'Pejivalle Distrito de Florida',
           'Activo' );          -- 70302
INSERT INTO sucursales (
    nombre,
    estado
) VALUES ( 'Pejivalle Distrito de Talamanca',
           'Activo' );        -- 70401
INSERT INTO sucursales (
    nombre,
    estado
) VALUES ( 'Pejivalle Distrito de Bratsi,',
           'Activo' );           -- 70402
INSERT INTO sucursales (
    nombre,
    estado
) VALUES ( 'Pejivalle Distrito de Matina,',
           'Activo' );              -- 70501
INSERT INTO sucursales (
    nombre,
    estado
) VALUES ( 'Pejivalle Distrito de Batán,',
           'Activo' );               -- 70502

COMMIT;

SELECT
    *
FROM
    sucursales;

--SUCURSALES_DIRECCIONES

INSERT INTO sucursales_direcciones (
    id_sucursal,
    id_direccion
) VALUES ( 1,
           1 );

INSERT INTO sucursales_direcciones (
    id_sucursal,
    id_direccion
) VALUES ( 2,
           2 );

INSERT INTO sucursales_direcciones (
    id_sucursal,
    id_direccion
) VALUES ( 3,
           3 );

INSERT INTO sucursales_direcciones (
    id_sucursal,
    id_direccion
) VALUES ( 4,
           4 );

INSERT INTO sucursales_direcciones (
    id_sucursal,
    id_direccion
) VALUES ( 5,
           5 );

INSERT INTO sucursales_direcciones (
    id_sucursal,
    id_direccion
) VALUES ( 6,
           6 );

INSERT INTO sucursales_direcciones (
    id_sucursal,
    id_direccion
) VALUES ( 7,
           7 );

INSERT INTO sucursales_direcciones (
    id_sucursal,
    id_direccion
) VALUES ( 8,
           8 );

INSERT INTO sucursales_direcciones (
    id_sucursal,
    id_direccion
) VALUES ( 9,
           9 );

INSERT INTO sucursales_direcciones (
    id_sucursal,
    id_direccion
) VALUES ( 10,
           10 );

INSERT INTO sucursales_direcciones (
    id_sucursal,
    id_direccion
) VALUES ( 11,
           11 );

INSERT INTO sucursales_direcciones (
    id_sucursal,
    id_direccion
) VALUES ( 12,
           12 );

INSERT INTO sucursales_direcciones (
    id_sucursal,
    id_direccion
) VALUES ( 13,
           13 );

INSERT INTO sucursales_direcciones (
    id_sucursal,
    id_direccion
) VALUES ( 14,
           14 );

INSERT INTO sucursales_direcciones (
    id_sucursal,
    id_direccion
) VALUES ( 15,
           15 );

INSERT INTO sucursales_direcciones (
    id_sucursal,
    id_direccion
) VALUES ( 16,
           16 );

INSERT INTO sucursales_direcciones (
    id_sucursal,
    id_direccion
) VALUES ( 17,
           17 );

INSERT INTO sucursales_direcciones (
    id_sucursal,
    id_direccion
) VALUES ( 18,
           18 );

INSERT INTO sucursales_direcciones (
    id_sucursal,
    id_direccion
) VALUES ( 19,
           19 );

INSERT INTO sucursales_direcciones (
    id_sucursal,
    id_direccion
) VALUES ( 20,
           20 );

INSERT INTO sucursales_direcciones (
    id_sucursal,
    id_direccion
) VALUES ( 21,
           21 );

INSERT INTO sucursales_direcciones (
    id_sucursal,
    id_direccion
) VALUES ( 22,
           22 );

INSERT INTO sucursales_direcciones (
    id_sucursal,
    id_direccion
) VALUES ( 23,
           23 );

INSERT INTO sucursales_direcciones (
    id_sucursal,
    id_direccion
) VALUES ( 24,
           24 );

INSERT INTO sucursales_direcciones (
    id_sucursal,
    id_direccion
) VALUES ( 25,
           25 );

INSERT INTO sucursales_direcciones (
    id_sucursal,
    id_direccion
) VALUES ( 26,
           26 );

INSERT INTO sucursales_direcciones (
    id_sucursal,
    id_direccion
) VALUES ( 27,
           27 );

INSERT INTO sucursales_direcciones (
    id_sucursal,
    id_direccion
) VALUES ( 28,
           28 );

INSERT INTO sucursales_direcciones (
    id_sucursal,
    id_direccion
) VALUES ( 29,
           29 );

INSERT INTO sucursales_direcciones (
    id_sucursal,
    id_direccion
) VALUES ( 30,
           30 );

INSERT INTO sucursales_direcciones (
    id_sucursal,
    id_direccion
) VALUES ( 31,
           31 );

INSERT INTO sucursales_direcciones (
    id_sucursal,
    id_direccion
) VALUES ( 32,
           32 );

INSERT INTO sucursales_direcciones (
    id_sucursal,
    id_direccion
) VALUES ( 33,
           33 );

INSERT INTO sucursales_direcciones (
    id_sucursal,
    id_direccion
) VALUES ( 34,
           34 );

INSERT INTO sucursales_direcciones (
    id_sucursal,
    id_direccion
) VALUES ( 35,
           35 );

INSERT INTO sucursales_direcciones (
    id_sucursal,
    id_direccion
) VALUES ( 36,
           36 );

INSERT INTO sucursales_direcciones (
    id_sucursal,
    id_direccion
) VALUES ( 37,
           37 );

INSERT INTO sucursales_direcciones (
    id_sucursal,
    id_direccion
) VALUES ( 38,
           38 );

INSERT INTO sucursales_direcciones (
    id_sucursal,
    id_direccion
) VALUES ( 39,
           39 );

INSERT INTO sucursales_direcciones (
    id_sucursal,
    id_direccion
) VALUES ( 40,
           40 );

INSERT INTO sucursales_direcciones (
    id_sucursal,
    id_direccion
) VALUES ( 41,
           41 );

INSERT INTO sucursales_direcciones (
    id_sucursal,
    id_direccion
) VALUES ( 42,
           42 );

INSERT INTO sucursales_direcciones (
    id_sucursal,
    id_direccion
) VALUES ( 43,
           43 );

INSERT INTO sucursales_direcciones (
    id_sucursal,
    id_direccion
) VALUES ( 44,
           44 );

INSERT INTO sucursales_direcciones (
    id_sucursal,
    id_direccion
) VALUES ( 45,
           45 );

INSERT INTO sucursales_direcciones (
    id_sucursal,
    id_direccion
) VALUES ( 46,
           46 );

INSERT INTO sucursales_direcciones (
    id_sucursal,
    id_direccion
) VALUES ( 47,
           47 );

INSERT INTO sucursales_direcciones (
    id_sucursal,
    id_direccion
) VALUES ( 48,
           48 );

INSERT INTO sucursales_direcciones (
    id_sucursal,
    id_direccion
) VALUES ( 49,
           49 );

INSERT INTO sucursales_direcciones (
    id_sucursal,
    id_direccion
) VALUES ( 50,
           50 );

COMMIT;

SELECT
    *
FROM
    sucursales_direcciones;

--PROVEEDORES
INSERT INTO proveedores (
    nombre_proveedor,
    nombre_contacto,
    apellido1,
    apellido2,
    correo_electr,
    telefono
) VALUES ( 'Motul Costa Rica',
           'Carlos',
           'Ramírez',
           'Vargas',
           'motul.cr@example.com',
           '22221101' );

INSERT INTO proveedores (
    nombre_proveedor,
    nombre_contacto,
    apellido1,
    apellido2,
    correo_electr,
    telefono
) VALUES ( 'Castrol Distribución',
           'Andrea',
           'Soto',
           'Mora',
           'castrol.cr@example.com',
           '22221102' );

INSERT INTO proveedores (
    nombre_proveedor,
    nombre_contacto,
    apellido1,
    apellido2,
    correo_electr,
    telefono
) VALUES ( 'Shell Helix CR',
           'Jorge',
           'Hernández',
           'Soto',
           'shell.cr@example.com',
           '22221103' );

INSERT INTO proveedores (
    nombre_proveedor,
    nombre_contacto,
    apellido1,
    apellido2,
    correo_electr,
    telefono
) VALUES ( 'Valvoline CR',
           'Paula',
           'González',
           'Vega',
           'valvoline.cr@example.com',
           '22221104' );

INSERT INTO proveedores (
    nombre_proveedor,
    nombre_contacto,
    apellido1,
    apellido2,
    correo_electr,
    telefono
) VALUES ( 'TotalEnergies CR',
           'Luis',
           'Jiménez',
           'Araya',
           'total.cr@example.com',
           '22221105' );

INSERT INTO proveedores (
    nombre_proveedor,
    nombre_contacto,
    apellido1,
    apellido2,
    correo_electr,
    telefono
) VALUES ( 'MANN-FILTER',
           'Sofía',
           'Rodríguez',
           'Chacón',
           'mann.cr@example.com',
           '22221106' );

INSERT INTO proveedores (
    nombre_proveedor,
    nombre_contacto,
    apellido1,
    apellido2,
    correo_electr,
    telefono
) VALUES ( 'Bosch Autopartes',
           'Daniel',
           'Pérez',
           'Segura',
           'bosch.cr@example.com',
           '22221107' );

INSERT INTO proveedores (
    nombre_proveedor,
    nombre_contacto,
    apellido1,
    apellido2,
    correo_electr,
    telefono
) VALUES ( 'FRAM Filtros',
           'Natalia',
           'Sánchez',
           'Ureña',
           'fram.cr@example.com',
           '22221108' );

INSERT INTO proveedores (
    nombre_proveedor,
    nombre_contacto,
    apellido1,
    apellido2,
    correo_electr,
    telefono
) VALUES ( 'Mobil 1',
           'Ricardo',
           'Vargas',
           'Méndez',
           'mobil1.cr@example.com',
           '22221109' );

INSERT INTO proveedores (
    nombre_proveedor,
    nombre_contacto,
    apellido1,
    apellido2,
    correo_electr,
    telefono
) VALUES ( 'Liqui Moly',
           'Fernanda',
           'Castro',
           'Valverde',
           'liquimoly.cr@example.com',
           '22221110' );

COMMIT;

SELECT
    *
FROM
    proveedores;

--PROVEEDORES_DIRECCIONES
INSERT INTO proveedores_direcciones (
    id_proveedor,
    id_direccion
) VALUES ( 1,
           1 );

INSERT INTO proveedores_direcciones (
    id_proveedor,
    id_direccion
) VALUES ( 2,
           2 );

INSERT INTO proveedores_direcciones (
    id_proveedor,
    id_direccion
) VALUES ( 3,
           3 );

INSERT INTO proveedores_direcciones (
    id_proveedor,
    id_direccion
) VALUES ( 4,
           4 );

INSERT INTO proveedores_direcciones (
    id_proveedor,
    id_direccion
) VALUES ( 5,
           5 );

INSERT INTO proveedores_direcciones (
    id_proveedor,
    id_direccion
) VALUES ( 6,
           6 );

INSERT INTO proveedores_direcciones (
    id_proveedor,
    id_direccion
) VALUES ( 7,
           7 );

INSERT INTO proveedores_direcciones (
    id_proveedor,
    id_direccion
) VALUES ( 8,
           8 );

INSERT INTO proveedores_direcciones (
    id_proveedor,
    id_direccion
) VALUES ( 9,
           9 );

INSERT INTO proveedores_direcciones (
    id_proveedor,
    id_direccion
) VALUES ( 10,
           10 );

COMMIT;

SELECT
    *
FROM
    proveedores_direcciones;

--CLIENTES
INSERT INTO clientes VALUES ( '110002000',
                              'María',
                              'González',
                              'Soto',
                              'maria.gonzalez01@gmail.com',
                              '86000000' );

INSERT INTO clientes VALUES ( '210012001',
                              'Ana',
                              'Rodríguez',
                              'Méndez',
                              'ana.rodriguez02@hotmail.com',
                              '86000001' );

INSERT INTO clientes VALUES ( '310022002',
                              'Sofía',
                              'Hernández',
                              'Vega',
                              'sofia.hernandez03@icloud.com',
                              '86000002' );

INSERT INTO clientes VALUES ( '410032003',
                              'Valeria',
                              'Pérez',
                              'Cordero',
                              'valeria.perez04@outlook.com',
                              '86000003' );

INSERT INTO clientes VALUES ( '510042004',
                              'Camila',
                              'Sánchez',
                              'Madrigal',
                              'camila.sanchez05@yahoo.com',
                              '86000004' );

INSERT INTO clientes VALUES ( '610052005',
                              'Isabella',
                              'Ramírez',
                              'Segura',
                              'isabella.ramirez06@gmail.com',
                              '86000005' );

INSERT INTO clientes VALUES ( '710062006',
                              'Daniela',
                              'Cruz',
                              'Araya',
                              'daniela.cruz07@hotmail.com',
                              '86000006' );

INSERT INTO clientes VALUES ( '110072007',
                              'Gabriela',
                              'Vargas',
                              'Chacón',
                              'gabriela.vargas08@icloud.com',
                              '86000007' );

INSERT INTO clientes VALUES ( '210082008',
                              'Paula',
                              'Jiménez',
                              'Villalobos',
                              'paula.jimenez09@outlook.com',
                              '86000008' );

INSERT INTO clientes VALUES ( '310092009',
                              'Lucía',
                              'Mora',
                              'Valverde',
                              'lucia.mora10@yahoo.com',
                              '86000009' );

INSERT INTO clientes VALUES ( '410102010',
                              'Karla',
                              'Castro',
                              'Ureña',
                              'karla.castro11@gmail.com',
                              '86000010' );

INSERT INTO clientes VALUES ( '510112011',
                              'Andrea',
                              'Rojas',
                              'Zúñiga',
                              'andrea.rojas12@hotmail.com',
                              '86000011' );

INSERT INTO clientes VALUES ( '610122012',
                              'Laura',
                              'Alvarado',
                              'Brenes',
                              'laura.alvarado13@icloud.com',
                              '86000012' );

INSERT INTO clientes VALUES ( '71013-2013',
                              'Natalia',
                              'Solís',
                              'Pacheco',
                              'natalia.solis14@outlook.com',
                              '86000013' );

INSERT INTO clientes VALUES ( '110142014',
                              'Fernanda',
                              'Arias',
                              'Muñoz',
                              'fernanda.arias15@yahoo.com',
                              '86000014' );

INSERT INTO clientes VALUES ( '210152015',
                              'Diana',
                              'Aguilar',
                              'Fonseca',
                              'diana.aguilar16@gmail.com',
                              '86000015' );

INSERT INTO clientes VALUES ( '310162016',
                              'Melanie',
                              'Navarro',
                              'Núñez',
                              'melanie.navarro17@hotmail.com',
                              '86000016' );

INSERT INTO clientes VALUES ( '410172017',
                              'Alejandra',
                              'Campos',
                              'Guzmán',
                              'alejandra.campos18@icloud.com',
                              '86000017' );

INSERT INTO clientes VALUES ( '510182018',
                              'Carolina',
                              'Quesada',
                              'Céspedes',
                              'carolina.quesada19@outlook.com',
                              '86000018' );

INSERT INTO clientes VALUES ( '610192019',
                              'Victoria',
                              'Salas',
                              'Soto',
                              'victoria.salas20@yahoo.com',
                              '86000019' );

INSERT INTO clientes VALUES ( '710202020',
                              'José',
                              'González',
                              'Méndez',
                              'jose.gonzalez21@gmail.com',
                              '86000020' );

INSERT INTO clientes VALUES ( '110212021',
                              'Juan',
                              'Rodríguez',
                              'Vega',
                              'juan.rodriguez22@hotmail.com',
                              '86000021' );

INSERT INTO clientes VALUES ( '210222022',
                              'Carlos',
                              'Hernández',
                              'Cordero',
                              'carlos.hernandez23@icloud.com',
                              '86000022' );

INSERT INTO clientes VALUES ( '310232023',
                              'Luis',
                              'Pérez',
                              'Madrigal',
                              'luis.perez24@outlook.com',
                              '86000023' );

INSERT INTO clientes VALUES ( '410242024',
                              'Daniel',
                              'Sánchez',
                              'Segura',
                              'daniel.sanchez25@yahoo.com',
                              '86000024' );

INSERT INTO clientes VALUES ( '510252025',
                              'Andrés',
                              'Ramírez',
                              'Araya',
                              'andres.ramirez26@gmail.com',
                              '86000025' );

INSERT INTO clientes VALUES ( '610262026',
                              'Jorge',
                              'Cruz',
                              'Chacón',
                              'jorge.cruz27@hotmail.com',
                              '86000026' );

INSERT INTO clientes VALUES ( '710272027',
                              'David',
                              'Vargas',
                              'Villalobos',
                              'david.vargas28@icloud.com',
                              '86000027' );

INSERT INTO clientes VALUES ( '110282028',
                              'Kevin',
                              'Jiménez',
                              'Valverde',
                              'kevin.jimenez29@outlook.com',
                              '86000028' );

INSERT INTO clientes VALUES ( '210292029',
                              'Fernando',
                              'Mora',
                              'Ureña',
                              'fernando.mora30@yahoo.com',
                              '86000029' );

INSERT INTO clientes VALUES ( '310302030',
                              'Ricardo',
                              'Castro',
                              'Zúñiga',
                              'ricardo.castro31@gmail.com',
                              '86000030' );

INSERT INTO clientes VALUES ( '410312031',
                              'Sebastián',
                              'Rojas',
                              'Brenes',
                              'sebastian.rojas32@hotmail.com',
                              '86000031' );

INSERT INTO clientes VALUES ( '510322032',
                              'Diego',
                              'Alvarado',
                              'Pacheco',
                              'diego.alvarado33@icloud.com',
                              '86000032' );

INSERT INTO clientes VALUES ( '610332033',
                              'Pablo',
                              'Solís',
                              'Muñoz',
                              'pablo.solis34@outlook.com',
                              '86000033' );

INSERT INTO clientes VALUES ( '710342034',
                              'Marco',
                              'Arias',
                              'Fonseca',
                              'marco.arias35@yahoo.com',
                              '86000034' );

INSERT INTO clientes VALUES ( '110352035',
                              'Esteban',
                              'Aguilar',
                              'Núñez',
                              'esteban.aguilar36@gmail.com',
                              '86000035' );

INSERT INTO clientes VALUES ( '210362036',
                              'Emilio',
                              'Navarro',
                              'Guzmán',
                              'emilio.navarro37@hotmail.com',
                              '86000036' );

INSERT INTO clientes VALUES ( '310372037',
                              'Mateo',
                              'Campos',
                              'Céspedes',
                              'mateo.campos38@icloud.com',
                              '86000037' );

INSERT INTO clientes VALUES ( '410382038',
                              'Alejandro',
                              'Quesada',
                              'Soto',
                              'alejandro.quesada39@outlook.com',
                              '86000038' );

INSERT INTO clientes VALUES ( '510392039',
                              'Héctor',
                              'Salas',
                              'Méndez',
                              'hector.salas40@yahoo.com',
                              '86000039' );

INSERT INTO clientes VALUES ( '610402040',
                              'Vanessa',
                              'González',
                              'Vega',
                              'vanessa.gonzalez41@gmail.com',
                              '86000040' );

INSERT INTO clientes VALUES ( '710412041',
                              'Monserrat',
                              'Rodríguez',
                              'Cordero',
                              'monserrat.rodriguez42@hotmail.com',
                              '86000041' );

INSERT INTO clientes VALUES ( '110422042',
                              'Rocío',
                              'Hernández',
                              'Madrigal',
                              'rocio.hernandez43@icloud.com',
                              '86000042' );

INSERT INTO clientes VALUES ( '210432043',
                              'Karen',
                              'Pérez',
                              'Segura',
                              'karen.perez44@outlook.com',
                              '86000043' );

INSERT INTO clientes VALUES ( '310442044',
                              'Cristina',
                              'Sánchez',
                              'Araya',
                              'cristina.sanchez45@yahoo.com',
                              '86000044' );

INSERT INTO clientes VALUES ( '410452045',
                              'Patricia',
                              'Ramírez',
                              'Chacón',
                              'patricia.ramirez46@gmail.com',
                              '86000045' );

INSERT INTO clientes VALUES ( '510462046',
                              'Mónica',
                              'Cruz',
                              'Villalobos',
                              'monica.cruz47@hotmail.com',
                              '86000046' );

INSERT INTO clientes VALUES ( '610472047',
                              'Lorena',
                              'Vargas',
                              'Valverde',
                              'lorena.vargas48@icloud.com',
                              '86000047' );

INSERT INTO clientes VALUES ( '710482048',
                              'Paola',
                              'Jiménez',
                              'Ureña',
                              'paola.jimenez49@outlook.com',
                              '86000048' );

INSERT INTO clientes VALUES ( '110492049',
                              'Jimena',
                              'Mora',
                              'Zúñiga',
                              'jimena.mora50@yahoo.com',
                              '86000049' );

COMMIT;

SELECT
    *
FROM
    clientes;

--CLIENTES_DIRECCIONES
INSERT INTO clientes_direcciones (
    cedula,
    id_direccion
) VALUES ( '110002000',
           1 );

INSERT INTO clientes_direcciones (
    cedula,
    id_direccion
) VALUES ( '210012001',
           2 );

INSERT INTO clientes_direcciones (
    cedula,
    id_direccion
) VALUES ( '310022002',
           3 );

INSERT INTO clientes_direcciones (
    cedula,
    id_direccion
) VALUES ( '410032003',
           4 );

INSERT INTO clientes_direcciones (
    cedula,
    id_direccion
) VALUES ( '510042004',
           5 );

INSERT INTO clientes_direcciones (
    cedula,
    id_direccion
) VALUES ( '610052005',
           6 );

INSERT INTO clientes_direcciones (
    cedula,
    id_direccion
) VALUES ( '710062006',
           7 );

INSERT INTO clientes_direcciones (
    cedula,
    id_direccion
) VALUES ( '110072007',
           8 );

INSERT INTO clientes_direcciones (
    cedula,
    id_direccion
) VALUES ( '210082008',
           9 );

INSERT INTO clientes_direcciones (
    cedula,
    id_direccion
) VALUES ( '310092009',
           10 );

INSERT INTO clientes_direcciones (
    cedula,
    id_direccion
) VALUES ( '410102010',
           11 );

INSERT INTO clientes_direcciones (
    cedula,
    id_direccion
) VALUES ( '510112011',
           12 );

INSERT INTO clientes_direcciones (
    cedula,
    id_direccion
) VALUES ( '610122012',
           13 );

INSERT INTO clientes_direcciones (
    cedula,
    id_direccion
) VALUES ( '710132013',
           14 );

INSERT INTO clientes_direcciones (
    cedula,
    id_direccion
) VALUES ( '110142014',
           15 );

INSERT INTO clientes_direcciones (
    cedula,
    id_direccion
) VALUES ( '210152015',
           16 );

INSERT INTO clientes_direcciones (
    cedula,
    id_direccion
) VALUES ( '310162016',
           17 );

INSERT INTO clientes_direcciones (
    cedula,
    id_direccion
) VALUES ( '410172017',
           18 );

INSERT INTO clientes_direcciones (
    cedula,
    id_direccion
) VALUES ( '510182018',
           19 );

INSERT INTO clientes_direcciones (
    cedula,
    id_direccion
) VALUES ( '610192019',
           20 );

INSERT INTO clientes_direcciones (
    cedula,
    id_direccion
) VALUES ( '710202020',
           21 );

INSERT INTO clientes_direcciones (
    cedula,
    id_direccion
) VALUES ( '110212021',
           22 );

INSERT INTO clientes_direcciones (
    cedula,
    id_direccion
) VALUES ( '210222022',
           23 );

INSERT INTO clientes_direcciones (
    cedula,
    id_direccion
) VALUES ( '310232023',
           24 );

INSERT INTO clientes_direcciones (
    cedula,
    id_direccion
) VALUES ( '410242024',
           25 );

INSERT INTO clientes_direcciones (
    cedula,
    id_direccion
) VALUES ( '510252025',
           26 );

INSERT INTO clientes_direcciones (
    cedula,
    id_direccion
) VALUES ( '610262026',
           27 );

INSERT INTO clientes_direcciones (
    cedula,
    id_direccion
) VALUES ( '710272027',
           28 );

INSERT INTO clientes_direcciones (
    cedula,
    id_direccion
) VALUES ( '110282028',
           29 );

INSERT INTO clientes_direcciones (
    cedula,
    id_direccion
) VALUES ( '210292029',
           30 );

INSERT INTO clientes_direcciones (
    cedula,
    id_direccion
) VALUES ( '310302030',
           31 );

INSERT INTO clientes_direcciones (
    cedula,
    id_direccion
) VALUES ( '410312031',
           32 );

INSERT INTO clientes_direcciones (
    cedula,
    id_direccion
) VALUES ( '510322032',
           33 );

INSERT INTO clientes_direcciones (
    cedula,
    id_direccion
) VALUES ( '610332033',
           34 );

INSERT INTO clientes_direcciones (
    cedula,
    id_direccion
) VALUES ( '710342034',
           35 );

INSERT INTO clientes_direcciones (
    cedula,
    id_direccion
) VALUES ( '110352035',
           36 );

INSERT INTO clientes_direcciones (
    cedula,
    id_direccion
) VALUES ( '210362036',
           37 );

INSERT INTO clientes_direcciones (
    cedula,
    id_direccion
) VALUES ( '310372037',
           38 );

INSERT INTO clientes_direcciones (
    cedula,
    id_direccion
) VALUES ( '410382038',
           39 );

INSERT INTO clientes_direcciones (
    cedula,
    id_direccion
) VALUES ( '510392039',
           40 );

INSERT INTO clientes_direcciones (
    cedula,
    id_direccion
) VALUES ( '610402040',
           41 );

INSERT INTO clientes_direcciones (
    cedula,
    id_direccion
) VALUES ( '710412041',
           42 );

INSERT INTO clientes_direcciones (
    cedula,
    id_direccion
) VALUES ( '110422042',
           43 );

INSERT INTO clientes_direcciones (
    cedula,
    id_direccion
) VALUES ( '210432043',
           44 );

INSERT INTO clientes_direcciones (
    cedula,
    id_direccion
) VALUES ( '310442044',
           45 );

INSERT INTO clientes_direcciones (
    cedula,
    id_direccion
) VALUES ( '410452045',
           46 );

INSERT INTO clientes_direcciones (
    cedula,
    id_direccion
) VALUES ( '510462046',
           47 );

INSERT INTO clientes_direcciones (
    cedula,
    id_direccion
) VALUES ( '610472047',
           48 );

INSERT INTO clientes_direcciones (
    cedula,
    id_direccion
) VALUES ( '710482048',
           49 );

INSERT INTO clientes_direcciones (
    cedula,
    id_direccion
) VALUES ( '110492049',
           50 );

COMMIT;

SELECT
    *
FROM
    clientes_direcciones;

--TRABAJADORES
INSERT INTO trabajadores (
    nombre,
    apellido1,
    apellido2,
    identificacion,
    correo_electronico,
    estado,
    id_sucursal,
    id_turno,
    id_rol
) VALUES ( 'Karla',
           'Pérez',
           'Chacón',
           'T-3000',
           'karla.perez01@pejivalle.cr',
           'Activo',
           1,
           2,
           2 );

INSERT INTO trabajadores (
    nombre,
    apellido1,
    apellido2,
    identificacion,
    correo_electronico,
    estado,
    id_sucursal,
    id_turno,
    id_rol
) VALUES ( 'Andrea',
           'Sánchez',
           'Villalobos',
           'T-3001',
           'andrea.sanchez02@pejivalle.cr',
           'Activo',
           2,
           1,
           3 );

INSERT INTO trabajadores (
    nombre,
    apellido1,
    apellido2,
    identificacion,
    correo_electronico,
    estado,
    id_sucursal,
    id_turno,
    id_rol
) VALUES ( 'Laura',
           'Ramírez',
           'Valverde',
           'T-3002',
           'laura.ramirez03@pejivalle.cr',
           'Activo',
           3,
           2,
           3 );

INSERT INTO trabajadores (
    nombre,
    apellido1,
    apellido2,
    identificacion,
    correo_electronico,
    estado,
    id_sucursal,
    id_turno,
    id_rol
) VALUES ( 'Natalia',
           'Cruz',
           'Ureña',
           'T-3003',
           'natalia.cruz04@pejivalle.cr',
           'Activo',
           4,
           1,
           2 );

INSERT INTO trabajadores (
    nombre,
    apellido1,
    apellido2,
    identificacion,
    correo_electronico,
    estado,
    id_sucursal,
    id_turno,
    id_rol
) VALUES ( 'Fernanda',
           'Vargas',
           'Zúñiga',
           'T-3004',
           'fernanda.vargas05@pejivalle.cr',
           'Activo',
           5,
           2,
           3 );

INSERT INTO trabajadores (
    nombre,
    apellido1,
    apellido2,
    identificacion,
    correo_electronico,
    estado,
    id_sucursal,
    id_turno,
    id_rol
) VALUES ( 'Diana',
           'Jiménez',
           'Brenes',
           'T-3005',
           'diana.jimenez06@pejivalle.cr',
           'Activo',
           1,
           1,
           3 );

INSERT INTO trabajadores (
    nombre,
    apellido1,
    apellido2,
    identificacion,
    correo_electronico,
    estado,
    id_sucursal,
    id_turno,
    id_rol
) VALUES ( 'Melanie',
           'Mora',
           'Pacheco',
           'T-3006',
           'melanie.mora07@pejivalle.cr',
           'Activo',
           2,
           2,
           2 );

INSERT INTO trabajadores (
    nombre,
    apellido1,
    apellido2,
    identificacion,
    correo_electronico,
    estado,
    id_sucursal,
    id_turno,
    id_rol
) VALUES ( 'Alejandra',
           'Castro',
           'Muñoz',
           'T-3007',
           'alejandra.castro08@pejivalle.cr',
           'Activo',
           3,
           2,
           3 );

INSERT INTO trabajadores (
    nombre,
    apellido1,
    apellido2,
    identificacion,
    correo_electronico,
    estado,
    id_sucursal,
    id_turno,
    id_rol
) VALUES ( 'Carolina',
           'Rojas',
           'Fonseca',
           'T-3008',
           'carolina.rojas09@pejivalle.cr',
           'Activo',
           4,
           2,
           3 );

INSERT INTO trabajadores (
    nombre,
    apellido1,
    apellido2,
    identificacion,
    correo_electronico,
    estado,
    id_sucursal,
    id_turno,
    id_rol
) VALUES ( 'Victoria',
           'Alvarado',
           'Núñez',
           'T-3009',
           'victoria.alvarado10@pejivalle.cr',
           'Activo',
           5,
           1,
           2 );

INSERT INTO trabajadores (
    nombre,
    apellido1,
    apellido2,
    identificacion,
    correo_electronico,
    estado,
    id_sucursal,
    id_turno,
    id_rol
) VALUES ( 'José',
           'Solís',
           'Guzmán',
           'T-3010',
           'jose.solis11@pejivalle.cr',
           'Activo',
           1,
           2,
           3 );

INSERT INTO trabajadores (
    nombre,
    apellido1,
    apellido2,
    identificacion,
    correo_electronico,
    estado,
    id_sucursal,
    id_turno,
    id_rol
) VALUES ( 'Juan',
           'Arias',
           'Céspedes',
           'T-3011',
           'juan.arias12@pejivalle.cr',
           'Activo',
           2,
           1,
           3 );

INSERT INTO trabajadores (
    nombre,
    apellido1,
    apellido2,
    identificacion,
    correo_electronico,
    estado,
    id_sucursal,
    id_turno,
    id_rol
) VALUES ( 'Carlos',
           'Aguilar',
           'Soto',
           'T-3012',
           'carlos.aguilar13@pejivalle.cr',
           'Activo',
           3,
           2,
           2 );

INSERT INTO trabajadores (
    nombre,
    apellido1,
    apellido2,
    identificacion,
    correo_electronico,
    estado,
    id_sucursal,
    id_turno,
    id_rol
) VALUES ( 'Luis',
           'Navarro',
           'Méndez',
           'T-3013',
           'luis.navarro14@pejivalle.cr',
           'Activo',
           4,
           1,
           3 );

INSERT INTO trabajadores (
    nombre,
    apellido1,
    apellido2,
    identificacion,
    correo_electronico,
    estado,
    id_sucursal,
    id_turno,
    id_rol
) VALUES ( 'Daniel',
           'Campos',
           'Vega',
           'T-3014',
           'daniel.campos15@pejivalle.cr',
           'Activo',
           5,
           2,
           3 );

INSERT INTO trabajadores (
    nombre,
    apellido1,
    apellido2,
    identificacion,
    correo_electronico,
    estado,
    id_sucursal,
    id_turno,
    id_rol
) VALUES ( 'Andrés',
           'Quesada',
           'Cordero',
           'T-3015',
           'andres.quesada16@pejivalle.cr',
           'Activo',
           1,
           2,
           2 );

INSERT INTO trabajadores (
    nombre,
    apellido1,
    apellido2,
    identificacion,
    correo_electronico,
    estado,
    id_sucursal,
    id_turno,
    id_rol
) VALUES ( 'Jorge',
           'Salas',
           'Madrigal',
           'T-3016',
           'jorge.salas17@pejivalle.cr',
           'Activo',
           2,
           2,
           3 );

INSERT INTO trabajadores (
    nombre,
    apellido1,
    apellido2,
    identificacion,
    correo_electronico,
    estado,
    id_sucursal,
    id_turno,
    id_rol
) VALUES ( 'David',
           'González',
           'Segura',
           'T-3017',
           'david.gonzalez18@pejivalle.cr',
           'Activo',
           3,
           1,
           2 );

INSERT INTO trabajadores (
    nombre,
    apellido1,
    apellido2,
    identificacion,
    correo_electronico,
    estado,
    id_sucursal,
    id_turno,
    id_rol
) VALUES ( 'Kevin',
           'Rodríguez',
           'Araya',
           'T-3018',
           'kevin.rodriguez19@pejivalle.cr',
           'Activo',
           4,
           2,
           2 );

INSERT INTO trabajadores (
    nombre,
    apellido1,
    apellido2,
    identificacion,
    correo_electronico,
    estado,
    id_sucursal,
    id_turno,
    id_rol
) VALUES ( 'Fernando',
           'Hernández',
           'Chacón',
           'T-3019',
           'fernando.hernandez20@pejivalle.cr',
           'Activo',
           5,
           1,
           3 );

INSERT INTO trabajadores (
    nombre,
    apellido1,
    apellido2,
    identificacion,
    correo_electronico,
    estado,
    id_sucursal,
    id_turno,
    id_rol
) VALUES ( 'Ricardo',
           'Pérez',
           'Villalobos',
           'T-3020',
           'ricardo.perez21@pejivalle.cr',
           'Activo',
           1,
           2,
           1 );

INSERT INTO trabajadores (
    nombre,
    apellido1,
    apellido2,
    identificacion,
    correo_electronico,
    estado,
    id_sucursal,
    id_turno,
    id_rol
) VALUES ( 'Sebastián',
           'Sánchez',
           'Valverde',
           'T-3021',
           'sebastian.sanchez22@pejivalle.cr',
           'Activo',
           2,
           1,
           2 );

INSERT INTO trabajadores (
    nombre,
    apellido1,
    apellido2,
    identificacion,
    correo_electronico,
    estado,
    id_sucursal,
    id_turno,
    id_rol
) VALUES ( 'Diego',
           'Ramírez',
           'Ureña',
           'T-3022',
           'diego.ramirez23@pejivalle.cr',
           'Activo',
           3,
           2,
           2 );

INSERT INTO trabajadores (
    nombre,
    apellido1,
    apellido2,
    identificacion,
    correo_electronico,
    estado,
    id_sucursal,
    id_turno,
    id_rol
) VALUES ( 'Pablo',
           'Cruz',
           'Zúñiga',
           'T-3023',
           'pablo.cruz24@pejivalle.cr',
           'Activo',
           4,
           2,
           1 );

INSERT INTO trabajadores (
    nombre,
    apellido1,
    apellido2,
    identificacion,
    correo_electronico,
    estado,
    id_sucursal,
    id_turno,
    id_rol
) VALUES ( 'Marco',
           'Vargas',
           'Brenes',
           'T-3024',
           'marco.vargas25@pejivalle.cr',
           'Activo',
           5,
           2,
           2 );

INSERT INTO trabajadores (
    nombre,
    apellido1,
    apellido2,
    identificacion,
    correo_electronico,
    estado,
    id_sucursal,
    id_turno,
    id_rol
) VALUES ( 'Esteban',
           'Jiménez',
           'Pacheco',
           'T-3025',
           'esteban.jimenez26@pejivalle.cr',
           'Activo',
           1,
           2,
           3 );

INSERT INTO trabajadores (
    nombre,
    apellido1,
    apellido2,
    identificacion,
    correo_electronico,
    estado,
    id_sucursal,
    id_turno,
    id_rol
) VALUES ( 'Emilio',
           'Mora',
           'Muñoz',
           'T-3026',
           'emilio.mora27@pejivalle.cr',
           'Activo',
           2,
           2,
           3 );

INSERT INTO trabajadores (
    nombre,
    apellido1,
    apellido2,
    identificacion,
    correo_electronico,
    estado,
    id_sucursal,
    id_turno,
    id_rol
) VALUES ( 'Mateo',
           'Castro',
           'Fonseca',
           'T-3027',
           'mateo.castro28@pejivalle.cr',
           'Activo',
           3,
           1,
           2 );

INSERT INTO trabajadores (
    nombre,
    apellido1,
    apellido2,
    identificacion,
    correo_electronico,
    estado,
    id_sucursal,
    id_turno,
    id_rol
) VALUES ( 'Alejandro',
           'Rojas',
           'Núñez',
           'T-3028',
           'alejandro.rojas29@pejivalle.cr',
           'Activo',
           4,
           2,
           3 );

INSERT INTO trabajadores (
    nombre,
    apellido1,
    apellido2,
    identificacion,
    correo_electronico,
    estado,
    id_sucursal,
    id_turno,
    id_rol
) VALUES ( 'Héctor',
           'Alvarado',
           'Guzmán',
           'T-3029',
           'hector.alvarado30@pejivalle.cr',
           'Activo',
           5,
           1,
           3 );

INSERT INTO trabajadores (
    nombre,
    apellido1,
    apellido2,
    identificacion,
    correo_electronico,
    estado,
    id_sucursal,
    id_turno,
    id_rol
) VALUES ( 'Vanessa',
           'Solís',
           'Céspedes',
           'T-3030',
           'vanessa.solis31@pejivalle.cr',
           'Activo',
           1,
           2,
           2 );

INSERT INTO trabajadores (
    nombre,
    apellido1,
    apellido2,
    identificacion,
    correo_electronico,
    estado,
    id_sucursal,
    id_turno,
    id_rol
) VALUES ( 'Monserrat',
           'Arias',
           'Soto',
           'T-3031',
           'monserrat.arias32@pejivalle.cr',
           'Activo',
           2,
           1,
           3 );

INSERT INTO trabajadores (
    nombre,
    apellido1,
    apellido2,
    identificacion,
    correo_electronico,
    estado,
    id_sucursal,
    id_turno,
    id_rol
) VALUES ( 'Rocío',
           'Aguilar',
           'Méndez',
           'T-3032',
           'rocio.aguilar33@pejivalle.cr',
           'Activo',
           3,
           2,
           3 );

INSERT INTO trabajadores (
    nombre,
    apellido1,
    apellido2,
    identificacion,
    correo_electronico,
    estado,
    id_sucursal,
    id_turno,
    id_rol
) VALUES ( 'Karen',
           'Navarro',
           'Vega',
           'T-3033',
           'karen.navarro34@pejivalle.cr',
           'Activo',
           4,
           1,
           2 );

INSERT INTO trabajadores (
    nombre,
    apellido1,
    apellido2,
    identificacion,
    correo_electronico,
    estado,
    id_sucursal,
    id_turno,
    id_rol
) VALUES ( 'Cristina',
           'Campos',
           'Cordero',
           'T-3034',
           'cristina.campos35@pejivalle.cr',
           'Activo',
           5,
           2,
           3 );

INSERT INTO trabajadores (
    nombre,
    apellido1,
    apellido2,
    identificacion,
    correo_electronico,
    estado,
    id_sucursal,
    id_turno,
    id_rol
) VALUES ( 'Patricia',
           'Quesada',
           'Madrigal',
           'T-3035',
           'patricia.quesada36@pejivalle.cr',
           'Activo',
           1,
           2,
           3 );

INSERT INTO trabajadores (
    nombre,
    apellido1,
    apellido2,
    identificacion,
    correo_electronico,
    estado,
    id_sucursal,
    id_turno,
    id_rol
) VALUES ( 'Mónica',
           'Salas',
           'Segura',
           'T-3036',
           'monica.salas37@pejivalle.cr',
           'Activo',
           2,
           2,
           2 );

INSERT INTO trabajadores (
    nombre,
    apellido1,
    apellido2,
    identificacion,
    correo_electronico,
    estado,
    id_sucursal,
    id_turno,
    id_rol
) VALUES ( 'Lorena',
           'González',
           'Araya',
           'T-3037',
           'lorena.gonzalez38@pejivalle.cr',
           'Activo',
           3,
           1,
           3 );

INSERT INTO trabajadores (
    nombre,
    apellido1,
    apellido2,
    identificacion,
    correo_electronico,
    estado,
    id_sucursal,
    id_turno,
    id_rol
) VALUES ( 'Paola',
           'Rodríguez',
           'Chacón',
           'T-3038',
           'paola.rodriguez39@pejivalle.cr',
           'Activo',
           4,
           2,
           1 );

INSERT INTO trabajadores (
    nombre,
    apellido1,
    apellido2,
    identificacion,
    correo_electronico,
    estado,
    id_sucursal,
    id_turno,
    id_rol
) VALUES ( 'Jimena',
           'Hernández',
           'Villalobos',
           'T-3039',
           'jimena.hernandez40@pejivalle.cr',
           'Activo',
           5,
           1,
           2 );

INSERT INTO trabajadores (
    nombre,
    apellido1,
    apellido2,
    identificacion,
    correo_electronico,
    estado,
    id_sucursal,
    id_turno,
    id_rol
) VALUES ( 'María',
           'Pérez',
           'Valverde',
           'T-3040',
           'maria.perez41@pejivalle.cr',
           'Activo',
           1,
           2,
           3 );

INSERT INTO trabajadores (
    nombre,
    apellido1,
    apellido2,
    identificacion,
    correo_electronico,
    estado,
    id_sucursal,
    id_turno,
    id_rol
) VALUES ( 'Ana',
           'Sánchez',
           'Ureña',
           'T-3041',
           'ana.sanchez42@pejivalle.cr',
           'Activo',
           2,
           2,
           3 );

INSERT INTO trabajadores (
    nombre,
    apellido1,
    apellido2,
    identificacion,
    correo_electronico,
    estado,
    id_sucursal,
    id_turno,
    id_rol
) VALUES ( 'Sofía',
           'Ramírez',
           'Zúñiga',
           'T-3042',
           'sofia.ramirez43@pejivalle.cr',
           'Activo',
           3,
           2,
           2 );

INSERT INTO trabajadores (
    nombre,
    apellido1,
    apellido2,
    identificacion,
    correo_electronico,
    estado,
    id_sucursal,
    id_turno,
    id_rol
) VALUES ( 'Valeria',
           'Cruz',
           'Brenes',
           'T-3043',
           'valeria.cruz44@pejivalle.cr',
           'Activo',
           4,
           2,
           3 );

INSERT INTO trabajadores (
    nombre,
    apellido1,
    apellido2,
    identificacion,
    correo_electronico,
    estado,
    id_sucursal,
    id_turno,
    id_rol
) VALUES ( 'Camila',
           'Vargas',
           'Pacheco',
           'T-3044',
           'camila.vargas45@pejivalle.cr',
           'Activo',
           5,
           2,
           3 );

INSERT INTO trabajadores (
    nombre,
    apellido1,
    apellido2,
    identificacion,
    correo_electronico,
    estado,
    id_sucursal,
    id_turno,
    id_rol
) VALUES ( 'Isabella',
           'Jiménez',
           'Muñoz',
           'T-3045',
           'isabella.jimenez46@pejivalle.cr',
           'Activo',
           1,
           1,
           2 );

INSERT INTO trabajadores (
    nombre,
    apellido1,
    apellido2,
    identificacion,
    correo_electronico,
    estado,
    id_sucursal,
    id_turno,
    id_rol
) VALUES ( 'Daniela',
           'Mora',
           'Fonseca',
           'T-3046',
           'daniela.mora47@pejivalle.cr',
           'Activo',
           2,
           2,
           3 );

INSERT INTO trabajadores (
    nombre,
    apellido1,
    apellido2,
    identificacion,
    correo_electronico,
    estado,
    id_sucursal,
    id_turno,
    id_rol
) VALUES ( 'Gabriela',
           'Castro',
           'Núñez',
           'T-3047',
           'gabriela.castro48@pejivalle.cr',
           'Activo',
           3,
           2,
           3 );

INSERT INTO trabajadores (
    nombre,
    apellido1,
    apellido2,
    identificacion,
    correo_electronico,
    estado,
    id_sucursal,
    id_turno,
    id_rol
) VALUES ( 'Paula',
           'Rojas',
           'Guzmán',
           'T-3048',
           'paula.rojas49@pejivalle.cr',
           'Activo',
           4,
           2,
           2 );

INSERT INTO trabajadores (
    nombre,
    apellido1,
    apellido2,
    identificacion,
    correo_electronico,
    estado,
    id_sucursal,
    id_turno,
    id_rol
) VALUES ( 'Lucía',
           'Alvarado',
           'Céspedes',
           'T-3049',
           'lucia.alvarado50@pejivalle.cr',
           'Activo',
           5,
           2,
           3 );

COMMIT;

SELECT
    *
FROM
    trabajadores;

--Telefonos trabajadores
INSERT INTO telefonos (
    telefono,
    id_trabajador
) VALUES ( '87100000',
           1 );

INSERT INTO telefonos (
    telefono,
    id_trabajador
) VALUES ( '87100000',
           2 );

INSERT INTO telefonos (
    telefono,
    id_trabajador
) VALUES ( '87100000',
           3 );

INSERT INTO telefonos (
    telefono,
    id_trabajador
) VALUES ( '87100000',
           4 );

INSERT INTO telefonos (
    telefono,
    id_trabajador
) VALUES ( '87100000',
           5 );

INSERT INTO telefonos (
    telefono,
    id_trabajador
) VALUES ( '87100000',
           6 );

INSERT INTO telefonos (
    telefono,
    id_trabajador
) VALUES ( '87100000',
           7 );

INSERT INTO telefonos (
    telefono,
    id_trabajador
) VALUES ( '87100000',
           8 );

INSERT INTO telefonos (
    telefono,
    id_trabajador
) VALUES ( '87100000',
           9 );

INSERT INTO telefonos (
    telefono,
    id_trabajador
) VALUES ( '87100000',
           10 );

INSERT INTO telefonos (
    telefono,
    id_trabajador
) VALUES ( '87100000',
           11 );

INSERT INTO telefonos (
    telefono,
    id_trabajador
) VALUES ( '87100000',
           12 );

INSERT INTO telefonos (
    telefono,
    id_trabajador
) VALUES ( '87100000',
           13 );

INSERT INTO telefonos (
    telefono,
    id_trabajador
) VALUES ( '87100000',
           14 );

INSERT INTO telefonos (
    telefono,
    id_trabajador
) VALUES ( '87100000',
           15 );

INSERT INTO telefonos (
    telefono,
    id_trabajador
) VALUES ( '87100000',
           16 );

INSERT INTO telefonos (
    telefono,
    id_trabajador
) VALUES ( '87100000',
           17 );

INSERT INTO telefonos (
    telefono,
    id_trabajador
) VALUES ( '87100000',
           18 );

INSERT INTO telefonos (
    telefono,
    id_trabajador
) VALUES ( '87100000',
           19 );

INSERT INTO telefonos (
    telefono,
    id_trabajador
) VALUES ( '87100000',
           20 );

INSERT INTO telefonos (
    telefono,
    id_trabajador
) VALUES ( '87100000',
           21 );

INSERT INTO telefonos (
    telefono,
    id_trabajador
) VALUES ( '87100000',
           22 );

INSERT INTO telefonos (
    telefono,
    id_trabajador
) VALUES ( '87100000',
           23 );

INSERT INTO telefonos (
    telefono,
    id_trabajador
) VALUES ( '87100000',
           24 );

INSERT INTO telefonos (
    telefono,
    id_trabajador
) VALUES ( '87100000',
           25 );

INSERT INTO telefonos (
    telefono,
    id_trabajador
) VALUES ( '8710-0000',
           26 );

INSERT INTO telefonos (
    telefono,
    id_trabajador
) VALUES ( '87100000',
           27 );

INSERT INTO telefonos (
    telefono,
    id_trabajador
) VALUES ( '87100000',
           28 );

INSERT INTO telefonos (
    telefono,
    id_trabajador
) VALUES ( '87100000',
           29 );

INSERT INTO telefonos (
    telefono,
    id_trabajador
) VALUES ( '87100000',
           30 );

INSERT INTO telefonos (
    telefono,
    id_trabajador
) VALUES ( '87100000',
           31 );

INSERT INTO telefonos (
    telefono,
    id_trabajador
) VALUES ( '87100000',
           32 );

INSERT INTO telefonos (
    telefono,
    id_trabajador
) VALUES ( '87100000',
           33 );

INSERT INTO telefonos (
    telefono,
    id_trabajador
) VALUES ( '87100000',
           34 );

INSERT INTO telefonos (
    telefono,
    id_trabajador
) VALUES ( '87100000',
           35 );

INSERT INTO telefonos (
    telefono,
    id_trabajador
) VALUES ( '87100000',
           36 );

INSERT INTO telefonos (
    telefono,
    id_trabajador
) VALUES ( '87100000',
           37 );

INSERT INTO telefonos (
    telefono,
    id_trabajador
) VALUES ( '87100000',
           38 );

INSERT INTO telefonos (
    telefono,
    id_trabajador
) VALUES ( '87100000',
           39 );

INSERT INTO telefonos (
    telefono,
    id_trabajador
) VALUES ( '87100000',
           40 );

INSERT INTO telefonos (
    telefono,
    id_trabajador
) VALUES ( '87100000',
           41 );

INSERT INTO telefonos (
    telefono,
    id_trabajador
) VALUES ( '87100000',
           42 );

INSERT INTO telefonos (
    telefono,
    id_trabajador
) VALUES ( '87100000',
           43 );

INSERT INTO telefonos (
    telefono,
    id_trabajador
) VALUES ( '87100000',
           44 );

INSERT INTO telefonos (
    telefono,
    id_trabajador
) VALUES ( '87100000',
           45 );

INSERT INTO telefonos (
    telefono,
    id_trabajador
) VALUES ( '87100000',
           46 );

INSERT INTO telefonos (
    telefono,
    id_trabajador
) VALUES ( '87100000',
           47 );

INSERT INTO telefonos (
    telefono,
    id_trabajador
) VALUES ( '87100000',
           48 );

INSERT INTO telefonos (
    telefono,
    id_trabajador
) VALUES ( '87100000',
           49 );

INSERT INTO telefonos (
    telefono,
    id_trabajador
) VALUES ( '87100000',
           50 );

COMMIT;

SELECT
    *
FROM
    telefonos;

--PAGO TRABAJADORES
INSERT INTO pago_trabajadores (
    anio,
    mes,
    quincena,
    monto_hora,
    horas_laboradas,
    monto_total,
    id_trabajador
) VALUES ( 2026,
           2,
           1,
           3200.00,
           80.00,
           256000.00,
           1 );

INSERT INTO pago_trabajadores (
    anio,
    mes,
    quincena,
    monto_hora,
    horas_laboradas,
    monto_total,
    id_trabajador
) VALUES ( 2026,
           2,
           1,
           3200.00,
           80.00,
           256000.00,
           2 );

INSERT INTO pago_trabajadores (
    anio,
    mes,
    quincena,
    monto_hora,
    horas_laboradas,
    monto_total,
    id_trabajador
) VALUES ( 2026,
           2,
           1,
           3200.00,
           80.00,
           256000.00,
           3 );

INSERT INTO pago_trabajadores (
    anio,
    mes,
    quincena,
    monto_hora,
    horas_laboradas,
    monto_total,
    id_trabajador
) VALUES ( 2026,
           2,
           1,
           3200.00,
           80.00,
           256000.00,
           4 );

INSERT INTO pago_trabajadores (
    anio,
    mes,
    quincena,
    monto_hora,
    horas_laboradas,
    monto_total,
    id_trabajador
) VALUES ( 2026,
           2,
           1,
           3200.00,
           80.00,
           256000.00,
           5 );

INSERT INTO pago_trabajadores (
    anio,
    mes,
    quincena,
    monto_hora,
    horas_laboradas,
    monto_total,
    id_trabajador
) VALUES ( 2026,
           2,
           1,
           3200.00,
           80.00,
           256000.00,
           6 );

INSERT INTO pago_trabajadores (
    anio,
    mes,
    quincena,
    monto_hora,
    horas_laboradas,
    monto_total,
    id_trabajador
) VALUES ( 2026,
           2,
           1,
           3200.00,
           80.00,
           256000.00,
           7 );

INSERT INTO pago_trabajadores (
    anio,
    mes,
    quincena,
    monto_hora,
    horas_laboradas,
    monto_total,
    id_trabajador
) VALUES ( 2026,
           2,
           1,
           3200.00,
           80.00,
           256000.00,
           8 );

INSERT INTO pago_trabajadores (
    anio,
    mes,
    quincena,
    monto_hora,
    horas_laboradas,
    monto_total,
    id_trabajador
) VALUES ( 2026,
           2,
           1,
           3200.00,
           80.00,
           256000.00,
           9 );

INSERT INTO pago_trabajadores (
    anio,
    mes,
    quincena,
    monto_hora,
    horas_laboradas,
    monto_total,
    id_trabajador
) VALUES ( 2026,
           2,
           1,
           3200.00,
           80.00,
           256000.00,
           10 );

INSERT INTO pago_trabajadores (
    anio,
    mes,
    quincena,
    monto_hora,
    horas_laboradas,
    monto_total,
    id_trabajador
) VALUES ( 2026,
           2,
           1,
           3200.00,
           80.00,
           256000.00,
           11 );

INSERT INTO pago_trabajadores (
    anio,
    mes,
    quincena,
    monto_hora,
    horas_laboradas,
    monto_total,
    id_trabajador
) VALUES ( 2026,
           2,
           1,
           3200.00,
           80.00,
           256000.00,
           12 );

INSERT INTO pago_trabajadores (
    anio,
    mes,
    quincena,
    monto_hora,
    horas_laboradas,
    monto_total,
    id_trabajador
) VALUES ( 2026,
           2,
           1,
           3200.00,
           80.00,
           256000.00,
           13 );

INSERT INTO pago_trabajadores (
    anio,
    mes,
    quincena,
    monto_hora,
    horas_laboradas,
    monto_total,
    id_trabajador
) VALUES ( 2026,
           2,
           1,
           3200.00,
           80.00,
           256000.00,
           14 );

INSERT INTO pago_trabajadores (
    anio,
    mes,
    quincena,
    monto_hora,
    horas_laboradas,
    monto_total,
    id_trabajador
) VALUES ( 2026,
           2,
           1,
           3200.00,
           80.00,
           256000.00,
           15 );

INSERT INTO pago_trabajadores (
    anio,
    mes,
    quincena,
    monto_hora,
    horas_laboradas,
    monto_total,
    id_trabajador
) VALUES ( 2026,
           2,
           1,
           3200.00,
           80.00,
           256000.00,
           16 );

INSERT INTO pago_trabajadores (
    anio,
    mes,
    quincena,
    monto_hora,
    horas_laboradas,
    monto_total,
    id_trabajador
) VALUES ( 2026,
           2,
           1,
           3200.00,
           80.00,
           256000.00,
           17 );

INSERT INTO pago_trabajadores (
    anio,
    mes,
    quincena,
    monto_hora,
    horas_laboradas,
    monto_total,
    id_trabajador
) VALUES ( 2026,
           2,
           1,
           3200.00,
           80.00,
           256000.00,
           18 );

INSERT INTO pago_trabajadores (
    anio,
    mes,
    quincena,
    monto_hora,
    horas_laboradas,
    monto_total,
    id_trabajador
) VALUES ( 2026,
           2,
           1,
           3200.00,
           80.00,
           256000.00,
           19 );

INSERT INTO pago_trabajadores (
    anio,
    mes,
    quincena,
    monto_hora,
    horas_laboradas,
    monto_total,
    id_trabajador
) VALUES ( 2026,
           2,
           1,
           3200.00,
           80.00,
           256000.00,
           20 );

INSERT INTO pago_trabajadores (
    anio,
    mes,
    quincena,
    monto_hora,
    horas_laboradas,
    monto_total,
    id_trabajador
) VALUES ( 2026,
           2,
           1,
           3200.00,
           80.00,
           256000.00,
           21 );

INSERT INTO pago_trabajadores (
    anio,
    mes,
    quincena,
    monto_hora,
    horas_laboradas,
    monto_total,
    id_trabajador
) VALUES ( 2026,
           2,
           1,
           3200.00,
           80.00,
           256000.00,
           22 );

INSERT INTO pago_trabajadores (
    anio,
    mes,
    quincena,
    monto_hora,
    horas_laboradas,
    monto_total,
    id_trabajador
) VALUES ( 2026,
           2,
           1,
           3200.00,
           80.00,
           256000.00,
           23 );

INSERT INTO pago_trabajadores (
    anio,
    mes,
    quincena,
    monto_hora,
    horas_laboradas,
    monto_total,
    id_trabajador
) VALUES ( 2026,
           2,
           1,
           3200.00,
           80.00,
           256000.00,
           24 );

INSERT INTO pago_trabajadores (
    anio,
    mes,
    quincena,
    monto_hora,
    horas_laboradas,
    monto_total,
    id_trabajador
) VALUES ( 2026,
           2,
           1,
           3200.00,
           80.00,
           256000.00,
           25 );

INSERT INTO pago_trabajadores (
    anio,
    mes,
    quincena,
    monto_hora,
    horas_laboradas,
    monto_total,
    id_trabajador
) VALUES ( 2026,
           2,
           1,
           3200.00,
           80.00,
           256000.00,
           26 );

INSERT INTO pago_trabajadores (
    anio,
    mes,
    quincena,
    monto_hora,
    horas_laboradas,
    monto_total,
    id_trabajador
) VALUES ( 2026,
           2,
           1,
           3200.00,
           80.00,
           256000.00,
           27 );

INSERT INTO pago_trabajadores (
    anio,
    mes,
    quincena,
    monto_hora,
    horas_laboradas,
    monto_total,
    id_trabajador
) VALUES ( 2026,
           2,
           1,
           3200.00,
           80.00,
           256000.00,
           28 );

INSERT INTO pago_trabajadores (
    anio,
    mes,
    quincena,
    monto_hora,
    horas_laboradas,
    monto_total,
    id_trabajador
) VALUES ( 2026,
           2,
           1,
           3200.00,
           80.00,
           256000.00,
           29 );

INSERT INTO pago_trabajadores (
    anio,
    mes,
    quincena,
    monto_hora,
    horas_laboradas,
    monto_total,
    id_trabajador
) VALUES ( 2026,
           2,
           1,
           3200.00,
           80.00,
           256000.00,
           30 );

INSERT INTO pago_trabajadores (
    anio,
    mes,
    quincena,
    monto_hora,
    horas_laboradas,
    monto_total,
    id_trabajador
) VALUES ( 2026,
           2,
           1,
           3200.00,
           80.00,
           256000.00,
           31 );

INSERT INTO pago_trabajadores (
    anio,
    mes,
    quincena,
    monto_hora,
    horas_laboradas,
    monto_total,
    id_trabajador
) VALUES ( 2026,
           2,
           1,
           3200.00,
           80.00,
           256000.00,
           32 );

INSERT INTO pago_trabajadores (
    anio,
    mes,
    quincena,
    monto_hora,
    horas_laboradas,
    monto_total,
    id_trabajador
) VALUES ( 2026,
           2,
           1,
           3200.00,
           80.00,
           256000.00,
           33 );

INSERT INTO pago_trabajadores (
    anio,
    mes,
    quincena,
    monto_hora,
    horas_laboradas,
    monto_total,
    id_trabajador
) VALUES ( 2026,
           2,
           1,
           3200.00,
           80.00,
           256000.00,
           34 );

INSERT INTO pago_trabajadores (
    anio,
    mes,
    quincena,
    monto_hora,
    horas_laboradas,
    monto_total,
    id_trabajador
) VALUES ( 2026,
           2,
           1,
           3200.00,
           80.00,
           256000.00,
           35 );

INSERT INTO pago_trabajadores (
    anio,
    mes,
    quincena,
    monto_hora,
    horas_laboradas,
    monto_total,
    id_trabajador
) VALUES ( 2026,
           2,
           1,
           3200.00,
           80.00,
           256000.00,
           36 );

INSERT INTO pago_trabajadores (
    anio,
    mes,
    quincena,
    monto_hora,
    horas_laboradas,
    monto_total,
    id_trabajador
) VALUES ( 2026,
           2,
           1,
           3200.00,
           80.00,
           256000.00,
           37 );

INSERT INTO pago_trabajadores (
    anio,
    mes,
    quincena,
    monto_hora,
    horas_laboradas,
    monto_total,
    id_trabajador
) VALUES ( 2026,
           2,
           1,
           3200.00,
           80.00,
           256000.00,
           38 );

INSERT INTO pago_trabajadores (
    anio,
    mes,
    quincena,
    monto_hora,
    horas_laboradas,
    monto_total,
    id_trabajador
) VALUES ( 2026,
           2,
           1,
           3200.00,
           80.00,
           256000.00,
           39 );

INSERT INTO pago_trabajadores (
    anio,
    mes,
    quincena,
    monto_hora,
    horas_laboradas,
    monto_total,
    id_trabajador
) VALUES ( 2026,
           2,
           1,
           3200.00,
           80.00,
           256000.00,
           40 );

INSERT INTO pago_trabajadores (
    anio,
    mes,
    quincena,
    monto_hora,
    horas_laboradas,
    monto_total,
    id_trabajador
) VALUES ( 2026,
           2,
           1,
           3200.00,
           80.00,
           256000.00,
           41 );

INSERT INTO pago_trabajadores (
    anio,
    mes,
    quincena,
    monto_hora,
    horas_laboradas,
    monto_total,
    id_trabajador
) VALUES ( 2026,
           2,
           1,
           3200.00,
           80.00,
           256000.00,
           42 );

INSERT INTO pago_trabajadores (
    anio,
    mes,
    quincena,
    monto_hora,
    horas_laboradas,
    monto_total,
    id_trabajador
) VALUES ( 2026,
           2,
           1,
           3200.00,
           80.00,
           256000.00,
           43 );

INSERT INTO pago_trabajadores (
    anio,
    mes,
    quincena,
    monto_hora,
    horas_laboradas,
    monto_total,
    id_trabajador
) VALUES ( 2026,
           2,
           1,
           3200.00,
           80.00,
           256000.00,
           44 );

INSERT INTO pago_trabajadores (
    anio,
    mes,
    quincena,
    monto_hora,
    horas_laboradas,
    monto_total,
    id_trabajador
) VALUES ( 2026,
           2,
           1,
           3200.00,
           80.00,
           256000.00,
           45 );

INSERT INTO pago_trabajadores (
    anio,
    mes,
    quincena,
    monto_hora,
    horas_laboradas,
    monto_total,
    id_trabajador
) VALUES ( 2026,
           2,
           1,
           3200.00,
           80.00,
           256000.00,
           46 );

INSERT INTO pago_trabajadores (
    anio,
    mes,
    quincena,
    monto_hora,
    horas_laboradas,
    monto_total,
    id_trabajador
) VALUES ( 2026,
           2,
           1,
           3200.00,
           80.00,
           256000.00,
           47 );

INSERT INTO pago_trabajadores (
    anio,
    mes,
    quincena,
    monto_hora,
    horas_laboradas,
    monto_total,
    id_trabajador
) VALUES ( 2026,
           2,
           1,
           3200.00,
           80.00,
           256000.00,
           48 );

INSERT INTO pago_trabajadores (
    anio,
    mes,
    quincena,
    monto_hora,
    horas_laboradas,
    monto_total,
    id_trabajador
) VALUES ( 2026,
           2,
           1,
           3200.00,
           80.00,
           256000.00,
           49 );

INSERT INTO pago_trabajadores (
    anio,
    mes,
    quincena,
    monto_hora,
    horas_laboradas,
    monto_total,
    id_trabajador
) VALUES ( 2026,
           2,
           1,
           3200.00,
           80.00,
           256000.00,
           50 );

COMMIT;

SELECT
    *
FROM
    pago_trabajadores;

--PRODUCTOS
INSERT INTO productos (
    nombre,
    descripcion,
    precio_venta,
    precio_costo,
    fecha_ultima_entrada,
    id_proveedor,
    id_categoria
) VALUES ( 'Aceite Motul 5W-30 1L',
           'Aceite sintético para motor',
           2500.00,
           1800.00,
           DATE '2026-01-15',
           1,
           1 );

INSERT INTO productos (
    nombre,
    descripcion,
    precio_venta,
    precio_costo,
    fecha_ultima_entrada,
    id_proveedor,
    id_categoria
) VALUES ( 'Aceite Castrol GTX 10W-40 1L',
           'Aceite semisintético para motor',
           2850.00,
           2050.00,
           DATE '2026-01-16',
           2,
           1 );

INSERT INTO productos (
    nombre,
    descripcion,
    precio_venta,
    precio_costo,
    fecha_ultima_entrada,
    id_proveedor,
    id_categoria
) VALUES ( 'Aceite Shell Helix Ultra 5W-40 1L',
           'Aceite sintético premium',
           3200.00,
           2300.00,
           DATE '2026-01-17',
           3,
           1 );

INSERT INTO productos (
    nombre,
    descripcion,
    precio_venta,
    precio_costo,
    fecha_ultima_entrada,
    id_proveedor,
    id_categoria
) VALUES ( 'Aceite Valvoline 20W-50 1L',
           'Aceite mineral para motor',
           2400.00,
           1700.00,
           DATE '2026-01-18',
           4,
           1 );

INSERT INTO productos (
    nombre,
    descripcion,
    precio_venta,
    precio_costo,
    fecha_ultima_entrada,
    id_proveedor,
    id_categoria
) VALUES ( 'Aceite Mobil 1 0W-20 1L',
           'Aceite sintético alto rendimiento',
           3550.00,
           2550.00,
           DATE '2026-01-19',
           10,
           1 );

INSERT INTO productos (
    nombre,
    descripcion,
    precio_venta,
    precio_costo,
    fecha_ultima_entrada,
    id_proveedor,
    id_categoria
) VALUES ( 'Aceite Motul 8100 X-clean 5W-40 4L',
           'Aceite sintético (galón 4L)',
           11800.00,
           8800.00,
           DATE '2026-01-20',
           1,
           1 );

INSERT INTO productos (
    nombre,
    descripcion,
    precio_venta,
    precio_costo,
    fecha_ultima_entrada,
    id_proveedor,
    id_categoria
) VALUES ( 'Aceite Castrol Magnatec 5W-30 4L',
           'Aceite sintético con protección extra (4L)',
           11200.00,
           8200.00,
           DATE '2026-01-21',
           2,
           1 );

INSERT INTO productos (
    nombre,
    descripcion,
    precio_venta,
    precio_costo,
    fecha_ultima_entrada,
    id_proveedor,
    id_categoria
) VALUES ( 'Aceite Shell Helix HX7 10W-40 4L',
           'Aceite semisintético (4L)',
           10500.00,
           7700.00,
           DATE '2026-01-22',
           4,
           1 );

INSERT INTO productos (
    nombre,
    descripcion,
    precio_venta,
    precio_costo,
    fecha_ultima_entrada,
    id_proveedor,
    id_categoria
) VALUES ( 'Aceite Valvoline SynPower 5W-30 4L',
           'Aceite sintético (4L)',
           11500.00,
           8450.00,
           DATE '2026-01-23',
           4,
           1 );

INSERT INTO productos (
    nombre,
    descripcion,
    precio_venta,
    precio_costo,
    fecha_ultima_entrada,
    id_proveedor,
    id_categoria
) VALUES ( 'Aceite Mobil Super 2000 10W-40 4L',
           'Aceite semisintético (4L)',
           10800.00,
           7900.00,
           DATE '2026-01-24',
           9,
           1 );

INSERT INTO productos (
    nombre,
    descripcion,
    precio_venta,
    precio_costo,
    fecha_ultima_entrada,
    id_proveedor,
    id_categoria
) VALUES ( 'Filtro de Aceite MANN W 610/3',
           'Filtro de aceite para motor',
           3900.00,
           2800.00,
           DATE '2026-01-25',
           6,
           2 );

INSERT INTO productos (
    nombre,
    descripcion,
    precio_venta,
    precio_costo,
    fecha_ultima_entrada,
    id_proveedor,
    id_categoria
) VALUES ( 'Filtro de Aire FRAM CA10242',
           'Filtro de aire para motor',
           4250.00,
           3060.00,
           DATE '2026-01-26',
           8,
           2 );

INSERT INTO productos (
    nombre,
    descripcion,
    precio_venta,
    precio_costo,
    fecha_ultima_entrada,
    id_proveedor,
    id_categoria
) VALUES ( 'Filtro de Cabina MANN CU 26004',
           'Filtro de polen/cabina',
           4800.00,
           3450.00,
           DATE '2026-01-27',
           6,
           2 );

INSERT INTO productos (
    nombre,
    descripcion,
    precio_venta,
    precio_costo,
    fecha_ultima_entrada,
    id_proveedor,
    id_categoria
) VALUES ( 'Filtro de Combustible Bosch N2040',
           'Filtro de gasolina/diésel',
           5200.00,
           3780.00,
           DATE '2026-01-28',
           7,
           2 );

INSERT INTO productos (
    nombre,
    descripcion,
    precio_venta,
    precio_costo,
    fecha_ultima_entrada,
    id_proveedor,
    id_categoria
) VALUES ( 'Filtro de Aceite FRAM PH7317',
           'Filtro de aceite para motor',
           4100.00,
           2950.00,
           DATE '2026-01-29',
           8,
           2 );

INSERT INTO productos (
    nombre,
    descripcion,
    precio_venta,
    precio_costo,
    fecha_ultima_entrada,
    id_proveedor,
    id_categoria
) VALUES ( 'Filtro de Aire MANN C 30005',
           'Filtro de aire para motor',
           4500.00,
           3240.00,
           DATE '2026-01-30',
           6,
           2 );

INSERT INTO productos (
    nombre,
    descripcion,
    precio_venta,
    precio_costo,
    fecha_ultima_entrada,
    id_proveedor,
    id_categoria
) VALUES ( 'Liqui Moly Limpiador de Inyectores 300ml',
           'Aditivo para limpiar inyectores',
           4600.00,
           3310.00,
           DATE '2026-02-01',
           10,
           3 );

INSERT INTO productos (
    nombre,
    descripcion,
    precio_venta,
    precio_costo,
    fecha_ultima_entrada,
    id_proveedor,
    id_categoria
) VALUES ( 'Liqui Moly Aditivo Octanaje Booster 150ml',
           'Mejorador de octanaje',
           5200.00,
           3750.00,
           DATE '2026-02-02',
           10,
           3 );

INSERT INTO productos (
    nombre,
    descripcion,
    precio_venta,
    precio_costo,
    fecha_ultima_entrada,
    id_proveedor,
    id_categoria
) VALUES ( 'Liqui Moly Tratamiento Motor Oil Additive 200ml',
           'Reduce fricción y desgaste',
           5400.00,
           3900.00,
           DATE '2026-02-03',
           10,
           3 );

INSERT INTO productos (
    nombre,
    descripcion,
    precio_venta,
    precio_costo,
    fecha_ultima_entrada,
    id_proveedor,
    id_categoria
) VALUES ( 'Liqui Moly Limpia Radiador 300ml',
           'Aditivo para limpiar sistema de enfriamiento',
           4900.00,
           3520.00,
           DATE '2026-02-04',
           10,
           3 );

INSERT INTO productos (
    nombre,
    descripcion,
    precio_venta,
    precio_costo,
    fecha_ultima_entrada,
    id_proveedor,
    id_categoria
) VALUES ( 'Aditivo Motul Fuel System Clean 300ml',
           'Limpieza del sistema de combustible',
           5100.00,
           3680.00,
           DATE '2026-02-05',
           1,
           3 );

INSERT INTO productos (
    nombre,
    descripcion,
    precio_venta,
    precio_costo,
    fecha_ultima_entrada,
    id_proveedor,
    id_categoria
) VALUES ( 'Refrigerante TotalEnergies Verde 1L',
           'Refrigerante listo para usar',
           4950.00,
           3560.00,
           DATE '2026-02-06',
           5,
           4 );

INSERT INTO productos (
    nombre,
    descripcion,
    precio_venta,
    precio_costo,
    fecha_ultima_entrada,
    id_proveedor,
    id_categoria
) VALUES ( 'Refrigerante TotalEnergies Rojo 1L',
           'Refrigerante larga duración',
           5200.00,
           3740.00,
           DATE '2026-02-07',
           5,
           4 );

INSERT INTO productos (
    nombre,
    descripcion,
    precio_venta,
    precio_costo,
    fecha_ultima_entrada,
    id_proveedor,
    id_categoria
) VALUES ( 'Refrigerante TotalEnergies Verde 4L',
           'Refrigerante listo para usar (4L)',
           16500.00,
           12400.00,
           DATE '2026-02-08',
           5,
           4 );

INSERT INTO productos (
    nombre,
    descripcion,
    precio_venta,
    precio_costo,
    fecha_ultima_entrada,
    id_proveedor,
    id_categoria
) VALUES ( 'Refrigerante TotalEnergies Concentrado 1L',
           'Concentrado para mezcla',
           5400.00,
           3950.00,
           DATE '2026-02-09',
           5,
           4 );

INSERT INTO productos (
    nombre,
    descripcion,
    precio_venta,
    precio_costo,
    fecha_ultima_entrada,
    id_proveedor,
    id_categoria
) VALUES ( 'Bosch Limpiador de Frenos 500ml',
           'Limpia grasa/polvo en discos y pastillas',
           5300.00,
           3810.00,
           DATE '2026-02-10',
           7,
           5 );

INSERT INTO productos (
    nombre,
    descripcion,
    precio_venta,
    precio_costo,
    fecha_ultima_entrada,
    id_proveedor,
    id_categoria
) VALUES ( 'Liquido de Frenos DOT 4 Castrol 355ml',
           'Fluido DOT 4 para sistema de frenos',
           4200.00,
           3000.00,
           DATE '2026-02-11',
           2,
           5 );

INSERT INTO productos (
    nombre,
    descripcion,
    precio_venta,
    precio_costo,
    fecha_ultima_entrada,
    id_proveedor,
    id_categoria
) VALUES ( 'Liquido de Frenos DOT 3 Valvoline 355ml',
           'Fluido DOT 3 para frenos',
           3900.00,
           2750.00,
           DATE '2026-02-12',
           4,
           5 );

INSERT INTO productos (
    nombre,
    descripcion,
    precio_venta,
    precio_costo,
    fecha_ultima_entrada,
    id_proveedor,
    id_categoria
) VALUES ( 'Grasa para Caliper Bosch 70g',
           'Lubricante para componentes de freno',
           3600.00,
           2500.00,
           DATE '2026-02-13',
           7,
           5 );

INSERT INTO productos (
    nombre,
    descripcion,
    precio_venta,
    precio_costo,
    fecha_ultima_entrada,
    id_proveedor,
    id_categoria
) VALUES ( 'Spray Antichirrido Liqui Moly 400ml',
           'Reduce chirridos en frenos',
           5900.00,
           4300.00,
           DATE '2026-02-14',
           10,
           5 );

INSERT INTO productos (
    nombre,
    descripcion,
    precio_venta,
    precio_costo,
    fecha_ultima_entrada,
    id_proveedor,
    id_categoria
) VALUES ( 'Bosch Limpiador Multiuso 500ml',
           'Limpieza general de partes automotrices',
           5600.00,
           4030.00,
           DATE '2026-02-15',
           7,
           6 );

INSERT INTO productos (
    nombre,
    descripcion,
    precio_venta,
    precio_costo,
    fecha_ultima_entrada,
    id_proveedor,
    id_categoria
) VALUES ( 'Liqui Moly Limpia Contactos 200ml',
           'Spray para limpieza de contactos eléctricos',
           6100.00,
           4500.00,
           DATE '2026-02-16',
           10,
           6 );

INSERT INTO productos (
    nombre,
    descripcion,
    precio_venta,
    precio_costo,
    fecha_ultima_entrada,
    id_proveedor,
    id_categoria
) VALUES ( 'Liqui Moly Espuma Limpia Tapiceria 400ml',
           'Espuma para limpieza interior',
           6500.00,
           4800.00,
           DATE '2026-02-17',
           10,
           6 );

INSERT INTO productos (
    nombre,
    descripcion,
    precio_venta,
    precio_costo,
    fecha_ultima_entrada,
    id_proveedor,
    id_categoria
) VALUES ( 'Bosch Shampoo Automotriz 1L',
           'Shampoo para carrocería',
           4800.00,
           3450.00,
           DATE '2026-02-18',
           7,
           6 );

INSERT INTO productos (
    nombre,
    descripcion,
    precio_venta,
    precio_costo,
    fecha_ultima_entrada,
    id_proveedor,
    id_categoria
) VALUES ( 'Desengrasante Motul Engine Clean 300ml',
           'Desengrasante para motor',
           5700.00,
           4150.00,
           DATE '2026-02-19',
           1,
           6 );

INSERT INTO productos (
    nombre,
    descripcion,
    precio_venta,
    precio_costo,
    fecha_ultima_entrada,
    id_proveedor,
    id_categoria
) VALUES ( 'Bosch Bujía Iridium (unidad)',
           'Bujía de alto desempeño',
           5650.00,
           4060.00,
           DATE '2026-02-20',
           7,
           7 );

INSERT INTO productos (
    nombre,
    descripcion,
    precio_venta,
    precio_costo,
    fecha_ultima_entrada,
    id_proveedor,
    id_categoria
) VALUES ( 'Cable de Bujía Bosch Juego x4',
           'Juego de cables de bujía',
           14500.00,
           10800.00,
           DATE '2026-02-21',
           7,
           7 );

INSERT INTO productos (
    nombre,
    descripcion,
    precio_venta,
    precio_costo,
    fecha_ultima_entrada,
    id_proveedor,
    id_categoria
) VALUES ( 'Plumillas Bosch Aerotwin 24"',
           'Escobilla limpiaparabrisas',
           9800.00,
           7200.00,
           DATE '2026-02-22',
           7,
           7 );

INSERT INTO productos (
    nombre,
    descripcion,
    precio_venta,
    precio_costo,
    fecha_ultima_entrada,
    id_proveedor,
    id_categoria
) VALUES ( 'Plumillas Bosch Aerotwin 18"',
           'Escobilla limpiaparabrisas',
           9200.00,
           6800.00,
           DATE '2026-02-23',
           7,
           7 );

INSERT INTO productos (
    nombre,
    descripcion,
    precio_venta,
    precio_costo,
    fecha_ultima_entrada,
    id_proveedor,
    id_categoria
) VALUES ( 'Botella Mezcladora Refrigerante 1L',
           'Botella para mezcla y relleno',
           2500.00,
           1600.00,
           DATE '2026-02-24',
           5,
           7 );

INSERT INTO productos (
    nombre,
    descripcion,
    precio_venta,
    precio_costo,
    fecha_ultima_entrada,
    id_proveedor,
    id_categoria
) VALUES ( 'Bombillo H4 Bosch 60/55W',
           'Bombillo halógeno H4',
           3200.00,
           2100.00,
           DATE '2026-02-25',
           7,
           8 );

INSERT INTO productos (
    nombre,
    descripcion,
    precio_venta,
    precio_costo,
    fecha_ultima_entrada,
    id_proveedor,
    id_categoria
) VALUES ( 'Bombillo H7 Bosch 55W',
           'Bombillo halógeno H7',
           3400.00,
           2250.00,
           DATE '2026-02-26',
           7,
           8 );

INSERT INTO productos (
    nombre,
    descripcion,
    precio_venta,
    precio_costo,
    fecha_ultima_entrada,
    id_proveedor,
    id_categoria
) VALUES ( 'Bombillo P21W Bosch (unidad)',
           'Bombillo direccional/stop P21W',
           1500.00,
           900.00,
           DATE '2026-02-27',
           7,
           8 );

INSERT INTO productos (
    nombre,
    descripcion,
    precio_venta,
    precio_costo,
    fecha_ultima_entrada,
    id_proveedor,
    id_categoria
) VALUES ( 'Luz LED Interior 12V Bosch',
           'Luz LED para cabina',
           2800.00,
           1700.00,
           DATE '2026-02-28',
           7,
           8 );

INSERT INTO productos (
    nombre,
    descripcion,
    precio_venta,
    precio_costo,
    fecha_ultima_entrada,
    id_proveedor,
    id_categoria
) VALUES ( 'Neumático 195/65R15 Touring',
           'Llanta para sedán (touring)',
           42000.00,
           33500.00,
           DATE '2026-03-01',
           7,
           9 );

INSERT INTO productos (
    nombre,
    descripcion,
    precio_venta,
    precio_costo,
    fecha_ultima_entrada,
    id_proveedor,
    id_categoria
) VALUES ( 'Neumático 205/55R16 Sport',
           'Llanta para sedán (sport)',
           47000.00,
           37800.00,
           DATE '2026-03-02',
           7,
           9 );

INSERT INTO productos (
    nombre,
    descripcion,
    precio_venta,
    precio_costo,
    fecha_ultima_entrada,
    id_proveedor,
    id_categoria
) VALUES ( 'Neumático 215/60R16 SUV',
           'Llanta para SUV',
           52000.00,
           41800.00,
           DATE '2026-03-03',
           7,
           9 );

INSERT INTO productos (
    nombre,
    descripcion,
    precio_venta,
    precio_costo,
    fecha_ultima_entrada,
    id_proveedor,
    id_categoria
) VALUES ( 'Neumático 225/45R17 Performance',
           'Llanta alto desempeño',
           58500.00,
           47200.00,
           DATE '2026-03-04',
           7,
           9 );

INSERT INTO productos (
    nombre,
    descripcion,
    precio_venta,
    precio_costo,
    fecha_ultima_entrada,
    id_proveedor,
    id_categoria
) VALUES ( 'Neumático 265/70R16 All Terrain',
           'Llanta todo terreno',
           69000.00,
           56000.00,
           DATE '2026-03-05',
           7,
           9 );

INSERT INTO productos (
    nombre,
    descripcion,
    precio_venta,
    precio_costo,
    fecha_ultima_entrada,
    id_proveedor,
    id_categoria
) VALUES ( 'Juego de Llaves Combinadas 8-19mm',
           'Set de llaves para mecánica',
           18500.00,
           14000.00,
           DATE '2026-03-06',
           7,
           9 );

INSERT INTO productos (
    nombre,
    descripcion,
    precio_venta,
    precio_costo,
    fecha_ultima_entrada,
    id_proveedor,
    id_categoria
) VALUES ( 'Ratchet 1/2" con Dados 10-24mm',
           'Juego de ratchet y dados',
           26500.00,
           20500.00,
           DATE '2026-03-07',
           7,
           9 );

INSERT INTO productos (
    nombre,
    descripcion,
    precio_venta,
    precio_costo,
    fecha_ultima_entrada,
    id_proveedor,
    id_categoria
) VALUES ( 'Gato Hidráulico 2 Toneladas',
           'Gato para levantamiento de vehículo',
           32000.00,
           25500.00,
           DATE '2026-03-08',
           7,
           9 );

INSERT INTO productos (
    nombre,
    descripcion,
    precio_venta,
    precio_costo,
    fecha_ultima_entrada,
    id_proveedor,
    id_categoria
) VALUES ( 'Llave de Rueda Cruz 14-17-19-21mm',
           'Llave cruz para cambio de llanta',
           8500.00,
           6200.00,
           DATE '2026-03-09',
           7,
           9 );

INSERT INTO productos (
    nombre,
    descripcion,
    precio_venta,
    precio_costo,
    fecha_ultima_entrada,
    id_proveedor,
    id_categoria
) VALUES ( 'Torquímetro 1/2" 28-210 Nm',
           'Herramienta para torque preciso',
           39500.00,
           31800.00,
           DATE '2026-03-10',
           7,
           9 );

INSERT INTO productos (
    nombre,
    descripcion,
    precio_venta,
    precio_costo,
    fecha_ultima_entrada,
    id_proveedor,
    id_categoria
) VALUES ( 'Aceite Motul 10W-40 1L',
           'Aceite semisintético para motor',
           2600.00,
           1870.00,
           DATE '2026-03-11',
           1,
           1 );

INSERT INTO productos (
    nombre,
    descripcion,
    precio_venta,
    precio_costo,
    fecha_ultima_entrada,
    id_proveedor,
    id_categoria
) VALUES ( 'Aceite Castrol Edge 0W-30 1L',
           'Aceite sintético premium',
           3950.00,
           2870.00,
           DATE '2026-03-12',
           2,
           1 );

INSERT INTO productos (
    nombre,
    descripcion,
    precio_venta,
    precio_costo,
    fecha_ultima_entrada,
    id_proveedor,
    id_categoria
) VALUES ( 'Aceite Shell Helix 0W-20 1L',
           'Aceite sintético para motores modernos',
           3800.00,
           2750.00,
           DATE '2026-03-13',
           3,
           1 );

INSERT INTO productos (
    nombre,
    descripcion,
    precio_venta,
    precio_costo,
    fecha_ultima_entrada,
    id_proveedor,
    id_categoria
) VALUES ( 'Filtro de Cabina FRAM CF10134',
           'Filtro de cabina',
           4700.00,
           3350.00,
           DATE '2026-03-14',
           8,
           2 );

INSERT INTO productos (
    nombre,
    descripcion,
    precio_venta,
    precio_costo,
    fecha_ultima_entrada,
    id_proveedor,
    id_categoria
) VALUES ( 'Filtro de Combustible MANN WK 820/17',
           'Filtro de combustible',
           5600.00,
           4100.00,
           DATE '2026-03-15',
           6,
           2 );

INSERT INTO productos (
    nombre,
    descripcion,
    precio_venta,
    precio_costo,
    fecha_ultima_entrada,
    id_proveedor,
    id_categoria
) VALUES ( 'Liqui Moly Sellador de Fugas Radiador 250ml',
           'Sella microfugas del radiador',
           6200.00,
           4600.00,
           DATE '2026-03-16',
           8,
           3 );

INSERT INTO productos (
    nombre,
    descripcion,
    precio_venta,
    precio_costo,
    fecha_ultima_entrada,
    id_proveedor,
    id_categoria
) VALUES ( 'Refrigerante TotalEnergies Rojo 4L',
           'Refrigerante larga duración (4L)',
           17800.00,
           13400.00,
           DATE '2026-03-17',
           5,
           4 );

INSERT INTO productos (
    nombre,
    descripcion,
    precio_venta,
    precio_costo,
    fecha_ultima_entrada,
    id_proveedor,
    id_categoria
) VALUES ( 'Liquido de Frenos DOT 4 Motul 500ml',
           'Fluido DOT 4 alto desempeño',
           5900.00,
           4350.00,
           DATE '2026-03-18',
           1,
           5 );

INSERT INTO productos (
    nombre,
    descripcion,
    precio_venta,
    precio_costo,
    fecha_ultima_entrada,
    id_proveedor,
    id_categoria
) VALUES ( 'Liqui Moly Limpia Carburador 500ml',
           'Spray para limpieza de carburador/cuerpo',
           6800.00,
           5050.00,
           DATE '2026-03-19',
           4,
           6 );

INSERT INTO productos (
    nombre,
    descripcion,
    precio_venta,
    precio_costo,
    fecha_ultima_entrada,
    id_proveedor,
    id_categoria
) VALUES ( 'Bosch Batería 12V 60Ah',
           'Batería para vehículo liviano',
           62000.00,
           50500.00,
           DATE '2026-03-20',
           7,
           7 );

INSERT INTO productos (
    nombre,
    descripcion,
    precio_venta,
    precio_costo,
    fecha_ultima_entrada,
    id_proveedor,
    id_categoria
) VALUES ( 'Bombillo W5W Bosch (unidad)',
           'Bombillo posición W5W',
           1200.00,
           700.00,
           DATE '2026-03-21',
           7,
           8 );

INSERT INTO productos (
    nombre,
    descripcion,
    precio_venta,
    precio_costo,
    fecha_ultima_entrada,
    id_proveedor,
    id_categoria
) VALUES ( 'Neumático 175/70R13 Económico',
           'Llanta para compacto',
           35500.00,
           27800.00,
           DATE '2026-03-22',
           7,
           8 );

INSERT INTO productos (
    nombre,
    descripcion,
    precio_venta,
    precio_costo,
    fecha_ultima_entrada,
    id_proveedor,
    id_categoria
) VALUES ( 'Compresor Portátil 12V',
           'Compresor para inflar llantas',
           24000.00,
           18500.00,
           DATE '2026-03-23',
           7,
           8 );

COMMIT;

SELECT
    *
FROM
    productos;

SELECT
    *
FROM
    proveedores;

SELECT
    *
FROM
    categoria;

---Productos_sucursales
INSERT INTO productos_sucursales (
    cantidad,
    id_sucursal,
    id_producto
) VALUES ( 8,
           1,
           1 );

INSERT INTO productos_sucursales (
    cantidad,
    id_sucursal,
    id_producto
) VALUES ( 8,
           1,
           2 );

INSERT INTO productos_sucursales (
    cantidad,
    id_sucursal,
    id_producto
) VALUES ( 8,
           1,
           3 );

INSERT INTO productos_sucursales (
    cantidad,
    id_sucursal,
    id_producto
) VALUES ( 8,
           1,
           4 );

INSERT INTO productos_sucursales (
    cantidad,
    id_sucursal,
    id_producto
) VALUES ( 8,
           1,
           5 );

INSERT INTO productos_sucursales (
    cantidad,
    id_sucursal,
    id_producto
) VALUES ( 8,
           1,
           6 );

INSERT INTO productos_sucursales (
    cantidad,
    id_sucursal,
    id_producto
) VALUES ( 8,
           1,
           7 );

INSERT INTO productos_sucursales (
    cantidad,
    id_sucursal,
    id_producto
) VALUES ( 8,
           1,
           8 );

INSERT INTO productos_sucursales (
    cantidad,
    id_sucursal,
    id_producto
) VALUES ( 8,
           1,
           9 );

INSERT INTO productos_sucursales (
    cantidad,
    id_sucursal,
    id_producto
) VALUES ( 8,
           1,
           10 );

INSERT INTO productos_sucursales (
    cantidad,
    id_sucursal,
    id_producto
) VALUES ( 8,
           1,
           11 );

INSERT INTO productos_sucursales (
    cantidad,
    id_sucursal,
    id_producto
) VALUES ( 8,
           1,
           12 );

INSERT INTO productos_sucursales (
    cantidad,
    id_sucursal,
    id_producto
) VALUES ( 8,
           1,
           13 );

INSERT INTO productos_sucursales (
    cantidad,
    id_sucursal,
    id_producto
) VALUES ( 8,
           1,
           14 );

INSERT INTO productos_sucursales (
    cantidad,
    id_sucursal,
    id_producto
) VALUES ( 8,
           1,
           15 );

INSERT INTO productos_sucursales (
    cantidad,
    id_sucursal,
    id_producto
) VALUES ( 8,
           1,
           16 );

INSERT INTO productos_sucursales (
    cantidad,
    id_sucursal,
    id_producto
) VALUES ( 8,
           1,
           21 );

INSERT INTO productos_sucursales (
    cantidad,
    id_sucursal,
    id_producto
) VALUES ( 8,
           1,
           22 );

INSERT INTO productos_sucursales (
    cantidad,
    id_sucursal,
    id_producto
) VALUES ( 8,
           1,
           23 );

INSERT INTO productos_sucursales (
    cantidad,
    id_sucursal,
    id_producto
) VALUES ( 8,
           1,
           24 );

INSERT INTO productos_sucursales (
    cantidad,
    id_sucursal,
    id_producto
) VALUES ( 8,
           1,
           25 );

INSERT INTO productos_sucursales (
    cantidad,
    id_sucursal,
    id_producto
) VALUES ( 8,
           1,
           26 );

INSERT INTO productos_sucursales (
    cantidad,
    id_sucursal,
    id_producto
) VALUES ( 8,
           1,
           27 );

INSERT INTO productos_sucursales (
    cantidad,
    id_sucursal,
    id_producto
) VALUES ( 8,
           1,
           28 );

INSERT INTO productos_sucursales (
    cantidad,
    id_sucursal,
    id_producto
) VALUES ( 8,
           1,
           29 );

INSERT INTO productos_sucursales (
    cantidad,
    id_sucursal,
    id_producto
) VALUES ( 8,
           1,
           31 );

INSERT INTO productos_sucursales (
    cantidad,
    id_sucursal,
    id_producto
) VALUES ( 8,
           1,
           34 );

INSERT INTO productos_sucursales (
    cantidad,
    id_sucursal,
    id_producto
) VALUES ( 8,
           1,
           35 );

INSERT INTO productos_sucursales (
    cantidad,
    id_sucursal,
    id_producto
) VALUES ( 8,
           1,
           36 );

INSERT INTO productos_sucursales (
    cantidad,
    id_sucursal,
    id_producto
) VALUES ( 8,
           1,
           37 );

INSERT INTO productos_sucursales (
    cantidad,
    id_sucursal,
    id_producto
) VALUES ( 8,
           1,
           38 );

INSERT INTO productos_sucursales (
    cantidad,
    id_sucursal,
    id_producto
) VALUES ( 8,
           1,
           39 );

INSERT INTO productos_sucursales (
    cantidad,
    id_sucursal,
    id_producto
) VALUES ( 8,
           1,
           40 );

INSERT INTO productos_sucursales (
    cantidad,
    id_sucursal,
    id_producto
) VALUES ( 8,
           1,
           41 );

INSERT INTO productos_sucursales (
    cantidad,
    id_sucursal,
    id_producto
) VALUES ( 8,
           1,
           42 );

INSERT INTO productos_sucursales (
    cantidad,
    id_sucursal,
    id_producto
) VALUES ( 8,
           1,
           43 );

INSERT INTO productos_sucursales (
    cantidad,
    id_sucursal,
    id_producto
) VALUES ( 8,
           1,
           44 );

INSERT INTO productos_sucursales (
    cantidad,
    id_sucursal,
    id_producto
) VALUES ( 8,
           1,
           45 );

INSERT INTO productos_sucursales (
    cantidad,
    id_sucursal,
    id_producto
) VALUES ( 8,
           1,
           46 );

INSERT INTO productos_sucursales (
    cantidad,
    id_sucursal,
    id_producto
) VALUES ( 8,
           1,
           47 );

INSERT INTO productos_sucursales (
    cantidad,
    id_sucursal,
    id_producto
) VALUES ( 8,
           1,
           48 );

INSERT INTO productos_sucursales (
    cantidad,
    id_sucursal,
    id_producto
) VALUES ( 8,
           1,
           49 );

INSERT INTO productos_sucursales (
    cantidad,
    id_sucursal,
    id_producto
) VALUES ( 8,
           1,
           55 );

INSERT INTO productos_sucursales (
    cantidad,
    id_sucursal,
    id_producto
) VALUES ( 8,
           1,
           56 );

INSERT INTO productos_sucursales (
    cantidad,
    id_sucursal,
    id_producto
) VALUES ( 8,
           1,
           57 );

INSERT INTO productos_sucursales (
    cantidad,
    id_sucursal,
    id_producto
) VALUES ( 8,
           1,
           58 );

INSERT INTO productos_sucursales (
    cantidad,
    id_sucursal,
    id_producto
) VALUES ( 8,
           1,
           59 );

INSERT INTO productos_sucursales (
    cantidad,
    id_sucursal,
    id_producto
) VALUES ( 8,
           1,
           61 );

INSERT INTO productos_sucursales (
    cantidad,
    id_sucursal,
    id_producto
) VALUES ( 8,
           1,
           62 );

INSERT INTO productos_sucursales (
    cantidad,
    id_sucursal,
    id_producto
) VALUES ( 8,
           1,
           64 );

INSERT INTO productos_sucursales (
    cantidad,
    id_sucursal,
    id_producto
) VALUES ( 8,
           1,
           65 );

INSERT INTO productos_sucursales (
    cantidad,
    id_sucursal,
    id_producto
) VALUES ( 8,
           1,
           66 );

COMMIT;

SELECT
    *
FROM
    productos_sucursales;

--VENTAS

SELECT
    *
FROM
    tipo_pagos;

INSERT INTO ventas (
    fecha_hora,
    total,
    cedula,
    id_trabajador,
    id_tipo_pago
) VALUES ( TO_TIMESTAMP('2026-02-01 08:15:00', 'YYYY-MM-DD HH24:MI:SS'),
           6000.00,
           '110002000',
           1,
           2 );

INSERT INTO ventas (
    fecha_hora,
    total,
    cedula,
    id_trabajador,
    id_tipo_pago
) VALUES ( TO_TIMESTAMP('2026-02-01 11:15:00', 'YYYY-MM-DD HH24:MI:SS'),
           6500.00,
           '210012001',
           3,
           1 );

INSERT INTO ventas (
    fecha_hora,
    total,
    cedula,
    id_trabajador,
    id_tipo_pago
) VALUES ( TO_TIMESTAMP('2026-02-01 14:15:00', 'YYYY-MM-DD HH24:MI:SS'),
           7000.00,
           '310022002',
           2,
           1 );

INSERT INTO ventas (
    fecha_hora,
    total,
    cedula,
    id_trabajador,
    id_tipo_pago
) VALUES ( TO_TIMESTAMP('2026-02-01 17:15:00', 'YYYY-MM-DD HH24:MI:SS'),
           7500.00,
           '410032003',
           1,
           2 );

INSERT INTO ventas (
    fecha_hora,
    total,
    cedula,
    id_trabajador,
    id_tipo_pago
) VALUES ( TO_TIMESTAMP('2026-02-01 20:15:00', 'YYYY-MM-DD HH24:MI:SS'),
           8000.00,
           '510042004',
           5,
           1 );

INSERT INTO ventas (
    fecha_hora,
    total,
    cedula,
    id_trabajador,
    id_tipo_pago
) VALUES ( TO_TIMESTAMP('2026-02-01 23:15:00', 'YYYY-MM-DD HH24:MI:SS'),
           8500.00,
           '610052005',
           6,
           1 );

INSERT INTO ventas (
    fecha_hora,
    total,
    cedula,
    id_trabajador,
    id_tipo_pago
) VALUES ( TO_TIMESTAMP('2026-02-02 02:15:00', 'YYYY-MM-DD HH24:MI:SS'),
           9000.00,
           '710062006',
           7,
           2 );

INSERT INTO ventas (
    fecha_hora,
    total,
    cedula,
    id_trabajador,
    id_tipo_pago
) VALUES ( TO_TIMESTAMP('2026-02-02 05:15:00', 'YYYY-MM-DD HH24:MI:SS'),
           9500.00,
           '110072007',
           10,
           1 );

INSERT INTO ventas (
    fecha_hora,
    total,
    cedula,
    id_trabajador,
    id_tipo_pago
) VALUES ( TO_TIMESTAMP('2026-02-02 08:15:00', 'YYYY-MM-DD HH24:MI:SS'),
           10000.00,
           '210082008',
           8,
           1 );

INSERT INTO ventas (
    fecha_hora,
    total,
    cedula,
    id_trabajador,
    id_tipo_pago
) VALUES ( TO_TIMESTAMP('2026-02-02 11:15:00', 'YYYY-MM-DD HH24:MI:SS'),
           10500.00,
           '310092009',
           9,
           2 );

INSERT INTO ventas (
    fecha_hora,
    total,
    cedula,
    id_trabajador,
    id_tipo_pago
) VALUES ( TO_TIMESTAMP('2026-02-02 14:15:00', 'YYYY-MM-DD HH24:MI:SS'),
           11000.00,
           '410102010',
           11,
           1 );

INSERT INTO ventas (
    fecha_hora,
    total,
    cedula,
    id_trabajador,
    id_tipo_pago
) VALUES ( TO_TIMESTAMP('2026-02-02 17:15:00', 'YYYY-MM-DD HH24:MI:SS'),
           11500.00,
           '510112011',
           8,
           1 );

INSERT INTO ventas (
    fecha_hora,
    total,
    cedula,
    id_trabajador,
    id_tipo_pago
) VALUES ( TO_TIMESTAMP('2026-02-02 20:15:00', 'YYYY-MM-DD HH24:MI:SS'),
           6000.00,
           '610122012',
           12,
           2 );

INSERT INTO ventas (
    fecha_hora,
    total,
    cedula,
    id_trabajador,
    id_tipo_pago
) VALUES ( TO_TIMESTAMP('2026-02-02 23:15:00', 'YYYY-MM-DD HH24:MI:SS'),
           6500.00,
           '710132013',
           13,
           1 );

INSERT INTO ventas (
    fecha_hora,
    total,
    cedula,
    id_trabajador,
    id_tipo_pago
) VALUES ( TO_TIMESTAMP('2026-02-03 02:15:00', 'YYYY-MM-DD HH24:MI:SS'),
           7000.00,
           '110142014',
           14,
           1 );

INSERT INTO ventas (
    fecha_hora,
    total,
    cedula,
    id_trabajador,
    id_tipo_pago
) VALUES ( TO_TIMESTAMP('2026-02-03 05:15:00', 'YYYY-MM-DD HH24:MI:SS'),
           7500.00,
           '210152015',
           15,
           2 );

INSERT INTO ventas (
    fecha_hora,
    total,
    cedula,
    id_trabajador,
    id_tipo_pago
) VALUES ( TO_TIMESTAMP('2026-02-03 08:15:00', 'YYYY-MM-DD HH24:MI:SS'),
           8000.00,
           '310162016',
           16,
           1 );

INSERT INTO ventas (
    fecha_hora,
    total,
    cedula,
    id_trabajador,
    id_tipo_pago
) VALUES ( TO_TIMESTAMP('2026-02-03 11:15:00', 'YYYY-MM-DD HH24:MI:SS'),
           8500.00,
           '410172017',
           17,
           1 );

INSERT INTO ventas (
    fecha_hora,
    total,
    cedula,
    id_trabajador,
    id_tipo_pago
) VALUES ( TO_TIMESTAMP('2026-02-03 14:15:00', 'YYYY-MM-DD HH24:MI:SS'),
           9000.00,
           '510182018',
           18,
           2 );

INSERT INTO ventas (
    fecha_hora,
    total,
    cedula,
    id_trabajador,
    id_tipo_pago
) VALUES ( TO_TIMESTAMP('2026-02-03 17:15:00', 'YYYY-MM-DD HH24:MI:SS'),
           9500.00,
           '610192019',
           20,
           1 );

INSERT INTO ventas (
    fecha_hora,
    total,
    cedula,
    id_trabajador,
    id_tipo_pago
) VALUES ( TO_TIMESTAMP('2026-02-03 20:15:00', 'YYYY-MM-DD HH24:MI:SS'),
           10000.00,
           '710202020',
           12,
           1 );

INSERT INTO ventas (
    fecha_hora,
    total,
    cedula,
    id_trabajador,
    id_tipo_pago
) VALUES ( TO_TIMESTAMP('2026-02-03 23:15:00', 'YYYY-MM-DD HH24:MI:SS'),
           10500.00,
           '110212021',
           13,
           2 );

INSERT INTO ventas (
    fecha_hora,
    total,
    cedula,
    id_trabajador,
    id_tipo_pago
) VALUES ( TO_TIMESTAMP('2026-02-04 02:15:00', 'YYYY-MM-DD HH24:MI:SS'),
           11000.00,
           '210222022',
           21,
           1 );

INSERT INTO ventas (
    fecha_hora,
    total,
    cedula,
    id_trabajador,
    id_tipo_pago
) VALUES ( TO_TIMESTAMP('2026-02-04 05:15:00', 'YYYY-MM-DD HH24:MI:SS'),
           11500.00,
           '310232023',
           15,
           1 );

INSERT INTO ventas (
    fecha_hora,
    total,
    cedula,
    id_trabajador,
    id_tipo_pago
) VALUES ( TO_TIMESTAMP('2026-02-04 08:15:00', 'YYYY-MM-DD HH24:MI:SS'),
           6000.00,
           '410242024',
           16,
           2 );

INSERT INTO ventas (
    fecha_hora,
    total,
    cedula,
    id_trabajador,
    id_tipo_pago
) VALUES ( TO_TIMESTAMP('2026-02-04 11:15:00', 'YYYY-MM-DD HH24:MI:SS'),
           6500.00,
           '510252025',
           17,
           1 );

INSERT INTO ventas (
    fecha_hora,
    total,
    cedula,
    id_trabajador,
    id_tipo_pago
) VALUES ( TO_TIMESTAMP('2026-02-04 14:15:00', 'YYYY-MM-DD HH24:MI:SS'),
           7000.00,
           '610262026',
           18,
           1 );

INSERT INTO ventas (
    fecha_hora,
    total,
    cedula,
    id_trabajador,
    id_tipo_pago
) VALUES ( TO_TIMESTAMP('2026-02-04 17:15:00', 'YYYY-MM-DD HH24:MI:SS'),
           7500.00,
           '710272027',
           19,
           2 );

INSERT INTO ventas (
    fecha_hora,
    total,
    cedula,
    id_trabajador,
    id_tipo_pago
) VALUES ( TO_TIMESTAMP('2026-02-04 20:15:00', 'YYYY-MM-DD HH24:MI:SS'),
           8000.00,
           '110282028',
           20,
           1 );

INSERT INTO ventas (
    fecha_hora,
    total,
    cedula,
    id_trabajador,
    id_tipo_pago
) VALUES ( TO_TIMESTAMP('2026-02-04 23:15:00', 'YYYY-MM-DD HH24:MI:SS'),
           8500.00,
           '210292029',
           21,
           1 );

INSERT INTO ventas (
    fecha_hora,
    total,
    cedula,
    id_trabajador,
    id_tipo_pago
) VALUES ( TO_TIMESTAMP('2026-02-05 02:15:00', 'YYYY-MM-DD HH24:MI:SS'),
           9000.00,
           '310302030',
           22,
           2 );

INSERT INTO ventas (
    fecha_hora,
    total,
    cedula,
    id_trabajador,
    id_tipo_pago
) VALUES ( TO_TIMESTAMP('2026-02-05 05:15:00', 'YYYY-MM-DD HH24:MI:SS'),
           9500.00,
           '410312031',
           23,
           1 );

INSERT INTO ventas (
    fecha_hora,
    total,
    cedula,
    id_trabajador,
    id_tipo_pago
) VALUES ( TO_TIMESTAMP('2026-02-05 08:15:00', 'YYYY-MM-DD HH24:MI:SS'),
           10000.00,
           '510322032',
           24,
           1 );

INSERT INTO ventas (
    fecha_hora,
    total,
    cedula,
    id_trabajador,
    id_tipo_pago
) VALUES ( TO_TIMESTAMP('2026-02-05 11:15:00', 'YYYY-MM-DD HH24:MI:SS'),
           10500.00,
           '610332033',
           26,
           2 );

INSERT INTO ventas (
    fecha_hora,
    total,
    cedula,
    id_trabajador,
    id_tipo_pago
) VALUES ( TO_TIMESTAMP('2026-02-05 14:15:00', 'YYYY-MM-DD HH24:MI:SS'),
           11000.00,
           '710342034',
           27,
           1 );

INSERT INTO ventas (
    fecha_hora,
    total,
    cedula,
    id_trabajador,
    id_tipo_pago
) VALUES ( TO_TIMESTAMP('2026-02-05 17:15:00', 'YYYY-MM-DD HH24:MI:SS'),
           11500.00,
           '110352035',
           28,
           1 );

INSERT INTO ventas (
    fecha_hora,
    total,
    cedula,
    id_trabajador,
    id_tipo_pago
) VALUES ( TO_TIMESTAMP('2026-02-05 20:15:00', 'YYYY-MM-DD HH24:MI:SS'),
           6000.00,
           '210362036',
           29,
           2 );

INSERT INTO ventas (
    fecha_hora,
    total,
    cedula,
    id_trabajador,
    id_tipo_pago
) VALUES ( TO_TIMESTAMP('2026-02-05 23:15:00', 'YYYY-MM-DD HH24:MI:SS'),
           6500.00,
           '310372037',
           30,
           1 );

INSERT INTO ventas (
    fecha_hora,
    total,
    cedula,
    id_trabajador,
    id_tipo_pago
) VALUES ( TO_TIMESTAMP('2026-02-06 02:15:00', 'YYYY-MM-DD HH24:MI:SS'),
           7000.00,
           '410382038',
           31,
           1 );

INSERT INTO ventas (
    fecha_hora,
    total,
    cedula,
    id_trabajador,
    id_tipo_pago
) VALUES ( TO_TIMESTAMP('2026-02-06 05:15:00', 'YYYY-MM-DD HH24:MI:SS'),
           7500.00,
           '510392039',
           32,
           2 );

INSERT INTO ventas (
    fecha_hora,
    total,
    cedula,
    id_trabajador,
    id_tipo_pago
) VALUES ( TO_TIMESTAMP('2026-02-06 08:15:00', 'YYYY-MM-DD HH24:MI:SS'),
           8000.00,
           '610402040',
           33,
           1 );

INSERT INTO ventas (
    fecha_hora,
    total,
    cedula,
    id_trabajador,
    id_tipo_pago
) VALUES ( TO_TIMESTAMP('2026-02-06 11:15:00', 'YYYY-MM-DD HH24:MI:SS'),
           8500.00,
           '710412041',
           34,
           1 );

INSERT INTO ventas (
    fecha_hora,
    total,
    cedula,
    id_trabajador,
    id_tipo_pago
) VALUES ( TO_TIMESTAMP('2026-02-06 14:15:00', 'YYYY-MM-DD HH24:MI:SS'),
           9000.00,
           '110422042',
           35,
           2 );

INSERT INTO ventas (
    fecha_hora,
    total,
    cedula,
    id_trabajador,
    id_tipo_pago
) VALUES ( TO_TIMESTAMP('2026-02-06 17:15:00', 'YYYY-MM-DD HH24:MI:SS'),
           9500.00,
           '210432043',
           37,
           1 );

INSERT INTO ventas (
    fecha_hora,
    total,
    cedula,
    id_trabajador,
    id_tipo_pago
) VALUES ( TO_TIMESTAMP('2026-02-06 20:15:00', 'YYYY-MM-DD HH24:MI:SS'),
           10000.00,
           '310442044',
           36,
           1 );

INSERT INTO ventas (
    fecha_hora,
    total,
    cedula,
    id_trabajador,
    id_tipo_pago
) VALUES ( TO_TIMESTAMP('2026-02-06 23:15:00', 'YYYY-MM-DD HH24:MI:SS'),
           10500.00,
           '410452045',
           39,
           2 );

INSERT INTO ventas (
    fecha_hora,
    total,
    cedula,
    id_trabajador,
    id_tipo_pago
) VALUES ( TO_TIMESTAMP('2026-02-07 02:15:00', 'YYYY-MM-DD HH24:MI:SS'),
           11000.00,
           '510462046',
           40,
           1 );

INSERT INTO ventas (
    fecha_hora,
    total,
    cedula,
    id_trabajador,
    id_tipo_pago
) VALUES ( TO_TIMESTAMP('2026-02-07 05:15:00', 'YYYY-MM-DD HH24:MI:SS'),
           11500.00,
           '610472047',
           41,
           1 );

INSERT INTO ventas (
    fecha_hora,
    total,
    cedula,
    id_trabajador,
    id_tipo_pago
) VALUES ( TO_TIMESTAMP('2026-02-07 08:15:00', 'YYYY-MM-DD HH24:MI:SS'),
           6000.00,
           '710482048',
           42,
           2 );

INSERT INTO ventas (
    fecha_hora,
    total,
    cedula,
    id_trabajador,
    id_tipo_pago
) VALUES ( TO_TIMESTAMP('2026-02-07 11:15:00', 'YYYY-MM-DD HH24:MI:SS'),
           6500.00,
           '110492049',
           43,
           1 );

COMMIT;

SELECT
    *
FROM
    productos;

SELECT
    *
FROM
    ventas;

SELECT
    *
FROM
    productos_ventas;

--PRODUCTOS_VENTAS
INSERT INTO productos_ventas (
    cantidad,
    id_producto,
    id_venta
) VALUES ( 1,
           1,
           4 );

INSERT INTO productos_ventas (
    cantidad,
    id_producto,
    id_venta
) VALUES ( 2,
           2,
           5 );

INSERT INTO productos_ventas (
    cantidad,
    id_producto,
    id_venta
) VALUES ( 1,
           3,
           6 );

INSERT INTO productos_ventas (
    cantidad,
    id_producto,
    id_venta
) VALUES ( 2,
           4,
           7 );

INSERT INTO productos_ventas (
    cantidad,
    id_producto,
    id_venta
) VALUES ( 1,
           5,
           8 );

INSERT INTO productos_ventas (
    cantidad,
    id_producto,
    id_venta
) VALUES ( 2,
           6,
           9 );

INSERT INTO productos_ventas (
    cantidad,
    id_producto,
    id_venta
) VALUES ( 1,
           7,
           10 );

INSERT INTO productos_ventas (
    cantidad,
    id_producto,
    id_venta
) VALUES ( 2,
           8,
           11 );

INSERT INTO productos_ventas (
    cantidad,
    id_producto,
    id_venta
) VALUES ( 1,
           9,
           12 );

INSERT INTO productos_ventas (
    cantidad,
    id_producto,
    id_venta
) VALUES ( 2,
           10,
           13 );

INSERT INTO productos_ventas (
    cantidad,
    id_producto,
    id_venta
) VALUES ( 1,
           11,
           14 );

INSERT INTO productos_ventas (
    cantidad,
    id_producto,
    id_venta
) VALUES ( 2,
           12,
           15 );

INSERT INTO productos_ventas (
    cantidad,
    id_producto,
    id_venta
) VALUES ( 1,
           13,
           16 );

INSERT INTO productos_ventas (
    cantidad,
    id_producto,
    id_venta
) VALUES ( 2,
           14,
           17 );

INSERT INTO productos_ventas (
    cantidad,
    id_producto,
    id_venta
) VALUES ( 1,
           15,
           18 );

INSERT INTO productos_ventas (
    cantidad,
    id_producto,
    id_venta
) VALUES ( 2,
           16,
           19 );

INSERT INTO productos_ventas (
    cantidad,
    id_producto,
    id_venta
) VALUES ( 1,
           21,
           20 );

INSERT INTO productos_ventas (
    cantidad,
    id_producto,
    id_venta
) VALUES ( 2,
           22,
           21 );

INSERT INTO productos_ventas (
    cantidad,
    id_producto,
    id_venta
) VALUES ( 1,
           23,
           22 );

INSERT INTO productos_ventas (
    cantidad,
    id_producto,
    id_venta
) VALUES ( 2,
           24,
           23 );

INSERT INTO productos_ventas (
    cantidad,
    id_producto,
    id_venta
) VALUES ( 1,
           25,
           24 );

INSERT INTO productos_ventas (
    cantidad,
    id_producto,
    id_venta
) VALUES ( 2,
           26,
           25 );

INSERT INTO productos_ventas (
    cantidad,
    id_producto,
    id_venta
) VALUES ( 1,
           27,
           26 );

INSERT INTO productos_ventas (
    cantidad,
    id_producto,
    id_venta
) VALUES ( 2,
           28,
           27 );

INSERT INTO productos_ventas (
    cantidad,
    id_producto,
    id_venta
) VALUES ( 1,
           29,
           28 );

INSERT INTO productos_ventas (
    cantidad,
    id_producto,
    id_venta
) VALUES ( 2,
           31,
           29 );

INSERT INTO productos_ventas (
    cantidad,
    id_producto,
    id_venta
) VALUES ( 1,
           34,
           30 );

INSERT INTO productos_ventas (
    cantidad,
    id_producto,
    id_venta
) VALUES ( 2,
           35,
           31 );

INSERT INTO productos_ventas (
    cantidad,
    id_producto,
    id_venta
) VALUES ( 1,
           36,
           32 );

INSERT INTO productos_ventas (
    cantidad,
    id_producto,
    id_venta
) VALUES ( 2,
           37,
           33 );

INSERT INTO productos_ventas (
    cantidad,
    id_producto,
    id_venta
) VALUES ( 1,
           38,
           34 );

INSERT INTO productos_ventas (
    cantidad,
    id_producto,
    id_venta
) VALUES ( 2,
           39,
           35 );

INSERT INTO productos_ventas (
    cantidad,
    id_producto,
    id_venta
) VALUES ( 1,
           40,
           36 );

INSERT INTO productos_ventas (
    cantidad,
    id_producto,
    id_venta
) VALUES ( 2,
           41,
           37 );

INSERT INTO productos_ventas (
    cantidad,
    id_producto,
    id_venta
) VALUES ( 1,
           42,
           38 );

INSERT INTO productos_ventas (
    cantidad,
    id_producto,
    id_venta
) VALUES ( 2,
           43,
           39 );

INSERT INTO productos_ventas (
    cantidad,
    id_producto,
    id_venta
) VALUES ( 1,
           44,
           40 );

INSERT INTO productos_ventas (
    cantidad,
    id_producto,
    id_venta
) VALUES ( 2,
           45,
           41 );

INSERT INTO productos_ventas (
    cantidad,
    id_producto,
    id_venta
) VALUES ( 1,
           46,
           42 );

INSERT INTO productos_ventas (
    cantidad,
    id_producto,
    id_venta
) VALUES ( 2,
           47,
           43 );

INSERT INTO productos_ventas (
    cantidad,
    id_producto,
    id_venta
) VALUES ( 1,
           48,
           44 );

INSERT INTO productos_ventas (
    cantidad,
    id_producto,
    id_venta
) VALUES ( 2,
           49,
           45 );

INSERT INTO productos_ventas (
    cantidad,
    id_producto,
    id_venta
) VALUES ( 1,
           55,
           46 );

INSERT INTO productos_ventas (
    cantidad,
    id_producto,
    id_venta
) VALUES ( 2,
           56,
           47 );

INSERT INTO productos_ventas (
    cantidad,
    id_producto,
    id_venta
) VALUES ( 1,
           57,
           48 );

INSERT INTO productos_ventas (
    cantidad,
    id_producto,
    id_venta
) VALUES ( 2,
           58,
           49 );

INSERT INTO productos_ventas (
    cantidad,
    id_producto,
    id_venta
) VALUES ( 1,
           59,
           50 );

INSERT INTO productos_ventas (
    cantidad,
    id_producto,
    id_venta
) VALUES ( 2,
           61,
           51 );

INSERT INTO productos_ventas (
    cantidad,
    id_producto,
    id_venta
) VALUES ( 1,
           62,
           52 );

INSERT INTO productos_ventas (
    cantidad,
    id_producto,
    id_venta
) VALUES ( 2,
           64,
           53 );

INSERT INTO productos_ventas (
    cantidad,
    id_producto,
    id_venta
) VALUES ( 2,
           55,
           41 );

INSERT INTO productos_ventas (
    cantidad,
    id_producto,
    id_venta
) VALUES ( 1,
           56,
           42 );

INSERT INTO productos_ventas (
    cantidad,
    id_producto,
    id_venta
) VALUES ( 2,
           57,
           43 );

INSERT INTO productos_ventas (
    cantidad,
    id_producto,
    id_venta
) VALUES ( 1,
           58,
           44 );

INSERT INTO productos_ventas (
    cantidad,
    id_producto,
    id_venta
) VALUES ( 2,
           59,
           45 );

COMMIT;

SELECT
    *
FROM
    productos_ventas;

SELECT
    *
FROM
    devolucion;

--DEVOLUCION
INSERT INTO devolucion (
    motivo,
    cantidad_devuelta,
    fecha_hora,
    cedula,
    id_producto,
    id_venta,
    id_tipo_devolucion
) VALUES ( 'No era compatible con el vehículo',
           1,
           TO_TIMESTAMP('2026-03-05 10:00:00', 'YYYY-MM-DD HH24:MI:SS'),
           '110002000',
           1,
           4,
           2 );

INSERT INTO devolucion (
    motivo,
    cantidad_devuelta,
    fecha_hora,
    cedula,
    id_producto,
    id_venta,
    id_tipo_devolucion
) VALUES ( 'Producto defectuoso',
           1,
           TO_TIMESTAMP('2026-03-16 10:00:00', 'YYYY-MM-DD HH24:MI:SS'),
           '510112011',
           12,
           5,
           3 );

INSERT INTO devolucion (
    motivo,
    cantidad_devuelta,
    fecha_hora,
    cedula,
    id_producto,
    id_venta,
    id_tipo_devolucion
) VALUES ( 'Cambio por garantía',
           1,
           TO_TIMESTAMP('2026-03-17 10:00:00', 'YYYY-MM-DD HH24:MI:SS'),
           '610122012',
           13,
           6,
           4 );

INSERT INTO devolucion (
    motivo,
    cantidad_devuelta,
    fecha_hora,
    cedula,
    id_producto,
    id_venta,
    id_tipo_devolucion
) VALUES ( 'Error al comprar',
           1,
           TO_TIMESTAMP('2026-03-18 10:00:00', 'YYYY-MM-DD HH24:MI:SS'),
           '710132013',
           14,
           7,
           1 );

INSERT INTO devolucion (
    motivo,
    cantidad_devuelta,
    fecha_hora,
    cedula,
    id_producto,
    id_venta,
    id_tipo_devolucion
) VALUES ( 'No cumplió expectativas',
           1,
           TO_TIMESTAMP('2026-03-19 10:00:00', 'YYYY-MM-DD HH24:MI:SS'),
           '110142014',
           15,
           8,
           2 );

INSERT INTO devolucion (
    motivo,
    cantidad_devuelta,
    fecha_hora,
    cedula,
    id_producto,
    id_venta,
    id_tipo_devolucion
) VALUES ( 'No era compatible con el vehículo',
           1,
           TO_TIMESTAMP('2026-03-20 10:00:00', 'YYYY-MM-DD HH24:MI:SS'),
           '210152015',
           16,
           9,
           2 );

INSERT INTO devolucion (
    motivo,
    cantidad_devuelta,
    fecha_hora,
    cedula,
    id_producto,
    id_venta,
    id_tipo_devolucion
) VALUES ( 'Producto defectuoso',
           1,
           TO_TIMESTAMP('2026-03-21 10:00:00', 'YYYY-MM-DD HH24:MI:SS'),
           '310162016',
           21,
           10,
           3 );

INSERT INTO devolucion (
    motivo,
    cantidad_devuelta,
    fecha_hora,
    cedula,
    id_producto,
    id_venta,
    id_tipo_devolucion
) VALUES ( 'Cambio por garantía',
           1,
           TO_TIMESTAMP('2026-03-22 10:00:00', 'YYYY-MM-DD HH24:MI:SS'),
           '410172017',
           22,
           11,
           4 );

INSERT INTO devolucion (
    motivo,
    cantidad_devuelta,
    fecha_hora,
    cedula,
    id_producto,
    id_venta,
    id_tipo_devolucion
) VALUES ( 'Error al comprar',
           1,
           TO_TIMESTAMP('2026-03-23 10:00:00', 'YYYY-MM-DD HH24:MI:SS'),
           '510182018',
           23,
           12,
           1 );

INSERT INTO devolucion (
    motivo,
    cantidad_devuelta,
    fecha_hora,
    cedula,
    id_producto,
    id_venta,
    id_tipo_devolucion
) VALUES ( 'No cumplió expectativas',
           1,
           TO_TIMESTAMP('2026-03-24 10:00:00', 'YYYY-MM-DD HH24:MI:SS'),
           '610192019',
           24,
           13,
           2 );

INSERT INTO devolucion (
    motivo,
    cantidad_devuelta,
    fecha_hora,
    cedula,
    id_producto,
    id_venta,
    id_tipo_devolucion
) VALUES ( 'No era compatible con el vehículo',
           1,
           TO_TIMESTAMP('2026-03-25 10:00:00', 'YYYY-MM-DD HH24:MI:SS'),
           '710202020',
           25,
           14,
           2 );

INSERT INTO devolucion (
    motivo,
    cantidad_devuelta,
    fecha_hora,
    cedula,
    id_producto,
    id_venta,
    id_tipo_devolucion
) VALUES ( 'Producto defectuoso',
           1,
           TO_TIMESTAMP('2026-03-26 10:00:00', 'YYYY-MM-DD HH24:MI:SS'),
           '110212021',
           26,
           15,
           3 );

INSERT INTO devolucion (
    motivo,
    cantidad_devuelta,
    fecha_hora,
    cedula,
    id_producto,
    id_venta,
    id_tipo_devolucion
) VALUES ( 'Cambio por garantía',
           1,
           TO_TIMESTAMP('2026-03-27 10:00:00', 'YYYY-MM-DD HH24:MI:SS'),
           '210222022',
           27,
           16,
           4 );

INSERT INTO devolucion (
    motivo,
    cantidad_devuelta,
    fecha_hora,
    cedula,
    id_producto,
    id_venta,
    id_tipo_devolucion
) VALUES ( 'Error al comprar',
           1,
           TO_TIMESTAMP('2026-03-28 10:00:00', 'YYYY-MM-DD HH24:MI:SS'),
           '310232023',
           28,
           17,
           1 );

INSERT INTO devolucion (
    motivo,
    cantidad_devuelta,
    fecha_hora,
    cedula,
    id_producto,
    id_venta,
    id_tipo_devolucion
) VALUES ( 'No cumplió expectativas',
           1,
           TO_TIMESTAMP('2026-03-29 10:00:00', 'YYYY-MM-DD HH24:MI:SS'),
           '410242024',
           29,
           18,
           2 );

INSERT INTO devolucion (
    motivo,
    cantidad_devuelta,
    fecha_hora,
    cedula,
    id_producto,
    id_venta,
    id_tipo_devolucion
) VALUES ( 'No era compatible con el vehículo',
           1,
           TO_TIMESTAMP('2026-03-30 10:00:00', 'YYYY-MM-DD HH24:MI:SS'),
           '510252025',
           31,
           19,
           2 );

INSERT INTO devolucion (
    motivo,
    cantidad_devuelta,
    fecha_hora,
    cedula,
    id_producto,
    id_venta,
    id_tipo_devolucion
) VALUES ( 'Producto defectuoso',
           1,
           TO_TIMESTAMP('2026-03-31 10:00:00', 'YYYY-MM-DD HH24:MI:SS'),
           '610262026',
           34,
           20,
           3 );

INSERT INTO devolucion (
    motivo,
    cantidad_devuelta,
    fecha_hora,
    cedula,
    id_producto,
    id_venta,
    id_tipo_devolucion
) VALUES ( 'Cambio por garantía',
           1,
           TO_TIMESTAMP('2026-04-01 10:00:00', 'YYYY-MM-DD HH24:MI:SS'),
           '710272027',
           35,
           21,
           4 );

INSERT INTO devolucion (
    motivo,
    cantidad_devuelta,
    fecha_hora,
    cedula,
    id_producto,
    id_venta,
    id_tipo_devolucion
) VALUES ( 'Error al comprar',
           1,
           TO_TIMESTAMP('2026-04-02 10:00:00', 'YYYY-MM-DD HH24:MI:SS'),
           '110282028',
           36,
           22,
           1 );

INSERT INTO devolucion (
    motivo,
    cantidad_devuelta,
    fecha_hora,
    cedula,
    id_producto,
    id_venta,
    id_tipo_devolucion
) VALUES ( 'No cumplió expectativas',
           1,
           TO_TIMESTAMP('2026-04-03 10:00:00', 'YYYY-MM-DD HH24:MI:SS'),
           '210292029',
           37,
           23,
           2 );

INSERT INTO devolucion (
    motivo,
    cantidad_devuelta,
    fecha_hora,
    cedula,
    id_producto,
    id_venta,
    id_tipo_devolucion
) VALUES ( 'No era compatible con el vehículo',
           1,
           TO_TIMESTAMP('2026-04-04 10:00:00', 'YYYY-MM-DD HH24:MI:SS'),
           '310302030',
           38,
           24,
           2 );

INSERT INTO devolucion (
    motivo,
    cantidad_devuelta,
    fecha_hora,
    cedula,
    id_producto,
    id_venta,
    id_tipo_devolucion
) VALUES ( 'Producto defectuoso',
           1,
           TO_TIMESTAMP('2026-04-05 10:00:00', 'YYYY-MM-DD HH24:MI:SS'),
           '410312031',
           39,
           25,
           3 );

INSERT INTO devolucion (
    motivo,
    cantidad_devuelta,
    fecha_hora,
    cedula,
    id_producto,
    id_venta,
    id_tipo_devolucion
) VALUES ( 'Cambio por garantía',
           1,
           TO_TIMESTAMP('2026-04-06 10:00:00', 'YYYY-MM-DD HH24:MI:SS'),
           '510322032',
           40,
           26,
           4 );

INSERT INTO devolucion (
    motivo,
    cantidad_devuelta,
    fecha_hora,
    cedula,
    id_producto,
    id_venta,
    id_tipo_devolucion
) VALUES ( 'Error al comprar',
           1,
           TO_TIMESTAMP('2026-04-07 10:00:00', 'YYYY-MM-DD HH24:MI:SS'),
           '610332033',
           41,
           27,
           1 );

INSERT INTO devolucion (
    motivo,
    cantidad_devuelta,
    fecha_hora,
    cedula,
    id_producto,
    id_venta,
    id_tipo_devolucion
) VALUES ( 'No cumplió expectativas',
           1,
           TO_TIMESTAMP('2026-04-08 10:00:00', 'YYYY-MM-DD HH24:MI:SS'),
           '710342034',
           42,
           28,
           2 );

INSERT INTO devolucion (
    motivo,
    cantidad_devuelta,
    fecha_hora,
    cedula,
    id_producto,
    id_venta,
    id_tipo_devolucion
) VALUES ( 'No era compatible con el vehículo',
           1,
           TO_TIMESTAMP('2026-04-09 10:00:00', 'YYYY-MM-DD HH24:MI:SS'),
           '110352035',
           43,
           29,
           2 );

INSERT INTO devolucion (
    motivo,
    cantidad_devuelta,
    fecha_hora,
    cedula,
    id_producto,
    id_venta,
    id_tipo_devolucion
) VALUES ( 'Producto defectuoso',
           1,
           TO_TIMESTAMP('2026-04-10 10:00:00', 'YYYY-MM-DD HH24:MI:SS'),
           '210362036',
           44,
           30,
           3 );

INSERT INTO devolucion (
    motivo,
    cantidad_devuelta,
    fecha_hora,
    cedula,
    id_producto,
    id_venta,
    id_tipo_devolucion
) VALUES ( 'Cambio por garantía',
           1,
           TO_TIMESTAMP('2026-04-11 10:00:00', 'YYYY-MM-DD HH24:MI:SS'),
           '310372037',
           55,
           31,
           4 );

INSERT INTO devolucion (
    motivo,
    cantidad_devuelta,
    fecha_hora,
    cedula,
    id_producto,
    id_venta,
    id_tipo_devolucion
) VALUES ( 'Error al comprar',
           1,
           TO_TIMESTAMP('2026-04-12 10:00:00', 'YYYY-MM-DD HH24:MI:SS'),
           '410382038',
           56,
           32,
           1 );

INSERT INTO devolucion (
    motivo,
    cantidad_devuelta,
    fecha_hora,
    cedula,
    id_producto,
    id_venta,
    id_tipo_devolucion
) VALUES ( 'No cumplió expectativas',
           1,
           TO_TIMESTAMP('2026-04-13 10:00:00', 'YYYY-MM-DD HH24:MI:SS'),
           '510392039',
           57,
           33,
           2 );

INSERT INTO devolucion (
    motivo,
    cantidad_devuelta,
    fecha_hora,
    cedula,
    id_producto,
    id_venta,
    id_tipo_devolucion
) VALUES ( 'No era compatible con el vehículo',
           1,
           TO_TIMESTAMP('2026-04-14 10:00:00', 'YYYY-MM-DD HH24:MI:SS'),
           '610402040',
           58,
           34,
           2 );

INSERT INTO devolucion (
    motivo,
    cantidad_devuelta,
    fecha_hora,
    cedula,
    id_producto,
    id_venta,
    id_tipo_devolucion
) VALUES ( 'Producto defectuoso',
           1,
           TO_TIMESTAMP('2026-04-15 10:00:00', 'YYYY-MM-DD HH24:MI:SS'),
           '710412041',
           59,
           35,
           3 );

INSERT INTO devolucion (
    motivo,
    cantidad_devuelta,
    fecha_hora,
    cedula,
    id_producto,
    id_venta,
    id_tipo_devolucion
) VALUES ( 'Cambio por garantía',
           1,
           TO_TIMESTAMP('2026-04-16 10:00:00', 'YYYY-MM-DD HH24:MI:SS'),
           '110422042',
           55,
           36,
           4 );

INSERT INTO devolucion (
    motivo,
    cantidad_devuelta,
    fecha_hora,
    cedula,
    id_producto,
    id_venta,
    id_tipo_devolucion
) VALUES ( 'Error al comprar',
           1,
           TO_TIMESTAMP('2026-04-17 10:00:00', 'YYYY-MM-DD HH24:MI:SS'),
           '21043-043',
           56,
           37,
           1 );

INSERT INTO devolucion (
    motivo,
    cantidad_devuelta,
    fecha_hora,
    cedula,
    id_producto,
    id_venta,
    id_tipo_devolucion
) VALUES ( 'No cumplió expectativas',
           1,
           TO_TIMESTAMP('2026-04-18 10:00:00', 'YYYY-MM-DD HH24:MI:SS'),
           '310442044',
           57,
           38,
           2 );

INSERT INTO devolucion (
    motivo,
    cantidad_devuelta,
    fecha_hora,
    cedula,
    id_producto,
    id_venta,
    id_tipo_devolucion
) VALUES ( 'No era compatible con el vehículo',
           1,
           TO_TIMESTAMP('2026-04-19 10:00:00', 'YYYY-MM-DD HH24:MI:SS'),
           '410452045',
           58,
           39,
           2 );

INSERT INTO devolucion (
    motivo,
    cantidad_devuelta,
    fecha_hora,
    cedula,
    id_producto,
    id_venta,
    id_tipo_devolucion
) VALUES ( 'Producto defectuoso',
           1,
           TO_TIMESTAMP('2026-04-20 10:00:00', 'YYYY-MM-DD HH24:MI:SS'),
           '510462046',
           59,
           40,
           3 );

INSERT INTO devolucion (
    motivo,
    cantidad_devuelta,
    fecha_hora,
    cedula,
    id_producto,
    id_venta,
    id_tipo_devolucion
) VALUES ( 'Cambio por garantía',
           1,
           TO_TIMESTAMP('2026-04-21 10:00:00', 'YYYY-MM-DD HH24:MI:SS'),
           '610472047',
           61,
           41,
           4 );

INSERT INTO devolucion (
    motivo,
    cantidad_devuelta,
    fecha_hora,
    cedula,
    id_producto,
    id_venta,
    id_tipo_devolucion
) VALUES ( 'Error al comprar',
           1,
           TO_TIMESTAMP('2026-04-22 10:00:00', 'YYYY-MM-DD HH24:MI:SS'),
           '710482048',
           62,
           42,
           1 );

INSERT INTO devolucion (
    motivo,
    cantidad_devuelta,
    fecha_hora,
    cedula,
    id_producto,
    id_venta,
    id_tipo_devolucion
) VALUES ( 'No cumplió expectativas',
           1,
           TO_TIMESTAMP('2026-04-23 10:00:00', 'YYYY-MM-DD HH24:MI:SS'),
           '110492049',
           64,
           43,
           2 );

COMMIT;


----------------------------------------------------------------------------------------------------------------------------------------------------

----------------------RF-01 El sistema deberá permitir registrar clientes con sus datos personales y de contacto.---------------------------

/*--------------------
Paquete clientes
*/---------------------
CREATE OR REPLACE PACKAGE PK_CLIENTES AS

PROCEDURE registrar_cliente (
    p_cedula    IN clientes.cedula%TYPE,
    p_nombre    IN clientes.nombre%TYPE,
    p_apellido1 IN clientes.apellido1%TYPE,
    p_apellido2 IN clientes.apellido2%TYPE,
    p_correo    IN clientes.correo_electr%TYPE,
    p_telefono  IN clientes.telefono%TYPE
     
);

PROCEDURE consultar_clientes (
    p_resultado OUT SYS_REFCURSOR
);

PROCEDURE editar_correo_telefono_cliente (
    p_cedula   IN clientes.cedula%TYPE,
    p_correo   IN clientes.correo_electr%TYPE,
    p_telefono IN clientes.telefono%TYPE
);

PROCEDURE eliminar_cliente (
    p_cedula IN clientes.cedula%TYPE
);

FUNCTION existe_cliente (
    p_cedula IN clientes.cedula%TYPE
) RETURN NUMBER;

PROCEDURE mostrar_vw_clientes_compras (
    p_resultado OUT SYS_REFCURSOR
);

END PK_CLIENTES;

/*--------------------
Cuerpo de paquete clientes
*/---------------------

CREATE OR REPLACE PACKAGE BODY PK_CLIENTES AS

--Procedimiento para registrar clientes 

 PROCEDURE registrar_cliente (
    p_cedula    IN clientes.cedula%TYPE,
    p_nombre    IN clientes.nombre%TYPE,
    p_apellido1 IN clientes.apellido1%TYPE,
    p_apellido2 IN clientes.apellido2%TYPE,
    p_correo    IN clientes.correo_electr%TYPE,
    p_telefono  IN clientes.telefono%TYPE
) IS

    v_cedula          clientes.cedula%TYPE;
    v_correo          clientes.correo_electr%TYPE;
    v_telefono        clientes.telefono%TYPE;
    v_posicion_arroba NUMBER;
    v_posicion_punto  NUMBER;
    v_cantidad        NUMBER;
BEGIN
    v_cedula := trim(p_cedula);
    v_correo := lower(trim(p_correo));
    v_telefono := trim(p_telefono);
    IF v_cedula IS NULL
       OR TRIM(p_nombre) IS NULL
    OR TRIM(p_apellido1) IS NULL
    OR v_correo IS NULL
    OR v_telefono IS NULL THEN
        raise_application_error(-20001, 'Debe indicar todos los datos obligatorios del cliente.');
    END IF;

    IF NOT regexp_like(v_cedula, '^[0-9]+$') THEN
        raise_application_error(-20002, 'La cédula solamente debe contener números.');
    END IF;

    IF length(v_cedula) < 9 THEN
        raise_application_error(-20003, 'La cédula debe contener al menos 9 dígitos.');
    END IF;

    v_posicion_arroba := instr(v_correo, '@');
    v_posicion_punto := instr(v_correo, '.', v_posicion_arroba + 2);
    IF v_posicion_arroba <= 1
    OR v_posicion_punto = 0
    OR v_posicion_punto >= length(v_correo) THEN
        raise_application_error(-20004, 'El correo electrónico no tiene un formato válido.');
    END IF;

    IF NOT regexp_like(v_telefono, '^[0-9]+$') THEN
        raise_application_error(-20005, 'El teléfono solamente debe contener números.');
    END IF;

    IF length(v_telefono) < 8 THEN
        raise_application_error(-20006, 'El teléfono debe contener al menos 8 dígitos.');
    END IF;

    SELECT
        COUNT(*)
    INTO v_cantidad
    FROM
        clientes
    WHERE
        TRIM(cedula) = v_cedula;

    IF v_cantidad > 0 THEN
        raise_application_error(-20007, 'Ya existe un cliente registrado con esa cédula.');
    END IF;
    SELECT
        COUNT(*)
    INTO v_cantidad
    FROM
        clientes
    WHERE
        lower(trim(correo_electr)) = v_correo;

    IF v_cantidad > 0 THEN
        raise_application_error(-20008, 'Ya existe un cliente registrado con ese correo electrónico.');
    END IF;
    SELECT
        COUNT(*)
    INTO v_cantidad
    FROM
        clientes
    WHERE
        TRIM(telefono) = v_telefono;

    IF v_cantidad > 0 THEN
        raise_application_error(-20009, 'Ya existe un cliente registrado con ese teléfono.');
    END IF;
    INSERT INTO clientes (
        cedula,
        nombre,
        apellido1,
        apellido2,
        correo_electr,
        telefono
    ) VALUES ( v_cedula,
               initcap(trim(p_nombre)),
               initcap(trim(p_apellido1)),
               initcap(trim(p_apellido2)),
               v_correo,
               v_telefono );

    dbms_output.put_line('Cliente registrado correctamente.');
EXCEPTION
    WHEN dup_val_on_index THEN
        raise_application_error(-20010, 'La cédula, el correo o el teléfono ya se encuentra registrado.');
    WHEN OTHERS THEN
        IF sqlcode BETWEEN - 20999 AND - 20000 THEN
            RAISE;
        ELSE
            dbms_output.put_line('Código: ' || sqlcode);
            dbms_output.put_line('Mensaje: ' || sqlerrm);
            raise_application_error(-20011, 'No se logró registrar el cliente.');
        END IF;
END registrar_cliente;


 --Procedimiento para consultar los datos de los clientes

  PROCEDURE consultar_clientes (
    p_resultado OUT SYS_REFCURSOR
 ) IS
 BEGIN
 OPEN p_resultado FOR SELECT
 cedula,
 nombre,
 apellido1,
 apellido2,
 correo_electr,
 telefono
 FROM
 clientes
 ORDER BY
 nombre;

  END;

--Procedimiento para editar correo y telefono de los clientes

 PROCEDURE editar_correo_telefono_cliente (
    p_cedula   IN clientes.cedula%TYPE,
    p_correo   IN clientes.correo_electr%TYPE,
    p_telefono IN clientes.telefono%TYPE
) IS
    v_existe   NUMBER;
    v_correo   clientes.correo_electr%TYPE;
    v_telefono clientes.telefono%TYPE;
BEGIN
    v_correo := lower(trim(p_correo));
    v_telefono := trim(p_telefono);
    IF TRIM(p_cedula) IS NULL THEN
        raise_application_error(-20020, 'Debe indicar la cédula del cliente.');
    END IF;

    IF
        v_correo IS NULL
        AND v_telefono IS NULL
    THEN
        raise_application_error(-20021, 'Debe indicar al menos el correo o el teléfono que desea modificar.');
    END IF;

    SELECT
        COUNT(*)
    INTO v_existe
    FROM
        clientes
    WHERE
        cedula = TRIM(p_cedula);

    IF v_existe = 0 THEN
        raise_application_error(-20022, 'No existe un cliente registrado con esa cédula.');
    END IF;
    IF v_correo IS NOT NULL THEN
        IF NOT regexp_like(v_correo, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$') THEN
            raise_application_error(-20023, 'El correo electrónico no tiene un formato válido.');
        END IF;
    END IF;

    IF v_telefono IS NOT NULL THEN
        IF NOT regexp_like(v_telefono, '^[0-9]+$') THEN
            raise_application_error(-20024, 'El teléfono solamente debe contener números.');
        END IF;

        IF length(v_telefono) < 8 THEN
            raise_application_error(-20025, 'El teléfono debe contener al menos 8 dígitos.');
        END IF;

    END IF;

    UPDATE clientes
    SET
        correo_electr = nvl(v_correo, correo_electr),
        telefono = nvl(v_telefono, telefono)
    WHERE
        cedula = TRIM(p_cedula);

    dbms_output.put_line('Datos actualizados correctamente.');
EXCEPTION
    WHEN dup_val_on_index THEN
        raise_application_error(-20026, 'El correo electrónico o teléfono ya está registrado por otro cliente.');
    WHEN OTHERS THEN
        IF sqlcode BETWEEN - 20999 AND - 20000 THEN
            RAISE;
        ELSE
            dbms_output.put_line('Código: ' || sqlcode);
            dbms_output.put_line('Mensaje: ' || sqlerrm);
            raise_application_error(-20027, 'Error al editar los datos del cliente.');
        END IF;
END editar_correo_telefono_cliente;


--Procedimiento para eliminar un cliente

 PROCEDURE eliminar_cliente (
    p_cedula IN clientes.cedula%TYPE
) IS
    v_existe_cliente    NUMBER;
    v_cant_direcciones  NUMBER;
    v_cant_ventas       NUMBER;
    v_cant_devoluciones NUMBER;
BEGIN
    IF TRIM(p_cedula) IS NULL THEN
        raise_application_error(-20030, 'Debe indicar la cédula del cliente.');
    END IF;

    SELECT
        COUNT(*)
    INTO v_existe_cliente
    FROM
        clientes
    WHERE
        cedula = TRIM(p_cedula);

    IF v_existe_cliente = 0 THEN
        raise_application_error(-20031, 'No existe un cliente registrado con esa cédula.');
    END IF;
    SELECT
        COUNT(*)
    INTO v_cant_direcciones
    FROM
        clientes_direcciones
    WHERE
        cedula = TRIM(p_cedula);

    SELECT
        COUNT(*)
    INTO v_cant_ventas
    FROM
        ventas
    WHERE
        cedula = TRIM(p_cedula);

    SELECT
        COUNT(*)
    INTO v_cant_devoluciones
    FROM
        devolucion
    WHERE
        cedula = TRIM(p_cedula);

    IF v_cant_direcciones > 0
    OR v_cant_ventas > 0
    OR v_cant_devoluciones > 0 THEN
        raise_application_error(-20032, 'No se puede eliminar el cliente porque tiene registros asociados ');
    END IF;

    DELETE FROM clientes
    WHERE
        cedula = TRIM(p_cedula);

    dbms_output.put_line('Cliente eliminado correctamente.');
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode BETWEEN - 20999 AND - 20000 THEN
            RAISE;
        ELSE
            dbms_output.put_line('Código del error: ' || sqlcode);
            dbms_output.put_line('Mensaje del error: ' || sqlerrm);
            raise_application_error(-20033, 'Ocurrió un error al eliminar el cliente.');
        END IF;
END eliminar_cliente;



 FUNCTION existe_cliente (
    p_cedula IN clientes.cedula%TYPE
) RETURN NUMBER IS
    v_cantidad NUMBER;
BEGIN
    SELECT
        COUNT(*)
    INTO v_cantidad
    FROM
        clientes
    WHERE
        cedula = p_cedula;

    RETURN v_cantidad;
END;

--Procedimiento que llama a la vista

 PROCEDURE mostrar_vw_clientes_compras (
    p_resultado OUT SYS_REFCURSOR
) IS
BEGIN
    OPEN p_resultado FOR SELECT
  cedula,
  nombre,
   cantidad_compras,
   total_comprado
   FROM
   vista_clientes_compras
  ORDER BY
  nombre;

END;

 END PK_CLIENTES;

--Vista que permite ver el historial de compras por cliente

CREATE OR REPLACE VIEW vw_vista_clientes_compras AS
    SELECT
        c.cedula,
        c.nombre,
        COUNT(v.id_venta) AS cantidad_compras,
        nvl(
            sum(v.total),
            0
        )                 AS total_comprado
    FROM
        clientes c
        LEFT JOIN ventas   v ON c.cedula = v.cedula
    GROUP BY
        c.cedula,
        c.nombre;
        
    
----------------------RF-02 El sistema deberá permitir registrar proveedores.---------------------------

/*--------------------
Paquete proveedores
*/---------------------

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

 END PK_PROVEEDORES;
 
 
 /*--------------------
Cuerpo de paquete proveedores
*/---------------------
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



---Procedimiento para actualizar informacion del contacto del proveedor
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



--Procedimiento para eliminar proveedor

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


--Procedimiento para ver la informacion de la tabla (select * )

 PROCEDURE consultar_proveedores(
    p_resultado OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN p_resultado FOR
        SELECT
         nombre_proveedor,
        nombre_contacto,
        apellido1,
        apellido2,
        correo_electr,
        telefono,
        estado
        FROM proveedores;

END;


--Funcion para ver cuantos productos suministra el proveedor

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


--Funcion para ver si un proveedor esta innactivo

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



--Procedimiento para poner un proveedor como inactivo

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



--Procedimiento para ejecutar la vista

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

 END PK_PROVEEDORES;


--Vista para ver los productos de los proveedores

CREATE OR REPLACE VIEW vw_productos_proveedores AS
SELECT
    p.id_producto,
    p.nombre AS nombre_producto,
    pr.nombre_proveedor,
    pr.nombre_contacto || ' ' ||
    pr.apellido1 || ' ' ||
    pr.apellido2 AS contacto_proveedor
FROM productos p
JOIN proveedores pr
    ON p.id_proveedor = pr.id_proveedor;


--Trigger para poner el estado del proveedor como activo en caso de que se registre como "null"
CREATE OR REPLACE TRIGGER TRG_ESTADO_PROVEEDOR
BEFORE INSERT
ON PROVEEDORES
FOR EACH ROW
BEGIN
    IF :NEW.ESTADO IS NULL THEN
        :NEW.ESTADO := 'ACTIVO';
    END IF;
END TRG_ESTADO_PROVEEDOR;

--Trigger para impedir eliminar proveedores con productos asociados

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


 -----------------------------------RF-03----------------------------------------
    ----------El sistema deberá permitir registrar productos con sus respectivas categorías.-
/* ----------------------------------------------------------------------------------- */


/* -----------------------------------------------------------------------------------
   PROCEDIMIENTO 1: REGISTRAR UN PRODUCTO
   ----------------------------------------------------------------------------------- */

CREATE OR REPLACE PROCEDURE SP_REGISTRAR_PRODUCTO (
    p_nombre         IN PRODUCTOS.NOMBRE%TYPE,
    p_descripcion    IN PRODUCTOS.DESCRIPCION%TYPE,
    p_precio_venta   IN PRODUCTOS.PRECIO_VENTA%TYPE,
    p_precio_costo   IN PRODUCTOS.PRECIO_COSTO%TYPE,
    p_fecha_entrada  IN PRODUCTOS.FECHA_ULTIMA_ENTRADA%TYPE,
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
        p_fecha_entrada,
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
/



/* -----------------------------------------------------------------------------------
   PROCEDIMIENTO 2: ACTUALIZAR UN PRODUCTO CON NVL
   ----------------------------------------------------------------------------------- */

CREATE OR REPLACE PROCEDURE SP_ACTUALIZAR_PRODUCTO (
    p_id_producto    IN PRODUCTOS.ID_PRODUCTO%TYPE,
    p_nombre         IN PRODUCTOS.NOMBRE%TYPE,
    p_descripcion    IN PRODUCTOS.DESCRIPCION%TYPE,
    p_precio_venta   IN PRODUCTOS.PRECIO_VENTA%TYPE,
    p_precio_costo   IN PRODUCTOS.PRECIO_COSTO%TYPE,
    p_fecha_entrada  IN PRODUCTOS.FECHA_ULTIMA_ENTRADA%TYPE,
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
        FECHA_ULTIMA_ENTRADA = NVL(p_fecha_entrada, FECHA_ULTIMA_ENTRADA),
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


/* -----------------------------------------------------------------------------------
   PROCEDIMIENTO 3: ELIMINAR UN PRODUCTO
   ----------------------------------------------------------------------------------- */

CREATE OR REPLACE PROCEDURE SP_ELIMINAR_PRODUCTO (
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



/* -----------------------------------------------------------------------------------
   PROCEDIMIENTO 4: LISTAR CATEGORIAS
   ----------------------------------------------------------------------------------- */

CREATE OR REPLACE PROCEDURE SP_LISTAR_CATEGORIAS (
    p_cursor OUT SYS_REFCURSOR
)
AS
BEGIN

    OPEN p_cursor FOR

        SELECT
            ID_CATEGORIA,
            NOMBRE
        FROM CATEGORIA
        ORDER BY ID_CATEGORIA;

END SP_LISTAR_CATEGORIAS;
/


 ----------------------------- RF-04---------------------------------------
 ------------El sistema deberá administrar el inventario de productos por sucursal------------


/* -----------------------------------------------------------------------------------
   PROCEDIMIENTO 1: REGISTRAR INVENTARIO
   ----------------------------------------------------------------------------------- */

CREATE OR REPLACE PROCEDURE SP_REGISTRAR_INVENTARIO (
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




/* -----------------------------------------------------------------------------------
   PROCEDIMIENTO 2: ACTUALIZAR INVENTARIO
   ----------------------------------------------------------------------------------- */

CREATE OR REPLACE PROCEDURE SP_ACTUALIZAR_INVENTARIO (
    p_id_producto_sucursal IN PRODUCTOS_SUCURSALES.ID_PRODUCTOS_SUCURSALES%TYPE,
    p_cantidad             IN PRODUCTOS_SUCURSALES.CANTIDAD%TYPE,
    p_id_sucursal          IN PRODUCTOS_SUCURSALES.ID_SUCURSAL%TYPE,
    p_id_producto          IN PRODUCTOS_SUCURSALES.ID_PRODUCTO%TYPE
)
AS
BEGIN

    UPDATE PRODUCTOS_SUCURSALES
    SET
        CANTIDAD = NVL(p_cantidad, CANTIDAD),

        ID_SUCURSAL =
            NVL(p_id_sucursal, ID_SUCURSAL),

        ID_PRODUCTO =
            NVL(p_id_producto, ID_PRODUCTO)

    WHERE ID_PRODUCTOS_SUCURSALES =
          p_id_producto_sucursal;

    IF SQL%ROWCOUNT > 0 THEN

        COMMIT;

        DBMS_OUTPUT.PUT_LINE(
            'Inventario actualizado correctamente.'
        );

    ELSE

        DBMS_OUTPUT.PUT_LINE(
            'No existe el inventario indicado.'
        );

    END IF;

EXCEPTION
    WHEN OTHERS THEN

        ROLLBACK;

        DBMS_OUTPUT.PUT_LINE(
            'Error al actualizar inventario: ' || SQLERRM
        );

END SP_ACTUALIZAR_INVENTARIO;




/* -----------------------------------------------------------------------------------
   PROCEDIMIENTO 3: ELIMINAR INVENTARIO
   ----------------------------------------------------------------------------------- */

CREATE OR REPLACE PROCEDURE SP_ELIMINAR_INVENTARIO (
    p_id_producto_sucursal IN PRODUCTOS_SUCURSALES.ID_PRODUCTOS_SUCURSALES%TYPE
)
AS
BEGIN

    DELETE FROM PRODUCTOS_SUCURSALES
    WHERE ID_PRODUCTOS_SUCURSALES =
          p_id_producto_sucursal;

    IF SQL%ROWCOUNT > 0 THEN

        COMMIT;

        DBMS_OUTPUT.PUT_LINE(
            'Inventario eliminado correctamente.'
        );

    ELSE

        DBMS_OUTPUT.PUT_LINE(
            'No existe el inventario indicado.'
        );

    END IF;

EXCEPTION
    WHEN OTHERS THEN

        ROLLBACK;

        DBMS_OUTPUT.PUT_LINE(
            'Error al eliminar inventario: ' || SQLERRM
        );

END SP_ELIMINAR_INVENTARIO;





/* -----------------------------------------------------------------------------------
   PROCEDIMIENTO 4: LISTAR INVENTARIO
   ----------------------------------------------------------------------------------- */

CREATE OR REPLACE PROCEDURE SP_LISTAR_INVENTARIO (
    p_id_sucursal IN PRODUCTOS_SUCURSALES.ID_SUCURSAL%TYPE,
    p_cursor OUT SYS_REFCURSOR
)
AS
BEGIN

    OPEN p_cursor FOR

        SELECT
            ID_PRODUCTOS_SUCURSALES,
            CANTIDAD,
            ID_PRODUCTO
        FROM PRODUCTOS_SUCURSALES
        WHERE ID_SUCURSAL = p_id_sucursal
        ORDER BY ID_PRODUCTOS_SUCURSALES;

END SP_LISTAR_INVENTARIO;



-----------------------------RF-10 Y RF11---------------------------------------------
/* -----------------------------------------------------------------------------------
   RF-10: El sistema deberá registrar los pagos realizados
   a los trabajadores.
   ----------------------------------------------------------------------------------- */


/* -----------------------------------------------------------------------------------
   PROCEDIMIENTO 1: REGISTRAR PAGO DE TRABAJADOR
   ----------------------------------------------------------------------------------- */

CREATE OR REPLACE PROCEDURE SP_REGISTRAR_PAGO_TRABAJADOR (
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

/* -----------------------------------------------------------------------------------
   PROCEDIMIENTO 2: ACTUALIZAR PAGO CON NVL
   ----------------------------------------------------------------------------------- */

CREATE OR REPLACE PROCEDURE SP_ACTUALIZAR_PAGO_TRABAJADOR (
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

/* -----------------------------------------------------------------------------------
   PROCEDIMIENTO 3: ELIMINAR PAGO
   ----------------------------------------------------------------------------------- */

CREATE OR REPLACE PROCEDURE SP_ELIMINAR_PAGO_TRABAJADOR (
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

/* -----------------------------------------------------------------------------------
   PROCEDIMIENTO 4: CONSULTAR PAGOS POR TRABAJADOR
   ----------------------------------------------------------------------------------- */

CREATE OR REPLACE PROCEDURE SP_LISTAR_PAGOS_TRABAJADOR (
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


/* -----------------------------------------------------------------------------------
   RF-11: El sistema deberá generar consultas sobre ventas,
   inventarios, proveedores y clientes.
----------------------------------------------------------------------------------- */

/* -----------------------------------------------------------------------------------
   PROCEDIMIENTO 1: CONSULTAR VENTAS
   ----------------------------------------------------------------------------------- */

CREATE OR REPLACE PROCEDURE SP_CONSULTAR_VENTAS (
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




/* -----------------------------------------------------------------------------------
   PROCEDIMIENTO 2: CONSULTAR INVENTARIO
   ----------------------------------------------------------------------------------- */

CREATE OR REPLACE PROCEDURE SP_CONSULTAR_INVENTARIO (
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




/* -----------------------------------------------------------------------------------
   PROCEDIMIENTO 3: CONSULTAR PROVEEDORES
   ----------------------------------------------------------------------------------- */

CREATE OR REPLACE PROCEDURE SP_CONSULTAR_PROVEEDORES (
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




/* -----------------------------------------------------------------------------------
   PROCEDIMIENTO 4: CONSULTAR CLIENTES
   ----------------------------------------------------------------------------------- */

CREATE OR REPLACE PROCEDURE SP_CONSULTAR_CLIENTES (
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




/* -----------------------------------------------------------------------------------
   TRIGGER RF-03: VALIDAR PRECIOS DEL PRODUCTO
   ----------------------------------------------------------------------------------- */

CREATE OR REPLACE TRIGGER TRG_VALIDAR_PRECIOS_PRODUCTO
BEFORE INSERT OR UPDATE ON PRODUCTOS
FOR EACH ROW
BEGIN

    IF :NEW.PRECIO_VENTA <= 0 THEN
        RAISE_APPLICATION_ERROR(
            -20020,
            'El precio de venta debe ser mayor que cero.'
        );
    END IF;

    IF :NEW.PRECIO_COSTO <= 0 THEN
        RAISE_APPLICATION_ERROR(
            -20021,
            'El precio de costo debe ser mayor que cero.'
        );
    END IF;

END;





/* -----------------------------------------------------------------------------------
   TRIGGER RF-04: VALIDAR CANTIDAD DE INVENTARIO
   Autor: Sebastián Rivera
   ----------------------------------------------------------------------------------- */

CREATE OR REPLACE TRIGGER TRG_VALIDAR_CANTIDAD_INVENTARIO
BEFORE INSERT OR UPDATE ON PRODUCTOS_SUCURSALES
FOR EACH ROW
BEGIN

    IF :NEW.CANTIDAD < 0 THEN
        RAISE_APPLICATION_ERROR(
            -20022,
            'La cantidad de inventario no puede ser negativa.'
        );
    END IF;

END;


/* -----------------------------------------------------------------------------------
   TRIGGER RF-10: CALCULAR MONTO TOTAL DEL PAGO
   Autor: Sebastián Rivera
   ----------------------------------------------------------------------------------- */

CREATE OR REPLACE TRIGGER TRG_CALCULAR_PAGO_TRABAJADOR
BEFORE INSERT OR UPDATE ON PAGO_TRABAJADORES
FOR EACH ROW
BEGIN

    IF :NEW.MONTO_HORA <= 0 THEN
        RAISE_APPLICATION_ERROR(
            -20023,
            'El monto por hora debe ser mayor que cero.'
        );
    END IF;

    IF :NEW.HORAS_LABORADAS < 0 THEN
        RAISE_APPLICATION_ERROR(
            -20024,
            'Las horas laboradas no pueden ser negativas.'
        );
    END IF;

    IF :NEW.MES < 1 OR :NEW.MES > 12 THEN
        RAISE_APPLICATION_ERROR(
            -20025,
            'El mes debe estar entre 1 y 12.'
        );
    END IF;

    IF :NEW.QUINCENA < 1 OR :NEW.QUINCENA > 2 THEN
        RAISE_APPLICATION_ERROR(
            -20026,
            'La quincena debe ser 1 o 2.'
        );
    END IF;

    :NEW.MONTO_TOTAL :=
        :NEW.MONTO_HORA * :NEW.HORAS_LABORADAS;

END;


/* -----------------------------------------------------------------------------------
   VISTA 1: PRODUCTOS
   ----------------------------------------------------------------------------------- */

CREATE OR REPLACE VIEW VW_PRODUCTOS AS
SELECT
    ID_PRODUCTO,
    NOMBRE,
    PRECIO_VENTA,
    PRECIO_COSTO,
    ID_CATEGORIA
FROM PRODUCTOS;

---procedimiento de la vista 1---
CREATE OR REPLACE PROCEDURE SP_VISTA_PRODUCTOS (
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


/* -----------------------------------------------------------------------------------
   VISTA 2: INVENTARIO
   ----------------------------------------------------------------------------------- */

CREATE OR REPLACE VIEW VW_INVENTARIO AS
SELECT
    ID_PRODUCTOS_SUCURSALES,
    CANTIDAD,
    ID_SUCURSAL,
    ID_PRODUCTO
FROM PRODUCTOS_SUCURSALES;

--procedimiento vista 2----
CREATE OR REPLACE PROCEDURE SP_VISTA_INVENTARIO (
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
        FROM VW_INVENTARIO;

END SP_VISTA_INVENTARIO;



-----------------------RF-05 y RF-06 El sistema deberá permitir registrar ventas y devoluciones.---------------------------

SET SERVEROUTPUT ON;

-- Vista para consultar la venta junto con el cliente, trabajador y metodo de pago utilizado.
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
INNER JOIN Clientes c
    ON c.Cedula = v.Cedula
INNER JOIN Trabajadores t
    ON t.ID_Trabajador = v.ID_Trabajador
INNER JOIN Tipo_Pagos tp
    ON tp.ID_Tipo_Pago = v.ID_Tipo_Pago;

-----------------------------------------------------------------------------------
-- RF-05 y RF-06
-- Registra una venta, guarda el metodo de pago, crea el detalle del producto vendido y descuenta el inventario de la sucursal.
-----------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE SP_REGISTRAR_VENTA (
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

    -- Validar cantidad solicitada.
    IF p_cantidad IS NULL OR p_cantidad <= 0 THEN
        p_mensaje := 'La cantidad debe ser mayor que cero.';
        RETURN;
    END IF;

    -- Validar cliente.
    SELECT COUNT(*)
      INTO v_existe_cliente
      FROM Clientes
     WHERE Cedula = p_cedula;

    IF v_existe_cliente = 0 THEN
        p_mensaje := 'El cliente indicado no existe.';
        RETURN;
    END IF;

    -- Validar trabajador y que pertenezca a la sucursal indicada.
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

    -- RF-06: validar el metodo de pago seleccionado.
    SELECT COUNT(*)
      INTO v_existe_pago
      FROM Tipo_Pagos
     WHERE ID_Tipo_Pago = p_id_tipo_pago;

    IF v_existe_pago = 0 THEN
        p_mensaje := 'El metodo de pago indicado no existe.';
        RETURN;
    END IF;

    -- Obtener precio e inventario. FOR UPDATE evita que dos ventas
    -- descuenten simultaneamente la misma existencia.
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

    -- RF-05: registrar encabezado de la venta.
    -- RF-06: ID_Tipo_Pago queda asociado directamente a la venta.
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

    -- Registrar producto y cantidad de la venta.
    INSERT INTO Productos_Ventas (
        Cantidad,
        ID_Producto,
        ID_Venta
    ) VALUES (
        p_cantidad,
        p_id_producto,
        p_id_venta
    );

    -- Actualizar inventario por sucursal.
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

-- Lista las ventas registradas mediante SYS_REFCURSOR.
CREATE OR REPLACE PROCEDURE SP_LISTAR_VENTAS (
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

-- Lista productos disponibles por sucursal para facilitar la venta.
CREATE OR REPLACE PROCEDURE SP_LISTAR_INVENTARIO_VENTA (
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

-- -----------------------------------------------------------------------------------
-- RF-05 y RF-06
-- Modifica una venta existente. Se utiliza NVL para permitir modificar uno o varios datos.
-- -----------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_MODIFICAR_VENTA (
    p_id_venta       IN Ventas.ID_Venta%TYPE,
    p_cedula         IN Ventas.Cedula%TYPE DEFAULT NULL,
    p_id_trabajador  IN Ventas.ID_Trabajador%TYPE DEFAULT NULL,
    p_id_tipo_pago   IN Ventas.ID_Tipo_Pago%TYPE DEFAULT NULL,
    p_mensaje        OUT VARCHAR2
)
IS
    v_existe_venta NUMBER;
BEGIN

    -- Validar que la venta exista.
    SELECT COUNT(*)
      INTO v_existe_venta
      FROM Ventas
     WHERE ID_Venta = p_id_venta;

    IF v_existe_venta = 0 THEN
        p_mensaje := 'La venta indicada no existe.';
        RETURN;
    END IF;

    -- Modificar solamente los datos enviados.
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

-- -----------------------------------------------------------------------------------
-- RF-05 y RF-06
-- Elimina una venta. Antes de eliminar se valida que no tenga registros asociados.
-- -----------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_ELIMINAR_VENTA (
    p_id_venta IN Ventas.ID_Venta%TYPE,
    p_mensaje  OUT VARCHAR2
)
IS
    v_existe_venta NUMBER;
    v_detalles     NUMBER;
BEGIN

    -- Validar que la venta exista.
    SELECT COUNT(*)
      INTO v_existe_venta
      FROM Ventas
     WHERE ID_Venta = p_id_venta;

    IF v_existe_venta = 0 THEN
        p_mensaje := 'La venta indicada no existe.';
        RETURN;
    END IF;

    -- Validar si existen productos asociados a la venta.
    SELECT COUNT(*)
      INTO v_detalles
      FROM Productos_Ventas
     WHERE ID_Venta = p_id_venta;

    IF v_detalles > 0 THEN
        p_mensaje :=
            'No se puede eliminar la venta porque tiene productos asociados.';
        RETURN;
    END IF;

    -- Eliminar la venta si no tiene registros asociados.
    DELETE FROM Ventas
     WHERE ID_Venta = p_id_venta;

    COMMIT;

    p_mensaje := 'Venta eliminada correctamente.';

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        p_mensaje := 'Error al eliminar la venta: ' || SQLERRM;

END SP_ELIMINAR_VENTA;

-- -----------------------------------------------------------------------------------
-- BLOQUES DE PRUEBA y EVIDENCIAS
-- Cambia los identificadores si los datos de prueba del grupo utilizan otros valores.
-- -----------------------------------------------------------------------------------

-- Prueba 1: verificar metodos de pago disponibles.
SELECT ID_Tipo_Pago, Metodo_Pago
FROM Tipo_Pagos
ORDER BY ID_Tipo_Pago;

-- Prueba 2: consultar datos validos antes de registrar una venta.
SELECT Cedula, Nombre, Apellido1
FROM Clientes
FETCH FIRST 5 ROWS ONLY;

SELECT ID_Trabajador, Nombre, ID_Sucursal, Estado
FROM Trabajadores
FETCH FIRST 5 ROWS ONLY;

SELECT ps.ID_Sucursal, p.ID_Producto, p.Nombre,
       p.Precio_Venta, ps.Cantidad
FROM Productos_Sucursales ps
INNER JOIN Productos p
    ON p.ID_Producto = ps.ID_Producto
WHERE ps.Cantidad > 0
FETCH FIRST 10 ROWS ONLY;

-- Prueba 3: registrar una venta.
-- IMPORTANTE: sustituir los valores por datos existentes si fuera necesario.
DECLARE
    v_id_venta Ventas.ID_Venta%TYPE;
    v_total    Ventas.Total%TYPE;
    v_mensaje  VARCHAR2(300);
BEGIN
    SP_REGISTRAR_VENTA(
        p_cedula        => '1-1000-2000',
        p_id_trabajador => 1,
        p_id_tipo_pago  => 1,
        p_id_producto   => 1,
        p_cantidad      => 1,
        p_id_sucursal   => 1,
        p_id_venta      => v_id_venta,
        p_total         => v_total,
        p_mensaje       => v_mensaje
    );

    DBMS_OUTPUT.PUT_LINE('ID venta: ' || NVL(TO_CHAR(v_id_venta), 'N/A'));
    DBMS_OUTPUT.PUT_LINE('Total: ' || TO_CHAR(v_total, 'FM999G999G990D00'));
    DBMS_OUTPUT.PUT_LINE('Resultado: ' || v_mensaje);
END;

-- Prueba 4: comprobar que RF-05 y RF-06 quedaron almacenados.
SELECT *
FROM VW_DETALLE_VENTAS
ORDER BY ID_Venta DESC
FETCH FIRST 10 ROWS ONLY;

-- Prueba 5: salida por cursor.
DECLARE
    v_cursor SYS_REFCURSOR;
BEGIN
    SP_LISTAR_VENTAS(v_cursor);
    DBMS_SQL.RETURN_RESULT(v_cursor);
END;

--------------------------------------------------------
-- Procedimiento Registrar un nuevo producto

CREATE OR REPLACE PROCEDURE SP_REGISTRAR_PRODUCTO (

    p_nombre IN PRODUCTOS.NOMBRE%TYPE,
    p_descripcion IN PRODUCTOS.DESCRIPCION%TYPE,
    p_precio_venta IN PRODUCTOS.PRECIO_VENTA%TYPE,
    p_precio_costo IN PRODUCTOS.PRECIO_COSTO%TYPE,
    p_fecha_entrada IN PRODUCTOS.FECHA_ULTIMA_ENTRADA%TYPE,
    p_id_proveedor IN PRODUCTOS.ID_PROVEEDOR%TYPE,
    p_id_categoria IN PRODUCTOS.ID_CATEGORIA%TYPE

) AS

BEGIN

    INSERT INTO PRODUCTOS
    (
        NOMBRE,
        DESCRIPCION,
        PRECIO_VENTA,
        PRECIO_COSTO,
        FECHA_ULTIMA_ENTRADA,
        ID_PROVEEDOR,
        ID_CATEGORIA
    )

    VALUES
    (
        p_nombre,
        p_descripcion,
        p_precio_venta,
        p_precio_costo,
        p_fecha_entrada,
        p_id_proveedor,
        p_id_categoria
    );

    COMMIT;

END SP_REGISTRAR_PRODUCTO;

-- Procedimiento listar todos los productos 

CREATE OR REPLACE PROCEDURE SP_LISTAR_PRODUCTOS (

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


-- Objetos de Prueba - Módulo Inventario (RF-04)
-- Procedimiento Registrar inventario

CREATE OR REPLACE PROCEDURE SP_REGISTRAR_INVENTARIO (

    p_cantidad IN PRODUCTOS_SUCURSALES.CANTIDAD%TYPE,
    p_id_sucursal IN PRODUCTOS_SUCURSALES.ID_SUCURSAL%TYPE,
    p_id_producto IN PRODUCTOS_SUCURSALES.ID_PRODUCTO%TYPE

) AS

BEGIN

    INSERT INTO PRODUCTOS_SUCURSALES
    (
        CANTIDAD,
        ID_SUCURSAL,
        ID_PRODUCTO
    )

    VALUES
    (
        p_cantidad,
        p_id_sucursal,
        p_id_producto
    );

    COMMIT;

END SP_REGISTRAR_INVENTARIO;



-- Procedimiento Listar inventario por sucursal (usa cursor de salida)

CREATE OR REPLACE PROCEDURE SP_LISTAR_INVENTARIO (

    p_id_sucursal IN PRODUCTOS_SUCURSALES.ID_SUCURSAL%TYPE,
    p_cursor OUT SYS_REFCURSOR

) AS

BEGIN

    OPEN p_cursor FOR

        SELECT
            ID_PRODUCTOS_SUCURSALES,
            CANTIDAD,
            ID_PRODUCTO
        FROM PRODUCTOS_SUCURSALES
        WHERE ID_SUCURSAL = p_id_sucursal
        ORDER BY ID_PRODUCTOS_SUCURSALES;

END SP_LISTAR_INVENTARIO;




----------------------RF-08. El sistema deberá permitir registrar devoluciones de productos.---------------------------
/*--------------------
Paquete devoluciones
*/---------------------


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

/*--------------------
Cuerpo de paquete devoluciones
*/---------------------


CREATE OR REPLACE PACKAGE BODY PK_DEVOLUCIONES AS

--Procedimiento para registrar devoluciones

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


--Procedimiento que consulta los productos devueltos por un cliente

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

    
--Procedimiento que llama a la vista
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

--Vista que permite ver los detalles de las devoluciones:

CREATE OR REPLACE VIEW VW_DETALLE_DEVOLUCIONES AS
SELECT

    D.FECHA_HORA,
    
    D.CEDULA,
    C.NOMBRE || ' ' || C.APELLIDO1 ||
    CASE
        WHEN C.APELLIDO2 IS NOT NULL
        THEN ' ' || C.APELLIDO2
        ELSE ''
    END AS CLIENTE,
    P.NOMBRE AS PRODUCTO,
    D.CANTIDAD_DEVUELTA,
    D.MOTIVO,
    TD.TIPO_DEVOLUCION
FROM DEVOLUCION D
INNER JOIN CLIENTES C
    ON C.CEDULA = D.CEDULA
INNER JOIN PRODUCTOS P
    ON P.ID_PRODUCTO = D.ID_PRODUCTO
INNER JOIN TIPO_DEVOLUCIONES TD
    ON TD.ID_TIPO_DEVOLUCION = D.ID_TIPO_DEVOLUCION;
    
    select * from vw_detalle_devoluciones


--Trigger para automatizar el registro de la fecha del producto devuelto si se registra como null:

CREATE OR REPLACE TRIGGER TRG_FECHA_DEVOLUCION
BEFORE INSERT
ON DEVOLUCION
FOR EACH ROW
BEGIN
    
    IF :NEW.FECHA_HORA IS NULL THEN
        :NEW.FECHA_HORA := SYSDATE;
    END IF;
END TRG_FECHA_DEVOLUCION;

--Trigger que valida que la cantidad devuelta sea mayor a 0

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


----------------------RF-09. El sistema deberá almacenar la información de los trabajadores y sus respectivos roles.---------------------------

/*--------------------
paquete trabajadores
*/---------------------

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

END PK_TRABAJADORES;

/*--------------------
Cuerpo de paquete trabajadores
*/---------------------

CREATE OR REPLACE PACKAGE BODY PK_TRABAJADORES AS
--Registro de trabajadores

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


--Editar trabajador

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


--Asignar rol del trabajador

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



--Desactivar trabajadores

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



--Procedimiento que llama vw_trabajadores_detalle
PROCEDURE PD_CONSULTAR_VW_TRABAJADORES (
    P_CURSOR OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN P_CURSOR FOR
        SELECT *
        FROM VW_TRABAJADORES_DETALLE;
END PD_CONSULTAR_VW_TRABAJADORES;

    
    
--Procedimiento que llama VW_CANTIDAD_TRABAJADORES_ROL

PROCEDURE PD_CONSULTAR_VW_CANT_TRAB_ROL (
    P_CURSOR OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN P_CURSOR FOR
        SELECT *
        FROM VW_CANTIDAD_TRABAJADORES_ROL;
END PD_CONSULTAR_VW_CANT_TRAB_ROL;

    
    
--Procedimiento que llama VW_VENTAS_POR_TRABAJADOR

PROCEDURE PD_CONSULTAR_VW_VENTAS_TRAB (
    P_CURSOR OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN P_CURSOR FOR
        SELECT *
        FROM VW_VENTAS_POR_TRABAJADOR;
END PD_CONSULTAR_VW_VENTAS_TRAB;

END PK_TRABAJADORES;

--Vista para ver detalle de los trabajadores:
CREATE OR REPLACE VIEW VW_TRABAJADORES_DETALLE AS
SELECT
    T.ID_TRABAJADOR,
    T.IDENTIFICACION,
    T.NOMBRE || ' ' ||
    T.APELLIDO1 ||
    CASE
        WHEN T.APELLIDO2 IS NOT NULL
        THEN ' ' || T.APELLIDO2
        ELSE ''
    END AS NOMBRE_COMPLETO,
    T.CORREO_ELECTRONICO,
    T.ESTADO,
    S.ID_SUCURSAL,
    S.NOMBRE AS SUCURSAL,
    TU.ID_TURNO,
    TU.TURNO,
    R.ID_ROL,
    R.ROL
FROM TRABAJADORES T
INNER JOIN SUCURSALES S
    ON S.ID_SUCURSAL = T.ID_SUCURSAL
INNER JOIN TURNOS TU
    ON TU.ID_TURNO = T.ID_TURNO
INNER JOIN ROLES R
    ON R.ID_ROL = T.ID_ROL;
    
    
 --Vista para ver la cantidad de trabajadores por rol:
CREATE OR REPLACE VIEW VW_CANTIDAD_TRABAJADORES_ROL AS
SELECT
    R.ID_ROL,
    R.ROL,
    COUNT(T.ID_TRABAJADOR) AS CANTIDAD_TRABAJADORES
FROM ROLES R
LEFT JOIN TRABAJADORES T
    ON R.ID_ROL = T.ID_ROL
GROUP BY
    R.ID_ROL,
    R.ROL
ORDER BY
    R.ID_ROL;

--Vista para ver la cantidad de ventas por trabajador:

CREATE OR REPLACE VIEW VW_VENTAS_POR_TRABAJADOR AS
SELECT
    T.IDENTIFICACION,
    T.NOMBRE || ' ' ||
    T.APELLIDO1 ||
    CASE
        WHEN T.APELLIDO2 IS NOT NULL
        THEN ' ' || T.APELLIDO2
        ELSE ''
    END AS NOMBRE_COMPLETO,
    R.ROL,
    COUNT(V.ID_VENTA) AS CANTIDAD_VENTAS,
    NVL(SUM(V.TOTAL), 0) AS TOTAL_VENDIDO
FROM TRABAJADORES T
INNER JOIN ROLES R
    ON R.ID_ROL = T.ID_ROL
LEFT JOIN VENTAS V
    ON V.ID_TRABAJADOR = T.ID_TRABAJADOR
GROUP BY
    T.ID_TRABAJADOR,
    T.IDENTIFICACION,
    T.NOMBRE,
    T.APELLIDO1,
    T.APELLIDO2,
    R.ROL
ORDER BY
    TOTAL_VENDIDO DESC;
   


--Trigger para poner el estado de un trabajador como activo si es insertado como null

CREATE OR REPLACE TRIGGER TRG_ESTADO_TRABAJADOR
BEFORE INSERT
ON TRABAJADORES
FOR EACH ROW
BEGIN
    IF :NEW.ESTADO IS NULL THEN
        :NEW.ESTADO := 'ACTIVO';
    END IF;
END TRG_ESTADO_TRABAJADOR;



--Trigger que no elimina trabajadores con ventas
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

/*
DELETE FROM TRABAJADORES
WHERE IDENTIFICACION= 'T-3007';
*/


--Trigger para auditar cambios de rol

CREATE TABLE AUDITORIA_ROLES_TRABAJADOR (
    AUDIT_ID        NUMBER PRIMARY KEY,
    ID_TRABAJADOR   NUMBER NOT NULL,
    FECHA_CAMBIO    TIMESTAMP NOT NULL,
    USUARIO         VARCHAR2(100) NOT NULL,
    ROL_ANTERIOR    NUMBER NOT NULL,
    ROL_NUEVO       NUMBER NOT NULL,

    CONSTRAINT FK_AUDIT_TRABAJADOR FOREIGN KEY (ID_TRABAJADOR) REFERENCES TRABAJADORES(ID_TRABAJADOR),
    CONSTRAINT FK_AUDIT_ROL_ANTERIOR FOREIGN KEY (ROL_ANTERIOR)REFERENCES ROLES(ID_ROL),
    CONSTRAINT FK_AUDIT_ROL_NUEVO FOREIGN KEY (ROL_NUEVO)REFERENCES ROLES(ID_ROL)
);
CREATE SEQUENCE seq_auditoria_roles START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER trg_auditar_cambio_rol AFTER
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