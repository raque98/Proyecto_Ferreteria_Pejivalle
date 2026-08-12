# dao/dao_turnos.py
# Descripción: DAO para gestionar turnos de trabajadores

import oracledb

class DAOTurnos:
    def __init__(self, connection):
        self.connection = connection

    def listar_todos(self):
        """Lista todos los turnos usando PK_TURNOS.SP_LISTAR_TURNOS."""
        cursor = None
        try:
            cursor = self.connection.cursor()
            print(">> Ejecutando PK_TURNOS.SP_LISTAR_TURNOS...")
            resultado = cursor.var(oracledb.CURSOR)
            cursor.callproc("PK_TURNOS.SP_LISTAR_TURNOS", [resultado])
            filas = resultado.getvalue().fetchall()
            print(f"   Se encontraron {len(filas)} turno(s).")
            return filas
        except oracledb.Error as error:
            print(f"Error al listar turnos: {error}")
            return []
        finally:
            if cursor is not None:
                cursor.close()

    def registrar(self, turno):
        """Registra un turno usando PK_TURNOS.SP_REGISTRAR_TURNO."""
        cursor = None
        try:
            cursor = self.connection.cursor()
            cursor.callproc("PK_TURNOS.SP_REGISTRAR_TURNO", [turno])
            self.connection.commit()
            print("   Turno registrado con éxito.")
            return True
        except oracledb.Error as error:
            print(f"Error al registrar turno: {error}")
            return False
        finally:
            if cursor is not None:
                cursor.close()

    def actualizar(self, id_turno, turno):
        """Actualiza un turno usando PK_TURNOS.SP_ACTUALIZAR_TURNO (admite NVL)."""
        cursor = None
        try:
            cursor = self.connection.cursor()
            cursor.callproc("PK_TURNOS.SP_ACTUALIZAR_TURNO", [id_turno, turno])
            self.connection.commit()
            print("   Turno actualizado con éxito.")
            return True
        except oracledb.Error as error:
            print(f"Error al actualizar turno: {error}")
            return False
        finally:
            if cursor is not None:
                cursor.close()

    def eliminar(self, id_turno):
        """Elimina un turno usando PK_TURNOS.SP_ELIMINAR_TURNO
        (el procedimiento ya valida que no tenga trabajadores asociados)."""
        cursor = None
        try:
            cursor = self.connection.cursor()
            cursor.callproc("PK_TURNOS.SP_ELIMINAR_TURNO", [id_turno])
            self.connection.commit()
            print("   Turno eliminado con éxito.")
            return True
        except oracledb.Error as error:
            print(f"Error al eliminar turno: {error}")
            return False
        finally:
            if cursor is not None:
                cursor.close()