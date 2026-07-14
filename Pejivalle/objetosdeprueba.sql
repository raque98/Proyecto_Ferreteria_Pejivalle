-- -----------------------------------------------
--  Objetos de Prueba - Módulo Tipo_Pagos (RF-06)
--  Ejecutar este script en SQL Developer conectado a tu esquema de Ferretería Pejivalle. Sirve para probar la conexión
--  Python <-> Oracle de punta a punta con algo simple y real.
-- -----------------------------------------------

-- Procedimiento 1: registrar un nuevo metodo de pago
CREATE OR REPLACE PROCEDURE SP_REGISTRAR_TIPO_PAGO (
    p_metodo_pago IN Tipo_Pagos.Metodo_Pago%TYPE
) AS
BEGIN
    INSERT INTO Tipo_Pagos (Metodo_Pago)
    VALUES (p_metodo_pago);

    COMMIT;
END SP_REGISTRAR_TIPO_PAGO;
/

-- Procedimiento 2: listar todos los métodos de pago (usa cursor de salida)
CREATE OR REPLACE PROCEDURE SP_LISTAR_TIPOS_PAGO (
    p_cursor OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_cursor FOR
        SELECT ID_Tipo_Pago, Metodo_Pago
        FROM Tipo_Pagos
        ORDER BY ID_Tipo_Pago;
END SP_LISTAR_TIPOS_PAGO;

-- Prueba rápida manual en SQL Developer (opcional, antes de usar Python):
-- BEGIN
--     SP_REGISTRAR_TIPO_PAGO('Prueba Manual');
-- END;
--
-- VAR cur REFCURSOR;
-- EXEC SP_LISTAR_TIPOS_PAGO(:cur);
-- PRINT cur;




-- Procedimiento 1: registrar un nuevo producto

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
/




-- Procedimiento 2: listar todos los productos 

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
/


-- Objetos de Prueba - Módulo Inventario (RF-04)
-- Procedimiento 1: registrar inventario

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
/



- Procedimiento 2: listar inventario por sucursal (usa cursor de salida)

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
/