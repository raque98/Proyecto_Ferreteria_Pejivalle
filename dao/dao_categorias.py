# dao/dao_categorias.py
# Descripción: DAO para gestionar categorías de productos

import oracledb

class DAOCategorias:
    def __init__(self, connection):
        self.connection = connection

    def listar_todas(self):
        """Lista todas las categorías usando PK_CATEGORIA.SP_LISTAR_CATEGORIAS."""
        cursor = None
        try:
            cursor = self.connection.cursor()
            print(">> Ejecutando PK_CATEGORIA.SP_LISTAR_CATEGORIAS...")
            resultado = cursor.var(oracledb.CURSOR)
            cursor.callproc("PK_CATEGORIA.SP_LISTAR_CATEGORIAS", [resultado])
            filas = resultado.getvalue().fetchall()
            print(f"   Se encontraron {len(filas)} categoría(s).")
            return filas
        except oracledb.Error as error:
            print(f"Error al listar categorías: {error}")
            return []
        finally:
            if cursor is not None:
                cursor.close()