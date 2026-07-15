# dao/dao_productos.py
# Descripción: DAO para gestionar productos

import oracledb

class DAOProductos:
    def __init__(self, connection):
        self.connection = connection

    def listar_todos(self):
        cursor = None
        try:
            cursor = self.connection.cursor()
            print(">> Consultando productos...")
            cursor.execute("""
                SELECT 
                    ID_Producto,
                    Nombre,
                    Descripcion,
                    Precio_Venta,
                    Precio_Costo,
                    ID_Categoria
                FROM Productos
                ORDER BY Nombre
            """)
            rows = cursor.fetchall()
            print(f"   Se encontraron {len(rows)} producto(s).")
            return rows
        except oracledb.Error as error:
            print(f"Error al listar productos: {error}")
            return []
        finally:
            if cursor is not None:
                cursor.close()

    def buscar_por_id(self, id_producto):
        cursor = None
        try:
            cursor = self.connection.cursor()
            cursor.execute("""
                SELECT 
                    ID_Producto,
                    Nombre,
                    Descripcion,
                    Precio_Venta,
                    Precio_Costo,
                    ID_Categoria
                FROM Productos
                WHERE ID_Producto = :id_producto
            """, {'id_producto': id_producto})
            row = cursor.fetchone()
            if row:
                print(f"   Producto encontrado: {row[1]}")
            else:
                print(f"   No se encontró el producto con ID {id_producto}")
            return row
        except oracledb.Error as error:
            print(f"Error al buscar producto: {error}")
            return None
        finally:
            if cursor is not None:
                cursor.close()

    def listar_por_categoria(self, id_categoria):
        cursor = None
        try:
            cursor = self.connection.cursor()
            print(f">> Consultando productos de categoría {id_categoria}...")
            cursor.execute("""
                SELECT 
                    ID_Producto,
                    Nombre,
                    Precio_Venta,
                    Precio_Costo
                FROM Productos
                WHERE ID_Categoria = :id_categoria
                ORDER BY Nombre
            """, {'id_categoria': id_categoria})
            rows = cursor.fetchall()
            print(f"   Se encontraron {len(rows)} producto(s) en esta categoría.")
            return rows
        except oracledb.Error as error:
            print(f"Error al listar productos por categoría: {error}")
            return []
        finally:
            if cursor is not None:
                cursor.close()
    

    def registrar(self, nombre, descripcion, precio_venta, precio_costo, fecha_entrada, id_proveedor, id_categoria):
        """Registra un nuevo producto usando SP_REGISTRAR_PRODUCTO."""
        cursor = None
        try:
            cursor = self.connection.cursor()
            print(f">> Ejecutando SP_REGISTRAR_PRODUCTO en la base de datos...")
            print(f"   Producto: {nombre}, Precio Venta: {precio_venta}")
            
            cursor.callproc("SP_REGISTRAR_PRODUCTO", [
                nombre,
                descripcion,
                precio_venta,
                precio_costo,
                fecha_entrada,
                id_proveedor,
                id_categoria
            ])
            self.connection.commit()
            cursor.close()
            print("   Producto registrado con éxito.")
        except oracledb.Error as error:
            print(f"Error al registrar producto: {error}")
            return False
        finally:
            if cursor is not None:
                cursor.close()
        return True