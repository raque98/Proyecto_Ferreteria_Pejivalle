# dao/dao_tipo_pagos.py
# Descripción: DAO para gestionar métodos de pago

import oracledb

class DAOTipoPagos:
    def __init__(self, connection):
        self.connection = connection

    def registrar(self, metodo_pago):
        try:
            cursor = self.connection.cursor()
            cursor.callproc("SP_REGISTRAR_TIPO_PAGO", [metodo_pago])
            self.connection.commit()
            cursor.close()
            print("Método de pago registrado con éxito.")
        except Exception as e:
            print(f"Error al registrar método de pago: {e}")

    def listar_todos(self):
        try:
            cursor = self.connection.cursor()
            result = cursor.var(oracledb.CURSOR)
            cursor.callproc("SP_LISTAR_TIPOS_PAGO", [result])
            cursor = result.getvalue()
            rows = cursor.fetchall()
            cursor.close()
            
            if not rows:
                print("📭 No hay métodos de pago registrados.")
                return
            
            print("\n--- Metodos de Pago ---")
            for row in rows:
                print(f"[{row[0]}] {row[1]}")
            return rows
        except Exception as e:
            print(f"Error al listar métodos de pago: {e}")
            return []