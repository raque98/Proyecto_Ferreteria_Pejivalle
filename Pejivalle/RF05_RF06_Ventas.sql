-- Ferreteria Pejivalle
-- RF-05 y RF-06
-- Autor: Maria Paz Garcia Umana
-- Fecha: 12/07/2026

SET SERVEROUTPUT ON;

-- Vista de ventas
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
/

-- Registrar venta
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

    -- Validar cantidad
    IF p_cantidad IS NULL OR p_cantidad <= 0 THEN
        p_mensaje := 'La cantidad debe ser mayor que cero.';
        RETURN;
    END IF;

    -- Validar cliente
    SELECT COUNT(*)
      INTO v_existe_cliente
      FROM Clientes
     WHERE Cedula = p_cedula;

    IF v_existe_cliente = 0 THEN
        p_mensaje := 'El cliente indicado no existe.';
        RETURN;
    END IF;

    -- Validar trabajador
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

    -- Validar metodo de pago
    SELECT COUNT(*)
      INTO v_existe_pago
      FROM Tipo_Pagos
     WHERE ID_Tipo_Pago = p_id_tipo_pago;

    IF v_existe_pago = 0 THEN
        p_mensaje := 'El metodo de pago indicado no existe.';
        RETURN;
    END IF;

    -- Obtener precio e inventario
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

    -- Insertar venta
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

    -- Insertar detalle
    INSERT INTO Productos_Ventas (
        Cantidad,
        ID_Producto,
        ID_Venta
    ) VALUES (
        p_cantidad,
        p_id_producto,
        p_id_venta
    );

    -- Actualizar inventario
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
/

-- Listar ventas
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
/

-- Listar inventario
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
/

-- Pruebas

-- Metodos de pago
SELECT ID_Tipo_Pago, Metodo_Pago
FROM Tipo_Pagos
ORDER BY ID_Tipo_Pago;

-- Datos para la prueba
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

-- Registrar una venta
ALTER SESSION DISABLE PARALLEL DML;

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

    DBMS_OUTPUT.PUT_LINE(
        'ID venta: ' || NVL(TO_CHAR(v_id_venta), 'N/A')
    );

    DBMS_OUTPUT.PUT_LINE(
        'Total: ' || TO_CHAR(v_total, 'FM999G999G990D00')
    );

    DBMS_OUTPUT.PUT_LINE(
        'Resultado: ' || v_mensaje
    );
END;
/

-- Consultar ventas
SELECT *
FROM VW_DETALLE_VENTAS
ORDER BY ID_Venta DESC
FETCH FIRST 10 ROWS ONLY;

-- Prueba del cursor
DECLARE
    v_cursor SYS_REFCURSOR;
BEGIN
    SP_LISTAR_VENTAS(v_cursor);
    DBMS_SQL.RETURN_RESULT(v_cursor);
END;
/
