# dao/dao_ventas.py
# Descripción: DAO para RF-05 (ventas) y RF-06 (método de pago).

from decimal import Decimal
import oracledb


class DAOVentas:

    def __init__(self, connection):
        self.connection = connection

    # ==========================================================
    # LISTAR MÉTODOS DE PAGO
    # ==========================================================

    def listar_metodos_pago(self):
        """Retorna los métodos de pago disponibles."""
        cursor = None

        try:
            cursor = self.connection.cursor()

            print(">> Ejecutando consulta de métodos de pago...")

            cursor.execute(
                """
                SELECT ID_Tipo_Pago, Metodo_Pago
                FROM Tipo_Pagos
                ORDER BY ID_Tipo_Pago
                """
            )

            rows = cursor.fetchall()

            print(
                f"   Se encontraron {len(rows)} método(s) de pago."
            )

            return rows

        except oracledb.Error as error:
            print(
                f"Error al consultar métodos de pago: {error}"
            )
            return []

        finally:
            if cursor is not None:
                cursor.close()

    # ==========================================================
    # LISTAR INVENTARIO POR SUCURSAL
    # ==========================================================

    def listar_inventario(self, id_sucursal):
        """Retorna productos con existencia para una sucursal."""

        cursor = None
        result_cursor = None

        try:
            cursor = self.connection.cursor()

            print(
                f">> Ejecutando SP_LISTAR_INVENTARIO_VENTA "
                f"(Sucursal: {id_sucursal})..."
            )

            salida = cursor.var(oracledb.CURSOR)

            cursor.callproc(
                "SP_LISTAR_INVENTARIO_VENTA",
                [
                    id_sucursal,
                    salida
                ]
            )

            result_cursor = salida.getvalue()

            rows = result_cursor.fetchall()

            print(
                f"   Se encontraron {len(rows)} "
                f"producto(s) disponibles."
            )

            return rows

        except oracledb.Error as error:
            print(
                f"Error al consultar inventario: {error}"
            )
            return []

        finally:
            if result_cursor is not None:
                result_cursor.close()

            if cursor is not None:
                cursor.close()

    # ==========================================================
    # REGISTRAR VENTA
    # RF-05 / RF-06
    # ==========================================================

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
        Registra una venta y devuelve el ID,
        total y mensaje generado por Oracle.
        """

        cursor = None

        try:
            cursor = self.connection.cursor()

            print(
                ">> Ejecutando SP_REGISTRAR_VENTA "
                "en la base de datos..."
            )

            print(
                f"   Cliente: {cedula}, "
                f"Producto: {id_producto}, "
                f"Cantidad: {cantidad}"
            )

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
                    mensaje
                ]
            )

            venta_id = id_venta.getvalue()
            total_venta = total.getvalue()

            texto = (
                mensaje.getvalue()
                or "Sin mensaje devuelto por Oracle."
            )

            if venta_id is not None:

                self.connection.commit()

                print(
                    f"   ID Venta: {int(venta_id)}"
                )

                print(
                    f"   Total: "
                    f"{Decimal(str(total_venta or 0)):,.2f}"
                )

                print(
                    f"   {texto}"
                )

                return {
                    "ok": True,
                    "id_venta": int(venta_id),
                    "total": Decimal(
                        str(total_venta or 0)
                    ),
                    "mensaje": texto
                }

            self.connection.rollback()

            print(
                f"   {texto}"
            )

            return {
                "ok": False,
                "id_venta": None,
                "total": Decimal("0"),
                "mensaje": texto
            }

        except oracledb.Error as error:

            self.connection.rollback()

            print(
                f"Error Oracle al registrar la venta: "
                f"{error}"
            )

            return {
                "ok": False,
                "id_venta": None,
                "total": Decimal("0"),
                "mensaje":
                    f"Error Oracle al registrar "
                    f"la venta: {error}"
            }

        finally:
            if cursor is not None:
                cursor.close()

    # ==========================================================
    # CONSULTAR TODAS LAS VENTAS
    # ==========================================================

    def consultar_todas(self):
        """Consulta todas las ventas mediante SYS_REFCURSOR."""

        cursor = None
        result_cursor = None

        try:
            cursor = self.connection.cursor()

            print(
                ">> Ejecutando SP_LISTAR_VENTAS "
                "en la base de datos..."
            )

            salida = cursor.var(oracledb.CURSOR)

            cursor.callproc(
                "SP_LISTAR_VENTAS",
                [salida]
            )

            result_cursor = salida.getvalue()

            rows = result_cursor.fetchall()

            print(
                f"   Se encontraron {len(rows)} venta(s)."
            )

            return rows

        except oracledb.Error as error:

            print(
                f"Error al consultar ventas: {error}"
            )

            return []

        finally:

            if result_cursor is not None:
                result_cursor.close()

            if cursor is not None:
                cursor.close()

    # ==========================================================
    # BUSCAR UNA VENTA
    # ==========================================================

    def ver_detalle_venta(self, id_venta):
        """
        Obtiene el detalle de una venta específica
        utilizando VW_DETALLE_VENTAS.
        """

        cursor = None

        try:
            cursor = self.connection.cursor()

            print(
                f">> Consultando detalle de venta "
                f"ID: {id_venta}..."
            )

            cursor.execute(
                """
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
                """,
                {
                    "id_venta": id_venta
                }
            )

            row = cursor.fetchone()

            if row:

                print(
                    "   Venta encontrada."
                )

                return row

            print(
                f"   No se encontró la venta "
                f"con ID {id_venta}."
            )

            return None

        except oracledb.Error as error:

            print(
                f"Error al obtener detalle "
                f"de venta: {error}"
            )

            return None

        finally:
            if cursor is not None:
                cursor.close()

    # ==========================================================
    # MODIFICAR VENTA
    # ==========================================================

    def modificar_venta(
        self,
        id_venta,
        id_tipo_pago=None,
        id_trabajador=None
    ):
        """
        Modifica los datos permitidos de una venta.

        Los parámetros pueden enviarse como None.
        El procedimiento de Oracle utiliza NVL para
        conservar el dato existente cuando no se
        desea modificar.
        """

        cursor = None

        try:
            cursor = self.connection.cursor()

            print(
                f">> Ejecutando SP_MODIFICAR_VENTA "
                f"para venta ID: {id_venta}..."
            )

            mensaje = cursor.var(str, 500)

            cursor.callproc(
                "SP_MODIFICAR_VENTA",
                [
                    id_venta,
                    id_tipo_pago,
                    id_trabajador,
                    mensaje
                ]
            )

            texto = (
                mensaje.getvalue()
                or "Proceso finalizado."
            )

            if texto.lower().startswith("error"):

                self.connection.rollback()

                print(
                    f"   {texto}"
                )

                return {
                    "ok": False,
                    "mensaje": texto
                }

            self.connection.commit()

            print(
                f"   {texto}"
            )

            return {
                "ok": True,
                "mensaje": texto
            }

        except oracledb.Error as error:

            self.connection.rollback()

            print(
                f"Error Oracle al modificar "
                f"la venta: {error}"
            )

            return {
                "ok": False,
                "mensaje":
                    f"Error Oracle al modificar "
                    f"la venta: {error}"
            }

        finally:
            if cursor is not None:
                cursor.close()

    # ==========================================================
    # ELIMINAR VENTA
    # ==========================================================

    def eliminar_venta(self, id_venta):
        """
        Solicita a Oracle eliminar una venta.

        La validación de registros relacionados
        se realiza en SP_ELIMINAR_VENTA.
        """

        cursor = None

        try:
            cursor = self.connection.cursor()

            print(
                f">> Ejecutando SP_ELIMINAR_VENTA "
                f"para venta ID: {id_venta}..."
            )

            mensaje = cursor.var(str, 500)

            cursor.callproc(
                "SP_ELIMINAR_VENTA",
                [
                    id_venta,
                    mensaje
                ]
            )

            texto = (
                mensaje.getvalue()
                or "Proceso finalizado."
            )

            if texto.lower().startswith("error"):

                self.connection.rollback()

                print(
                    f"   {texto}"
                )

                return {
                    "ok": False,
                    "mensaje": texto
                }

            self.connection.commit()

            print(
                f"   {texto}"
            )

            return {
                "ok": True,
                "mensaje": texto
            }

        except oracledb.Error as error:

            self.connection.rollback()

            print(
                f"Error Oracle al eliminar "
                f"la venta: {error}"
            )

            return {
                "ok": False,
                "mensaje":
                    f"Error Oracle al eliminar "
                    f"la venta: {error}"
            }

        finally:
            if cursor is not None:
                cursor.close()

    # ==========================================================
    # ALIAS UTILIZADOS POR EL PROYECTO
    # ==========================================================

    def listar_ventas(self):
        """
        Alias de consultar_todas para mantener
        compatibilidad con el proyecto.
        """

        return self.consultar_todas()

    def listar_inventario_venta(self, id_sucursal):
        """
        Alias de listar_inventario para mantener
        compatibilidad con el proyecto.
        """

        return self.listar_inventario(
            id_sucursal
        )

    def registrar_venta(
        self,
        cedula,
        id_trabajador,
        id_tipo_pago,
        id_producto,
        cantidad,
        id_sucursal
    ):
        """
        Alias de registrar para mantener
        compatibilidad con el proyecto.
        """

        return self.registrar(
            cedula,
            id_trabajador,
            id_tipo_pago,
            id_producto,
            cantidad,
            id_sucursal
        )
