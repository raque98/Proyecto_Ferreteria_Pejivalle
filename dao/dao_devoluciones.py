# dao/dao_devoluciones.py
# Descripción: DAO para RF-08 (registrar devoluciones de productos)

import oracledb

class DAODevoluciones:
    def __init__(self, connection):
        self.connection = connection

    def registrar(self, id_venta, id_producto, cedula, cantidad_devuelta, id_tipo_devolucion, motivo):
        """Registra una devolución usando PK_DEVOLUCIONES.PD_REGISTRAR_DEVOLUCION.

        IMPORTANTE: este método NO atrapa el error de Oracle -- lo deja subir
        (raise) para que quien llame (la interfaz) sepa si realmente funcionó
        o no. Si se atrapa aquí y no se relanza, la interfaz no tiene forma
        de saber que algo falló y termina mostrando "Éxito" siempre.
        """
        cursor = None
        try:
            cursor = self.connection.cursor()
            print(">> Ejecutando PK_DEVOLUCIONES.PD_REGISTRAR_DEVOLUCION...")
            cursor.callproc("PK_DEVOLUCIONES.PD_REGISTRAR_DEVOLUCION", [
                id_venta,
                id_producto,
                cedula,
                cantidad_devuelta,
                id_tipo_devolucion,
                motivo
            ])
            self.connection.commit()
            print("   Devolución registrada con éxito.")
        except oracledb.Error as error:
            print(f"Error al registrar devolución: {error}")
            self.connection.rollback()
            raise
        finally:
            if cursor is not None:
                cursor.close()

    def consultar_por_cliente(self, cedula):
        """Consulta las devoluciones de un cliente usando
        PK_DEVOLUCIONES.PD_CONSULTAR_DEVOLUCIONES_CLIENTE.

        NOTA: se usa execute() con bloque PL/SQL explícito en vez de callproc()
        porque este procedimiento combina un IN (cedula) con un SYS_REFCURSOR
        de salida, y callproc() se cuelga con esa combinación en este entorno.
        """
        cursor = None
        result_cursor = None
        try:
            cursor = self.connection.cursor()
            print(f">> Ejecutando PK_DEVOLUCIONES.PD_CONSULTAR_DEVOLUCIONES_CLIENTE (Cedula: {cedula})...")
            resultado = cursor.var(oracledb.CURSOR)

            cursor.execute(
                """
                BEGIN
                    PK_DEVOLUCIONES.PD_CONSULTAR_DEVOLUCIONES_CLIENTE(:cedula, :cur);
                END;
                """,
                cedula=cedula,
                cur=resultado
            )

            result_cursor = resultado.getvalue()
            if result_cursor is None:
                print("   Error: El cursor devuelto es NULL")
                return []

            filas = result_cursor.fetchall()
            print(f"   Se encontraron {len(filas)} devolución(es).")
            return filas
        except oracledb.Error as error:
            print(f"Error al consultar devoluciones: {error}")
            return []
        finally:
            if result_cursor is not None:
                try:
                    result_cursor.close()
                except:
                    pass
            if cursor is not None:
                cursor.close()

    def ver_detalle_todas(self):
        """Lista el detalle de devoluciones (con nombres) usando
        PK_DEVOLUCIONES.PD_VW_DETALLE_DEVOLUCIONES (sin parámetro de entrada,
        por eso callproc() funciona bien aquí)."""
        cursor = None
        result_cursor = None
        try:
            cursor = self.connection.cursor()
            print(">> Ejecutando PK_DEVOLUCIONES.PD_VW_DETALLE_DEVOLUCIONES...")
            resultado = cursor.var(oracledb.CURSOR)
            cursor.callproc("PK_DEVOLUCIONES.PD_VW_DETALLE_DEVOLUCIONES", [resultado])
            result_cursor = resultado.getvalue()

            if result_cursor is None:
                print("   Error: El cursor devuelto es NULL")
                return []

            filas = result_cursor.fetchall()
            print(f"   Se encontraron {len(filas)} devolución(es).")
            return filas
        except oracledb.Error as error:
            print(f"Error al consultar el detalle de devoluciones: {error}")
            return []
        finally:
            if result_cursor is not None:
                try:
                    result_cursor.close()
                except:
                    pass
            if cursor is not None:
                cursor.close()

    def ver_detalle_completo(self):
        """Lista el detalle de devoluciones INCLUYENDO los IDs (ID_Devolucion,
        ID_Venta, ID_Producto, ID_Tipo_Devolucion) usando
        PK_DEVOLUCIONES_EXTRA.SP_LISTAR_DEVOLUCIONES_COMPLETO.

        Este procedimiento existe porque PD_VW_DETALLE_DEVOLUCIONES solo
        muestra nombres, y para registrar una devolución nueva hace falta
        saber los IDs reales."""
        cursor = None
        result_cursor = None
        try:
            cursor = self.connection.cursor()
            print(">> Ejecutando PK_DEVOLUCIONES_EXTRA.SP_LISTAR_DEVOLUCIONES_COMPLETO...")
            resultado = cursor.var(oracledb.CURSOR)
            cursor.callproc("PK_DEVOLUCIONES_EXTRA.SP_LISTAR_DEVOLUCIONES_COMPLETO", [resultado])
            result_cursor = resultado.getvalue()

            if result_cursor is None:
                print("   Error: El cursor devuelto es NULL")
                return []

            filas = result_cursor.fetchall()
            print(f"   Se encontraron {len(filas)} devolución(es).")
            return filas
        except oracledb.Error as error:
            print(f"Error al consultar el detalle completo: {error}")
            return []
        finally:
            if result_cursor is not None:
                try:
                    result_cursor.close()
                except:
                    pass
            if cursor is not None:
                cursor.close()