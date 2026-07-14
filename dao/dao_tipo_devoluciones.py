# dao/dao_tipo_devoluciones.py
# Descripción: DAO para gestionar tipos de devoluciones

import oracledb

class DAOTipoDevoluciones:
    def __init__(self, connection):
        self.connection = connection

    def listar_todos(self):
        cursor = None
        try:
            cursor = self.connection.cursor()
            print(">> Consultando tipos de devolución...")
            cursor.execute("""
                SELECT 
                    ID_Tipo_Devolucion,
                    Tipo_Devolucion
                FROM Tipo_Devoluciones
                ORDER BY Tipo_Devolucion
            """)
            rows = cursor.fetchall()
            print(f"   Se encontraron {len(rows)} tipo(s) de devolución.")
            return rows
        except oracledb.Error as error:
            print(f"Error al listar tipos de devolución: {error}")
            return []
        finally:
            if cursor is not None:
                cursor.close()

    def buscar_por_id(self, id_tipo_devolucion):
        cursor = None
        try:
            cursor = self.connection.cursor()
            cursor.execute("""
                SELECT 
                    ID_Tipo_Devolucion,
                    Tipo_Devolucion
                FROM Tipo_Devoluciones
                WHERE ID_Tipo_Devolucion = :id_tipo_devolucion
            """, {'id_tipo_devolucion': id_tipo_devolucion})
            row = cursor.fetchone()
            if row:
                print(f"   Tipo de devolución encontrado: {row[1]}")
            else:
                print(f"   No se encontró el tipo de devolución con ID {id_tipo_devolucion}")
            return row
        except oracledb.Error as error:
            print(f"Error al buscar tipo de devolución: {error}")
            return None
        finally:
            if cursor is not None:
                cursor.close()