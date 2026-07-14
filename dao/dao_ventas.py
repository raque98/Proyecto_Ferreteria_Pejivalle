# dao/dao_ventas.py
# Descripción: DAO para RF-05 (ventas) y RF-06 (metodo de pago).

from decimal import Decimal
import oracledb


class DAOVentas:
    def __init__(self, connection):
        self.connection = connection

    def listar_metodos_pago(self):
        """Retorna los metodos de pago disponibles."""
        cursor = None
        try:
            cursor = self.connection.cursor()
            print(">> Ejecutando consulta: SELECT * FROM Tipo_Pagos")
            cursor.execute(
                """
                SELECT ID_Tipo_Pago, Metodo_Pago
                FROM Tipo_Pagos
                ORDER BY ID_Tipo_Pago
                """
            )
            rows = cursor.fetchall()
            print(f"   Se encontraron {len(rows)} metodo(s) de pago.")
            return rows
        except oracledb.Error as error:
            print(f"Error al consultar metodos de pago: {error}")
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
            print(f">> Ejecutando SP_LISTAR_INVENTARIO_VENTA (Sucursal: {id_sucursal}) en la base de datos...")
            salida = cursor.var(oracledb.CURSOR)
            cursor.callproc("SP_LISTAR_INVENTARIO_VENTA", [id_sucursal, salida])
            result_cursor = salida.getvalue()
            rows = result_cursor.fetchall()
            print(f"   Se encontraron {len(rows)} producto(s) disponibles.")
            return rows
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
            print(f">> Ejecutando SP_REGISTRAR_VENTA en la base de datos...")
            print(f"   Cliente: {cedula}, Producto: {id_producto}, Cantidad: {cantidad}")
            
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
                print(f"   ID Venta: {int(venta_id)}")
                print(f"   Total: {Decimal(str(total_venta or 0)):,.2f}")
                print(f"   {texto}")
                return {
                    "ok": True,
                    "id_venta": int(venta_id),
                    "total": Decimal(str(total_venta or 0)),
                    "mensaje": texto,
                }

            self.connection.rollback()
            print(f"   {texto}")
            return {
                "ok": False,
                "id_venta": None,
                "total": Decimal("0"),
                "mensaje": texto,
            }
        except oracledb.Error as error:
            self.connection.rollback()
            print(f"Error Oracle al registrar la venta: {error}")
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
            print(">> Ejecutando SP_LISTAR_VENTAS en la base de datos...")
            salida = cursor.var(oracledb.CURSOR)
            cursor.callproc("SP_LISTAR_VENTAS", [salida])
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

    def listar_ventas(self):
        """Alias de consultar_todas para mantener consistencia."""
        return self.consultar_todas()

    def listar_inventario_venta(self, id_sucursal):
        """Alias de listar_inventario para mantener consistencia."""
        return self.listar_inventario(id_sucursal)

    def ver_detalle_venta(self, id_venta):
        """Obtiene el detalle de una venta especifica usando la vista."""
        cursor = None
        try:
            cursor = self.connection.cursor()
            print(f">> Consultando detalle de venta ID: {id_venta}...")
            
            cursor.execute("""
                SELECT 
                    ID_Venta,
                    Fecha_Hora,
                    Cedula,
                    Cliente,
                    Trabajador,
                    Metodo_Pago,
                    Total
                FROM VW_DETALLE_VENTAS
                WHERE ID_Venta = :id_venta
            """, {'id_venta': id_venta})
            
            row = cursor.fetchone()
            cursor.close()
            
            if row:
                print(f"   Venta encontrada")
                return row
            else:
                print(f"   No se encontró la venta con ID {id_venta}")
                return None
                
        except oracledb.Error as error:
            print(f"Error al obtener detalle de venta: {error}")
            return None
        finally:
            if cursor is not None:
                cursor.close()

    def registrar_venta(self, cedula, id_trabajador, id_tipo_pago, id_producto, cantidad, id_sucursal):
        """Alias de registrar para mantener consistencia."""
        return self.registrar(cedula, id_trabajador, id_tipo_pago, id_producto, cantidad, id_sucursal)