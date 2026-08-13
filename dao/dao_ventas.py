# dao/dao_ventas.py
# Descripción: DAO para RF-05 (ventas) y RF-06 (método de pago).

from decimal import Decimal
import oracledb


class DAOVentas:

    def __init__(self, connection):
        self.connection = connection


    # LISTAR METODOS DE PAGO

    def listar_metodos_pago(self):
        """Retorna los métodos de pago disponibles usando PK_TIPO_PAGOS.SP_LISTAR_TIPOS_PAGO."""
        cursor = None
        try:
            cursor = self.connection.cursor()
            print(">> Ejecutando PK_TIPO_PAGOS.SP_LISTAR_TIPOS_PAGO...")
            resultado = cursor.var(oracledb.CURSOR)
            cursor.callproc("PK_TIPO_PAGOS.SP_LISTAR_TIPOS_PAGO", [resultado])
            rows = resultado.getvalue().fetchall()
            print(f"   Se encontraron {len(rows)} método(s) de pago.")
            return rows
        except oracledb.Error as error:
            print(f"Error al consultar métodos de pago: {error}")
            return []
        finally:
            if cursor is not None:
                cursor.close()


    # LISTAR INVENTARIO POR SUCURSAL

    def listar_inventario(self, id_sucursal):
        """Retorna productos con existencia para una sucursal.

        NOTA: se usa execute() con bloque PL/SQL explícito en vez de callproc()
        porque callproc() se queda colgado en el paso de "describe" cuando el
        procedimiento pertenece a un paquete y combina un IN con un SYS_REFCURSOR
        de salida (bug conocido de python-oracledb en modo thin).
        """
        cursor = None
        result_cursor = None
        try:
            cursor = self.connection.cursor()
            print(f">> Ejecutando PK_VENTAS.SP_LISTAR_INVENTARIO_VENTA (Sucursal: {id_sucursal})...")
            salida = cursor.var(oracledb.CURSOR)

            cursor.execute(
                """
                BEGIN
                    PK_VENTAS.SP_LISTAR_INVENTARIO_VENTA(:id_sucursal, :cur);
                END;
                """,
                id_sucursal=str(id_sucursal),
                cur=salida
            )

            result_cursor = salida.getvalue()
            if result_cursor is None:
                print("   Error: El cursor devuelto es NULL")
                return []

            rows = result_cursor.fetchall()
            print(f"   Se encontraron {len(rows)} producto(s) disponibles.")
            return rows

        except oracledb.Error as error:
            print(f"Error al consultar inventario: {error}")
            return []
        finally:
            if result_cursor is not None:
                try:
                    result_cursor.close()
                except:
                    pass
            if cursor is not None:
                cursor.close()


    # REGISTRAR VENTA

    def registrar(
        self,
        cedula,
        id_trabajador,
        id_tipo_pago,
        id_producto,
        cantidad,
        id_sucursal
    ):
        """
        Registra una venta y devuelve el ID, total y mensaje generado por Oracle.
        """
        cursor = None
        try:
            cursor = self.connection.cursor()
            print(">> Ejecutando PK_VENTAS.SP_REGISTRAR_VENTA en la base de datos...")
            print(f"   Cliente: {cedula}, Producto: {id_producto}, Cantidad: {cantidad}")

            id_venta = cursor.var(oracledb.NUMBER)
            total = cursor.var(oracledb.NUMBER)
            mensaje = cursor.var(oracledb.DB_TYPE_VARCHAR, 500)

            cursor.callproc(
                "PK_VENTAS.SP_REGISTRAR_VENTA",
                [
                    cedula,           # IN
                    id_trabajador,    # IN
                    id_tipo_pago,     # IN
                    id_producto,      # IN
                    cantidad,         # IN
                    id_sucursal,      # IN
                    id_venta,         # OUT
                    total,            # OUT
                    mensaje           # OUT
                ]
            )

            venta_id = id_venta.getvalue()
            total_venta = total.getvalue()
            texto = mensaje.getvalue() or "Sin mensaje devuelto por Oracle."

            if venta_id is not None:
                self.connection.commit()
                print(f"   ID Venta: {int(venta_id)}")
                print(f"   Total: {Decimal(str(total_venta or 0)):,.2f}")
                print(f"   {texto}")

                return {
                    "ok": True,
                    "id_venta": int(venta_id),
                    "total": Decimal(str(total_venta or 0)),
                    "mensaje": texto
                }

            self.connection.rollback()
            print(f"    {texto}")
            return {
                "ok": False,
                "id_venta": None,
                "total": Decimal("0"),
                "mensaje": texto
            }

        except oracledb.Error as error:
            self.connection.rollback()
            print(f"Error Oracle al registrar la venta: {error}")
            return {
                "ok": False,
                "id_venta": None,
                "total": Decimal("0"),
                "mensaje": f"Error Oracle: {error}"
            }
        finally:
            if cursor is not None:
                cursor.close()


    # CONSULTAR TODAS LAS VENTAS

    def consultar_todas(self):
        """Consulta todas las ventas mediante SYS_REFCURSOR."""
        cursor = None
        result_cursor = None
        try:
            cursor = self.connection.cursor()
            print(">> Ejecutando PK_VENTAS.SP_LISTAR_VENTAS en la base de datos...")
            salida = cursor.var(oracledb.CURSOR)
            cursor.callproc("PK_VENTAS.SP_LISTAR_VENTAS", [salida])
            result_cursor = salida.getvalue()
            rows = result_cursor.fetchall()
            print(f"   Se encontraron {len(rows)} venta(s).")
            return rows
        except oracledb.Error as error:
            print(f"Error al consultar ventas: {error}")
            return []
        finally:
            if result_cursor is not None:
                result_cursor.close()
            if cursor is not None:
                cursor.close()


    # DETALLE DE VENTAS POR PRODUCTO (para saber qué devolver)

    def consultar_detalle_productos(self):
        """Lista las ventas con el ID de producto y la cantidad comprada,
        usando PK_VENTAS_EXTRA.SP_LISTAR_VENTAS_DETALLE_PRODUCTOS.
        Pensado para tener a mano los datos que pide 'Registrar devolución'."""
        cursor = None
        result_cursor = None
        try:
            cursor = self.connection.cursor()
            print(">> Ejecutando PK_VENTAS_EXTRA.SP_LISTAR_VENTAS_DETALLE_PRODUCTOS...")
            salida = cursor.var(oracledb.CURSOR)
            cursor.callproc("PK_VENTAS_EXTRA.SP_LISTAR_VENTAS_DETALLE_PRODUCTOS", [salida])
            result_cursor = salida.getvalue()
            rows = result_cursor.fetchall()
            print(f"   Se encontraron {len(rows)} registro(s).")
            return rows
        except oracledb.Error as error:
            print(f"Error al consultar el detalle de ventas: {error}")
            return []
        finally:
            if result_cursor is not None:
                result_cursor.close()
            if cursor is not None:
                cursor.close()


    # BUSCAR UNA VENTA
    def ver_detalle_venta(self, id_venta):
        """Obtiene el detalle de una venta específica usando PK_VENTAS.SP_CONSULTAR_VENTA_POR_ID.

        NOTA: usa execute() en vez de callproc() por el mismo motivo que listar_inventario.
        """
        cursor = None
        result_cursor = None
        try:
            cursor = self.connection.cursor()
            print(f">> Ejecutando PK_VENTAS.SP_CONSULTAR_VENTA_POR_ID (ID: {id_venta})...")
            resultado = cursor.var(oracledb.CURSOR)

            cursor.execute(
                """
                BEGIN
                    PK_VENTAS.SP_CONSULTAR_VENTA_POR_ID(:id_venta, :cur);
                END;
                """,
                id_venta=id_venta,
                cur=resultado
            )

            result_cursor = resultado.getvalue()
            if result_cursor is None:
                print("   Error: El cursor devuelto es NULL")
                return None

            row = result_cursor.fetchone()
            if row:
                print("   Venta encontrada.")
                return row
            print(f"   No se encontró la venta con ID {id_venta}.")
            return None
        except oracledb.Error as error:
            print(f"Error al obtener detalle de venta: {error}")
            return None
        finally:
            if result_cursor is not None:
                try:
                    result_cursor.close()
                except:
                    pass
            if cursor is not None:
                cursor.close()


    # MODIFICAR VENTA
    def modificar_venta(
        self,
        id_venta,
        cedula=None,
        id_trabajador=None,
        id_tipo_pago=None
    ):
        """Modifica una venta existente. Los datos enviados como None mantienen su valor actual."""
        cursor = None
        try:
            cursor = self.connection.cursor()
            print(f">> Ejecutando PK_VENTAS.SP_MODIFICAR_VENTA para venta ID: {id_venta}...")
            mensaje = cursor.var(oracledb.DB_TYPE_VARCHAR, 500)
            cursor.callproc(
                "PK_VENTAS.SP_MODIFICAR_VENTA",
                [id_venta, cedula, id_trabajador, id_tipo_pago, mensaje]
            )
            texto = mensaje.getvalue() or "Proceso finalizado."

            if texto.lower().startswith("error"):
                self.connection.rollback()
                return {"ok": False, "mensaje": texto}

            self.connection.commit()
            print(f"   {texto}")
            return {"ok": True, "mensaje": texto}

        except oracledb.Error as error:
            self.connection.rollback()
            print(f"Error Oracle al modificar la venta: {error}")
            return {"ok": False, "mensaje": f"Error Oracle: {error}"}
        finally:
            if cursor is not None:
                cursor.close()


    # ELIMINAR VENTA
    def eliminar_venta(self, id_venta):
        """Solicita a Oracle eliminar una venta."""
        cursor = None
        try:
            cursor = self.connection.cursor()
            print(f">> Ejecutando PK_VENTAS.SP_ELIMINAR_VENTA para venta ID: {id_venta}...")
            mensaje = cursor.var(oracledb.DB_TYPE_VARCHAR, 500)
            cursor.callproc("PK_VENTAS.SP_ELIMINAR_VENTA", [id_venta, mensaje])
            texto = mensaje.getvalue() or "Proceso finalizado."

            if texto.lower().startswith("error"):
                self.connection.rollback()
                print(f"   {texto}")
                return {"ok": False, "mensaje": texto}

            self.connection.commit()
            print(f"   {texto}")
            return {"ok": True, "mensaje": texto}

        except oracledb.Error as error:
            self.connection.rollback()
            print(f"Error Oracle al eliminar la venta: {error}")
            return {"ok": False, "mensaje": f"Error Oracle: {error}"}
        finally:
            if cursor is not None:
                cursor.close()


    # ALIAS UTILIZADOS POR EL PROYECTO
    def listar_ventas(self):
        return self.consultar_todas()

    def listar_inventario_venta(self, id_sucursal):
        return self.listar_inventario(id_sucursal)

    def registrar_venta(
        self,
        cedula,
        id_trabajador,
        id_tipo_pago,
        id_producto,
        cantidad,
        id_sucursal
    ):
        return self.registrar(
            cedula,
            id_trabajador,
            id_tipo_pago,
            id_producto,
            cantidad,
            id_sucursal
        )