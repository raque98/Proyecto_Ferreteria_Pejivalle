# dao/dao_trabajadores.py
# Descripción: DAO para gestionar trabajadores

import oracledb

class DAOTrabajadores:
    def __init__(self, connection):
        self.connection = connection

    def listar_todos(self):
        """Lista trabajadores usando PK_TRABAJADORES.PD_CONSULTAR_VW_TRABAJADORES."""
        cursor = None
        result_cursor = None
        try:
            cursor = self.connection.cursor()
            print(">> Ejecutando PK_TRABAJADORES.PD_CONSULTAR_VW_TRABAJADORES...")
            resultado = cursor.var(oracledb.CURSOR)
            cursor.callproc("PK_TRABAJADORES.PD_CONSULTAR_VW_TRABAJADORES", [resultado])

            result_cursor = resultado.getvalue()
            if result_cursor is None:
                print("   Error: El cursor devuelto es NULL")
                return []

            filas = result_cursor.fetchall()
            print(f"   Se encontraron {len(filas)} trabajador(es).")
            return filas

        except oracledb.Error as error:
            print(f"Error al listar trabajadores: {error}")
            return []
        finally:
            if result_cursor is not None:
                try:
                    result_cursor.close()
                except:
                    pass
            if cursor is not None:
                cursor.close()

    def buscar_por_id(self, id_trabajador):
        """Busca un trabajador por ID usando PK_TRABAJADORES.PD_BUSCAR_TRABAJADOR_POR_ID.

        NOTA: se usa execute() con bloque PL/SQL explícito en vez de callproc()
        porque callproc() se queda colgado en el paso de "describe" cuando el
        procedimiento pertenece a un paquete y combina un IN con un SYS_REFCURSOR
        de salida (bug conocido de python-oracledb en modo thin).
        """
        cursor = None
        result_cursor = None
        try:
            cursor = self.connection.cursor()
            print(f">> Ejecutando PK_TRABAJADORES.PD_BUSCAR_TRABAJADOR_POR_ID con ID: {id_trabajador}...")
            resultado = cursor.var(oracledb.CURSOR)

            cursor.execute(
                """
                BEGIN
                    PK_TRABAJADORES.PD_BUSCAR_TRABAJADOR_POR_ID(:id_trabajador, :cur);
                END;
                """,
                id_trabajador=str(id_trabajador),
                cur=resultado
            )

            result_cursor = resultado.getvalue()
            if result_cursor is None:
                print("   Error: El cursor devuelto es NULL")
                return None

            fila = result_cursor.fetchone()

            if fila:
                print(f"   Trabajador encontrado: {fila[1]} {fila[2]}")
                return fila
            else:
                print(f"   No se encontró el trabajador con ID {id_trabajador}")
                return None

        except oracledb.Error as error:
            print(f"Error al buscar trabajador: {error}")
            return None
        finally:
            if result_cursor is not None:
                try:
                    result_cursor.close()
                except:
                    pass
            if cursor is not None:
                cursor.close()

    def listar_por_sucursal(self, id_sucursal):
        """Lista trabajadores activos de una sucursal usando PK_TRABAJADORES.PD_LISTAR_TRABAJADORES_POR_SUCURSAL.

        NOTA: usa execute() en vez de callproc() por el mismo motivo que buscar_por_id.
        """
        cursor = None
        result_cursor = None
        try:
            cursor = self.connection.cursor()
            print(f">> Consultando trabajadores de sucursal {id_sucursal}...")
            resultado = cursor.var(oracledb.CURSOR)

            cursor.execute(
                """
                BEGIN
                    PK_TRABAJADORES.PD_LISTAR_TRABAJADORES_POR_SUCURSAL(:id_sucursal, :cur);
                END;
                """,
                id_sucursal=str(id_sucursal),
                cur=resultado
            )

            result_cursor = resultado.getvalue()
            if result_cursor is None:
                print("   Error: El cursor devuelto es NULL")
                return []

            filas = result_cursor.fetchall()
            print(f"   Se encontraron {len(filas)} trabajador(es) en esta sucursal.")
            return filas

        except oracledb.Error as error:
            print(f"Error al listar trabajadores por sucursal: {error}")
            return []
        finally:
            if result_cursor is not None:
                try:
                    result_cursor.close()
                except:
                    pass
            if cursor is not None:
                cursor.close()

    def registrar(self, nombre, apellido1, apellido2, identificacion, correo_electronico, id_sucursal, id_turno, id_rol):
        cursor = None
        try:
            cursor = self.connection.cursor()
            cursor.callproc("PK_TRABAJADORES.PD_REGISTRAR_TRABAJADOR", [
                nombre, apellido1, apellido2, identificacion, correo_electronico, id_sucursal, id_turno, id_rol
            ])
            self.connection.commit()
            print("   Trabajador registrado con éxito.")
            return True

        except oracledb.Error as error:
            print(f"Error al registrar trabajador: {error}")
            self.connection.rollback()
            return False
        finally:
            if cursor is not None:
                cursor.close()

    def editar(self, identificacion, nombre=None, apellido1=None, apellido2=None,
               correo_electronico=None, id_sucursal=None, id_turno=None):
        cursor = None
        try:
            cursor = self.connection.cursor()
            cursor.callproc("PK_TRABAJADORES.PD_EDITAR_TRABAJADOR", [
                identificacion, nombre, apellido1, apellido2, correo_electronico, id_sucursal, id_turno
            ])
            self.connection.commit()
            print("   Trabajador actualizado con éxito.")
            return True

        except oracledb.Error as error:
            print(f"Error al editar trabajador: {error}")
            self.connection.rollback()
            return False
        finally:
            if cursor is not None:
                cursor.close()

    def asignar_rol(self, identificacion, id_rol):
        cursor = None
        try:
            cursor = self.connection.cursor()
            cursor.callproc("PK_TRABAJADORES.PD_ASIGNAR_ROL_TRABAJADOR", [identificacion, id_rol])
            self.connection.commit()
            print("   Rol asignado con éxito.")
            return True

        except oracledb.Error as error:
            print(f"Error al asignar rol: {error}")
            self.connection.rollback()
            return False
        finally:
            if cursor is not None:
                cursor.close()

    def desactivar(self, identificacion):
        cursor = None
        try:
            cursor = self.connection.cursor()
            cursor.callproc("PK_TRABAJADORES.PD_DESACTIVAR_TRABAJADOR", [identificacion])
            self.connection.commit()
            print("   Trabajador desactivado con éxito.")
            return True

        except oracledb.Error as error:
            print(f"Error al desactivar trabajador: {error}")
            self.connection.rollback()
            return False
        finally:
            if cursor is not None:
                cursor.close()