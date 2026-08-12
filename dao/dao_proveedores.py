# dao/dao_proveedores.py
# Descripción: DAO para gestionar proveedores usando procedimientos almacenados

import oracledb

class DAOProveedores:
    def __init__(self, connection):
        self.connection = connection

    # 1. Registra un nuevo proveedor
    def registrar(self, nombre_proveedor, nombre_contacto, apellido1, apellido2, correo, telefono):
        try:
            cursor = self.connection.cursor()
            cursor.callproc("PK_PROVEEDORES.registrar_proveedor",
                             [nombre_proveedor, nombre_contacto, apellido1, apellido2, correo, telefono])
            self.connection.commit()
            cursor.close()
            print("Proveedor registrado con éxito.")
        except Exception as e:
            print(f"Error al registrar proveedor: {e}")

    # 2. Consulta todos los proveedores
    def consultar_todos(self):
        try:
            cursor = self.connection.cursor()
            resultado = cursor.var(oracledb.CURSOR)
            cursor.callproc("PK_PROVEEDORES.consultar_proveedores", [resultado])
            filas = resultado.getvalue().fetchall()
            cursor.close()
            return filas
        except Exception as e:
            print(f"Error al consultar proveedores: {e}")
            return []

    # 3. Edita un contacto de un proveedor (usa NVL: los campos None conservan su valor)
    def editar_contacto(self, id_proveedor, nombre_contacto, apellido1, apellido2, correo, telefono):
        try:
            cursor = self.connection.cursor()
            cursor.callproc("PK_PROVEEDORES.EDITAR_CONTACTO_PROVEEDOR",
                             [id_proveedor, nombre_contacto, apellido1, apellido2, correo, telefono])
            self.connection.commit()
            cursor.close()
            print("Contacto del proveedor actualizado con éxito.")
        except Exception as e:
            print(f"Error al editar contacto: {e}")

    # 4. Elimina un proveedor
    def eliminar(self, id_proveedor):
        try:
            cursor = self.connection.cursor()
            cursor.callproc("PK_PROVEEDORES.ELIMINAR_PROVEEDOR", [id_proveedor])
            self.connection.commit()
            cursor.close()
            print("Proveedor eliminado con éxito.")
        except Exception as e:
            print(f"Error al eliminar proveedor: {e}")

    # 5. Cambia el estado de un proveedor
    # NOTA: requiere el procedimiento PK_PROVEEDORES.SP_ACTUALIZAR_ESTADO_PROVEEDOR
    def cambiar_estado(self, id_proveedor, estado):
        try:
            cursor = self.connection.cursor()
            cursor.callproc("PK_PROVEEDORES.SP_ACTUALIZAR_ESTADO_PROVEEDOR", [id_proveedor, estado])
            self.connection.commit()
            cursor.close()
            print("Estado del proveedor actualizado con éxito.")
        except Exception as e:
            print(f"Error al cambiar estado: {e}")

    # 6. Ver productos por proveedor (usa vista)
    def mostrar_productos_por_proveedor(self):
        try:
            cursor = self.connection.cursor()
            resultado = cursor.var(oracledb.CURSOR)
            cursor.callproc("PK_PROVEEDORES.mostrar_vw_productos_proveedores", [resultado])
            filas = resultado.getvalue().fetchall()
            cursor.close()
            return filas
        except Exception as e:
            print(f"Error al mostrar productos por proveedor: {e}")
            return []

    # 7. Contar productos de un proveedor (es una FUNCTION, se llama con callfunc)
    def contar_productos(self, id_proveedor):
        try:
            cursor = self.connection.cursor()
            resultado = cursor.callfunc("PK_PROVEEDORES.cantidad_productos_proveedor",
                                         oracledb.NUMBER, [id_proveedor])
            cursor.close()
            return resultado
        except Exception as e:
            print(f"Error al contar productos: {e}")
            return 0

    # 8. Ver estado de un proveedor (es una FUNCTION, se llama con callfunc)
    def ver_estado(self, id_proveedor):
        try:
            cursor = self.connection.cursor()
            resultado = cursor.callfunc("PK_PROVEEDORES.estado_proveedor",
                                         oracledb.STRING, [id_proveedor])
            cursor.close()
            return resultado
        except Exception as e:
            print(f"Error al ver estado: {e}")
            return "Error"