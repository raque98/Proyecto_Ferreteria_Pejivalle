# dao/dao_turnos.py
# Descripción: DAO para gestionar turnos de trabajadores

import oracledb

class DAOTurnos:
    def __init__(self, connection):
        self.connection = connection

    def listar_todos(self):
        """Lista todos los turnos."""
        cursor = None
        try:
            cursor = self.connection.cursor()
            print(">> Consultando turnos...")
            cursor.execute("""
                SELECT 
                    ID_Turno,
                    Turno
                FROM Turnos
                ORDER BY Turno
            """)
            rows = cursor.fetchall()
            cursor.close()
            print(f"   Se encontraron {len(rows)} turno(s).")
            return rows
        except oracledb.Error as error:
            print(f"Error al listar turnos: {error}")
            return []
        finally:
            if cursor is not None:
                cursor.close()

    def buscar_por_id(self, id_turno):
        """Busca un turno por su ID."""
        cursor = None
        try:
            cursor = self.connection.cursor()
            cursor.execute("""
                SELECT 
                    ID_Turno,
                    Turno
                FROM Turnos
                WHERE ID_Turno = :id_turno
            """, {'id_turno': id_turno})
            row = cursor.fetchone()
            cursor.close()
            if row:
                print(f"   Turno encontrado: {row[1]}")
            else:
                print(f"   No se encontró el turno con ID {id_turno}")
            return row
        except oracledb.Error as error:
            print(f"Error al buscar turno: {error}")
            return None
        finally:
            if cursor is not None:
                cursor.close()