# dao/dao_proveedores.py
# Descripción: DAO para gestionar proveedores usando procedimientos almacenados

import oracledb

class DAOProveedores:
    def __init__(self, connection):
        self.connection = connection

    # 1. Registrar un nuevo proveedor
    def registrar(self, nombre_proveedor, nombre_contacto, apellido1, apellido2, correo, telefono):
        try:
            cursor = self.connection.cursor()
            cursor.callproc("registrar_proveedor", [nombre_proveedor, nombre_contacto, apellido1, apellido2, correo, telefono])
            self.connection.commit()
            cursor.close()
            print("Proveedor registrado con éxito.")
        except Exception as e:
            print(f"Error al registrar proveedor: {e}")

    # 2. Consultar todos los proveedores
    def consultar_todos(self):
        try:
            cursor = self.connection.cursor()
            result = cursor.var(oracledb.CURSOR)
            cursor.callproc("consultar_proveedores", [result])
            cursor = result.getvalue()
            rows = cursor.fetchall()
            cursor.close()
            return rows
        except Exception as e:
            print(f"Error al consultar proveedores: {e}")
            return []

    # 3. Editar contacto de un proveedor
    def editar_contacto(self, id_proveedor, nombre_contacto, apellido1, apellido2, correo, telefono):
        try:
            cursor = self.connection.cursor()
            cursor.callproc("editar_contacto_proveedor", [id_proveedor, nombre_contacto, apellido1, apellido2, correo, telefono])
            self.connection.commit()
            cursor.close()
            print("Contacto del proveedor actualizado con éxito.")
        except Exception as e:
            print(f"Error al editar contacto: {e}")

    # 4. Eliminar un proveedor
    def eliminar(self, id_proveedor):
        try:
            cursor = self.connection.cursor()
            cursor.callproc("eliminar_proveedor", [id_proveedor])
            self.connection.commit()
            cursor.close()
            print("Proveedor eliminado con éxito.")
        except Exception as e:
            print(f"Error al eliminar proveedor: {e}")

    # 5. Cambiar estado de un proveedor
    def cambiar_estado(self, id_proveedor, estado):
        try:
            cursor = self.connection.cursor()
            cursor.callproc("editar_estado_proveedor", [id_proveedor, estado])
            self.connection.commit()
            cursor.close()
            print("Estado del proveedor actualizado con éxito.")
        except Exception as e:
            print(f"Error al cambiar estado: {e}")

    # 6. Ver productos por proveedor (usa vista)
    def mostrar_productos_por_proveedor(self):
        try:
            cursor = self.connection.cursor()
            result = cursor.var(oracledb.CURSOR)
            cursor.callproc("mostrar_productos_proveedores", [result])
            cursor = result.getvalue()
            rows = cursor.fetchall()
            cursor.close()
            return rows
        except Exception as e:
            print(f"Error al mostrar productos por proveedor: {e}")
            return []

    # 7. Contar productos de un proveedor (usa función)
    def contar_productos(self, id_proveedor):
        try:
            cursor = self.connection.cursor()
            result = cursor.var(int)
            cursor.callproc("cantidad_productos_proveedor", [id_proveedor, result])
            cursor.close()
            return result.getvalue()
        except Exception as e:
            print(f"Error al contar productos: {e}")
            return 0

    # 8. Ver estado de un proveedor (usa función)
    def ver_estado(self, id_proveedor):
        try:
            cursor = self.connection.cursor()
            result = cursor.var(str)
            cursor.callproc("estado_proveedor", [id_proveedor, result])
            cursor.close()
            return result.getvalue()
        except Exception as e:
            print(f"Error al ver estado: {e}")
            return "Error"