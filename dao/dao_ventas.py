# dao/dao_ventas.py
# Descripción: DAO para RF-05 (ventas) y RF-06 (método de pago).

from decimal import Decimal
import oracledb


class DAOVentas:
    def __init__(self, connection):
        self.connection = connection

    def listar_metodos_pago(self):
        """Retorna los métodos de pago disponibles."""
        cursor = None
        try:
            cursor = self.connection.cursor()
            cursor.execute(
                """
                SELECT ID_Tipo_Pago, Metodo_Pago
                FROM Tipo_Pagos
                ORDER BY ID_Tipo_Pago
                """
            )
            return cursor.fetchall()
        except oracledb.Error as error:
            print(f"Error al consultar métodos de pago: {error}")
            return []
        finally:
            if cursor is not None:
                cursor.close()

    def listar_inventario(self, id_sucursal):
        """Retorna productos con existencia para una sucursal."""
        cursor = None
        result_cursor = None
        try:
            cursor = self.connection.cursor()
            salida = cursor.var(oracledb.CURSOR)
            cursor.callproc("SP_LISTAR_INVENTARIO_VENTA", [id_sucursal, salida])
            result_cursor = salida.getvalue()
            return result_cursor.fetchall()
        except oracledb.Error as error:
            print(f"Error al consultar inventario: {error}")
            return []
        finally:
            if result_cursor is not None:
                result_cursor.close()
            if cursor is not None:
                cursor.close()

    def registrar(
        self,
        cedula,
        id_trabajador,
        id_tipo_pago,
        id_producto,
        cantidad,
        id_sucursal,
    ):
        """Registra una venta y devuelve ID, total y mensaje del procedimiento."""
        cursor = None
        try:
            cursor = self.connection.cursor()
            id_venta = cursor.var(oracledb.NUMBER)
            total = cursor.var(oracledb.NUMBER)
            mensaje = cursor.var(str, 500)

            cursor.callproc(
                "SP_REGISTRAR_VENTA",
                [
                    cedula,
                    id_trabajador,
                    id_tipo_pago,
                    id_producto,
                    cantidad,
                    id_sucursal,
                    id_venta,
                    total,
                    mensaje,
                ],
            )

            venta_id = id_venta.getvalue()
            total_venta = total.getvalue()
            texto = mensaje.getvalue() or "Sin mensaje devuelto por Oracle."

            if venta_id is not None:
                self.connection.commit()
                return {
                    "ok": True,
                    "id_venta": int(venta_id),
                    "total": Decimal(str(total_venta or 0)),
                    "mensaje": texto,
                }

            self.connection.rollback()
            return {
                "ok": False,
                "id_venta": None,
                "total": Decimal("0"),
                "mensaje": texto,
            }
        except oracledb.Error as error:
            self.connection.rollback()
            return {
                "ok": False,
                "id_venta": None,
                "total": Decimal("0"),
                "mensaje": f"Error Oracle al registrar la venta: {error}",
            }
        finally:
            if cursor is not None:
                cursor.close()

    def consultar_todas(self):
        """Consulta todas las ventas mediante SYS_REFCURSOR."""
        cursor = None
        result_cursor = None
        try:
            cursor = self.connection.cursor()
            salida = cursor.var(oracledb.CURSOR)
            cursor.callproc("SP_LISTAR_VENTAS", [salida])
            result_cursor = salida.getvalue()
            return result_cursor.fetchall()
        except oracledb.Error as error:
            print(f"Error al consultar ventas: {error}")
            return []
        finally:
            if result_cursor is not None:
                result_cursor.close()
            if cursor is not None:
                cursor.close()
