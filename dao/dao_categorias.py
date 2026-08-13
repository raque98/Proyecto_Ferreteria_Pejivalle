# dao/dao_categorias.py
# Descripción: DAO para gestionar categorías de productos

import oracledb

class DAOCategorias:
    def __init__(self, connection):
        self.connection = connection

    def listar_todas(self):
        """Lista todas las categorías usando PK_CATEGORIA.SP_LISTAR_CATEGORIAS."""
        cursor = None
        result_cursor = None
        try:
            cursor = self.connection.cursor()
            print(">> Ejecutando PK_CATEGORIA.SP_LISTAR_CATEGORIAS...")
            resultado = cursor.var(oracledb.CURSOR)
            cursor.callproc("PK_CATEGORIA.SP_LISTAR_CATEGORIAS", [resultado])
            result_cursor = resultado.getvalue()

            if result_cursor is None:
                print("   Error: El cursor devuelto es NULL")
                return []

            filas = result_cursor.fetchall()
            print(f"   Se encontraron {len(filas)} categoría(s).")
            return filas
        except oracledb.Error as error:
            print(f"Error al listar categorías: {error}")
            return []
        finally:
            if result_cursor is not None:
                try:
                    result_cursor.close()
                except:
                    pass
            if cursor is not None:
                cursor.close()

    def registrar(self, nombre):
        """Registra una categoría usando PK_CATEGORIA.SP_REGISTRAR_CATEGORIA."""
        cursor = None
        try:
            cursor = self.connection.cursor()
            cursor.callproc("PK_CATEGORIA.SP_REGISTRAR_CATEGORIA", [nombre])
            self.connection.commit()
            print("   Categoría registrada con éxito.")
            return True
        except oracledb.Error as error:
            print(f"Error al registrar categoría: {error}")
            self.connection.rollback()
            return False
        finally:
            if cursor is not None:
                cursor.close()

    def actualizar(self, id_categoria, nombre):
        """Actualiza una categoría usando PK_CATEGORIA.SP_ACTUALIZAR_CATEGORIA (admite NVL)."""
        cursor = None
        try:
            cursor = self.connection.cursor()
            cursor.callproc("PK_CATEGORIA.SP_ACTUALIZAR_CATEGORIA", [id_categoria, nombre])
            self.connection.commit()
            print("   Categoría actualizada con éxito.")
            return True
        except oracledb.Error as error:
            print(f"Error al actualizar categoría: {error}")
            self.connection.rollback()
            return False
        finally:
            if cursor is not None:
                cursor.close()

    def eliminar(self, id_categoria):
        """Elimina una categoría usando PK_CATEGORIA.SP_ELIMINAR_CATEGORIA
        (el procedimiento ya valida que no tenga productos asociados)."""
        cursor = None
        try:
            cursor = self.connection.cursor()
            cursor.callproc("PK_CATEGORIA.SP_ELIMINAR_CATEGORIA", [id_categoria])
            self.connection.commit()
            print("   Categoría eliminada con éxito.")
            return True
        except oracledb.Error as error:
            print(f"Error al eliminar categoría: {error}")
            self.connection.rollback()
            return False
        finally:
            if cursor is not None:
                cursor.close()