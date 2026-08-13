# dao/dao_sucursales.py
# Descripción: DAO para gestionar sucursales e inventario

import oracledb

class DAOSucursales:
    def __init__(self, connection):
        self.connection = connection

    def listar_todas(self):
        """Lista sucursales activas usando PK_SUCURSALES.SP_LISTAR_SUCURSALES."""
        cursor = None
        result_cursor = None
        try:
            cursor = self.connection.cursor()
            print(">> Ejecutando PK_SUCURSALES.SP_LISTAR_SUCURSALES...")
            resultado = cursor.var(oracledb.CURSOR)
            cursor.callproc("PK_SUCURSALES.SP_LISTAR_SUCURSALES", [resultado])

            result_cursor = resultado.getvalue()
            if result_cursor is None:
                print("   Error: El cursor devuelto es NULL")
                return []

            filas = result_cursor.fetchall()
            print(f"   Se encontraron {len(filas)} sucursal(es).")
            return filas

        except oracledb.Error as error:
            print(f"Error al listar sucursales: {error}")
            return []
        finally:
            if result_cursor is not None:
                try:
                    result_cursor.close()
                except:
                    pass
            if cursor is not None:
                cursor.close()

    def listar_todas_con_direccion(self):
        """Lista sucursales con su dirección usando PK_SUCURSALES.SP_LISTAR_SUCURSALES_CON_DIRECCION."""
        cursor = None
        result_cursor = None
        try:
            cursor = self.connection.cursor()
            print(">> Consultando sucursales con dirección...")
            resultado = cursor.var(oracledb.CURSOR)
            cursor.callproc("PK_SUCURSALES.SP_LISTAR_SUCURSALES_CON_DIRECCION", [resultado])

            result_cursor = resultado.getvalue()
            if result_cursor is None:
                print("   Error: El cursor devuelto es NULL")
                return []

            filas = result_cursor.fetchall()
            print(f"   Se encontraron {len(filas)} sucursal(es) con dirección.")
            return filas

        except oracledb.Error as error:
            print(f"Error al listar sucursales con dirección: {error}")
            return []
        finally:
            if result_cursor is not None:
                try:
                    result_cursor.close()
                except:
                    pass
            if cursor is not None:
                cursor.close()

    def listar_inventario_por_sucursal(self, id_sucursal):
        """Lista el inventario de una sucursal usando PK_INVENTARIO.SP_LISTAR_INVENTARIO.

        NOTA: se usa execute() con bloque PL/SQL explícito en vez de callproc()
        porque callproc() se queda colgado en el paso de "describe" cuando el
        procedimiento pertenece a un paquete y combina un IN con un SYS_REFCURSOR
        de salida (bug conocido de python-oracledb en modo thin).
        """
        cursor = None
        result_cursor = None
        try:
            cursor = self.connection.cursor()
            print(f">> Consultando inventario de sucursal {id_sucursal}...")
            resultado = cursor.var(oracledb.CURSOR)

            cursor.execute(
                """
                BEGIN
                    PK_INVENTARIO.SP_LISTAR_INVENTARIO(:id_sucursal, :cur);
                END;
                """,
                id_sucursal=str(id_sucursal),
                cur=resultado
            )

            result_cursor = resultado.getvalue()
            if result_cursor is None:
                print("   Error: El cursor devuelto es NULL")
                return []

            filas = result_cursor.fetchall()
            print(f"   Se encontraron {len(filas)} registro(s) de inventario.")
            return filas

        except oracledb.Error as error:
            print(f"Error al listar inventario: {error}")
            return []
        finally:
            if result_cursor is not None:
                try:
                    result_cursor.close()
                except:
                    pass
            if cursor is not None:
                cursor.close()

    def registrar_inventario(self, cantidad, id_sucursal, id_producto):
        """Registra inventario usando PK_INVENTARIO.SP_REGISTRAR_INVENTARIO."""
        cursor = None
        try:
            cursor = self.connection.cursor()
            print(">> Ejecutando PK_INVENTARIO.SP_REGISTRAR_INVENTARIO...")
            cursor.callproc("PK_INVENTARIO.SP_REGISTRAR_INVENTARIO", [cantidad, id_sucursal, id_producto])
            self.connection.commit()
            print("   Inventario registrado con éxito.")
            return True

        except oracledb.Error as error:
            print(f"Error al registrar inventario: {error}")
            self.connection.rollback()
            return False
        finally:
            if cursor is not None:
                cursor.close()