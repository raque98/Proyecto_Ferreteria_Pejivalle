"""
DAO (Data Access Object) del modulo Tipo_Pagos. Aqui SOLO se llaman procedimientos de la base de datos.
"""

import oracledb
from config.db_connection import obtener_conexion


def registrar_tipo_pago(nombre_metodo):
    """
    Llama a SP_REGISTRAR_TIPO_PAGO para insertar un nuevo método de pago.
    """
    conexion = obtener_conexion()
    cursor = conexion.cursor()

    cursor.callproc("SP_REGISTRAR_TIPO_PAGO", [nombre_metodo])

    cursor.close()
    conexion.close()


def listar_tipos_pago():
    """
    Llama a SP_LISTAR_TIPOS_PAGO y retorna la lista de metodos de pago como una lista de tuplas (id, nombre).
    """
    conexion = obtener_conexion()
    cursor = conexion.cursor()

    cursor_salida = cursor.var(oracledb.CURSOR)
    cursor.callproc("SP_LISTAR_TIPOS_PAGO", [cursor_salida])

    resultado_cursor = cursor_salida.getvalue()
    filas = resultado_cursor.fetchall()

    cursor.close()
    conexion.close()

    return filas