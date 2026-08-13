# dao/dao_productos.py
# Descripción: DAO para gestionar productos

import oracledb

class DAOProductos:
    def __init__(self, connection):
        self.connection = connection

    def listar_todos(self):
        """Lista todos los productos usando PK_PRODUCTOS.SP_LISTAR_PRODUCTOS."""
        cursor = None
        result_cursor = None
        try:
            cursor = self.connection.cursor()
            print(">> Ejecutando PK_PRODUCTOS.SP_LISTAR_PRODUCTOS...")
            resultado = cursor.var(oracledb.CURSOR)
            cursor.callproc("PK_PRODUCTOS.SP_LISTAR_PRODUCTOS", [resultado])
            result_cursor = resultado.getvalue()

            if result_cursor is None:
                print("   Error: El cursor devuelto es NULL")
                return []

            filas = result_cursor.fetchall()
            print(f"   Se encontraron {len(filas)} producto(s).")
            return filas

        except oracledb.Error as error:
            print(f"Error al listar productos: {error}")
            return []
        finally:
            if result_cursor is not None:
                try:
                    result_cursor.close()
                except:
                    pass
            if cursor is not None:
                cursor.close()

    def buscar_por_id(self, id_producto):
        """Busca un producto por ID usando PK_PRODUCTOS.SP_BUSCAR_PRODUCTO_POR_ID.

        NOTA: se usa execute() con bloque PL/SQL explícito en vez de callproc()
        porque callproc() se queda colgado en el paso de "describe" cuando el
        procedimiento pertenece a un paquete y combina un IN con un SYS_REFCURSOR
        de salida (bug conocido de python-oracledb en modo thin).
        """
        cursor = None
        result_cursor = None
        try:
            cursor = self.connection.cursor()
            print(f">> Ejecutando PK_PRODUCTOS.SP_BUSCAR_PRODUCTO_POR_ID con ID: {id_producto}...")
            resultado = cursor.var(oracledb.CURSOR)

            cursor.execute(
                """
                BEGIN
                    PK_PRODUCTOS.SP_BUSCAR_PRODUCTO_POR_ID(:id_producto, :cur);
                END;
                """,
                id_producto=str(id_producto),
                cur=resultado
            )

            result_cursor = resultado.getvalue()
            if result_cursor is None:
                print("   Error: El cursor devuelto es NULL")
                return None

            fila = result_cursor.fetchone()

            if fila:
                print(f"   Producto encontrado: {fila[1]}")
                return fila
            else:
                print(f"   No se encontró el producto con ID {id_producto}")
                return None

        except oracledb.Error as error:
            print(f"Error al buscar producto: {error}")
            return None
        finally:
            if result_cursor is not None:
                try:
                    result_cursor.close()
                except:
                    pass
            if cursor is not None:
                cursor.close()

    def listar_por_categoria(self, id_categoria):
        """Lista productos de una categoría usando PK_PRODUCTOS.SP_LISTAR_PRODUCTOS_POR_CATEGORIA.

        NOTA: usa execute() en vez de callproc() por el mismo motivo que buscar_por_id.
        """
        cursor = None
        result_cursor = None
        try:
            cursor = self.connection.cursor()
            print(f">> Consultando productos de categoría {id_categoria}...")
            resultado = cursor.var(oracledb.CURSOR)

            cursor.execute(
                """
                BEGIN
                    PK_PRODUCTOS.SP_LISTAR_PRODUCTOS_POR_CATEGORIA(:id_categoria, :cur);
                END;
                """,
                id_categoria=str(id_categoria),
                cur=resultado
            )

            result_cursor = resultado.getvalue()
            if result_cursor is None:
                print("   Error: El cursor devuelto es NULL")
                return []

            filas = result_cursor.fetchall()
            print(f"   Se encontraron {len(filas)} producto(s) en esta categoría.")
            return filas

        except oracledb.Error as error:
            print(f"Error al listar productos por categoría: {error}")
            return []
        finally:
            if result_cursor is not None:
                try:
                    result_cursor.close()
                except:
                    pass
            if cursor is not None:
                cursor.close()

    def registrar(self, nombre, descripcion, precio_venta, precio_costo, fecha_entrada, id_proveedor, id_categoria):
        """Registra un nuevo producto usando PK_PRODUCTOS.SP_REGISTRAR_PRODUCTO."""
        cursor = None
        try:
            cursor = self.connection.cursor()
            print(">> Ejecutando PK_PRODUCTOS.SP_REGISTRAR_PRODUCTO...")
            print(f"   Producto: {nombre}, Precio Venta: {precio_venta}")

            cursor.callproc("PK_PRODUCTOS.SP_REGISTRAR_PRODUCTO", [
                nombre,
                descripcion,
                precio_venta,
                precio_costo,
                fecha_entrada,
                id_proveedor,
                id_categoria
            ])
            self.connection.commit()
            print("   Producto registrado con éxito.")
            return True

        except oracledb.Error as error:
            print(f"Error al registrar producto: {error}")
            self.connection.rollback()
            return False
        finally:
            if cursor is not None:
                cursor.close()

    def actualizar(self, id_producto, nombre=None, descripcion=None, precio_venta=None,
                   precio_costo=None, fecha_entrada=None, id_proveedor=None, id_categoria=None):
        """Actualiza un producto usando PK_PRODUCTOS.SP_ACTUALIZAR_PRODUCTO."""
        cursor = None
        try:
            cursor = self.connection.cursor()
            cursor.callproc("PK_PRODUCTOS.SP_ACTUALIZAR_PRODUCTO", [
                id_producto, nombre, descripcion, precio_venta, precio_costo, fecha_entrada, id_proveedor, id_categoria
            ])
            self.connection.commit()
            print("   Producto actualizado con éxito.")
            return True

        except oracledb.Error as error:
            print(f"Error al actualizar producto: {error}")
            self.connection.rollback()
            return False
        finally:
            if cursor is not None:
                cursor.close()

    def eliminar(self, id_producto):
        """Elimina un producto usando PK_PRODUCTOS.SP_ELIMINAR_PRODUCTO."""
        cursor = None
        try:
            cursor = self.connection.cursor()
            cursor.callproc("PK_PRODUCTOS.SP_ELIMINAR_PRODUCTO", [id_producto])
            self.connection.commit()
            print("   Producto eliminado con éxito.")
            return True

        except oracledb.Error as error:
            print(f"Error al eliminar producto: {error}")
            self.connection.rollback()
            return False
        finally:
            if cursor is not None:
                cursor.close()