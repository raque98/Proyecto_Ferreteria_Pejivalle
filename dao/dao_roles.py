# dao/dao_roles.py
# Descripción: DAO para gestionar roles de trabajadores

import oracledb

class DAORoles:
    def __init__(self, connection):
        self.connection = connection

    def listar_todos(self):
        """Lista todos los roles."""
        cursor = None
        try:
            cursor = self.connection.cursor()
            print(">> Consultando roles...")
            cursor.execute("""
                SELECT 
                    ID_Rol,
                    Rol
                FROM Roles
                ORDER BY Rol
            """)
            rows = cursor.fetchall()
            cursor.close()
            print(f"   Se encontraron {len(rows)} rol(es).")
            return rows
        except oracledb.Error as error:
            print(f"Error al listar roles: {error}")
            return []
        finally:
            if cursor is not None:
                cursor.close()

    def buscar_por_id(self, id_rol):
        """Busca un rol por su ID."""
        cursor = None
        try:
            cursor = self.connection.cursor()
            cursor.execute("""
                SELECT 
                    ID_Rol,
                    Rol
                FROM Roles
                WHERE ID_Rol = :id_rol
            """, {'id_rol': id_rol})
            row = cursor.fetchone()
            cursor.close()
            if row:
                print(f"   Rol encontrado: {row[1]}")
            else:
                print(f"   No se encontró el rol con ID {id_rol}")
            return row
        except oracledb.Error as error:
            print(f"Error al buscar rol: {error}")
            return None
        finally:
            if cursor is not None:
                cursor.close()