# dao/dao_tipo_pagos.py
# Descripción: DAO para gestionar métodos de pago

import oracledb

class DAOTipoPagos:
    def __init__(self, connection):
        self.connection = connection

    def registrar(self, metodo_pago):
        """Registra un método de pago usando PK_TIPO_PAGOS.SP_REGISTRAR_TIPO_PAGO."""
        cursor = None
        try:
            cursor = self.connection.cursor()
            print(">> Ejecutando PK_TIPO_PAGOS.SP_REGISTRAR_TIPO_PAGO...")
            cursor.callproc("PK_TIPO_PAGOS.SP_REGISTRAR_TIPO_PAGO", [metodo_pago])
            self.connection.commit()
            print("   Método de pago registrado con éxito.")
        except oracledb.Error as error:
            print(f"Error al registrar método de pago: {error}")
            self.connection.rollback()
            raise
        finally:
            if cursor is not None:
                cursor.close()

    def listar_todos(self):
        """Lista los métodos de pago usando PK_TIPO_PAGOS.SP_LISTAR_TIPOS_PAGO."""
        cursor = None
        result_cursor = None
        try:
            cursor = self.connection.cursor()
            print(">> Ejecutando PK_TIPO_PAGOS.SP_LISTAR_TIPOS_PAGO...")
            resultado = cursor.var(oracledb.CURSOR)
            cursor.callproc("PK_TIPO_PAGOS.SP_LISTAR_TIPOS_PAGO", [resultado])
            result_cursor = resultado.getvalue()

            if result_cursor is None:
                print("   Error: El cursor devuelto es NULL")
                return []

            filas = result_cursor.fetchall()
            print(f"   Se encontraron {len(filas)} método(s) de pago.")
            return filas
        except oracledb.Error as error:
            print(f"Error al listar métodos de pago: {error}")
            return []
        finally:
            if result_cursor is not None:
                try:
                    result_cursor.close()
                except:
                    pass
            if cursor is not None:
                cursor.close()

    def actualizar(self, id_tipo_pago, metodo_pago):
        """Actualiza un método de pago usando PK_TIPO_PAGOS.SP_ACTUALIZAR_TIPO_PAGO (admite NVL)."""
        cursor = None
        try:
            cursor = self.connection.cursor()
            print(f">> Ejecutando PK_TIPO_PAGOS.SP_ACTUALIZAR_TIPO_PAGO (ID: {id_tipo_pago})...")
            cursor.callproc("PK_TIPO_PAGOS.SP_ACTUALIZAR_TIPO_PAGO", [id_tipo_pago, metodo_pago])
            self.connection.commit()
            print("   Método de pago actualizado con éxito.")
        except oracledb.Error as error:
            print(f"Error al actualizar método de pago: {error}")
            self.connection.rollback()
            raise
        finally:
            if cursor is not None:
                cursor.close()

    def eliminar(self, id_tipo_pago):
        """Elimina un método de pago usando PK_TIPO_PAGOS.SP_ELIMINAR_TIPO_PAGO
        (el procedimiento ya valida que no tenga ventas asociadas)."""
        cursor = None
        try:
            cursor = self.connection.cursor()
            print(f">> Ejecutando PK_TIPO_PAGOS.SP_ELIMINAR_TIPO_PAGO (ID: {id_tipo_pago})...")
            cursor.callproc("PK_TIPO_PAGOS.SP_ELIMINAR_TIPO_PAGO", [id_tipo_pago])
            self.connection.commit()
            print("   Método de pago eliminado con éxito.")
        except oracledb.Error as error:
            print(f"Error al eliminar método de pago: {error}")
            self.connection.rollback()
            raise
        finally:
            if cursor is not None:
                cursor.close()