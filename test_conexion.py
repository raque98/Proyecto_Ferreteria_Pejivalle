from config.db_connection import obtener_conexion

try:
    conexion = obtener_conexion()
    cursor = conexion.cursor()
    cursor.execute("SELECT 1 FROM DUAL")
    resultado = cursor.fetchone()

    print("Conexión exitosa. Resultado de prueba:", resultado)

    cursor.close()
    conexion.close()

except Exception as error:
    print("Error al conectar con la base de datos:")
    print(error)