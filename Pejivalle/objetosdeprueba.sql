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