# dao/dao_sucursales.py
# Descripción: DAO para gestionar sucursales

import oracledb

class DAOSucursales:
    def __init__(self, connection):
        self.connection = connection

    def listar_todas(self):
        cursor = None
        try:
            cursor = self.connection.cursor()
            print(">> Consultando sucursales...")
            cursor.execute("""
                SELECT 
                    ID_Sucursal,
                    Nombre,
                    Estado
                FROM Sucursales
                WHERE Estado = 'Activo'
                ORDER BY Nombre
            """)
            rows = cursor.fetchall()
            print(f"   Se encontraron {len(rows)} sucursal(es).")
            return rows
        except oracledb.Error as error:
            print(f"Error al listar sucursales: {error}")
            return []
        finally:
            if cursor is not None:
                cursor.close()

    def buscar_por_id(self, id_sucursal):
        cursor = None
        try:
            cursor = self.connection.cursor()
            cursor.execute("""
                SELECT 
                    ID_Sucursal,
                    Nombre,
                    Estado
                FROM Sucursales
                WHERE ID_Sucursal = :id_sucursal
            """, {'id_sucursal': id_sucursal})
            row = cursor.fetchone()
            if row:
                print(f"   Sucursal encontrada: {row[1]}")
            else:
                print(f"   No se encontró la sucursal con ID {id_sucursal}")
            return row
        except oracledb.Error as error:
            print(f"Error al buscar sucursal: {error}")
            return None
        finally:
            if cursor is not None:
                cursor.close()

    def listar_todas_con_direccion(self):
        cursor = None
        try:
            cursor = self.connection.cursor()
            print(">> Consultando sucursales con dirección...")
            cursor.execute("""
                SELECT 
                    s.ID_Sucursal,
                    s.Nombre,
                    s.Estado,
                    d.Detalle AS Direccion
                FROM Sucursales s
                JOIN Sucursales_Direcciones sd ON s.ID_Sucursal = sd.ID_Sucursal
                JOIN Direcciones d ON sd.ID_Direccion = d.ID_Direccion
                WHERE s.Estado = 'Activo'
                ORDER BY s.Nombre
            """)
            rows = cursor.fetchall()
            print(f"   Se encontraron {len(rows)} sucursal(es) con dirección.")
            return rows
        except oracledb.Error as error:
            print(f"Error al listar sucursales con dirección: {error}")
            return []
        finally:
            if cursor is not None:
                cursor.close()

    def registrar_inventario(self, cantidad, id_sucursal, id_producto):
        cursor = None
        try:
            cursor = self.connection.cursor()
            print(f">> Ejecutando SP_REGISTRAR_INVENTARIO en la base de datos...")
            print(f"   Producto: {id_producto}, Cantidad: {cantidad}, Sucursal: {id_sucursal}")
            
            cursor.callproc("SP_REGISTRAR_INVENTARIO", [
                cantidad,
                id_sucursal,
                id_producto
            ])
            self.connection.commit()
            print("   Inventario registrado con éxito.")
            return True
        except oracledb.Error as error:
            print(f"Error al registrar inventario: {error}")
            return False
        finally:
            if cursor is not None:
                cursor.close()

    def listar_inventario_por_sucursal(self, id_sucursal):
        cursor = None
        try:
            cursor = self.connection.cursor()
            print(f">> Consultando inventario de sucursal {id_sucursal}...")
            cursor.execute("""
                SELECT 
                    ps.ID_PRODUCTOS_SUCURSALES,
                    ps.CANTIDAD,
                    p.NOMBRE AS PRODUCTO,
                    p.ID_PRODUCTO
                FROM PRODUCTOS_SUCURSALES ps
                JOIN PRODUCTOS p ON p.ID_PRODUCTO = ps.ID_PRODUCTO
                WHERE ps.ID_SUCURSAL = :id_sucursal
                ORDER BY p.NOMBRE
            """, {'id_sucursal': id_sucursal})
            rows = cursor.fetchall()
            print(f"   Se encontraron {len(rows)} registro(s) de inventario.")
            return rows
        except oracledb.Error as error:
            print(f"Error al listar inventario: {error}")
            return []
        finally:
            if cursor is not None:
                cursor.close()