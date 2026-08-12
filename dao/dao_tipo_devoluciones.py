# dao/dao_tipo_devoluciones.py
# Descripción: DAO para gestionar tipos de devoluciones

import oracledb

class DAOTipoDevoluciones:
    def __init__(self, connection):
        self.connection = connection

    def listar_todos(self):
        """Lista todos los tipos de devolución usando PK_TIPO_DEVOLUCIONES.SP_LISTAR_TIPOS_DEVOLUCION."""
        cursor = None
        try:
            cursor = self.connection.cursor()
            print(">> Ejecutando PK_TIPO_DEVOLUCIONES.SP_LISTAR_TIPOS_DEVOLUCION...")
            resultado = cursor.var(oracledb.CURSOR)
            cursor.callproc("PK_TIPO_DEVOLUCIONES.SP_LISTAR_TIPOS_DEVOLUCION", [resultado])
            filas = resultado.getvalue().fetchall()
            print(f"   Se encontraron {len(filas)} tipo(s) de devolución.")
            return filas
        except oracledb.Error as error:
            print(f"Error al listar tipos de devolución: {error}")
            return []
        finally:
            if cursor is not None:
                cursor.close()

    def registrar(self, tipo_devolucion):
        """Registra un tipo de devolución usando PK_TIPO_DEVOLUCIONES.SP_REGISTRAR_TIPO_DEVOLUCION."""
        cursor = None
        try:
            cursor = self.connection.cursor()
            cursor.callproc("PK_TIPO_DEVOLUCIONES.SP_REGISTRAR_TIPO_DEVOLUCION", [tipo_devolucion])
            self.connection.commit()
            print("   Tipo de devolución registrado con éxito.")
            return True
        except oracledb.Error as error:
            print(f"Error al registrar tipo de devolución: {error}")
            return False
        finally:
            if cursor is not None:
                cursor.close()

    def actualizar(self, id_tipo_devolucion, tipo_devolucion):
        """Actualiza un tipo de devolución usando PK_TIPO_DEVOLUCIONES.SP_ACTUALIZAR_TIPO_DEVOLUCION (admite NVL)."""
        cursor = None
        try:
            cursor = self.connection.cursor()
            cursor.callproc("PK_TIPO_DEVOLUCIONES.SP_ACTUALIZAR_TIPO_DEVOLUCION", [id_tipo_devolucion, tipo_devolucion])
            self.connection.commit()
            print("   Tipo de devolución actualizado con éxito.")
            return True
        except oracledb.Error as error:
            print(f"Error al actualizar tipo de devolución: {error}")
            return False
        finally:
            if cursor is not None:
                cursor.close()

    def eliminar(self, id_tipo_devolucion):
        """Elimina un tipo de devolución usando PK_TIPO_DEVOLUCIONES.SP_ELIMINAR_TIPO_DEVOLUCION
        (el procedimiento ya valida que no tenga devoluciones asociadas)."""
        cursor = None
        try:
            cursor = self.connection.cursor()
            cursor.callproc("PK_TIPO_DEVOLUCIONES.SP_ELIMINAR_TIPO_DEVOLUCION", [id_tipo_devolucion])
            self.connection.commit()
            print("   Tipo de devolución eliminado con éxito.")
            return True
        except oracledb.Error as error:
            print(f"Error al eliminar tipo de devolución: {error}")
            return False
        finally:
            if cursor is not None:
                cursor.close()