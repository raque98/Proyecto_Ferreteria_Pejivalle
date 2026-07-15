# dao/dao_trabajadores.py
# Descripción: DAO para gestionar trabajadores

import oracledb

class DAOTrabajadores:
    def __init__(self, connection):
        self.connection = connection

    def listar_todos(self):
        cursor = None
        try:
            cursor = self.connection.cursor()
            print(">> Consultando trabajadores...")
            cursor.execute("""
                SELECT 
                    ID_Trabajador,
                    Nombre,
                    Apellido1,
                    Apellido2,
                    Correo_Electronico,
                    Estado,
                    ID_Sucursal
                FROM Trabajadores
                WHERE Estado = 'Activo'
                ORDER BY Nombre
            """)
            rows = cursor.fetchall()
            print(f"   Se encontraron {len(rows)} trabajador(es).")
            return rows
        except oracledb.Error as error:
            print(f"Error al listar trabajadores: {error}")
            return []
        finally:
            if cursor is not None:
                cursor.close()

    def buscar_por_id(self, id_trabajador):
        cursor = None
        try:
            cursor = self.connection.cursor()
            cursor.execute("""
                SELECT 
                    ID_Trabajador,
                    Nombre,
                    Apellido1,
                    Apellido2,
                    Correo_Electronico,
                    Estado,
                    ID_Sucursal,
                    ID_Turno,
                    ID_Rol
                FROM Trabajadores
                WHERE ID_Trabajador = :id_trabajador
            """, {'id_trabajador': id_trabajador})
            row = cursor.fetchone()
            if row:
                print(f"   Trabajador encontrado: {row[1]} {row[2]}")
            else:
                print(f"   No se encontró el trabajador con ID {id_trabajador}")
            return row
        except oracledb.Error as error:
            print(f"Error al buscar trabajador: {error}")
            return None
        finally:
            if cursor is not None:
                cursor.close()

    def listar_por_sucursal(self, id_sucursal):
        cursor = None
        try:
            cursor = self.connection.cursor()
            print(f">> Consultando trabajadores de sucursal {id_sucursal}...")
            cursor.execute("""
                SELECT 
                    ID_Trabajador,
                    Nombre,
                    Apellido1,
                    Apellido2,
                    Correo_Electronico,
                    Estado
                FROM Trabajadores
                WHERE ID_Sucursal = :id_sucursal
                  AND Estado = 'Activo'
                ORDER BY Nombre
            """, {'id_sucursal': id_sucursal})
            rows = cursor.fetchall()
            print(f"   Se encontraron {len(rows)} trabajador(es) en esta sucursal.")
            return rows
        except oracledb.Error as error:
            print(f"Error al listar trabajadores por sucursal: {error}")
            return []
        finally:
            if cursor is not None:
                cursor.close()