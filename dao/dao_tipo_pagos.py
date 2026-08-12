# dao/dao_tipo_pagos.py
# Descripción: DAO para gestionar métodos de pago

import oracledb

class DAOTipoPagos:
    def __init__(self, connection):
        self.connection = connection

    def registrar(self, metodo_pago):
        """Registra un método de pago usando PK_TIPO_PAGOS.SP_REGISTRAR_TIPO_PAGO."""
        try:
            cursor = self.connection.cursor()
            cursor.callproc("PK_TIPO_PAGOS.SP_REGISTRAR_TIPO_PAGO", [metodo_pago])
            self.connection.commit()
            cursor.close()
            print("Método de pago registrado con éxito.")
        except Exception as e:
            print(f"Error al registrar método de pago: {e}")

    def listar_todos(self):
        """Lista los métodos de pago usando PK_TIPO_PAGOS.SP_LISTAR_TIPOS_PAGO."""
        try:
            cursor = self.connection.cursor()
            resultado = cursor.var(oracledb.CURSOR)
            cursor.callproc("PK_TIPO_PAGOS.SP_LISTAR_TIPOS_PAGO", [resultado])
            filas = resultado.getvalue().fetchall()
            cursor.close()

            if not filas:
                print("No hay métodos de pago registrados.")
                return []

            print("\n--- Metodos de Pago ---")
            for fila in filas:
                print(f"[{fila[0]}] {fila[1]}")
            return filas
        except Exception as e:
            print(f"Error al listar métodos de pago: {e}")
            return []

    def actualizar(self, id_tipo_pago, metodo_pago):
        """Actualiza un método de pago usando PK_TIPO_PAGOS.SP_ACTUALIZAR_TIPO_PAGO (admite NVL)."""
        try:
            cursor = self.connection.cursor()
            cursor.callproc("PK_TIPO_PAGOS.SP_ACTUALIZAR_TIPO_PAGO", [id_tipo_pago, metodo_pago])
            self.connection.commit()
            cursor.close()
            print("Método de pago actualizado con éxito.")
            return True
        except Exception as e:
            print(f"Error al actualizar método de pago: {e}")
            return False

    def eliminar(self, id_tipo_pago):
        """Elimina un método de pago usando PK_TIPO_PAGOS.SP_ELIMINAR_TIPO_PAGO
        (el procedimiento ya valida que no tenga ventas asociadas)."""
        try:
            cursor = self.connection.cursor()
            cursor.callproc("PK_TIPO_PAGOS.SP_ELIMINAR_TIPO_PAGO", [id_tipo_pago])
            self.connection.commit()
            cursor.close()
            print("Método de pago eliminado con éxito.")
            return True
        except Exception as e:
            print(f"Error al eliminar método de pago: {e}")
            return False