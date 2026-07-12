# dao/dao_clientes.py
# Descripción: DAO para gestionar clientes usando procedimientos almacenados

import oracledb

class DAOClientes:
    def __init__(self, connection):
        self.connection = connection

    # 1. Registrar un nuevo cliente
    def registrar(self, cedula, nombre, apellido1, apellido2, correo, telefono):
        try:
            cursor = self.connection.cursor()
            cursor.callproc("registrar_cliente", [cedula, nombre, apellido1, apellido2, correo, telefono])
            self.connection.commit()
            cursor.close()
            print("Cliente registrado con éxito.")
        except Exception as e:
            print(f"Error al registrar cliente: {e}")

    # 2. Consultar todos los clientes
    def consultar_todos(self):
        try:
            cursor = self.connection.cursor()
            result = cursor.var(oracledb.CURSOR)
            cursor.callproc("consultar_clientes", [result])
            cursor = result.getvalue()
            rows = cursor.fetchall()
            cursor.close()
            return rows
        except Exception as e:
            print(f"Error al consultar clientes: {e}")
            return []

    # 3. Editar correo y teléfono de un cliente
    def editar_correo_telefono(self, cedula, correo, telefono):
        try:
            cursor = self.connection.cursor()
            cursor.callproc("editar_correo_telefono_cliente", [cedula, correo, telefono])
            self.connection.commit()
            cursor.close()
            print("Datos del cliente actualizados con éxito.")
        except Exception as e:
            print(f"Error al editar cliente: {e}")

    # 4. Eliminar un cliente
    def eliminar(self, cedula):
        try:
            cursor = self.connection.cursor()
            cursor.callproc("eliminar_cliente", [cedula])
            self.connection.commit()
            cursor.close()
            print("Cliente eliminado con éxito.")
        except Exception as e:
            print(f"Error al eliminar cliente: {e}")

    # 5. Verificar si un cliente existe (usa función)
    def existe(self, cedula):
        try:
            cursor = self.connection.cursor()
            result = cursor.var(int)
            cursor.callproc("existe_cliente", [cedula, result])
            cursor.close()
            return result.getvalue() > 0
        except Exception as e:
            print(f"Error al verificar cliente: {e}")
            return False

    # 6. Mostrar historial de compras por cliente (usa vista)
    def mostrar_historial_compras(self):
        try:
            cursor = self.connection.cursor()
            result = cursor.var(oracledb.CURSOR)
            cursor.callproc("mostrar_clientes_compras", [result])
            cursor = result.getvalue()
            rows = cursor.fetchall()
            cursor.close()
            return rows
        except Exception as e:
            print(f"Error al mostrar historial: {e}")
            return []