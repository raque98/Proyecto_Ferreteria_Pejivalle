# dao/dao_roles.py
# Descripción: DAO para gestionar roles de trabajadores

import oracledb

class DAORoles:
    def __init__(self, connection):
        self.connection = connection

    def listar_todos(self):
        """Lista todos los roles usando PK_ROLES.SP_LISTAR_ROLES."""
        cursor = None
        try:
            cursor = self.connection.cursor()
            print(">> Ejecutando PK_ROLES.SP_LISTAR_ROLES...")
            resultado = cursor.var(oracledb.CURSOR)
            cursor.callproc("PK_ROLES.SP_LISTAR_ROLES", [resultado])
            filas = resultado.getvalue().fetchall()
            print(f"   Se encontraron {len(filas)} rol(es).")
            return filas
        except oracledb.Error as error:
            print(f"Error al listar roles: {error}")
            return []
        finally:
            if cursor is not None:
                cursor.close()

    def registrar(self, rol):
        """Registra un rol usando PK_ROLES.SP_REGISTRAR_ROL."""
        cursor = None
        try:
            cursor = self.connection.cursor()
            cursor.callproc("PK_ROLES.SP_REGISTRAR_ROL", [rol])
            self.connection.commit()
            print("   Rol registrado con éxito.")
            return True
        except oracledb.Error as error:
            print(f"Error al registrar rol: {error}")
            return False
        finally:
            if cursor is not None:
                cursor.close()

    def actualizar(self, id_rol, rol):
        """Actualiza un rol usando PK_ROLES.SP_ACTUALIZAR_ROL (admite NVL)."""
        cursor = None
        try:
            cursor = self.connection.cursor()
            cursor.callproc("PK_ROLES.SP_ACTUALIZAR_ROL", [id_rol, rol])
            self.connection.commit()
            print("   Rol actualizado con éxito.")
            return True
        except oracledb.Error as error:
            print(f"Error al actualizar rol: {error}")
            return False
        finally:
            if cursor is not None:
                cursor.close()

    def eliminar(self, id_rol):
        """Elimina un rol usando PK_ROLES.SP_ELIMINAR_ROL
        (el procedimiento ya valida que no tenga trabajadores asociados)."""
        cursor = None
        try:
            cursor = self.connection.cursor()
            cursor.callproc("PK_ROLES.SP_ELIMINAR_ROL", [id_rol])
            self.connection.commit()
            print("   Rol eliminado con éxito.")
            return True
        except oracledb.Error as error:
            print(f"Error al eliminar rol: {error}")
            return False
        finally:
            if cursor is not None:
                cursor.close()