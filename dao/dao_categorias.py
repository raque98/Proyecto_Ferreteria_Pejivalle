# dao/dao_categorias.py
# Descripción: DAO para gestionar categorías de productos

import oracledb

class DAOCategorias:
    def __init__(self, connection):
        self.connection = connection

    def listar_todas(self):
        """Lista todas las categorías."""
        cursor = None
        try:
            cursor = self.connection.cursor()
            print(">> Consultando categorías...")
            cursor.execute("""
                SELECT 
                    ID_Categoria,
                    Nombre
                FROM Categoria
                ORDER BY Nombre
            """)
            rows = cursor.fetchall()
            cursor.close()
            print(f"   Se encontraron {len(rows)} categoría(s).")
            return rows
        except oracledb.Error as error:
            print(f"Error al listar categorías: {error}")
            return []
        finally:
            if cursor is not None:
                cursor.close()

    def buscar_por_id(self, id_categoria):
        """Busca una categoría por su ID."""
        cursor = None
        try:
            cursor = self.connection.cursor()
            cursor.execute("""
                SELECT 
                    ID_Categoria,
                    Nombre
                FROM Categoria
                WHERE ID_Categoria = :id_categoria
            """, {'id_categoria': id_categoria})
            row = cursor.fetchone()
            cursor.close()
            if row:
                print(f"   Categoría encontrada: {row[1]}")
            else:
                print(f"   No se encontró la categoría con ID {id_categoria}")
            return row
        except oracledb.Error as error:
            print(f"Error al buscar categoría: {error}")
            return None
        finally:
            if cursor is not None:
                cursor.close()