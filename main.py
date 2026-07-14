# main.py
# Descripción: Menú principal del sistema de gestión

import os
from dotenv import load_dotenv
import oracledb

# Importar DAOs
from dao.dao_tipo_pagos import DAOTipoPagos
from dao.dao_clientes import DAOClientes
from dao.dao_proveedores import DAOProveedores
from dao.dao_ventas import DAOVentas
from dao.dao_productos import DAOProductos
from dao.dao_sucursales import DAOSucursales
from dao.dao_trabajadores import DAOTrabajadores
from dao.dao_categorias import DAOCategorias
from dao.dao_roles import DAORoles
from dao.dao_turnos import DAOTurnos
from dao.dao_tipo_devoluciones import DAOTipoDevoluciones

load_dotenv()

class MenuFerreteria:
    def __init__(self):
        self.connection = None
        self.dao_tipo_pagos = None
        self.dao_clientes = None
        self.dao_proveedores = None
        self.dao_ventas = None
        self.dao_productos = None
        self.dao_sucursales = None
        self.dao_trabajadores = None
        self.dao_categorias = None
        self.dao_roles = None
        self.dao_turnos = None
        self.dao_tipo_devoluciones = None
        
    def conectar(self):
        try:
            self.connection = oracledb.connect(
                user=os.getenv('DB_USER'),
                password=os.getenv('DB_PASSWORD'),
                dsn=os.getenv('DB_DSN'),
                config_dir=os.getenv('WALLET_LOCATION'),
                wallet_location=os.getenv('WALLET_LOCATION'),
                wallet_password=os.getenv('WALLET_PASSWORD')
            )
            self.dao_tipo_pagos = DAOTipoPagos(self.connection)
            self.dao_clientes = DAOClientes(self.connection)
            self.dao_proveedores = DAOProveedores(self.connection)
            self.dao_ventas = DAOVentas(self.connection)
            self.dao_productos = DAOProductos(self.connection)
            self.dao_sucursales = DAOSucursales(self.connection)
            self.dao_trabajadores = DAOTrabajadores(self.connection)
            self.dao_categorias = DAOCategorias(self.connection)
            self.dao_roles = DAORoles(self.connection)
            self.dao_turnos = DAOTurnos(self.connection)
            self.dao_tipo_devoluciones = DAOTipoDevoluciones(self.connection)
            print("Conexión exitosa a Oracle Cloud\n")
            return True
        except Exception as e:
            print(f"Error de conexión: {e}")
            return False
    
    def mostrar_menu(self):
        while True:
            print("\n" + "="*55)
            print("   Ferretería Pejivalle - Sistema de Gestión")
            print("="*55)
            print("1.  Gestionar Métodos de Pago")
            print("2.  Gestionar Clientes")
            print("3.  Gestionar Proveedores")
            print("4.  Gestionar Productos")
            print("5.  Gestionar Sucursales")
            print("6.  Gestionar Trabajadores")
            print("7.  Gestionar Ventas")
            print("8.  Gestionar Devoluciones")
            print("9.  Reportes")
            print("0.  Salir")
            print("="*55)
            
            try:
                opcion = int(input("Seleccione una opción: "))
                
                if opcion == 0:
                    print("\nHasta luego!")
                    break
                elif opcion == 1:
                    self.menu_tipo_pagos()
                elif opcion == 2:
                    self.menu_clientes()
                elif opcion == 3:
                    self.menu_proveedores()
                elif opcion == 4:
                    self.menu_productos()
                elif opcion == 5:
                    self.menu_sucursales()
                elif opcion == 6:
                    self.menu_trabajadores()
                elif opcion == 7:
                    self.menu_ventas()
                elif opcion == 8:
                    self.menu_devoluciones()
                elif opcion == 9:
                    self.menu_reportes()
                else:
                    print("\nOpción no válida.")
                    
            except ValueError:
                print("\nIngrese un número válido")
            except Exception as e:
                print(f"\nError: {e}")

  
    # Menu: Metodos de Pago
  
    def menu_tipo_pagos(self):
        while True:
            print("\n" + "-"*40)
            print("   Metodos de Pago")
            print("-"*40)
            print("1. Ver todos")
            print("2. Registrar nuevo")
            print("0. Volver")
            
            opcion = input("Seleccione: ")
            
            if opcion == "0":
                break
            elif opcion == "1":
                self.dao_tipo_pagos.listar_todos()
            elif opcion == "2":
                nombre = input("Nombre del método de pago: ")
                self.dao_tipo_pagos.registrar(nombre)

   
    # Menu: Clientes
  
    def menu_clientes(self):
        while True:
            print("\n" + "-"*40)
            print("   Gestion de Clientes")
            print("-"*40)
            print("1. Ver todos los clientes")
            print("2. Registrar nuevo cliente")
            print("3. Editar correo/teléfono")
            print("4. Eliminar cliente")
            print("5. Ver historial de compras")
            print("6. Verificar si existe cliente")
            print("0. Volver")
            
            opcion = input("Seleccione: ")
            
            if opcion == "0":
                break
            elif opcion == "1":
                self.mostrar_clientes()
            elif opcion == "2":
                self.registrar_cliente()
            elif opcion == "3":
                self.editar_cliente()
            elif opcion == "4":
                self.eliminar_cliente()
            elif opcion == "5":
                self.mostrar_historial_compras()
            elif opcion == "6":
                self.verificar_cliente()

    def mostrar_clientes(self):
        rows = self.dao_clientes.consultar_todos()
        if not rows:
            print("No hay clientes registrados.")
            return
        print("\n--- Lista de Clientes ---")
        print("Cédula      | Nombre completo                | Correo               | Teléfono")
        print("-"*70)
        for row in rows:
            print(f"{row[0]:<11} | {row[1]} {row[2]} {row[3]:<20} | {row[4]:<18} | {row[5]}")

    def registrar_cliente(self):
        print("\n--- Registrar Cliente ---")
        cedula = input("Cédula: ")
        nombre = input("Nombre: ")
        apellido1 = input("Primer apellido: ")
        apellido2 = input("Segundo apellido: ")
        correo = input("Correo electrónico: ")
        telefono = input("Teléfono: ")
        self.dao_clientes.registrar(cedula, nombre, apellido1, apellido2, correo, telefono)

    def editar_cliente(self):
        print("\n--- Editar Cliente ---")
        cedula = input("Cédula del cliente a editar: ")
        correo = input("Nuevo correo electrónico: ")
        telefono = input("Nuevo teléfono: ")
        self.dao_clientes.editar_correo_telefono(cedula, correo, telefono)

    def eliminar_cliente(self):
        print("\n--- Eliminar Cliente ---")
        cedula = input("Cédula del cliente a eliminar: ")
        confirmar = input("¿Está seguro? (s/n): ")
        if confirmar.lower() == 's':
            self.dao_clientes.eliminar(cedula)

    def mostrar_historial_compras(self):
        rows = self.dao_clientes.mostrar_historial_compras()
        if not rows:
            print("No hay datos de compras.")
            return
        print("\n--- Historial de Compras ---")
        print("Cédula      | Nombre                | Compras | Total Comprado")
        print("-"*60)
        for row in rows:
            print(f"{row[0]:<11} | {row[1]:<20} | {row[2]:<7} | {row[3]:,.2f}")

    def verificar_cliente(self):
        print("\n--- Verificar Cliente ---")
        cedula = input("Cédula del cliente: ")
        existe = self.dao_clientes.existe(cedula)
        if existe:
            print("El cliente existe en la base de datos.")
        else:
            print("El cliente no existe.")

    
    # Menu: Proveedores
    
    def menu_proveedores(self):
        while True:
            print("\n" + "-"*40)
            print("   Gestion de Proveedores")
            print("-"*40)
            print("1.  Ver todos los proveedores")
            print("2.  Registrar nuevo proveedor")
            print("3.  Editar contacto de proveedor")
            print("4.  Eliminar proveedor")
            print("5.  Cambiar estado de proveedor")
            print("6.  Ver productos por proveedor")
            print("7.  Contar productos de un proveedor")
            print("8.  Ver estado de un proveedor")
            print("0.  Volver")
            
            opcion = input("Seleccione: ")
            
            if opcion == "0":
                break
            elif opcion == "1":
                self.mostrar_proveedores()
            elif opcion == "2":
                self.registrar_proveedor()
            elif opcion == "3":
                self.editar_proveedor()
            elif opcion == "4":
                self.eliminar_proveedor()
            elif opcion == "5":
                self.cambiar_estado_proveedor()
            elif opcion == "6":
                self.mostrar_productos_por_proveedor()
            elif opcion == "7":
                self.contar_productos_proveedor()
            elif opcion == "8":
                self.ver_estado_proveedor()

    def mostrar_proveedores(self):
        rows = self.dao_proveedores.consultar_todos()
        if not rows:
            print("No hay proveedores registrados.")
            return
        print("\n--- Lista de Proveedores ---")
        print("ID | Proveedor              | Contacto              | Correo               | Teléfono  | Estado")
        print("-"*95)
        for idx, row in enumerate(rows, start=1):
            print(f"{idx:<3} | {row[0]:<22} | {row[1]} {row[2]} {row[3]:<15} | {row[4]:<20} | {row[5]:<9} | {row[6]}")

    def registrar_proveedor(self):
        print("\n--- Registrar Proveedor ---")
        nombre_proveedor = input("Nombre del proveedor: ")
        nombre_contacto = input("Nombre de contacto: ")
        apellido1 = input("Primer apellido de contacto: ")
        apellido2 = input("Segundo apellido de contacto: ")
        correo = input("Correo electrónico: ")
        telefono = input("Teléfono: ")
        self.dao_proveedores.registrar(nombre_proveedor, nombre_contacto, apellido1, apellido2, correo, telefono)

    def editar_proveedor(self):
        print("\n--- Editar Contacto de Proveedor ---")
        id_proveedor = int(input("ID del proveedor: "))
        nombre_contacto = input("Nuevo nombre de contacto: ")
        apellido1 = input("Nuevo primer apellido: ")
        apellido2 = input("Nuevo segundo apellido: ")
        correo = input("Nuevo correo: ")
        telefono = input("Nuevo teléfono: ")
        self.dao_proveedores.editar_contacto(id_proveedor, nombre_contacto, apellido1, apellido2, correo, telefono)

    def eliminar_proveedor(self):
        print("\n--- Eliminar Proveedor ---")
        id_proveedor = int(input("ID del proveedor a eliminar: "))
        confirmar = input("¿Está seguro? (s/n): ")
        if confirmar.lower() == 's':
            self.dao_proveedores.eliminar(id_proveedor)

    def cambiar_estado_proveedor(self):
        print("\n--- Cambiar Estado de Proveedor ---")
        id_proveedor = int(input("ID del proveedor: "))
        print("Opciones de estado: Activo, Inactivo")
        estado = input("Nuevo estado: ")
        self.dao_proveedores.cambiar_estado(id_proveedor, estado)

    def mostrar_productos_por_proveedor(self):
        rows = self.dao_proveedores.mostrar_productos_por_proveedor()
        if not rows:
            print("No hay datos de productos por proveedor.")
            return
        print("\n--- Productos por Proveedor ---")
        print("ID Producto | Producto              | Proveedor             | Contacto")
        print("-"*75)
        for row in rows:
            print(f"{row[0]:<11} | {row[1]:<22} | {row[2]:<22} | {row[3]}")

    def contar_productos_proveedor(self):
        print("\n--- Contar Productos de Proveedor ---")
        id_proveedor = int(input("ID del proveedor: "))
        cantidad = self.dao_proveedores.contar_productos(id_proveedor)
        print(f"Este proveedor tiene {cantidad} producto(s) registrado(s).")

    def ver_estado_proveedor(self):
        print("\n--- Ver Estado de Proveedor ---")
        id_proveedor = int(input("ID del proveedor: "))
        estado = self.dao_proveedores.ver_estado(id_proveedor)
        print(f"El estado del proveedor es: {estado}")

  
    # Menu: Productos
   
    def menu_productos(self):
        while True:
            print("\n" + "-"*40)
            print("   Gestion de Productos")
            print("-"*40)
            print("1. Ver todos los productos")
            print("2. Buscar producto por ID")
            print("3. Ver productos por categoría")
            print("4. Ver categorías")
            print("5. Registrar nuevo producto")
            print("0. Volver")
            
            opcion = input("Seleccione: ")
            
            if opcion == "0":
                break
            elif opcion == "1":
                self.mostrar_productos()
            elif opcion == "2":
                self.buscar_producto()
            elif opcion == "3":
                self.mostrar_productos_por_categoria()
            elif opcion == "4":
                self.mostrar_categorias()
            elif opcion == "5":
                self.registrar_producto()

    def mostrar_productos(self):
        rows = self.dao_productos.listar_todos()
        if not rows:
            print("No hay productos registrados.")
            return
        print("\n--- Lista de Productos ---")
        print("ID | Producto                    | Precio Venta | Precio Costo")
        print("-"*60)
        for row in rows:
            print(f"{row[0]:<3} | {row[1]:<28} | {row[3]:,.2f} | {row[4]:,.2f}")

    def buscar_producto(self):
        print("\n--- Buscar Producto ---")
        id_producto = int(input("ID del producto: "))
        row = self.dao_productos.buscar_por_id(id_producto)
        if row:
            print(f"ID: {row[0]}")
            print(f"Nombre: {row[1]}")
            print(f"Descripción: {row[2]}")
            print(f"Precio Venta: {row[3]:,.2f}")
            print(f"Precio Costo: {row[4]:,.2f}")
            print(f"Categoría ID: {row[5]}")

    def mostrar_productos_por_categoria(self):
        print("\n--- Productos por Categoría ---")
        self.mostrar_categorias()
        id_categoria = int(input("Seleccione ID de categoría: "))
        rows = self.dao_productos.listar_por_categoria(id_categoria)
        if not rows:
            print("No hay productos en esta categoría.")
            return
        print("\nID | Producto              | Precio Venta | Precio Costo")
        print("-"*55)
        for row in rows:
            print(f"{row[0]:<3} | {row[1]:<22} | {row[2]:,.2f} | {row[3]:,.2f}")

    def mostrar_categorias(self):
        rows = self.dao_categorias.listar_todas()
        if not rows:
            print("No hay categorías registradas.")
            return
        print("\n--- Categorías ---")
        print("ID | Nombre")
        print("-"*25)
        for row in rows:
            print(f"{row[0]:<3} | {row[1]}")

    def registrar_producto(self):
        print("\n--- Registrar Nuevo Producto ---")
        try:
            nombre = input("Nombre del producto: ")
            descripcion = input("Descripción: ")
            precio_venta = float(input("Precio de venta: "))
            precio_costo = float(input("Precio de costo: "))
            fecha_entrada = input("Fecha de última entrada (YYYY-MM-DD): ")
            
            print("\n--- Proveedores disponibles ---")
            proveedores = self.dao_proveedores.consultar_todos()
            if not proveedores:
                print("No hay proveedores registrados.")
                return
            for p in proveedores:
                print(f"   ID: {p[0]} - {p[1]}")
            id_proveedor = int(input("ID del proveedor: "))
            
            print("\n--- Categorías disponibles ---")
            categorias = self.dao_categorias.listar_todas()
            if not categorias:
                print("No hay categorías registradas.")
                return
            for c in categorias:
                print(f"   ID: {c[0]} - {c[1]}")
            id_categoria = int(input("ID de la categoría: "))
            
            self.dao_productos.registrar(
                nombre, descripcion, precio_venta, precio_costo,
                fecha_entrada, id_proveedor, id_categoria
            )
        except ValueError:
            print("Error: Los precios e IDs deben ser numéricos.")
        except Exception as e:
            print(f"Error al registrar producto: {e}")

   
    # Menu: Sucursales
   
    def menu_sucursales(self):
        while True:
            print("\n" + "-"*40)
            print("   Gestion de Sucursales")
            print("-"*40)
            print("1. Ver todas las sucursales")
            print("2. Ver sucursales con dirección")
            print("3. Registrar inventario en sucursal")
            print("4. Ver inventario por sucursal")
            print("0. Volver")
            
            opcion = input("Seleccione: ")
            
            if opcion == "0":
                break
            elif opcion == "1":
                self.mostrar_sucursales()
            elif opcion == "2":
                self.mostrar_sucursales_con_direccion()
            elif opcion == "3":
                self.registrar_inventario()
            elif opcion == "4":
                self.mostrar_inventario_sucursal()

    def mostrar_sucursales(self):
        rows = self.dao_sucursales.listar_todas()
        if not rows:
            print("No hay sucursales registradas.")
            return
        print("\n--- Lista de Sucursales ---")
        print("ID | Nombre de Sucursal")
        print("-"*40)
        for row in rows:
            print(f"{row[0]:<3} | {row[1]}")

    def mostrar_sucursales_con_direccion(self):
        rows = self.dao_sucursales.listar_todas_con_direccion()
        if not rows:
            print("No hay sucursales con dirección registradas.")
            return
        print("\n--- Sucursales con Dirección ---")
        print("ID | Nombre de Sucursal           | Dirección")
        print("-"*65)
        for row in rows:
            print(f"{row[0]:<3} | {row[1]:<28} | {row[3]}")

    def registrar_inventario(self):
        print("\n--- Registrar Inventario en Sucursal ---")
        try:
            print("\n--- Sucursales disponibles ---")
            sucursales = self.dao_sucursales.listar_todas()
            if not sucursales:
                print("No hay sucursales registradas.")
                return
            for s in sucursales:
                print(f"   ID: {s[0]} - {s[1]}")
            id_sucursal = int(input("ID de la sucursal: "))
            
            print("\n--- Productos disponibles ---")
            productos = self.dao_productos.listar_todos()
            if not productos:
                print("No hay productos registrados.")
                return
            for p in productos:
                print(f"   ID: {p[0]} - {p[1]}")
            id_producto = int(input("ID del producto: "))
            
            cantidad = int(input("Cantidad a agregar al inventario: "))
            
            self.dao_sucursales.registrar_inventario(cantidad, id_sucursal, id_producto)
        except ValueError:
            print("Error: Los IDs y cantidad deben ser numéricos.")
        except Exception as e:
            print(f"Error al registrar inventario: {e}")

    def mostrar_inventario_sucursal(self):
        print("\n--- Inventario por Sucursal ---")
        try:
            print("\n--- Sucursales disponibles ---")
            sucursales = self.dao_sucursales.listar_todas()
            if not sucursales:
                print("No hay sucursales registradas.")
                return
            for s in sucursales:
                print(f"   ID: {s[0]} - {s[1]}")
            id_sucursal = int(input("ID de la sucursal: "))
            
            rows = self.dao_sucursales.listar_inventario_por_sucursal(id_sucursal)
            if not rows:
                print("No hay inventario registrado en esta sucursal.")
                return
            
            print("\nID | Cantidad | Producto")
            print("-"*40)
            for row in rows:
                print(f"{row[0]:<3} | {row[1]:<8} | {row[2]}")
        except ValueError:
            print("Error: El ID debe ser numérico.")
        except Exception as e:
            print(f"Error al listar inventario: {e}")

  
    # Menu: Trabajadores
 
    def menu_trabajadores(self):
        while True:
            print("\n" + "-"*40)
            print("   Gestion de Trabajadores")
            print("-"*40)
            print("1. Ver todos los trabajadores")
            print("2. Buscar trabajador por ID")
            print("3. Ver trabajadores por sucursal")
            print("4. Ver roles")
            print("5. Ver turnos")
            print("0. Volver")
            
            opcion = input("Seleccione: ")
            
            if opcion == "0":
                break
            elif opcion == "1":
                self.mostrar_trabajadores()
            elif opcion == "2":
                self.buscar_trabajador()
            elif opcion == "3":
                self.mostrar_trabajadores_por_sucursal()
            elif opcion == "4":
                self.mostrar_roles()
            elif opcion == "5":
                self.mostrar_turnos()

    def mostrar_trabajadores(self):
        rows = self.dao_trabajadores.listar_todos()
        if not rows:
            print("No hay trabajadores registrados.")
            return
        print("\n--- Lista de Trabajadores ---")
        print("ID | Nombre completo              | Correo                 | Sucursal")
        print("-"*65)
        for row in rows:
            print(f"{row[0]:<3} | {row[1]} {row[2]} {row[3]:<20} | {row[4]:<20} | {row[6]}")

    def buscar_trabajador(self):
        print("\n--- Buscar Trabajador ---")
        id_trabajador = int(input("ID del trabajador: "))
        row = self.dao_trabajadores.buscar_por_id(id_trabajador)
        if row:
            print(f"ID: {row[0]}")
            print(f"Nombre: {row[1]} {row[2]} {row[3]}")
            print(f"Correo: {row[4]}")
            print(f"Estado: {row[5]}")
            print(f"Sucursal ID: {row[6]}")
            print(f"Turno ID: {row[7]}")
            print(f"Rol ID: {row[8]}")

    def mostrar_trabajadores_por_sucursal(self):
        print("\n--- Trabajadores por Sucursal ---")
        self.mostrar_sucursales()
        id_sucursal = int(input("Seleccione ID de sucursal: "))
        rows = self.dao_trabajadores.listar_por_sucursal(id_sucursal)
        if not rows:
            print("No hay trabajadores en esta sucursal.")
            return
        print("\n--- Trabajadores en Sucursal ---")
        print("ID | Nombre completo              | Correo                 | Estado")
        print("-"*60)
        for row in rows:
            print(f"{row[0]:<3} | {row[1]} {row[2]} {row[3]:<20} | {row[4]:<20} | {row[5]}")

    def mostrar_roles(self):
        rows = self.dao_roles.listar_todos()
        if not rows:
            print("No hay roles registrados.")
            return
        print("\n--- Roles ---")
        print("ID | Rol")
        print("-"*20)
        for row in rows:
            print(f"{row[0]:<3} | {row[1]}")

    def mostrar_turnos(self):
        rows = self.dao_turnos.listar_todos()
        if not rows:
            print("No hay turnos registrados.")
            return
        print("\n--- Turnos ---")
        print("ID | Turno")
        print("-"*20)
        for row in rows:
            print(f"{row[0]:<3} | {row[1]}")


    # Menu: Ventas
  
    def menu_ventas(self):
        while True:
            print("\n" + "-"*40)
            print("   Gestion de Ventas")
            print("-"*40)
            print("1. Registrar venta")
            print("2. Consultar ventas")
            print("3. Ver inventario por sucursal")
            print("4. Ver métodos de pago")
            print("5. Buscar detalle de venta por ID")
            print("0. Volver")

            opcion = input("Seleccione: ")

            if opcion == "0":
                break
            elif opcion == "1":
                self.registrar_venta()
            elif opcion == "2":
                self.mostrar_ventas()
            elif opcion == "3":
                self.mostrar_inventario_venta()
            elif opcion == "4":
                self.mostrar_metodos_pago_venta()
            elif opcion == "5":
                self.buscar_venta()
            else:
                print("Opcion no valida.")

    def mostrar_metodos_pago_venta(self):
        rows = self.dao_ventas.listar_metodos_pago()
        if not rows:
            print("No hay metodos de pago registrados.")
            return
        print("\nID | Metodo de pago")
        print("-"*30)
        for row in rows:
            print(f"{row[0]:<2} | {row[1]}")

    def mostrar_inventario_venta(self):
        try:
            id_sucursal = int(input("ID de la sucursal: "))
        except ValueError:
            print("El ID de sucursal debe ser numerico.")
            return

        rows = self.dao_ventas.listar_inventario(id_sucursal)
        if not rows:
            print("No hay productos disponibles para esa sucursal.")
            return

        print("\nID | Producto | Precio | Existencia")
        print("-"*65)
        for row in rows:
            print(f"{row[0]:<3} | {row[1]:<25} | {row[2]:>10} | {row[3]}")

    def registrar_venta(self):
        print("\n--- Registrar Venta ---")
        try:
            cedula = input("Cedula del cliente: ").strip()
            id_trabajador = int(input("ID del trabajador: "))
            id_tipo_pago = int(input("ID del metodo de pago: "))
            id_producto = int(input("ID del producto: "))
            cantidad = int(input("Cantidad: "))
            id_sucursal = int(input("ID de la sucursal: "))
        except ValueError:
            print("Trabajador, metodo de pago, producto, cantidad y sucursal deben ser numericos.")
            return

        resultado = self.dao_ventas.registrar(
            cedula,
            id_trabajador,
            id_tipo_pago,
            id_producto,
            cantidad,
            id_sucursal,
        )

        print(f"Resultado: {resultado['mensaje']}")
        if resultado["ok"]:
            print(f"ID de venta: {resultado['id_venta']}")
            print(f"Total: {resultado['total']}")

    def mostrar_ventas(self):
        rows = self.dao_ventas.consultar_todas()
        if not rows:
            print("No hay ventas registradas.")
            return

        print("\nID | Fecha | Cedula | Cliente | Trabajador | Metodo | Total")
        print("-"*120)
        for row in rows:
            print(
                f"{row[0]} | {row[1]} | {row[2]} | {row[3]} | "
                f"{row[4]} | {row[5]} | {row[6]}"
            )

    def buscar_venta(self):
        print("\n--- Buscar Detalle de Venta ---")
        try:
            id_venta = int(input("ID de la venta: "))
        except ValueError:
            print("El ID debe ser numerico.")
            return
        
        row = self.dao_ventas.ver_detalle_venta(id_venta)
        if row:
            print("\n--- Detalle de Venta ---")
            print(f"ID Venta: {row[0]}")
            print(f"Fecha: {row[1]}")
            print(f"Cédula: {row[2]}")
            print(f"Cliente: {row[3]}")
            print(f"Trabajador: {row[4]}")
            print(f"Método de Pago: {row[5]}")
            print(f"Total: {row[6]:,.2f}")


    # Menu: Devoluciones

    def menu_devoluciones(self):
        while True:
            print("\n" + "-"*40)
            print("   Gestion de Devoluciones")
            print("-"*40)
            print("1. Ver tipos de devolución")
            print("0. Volver")
            
            opcion = input("Seleccione: ")
            
            if opcion == "0":
                break
            elif opcion == "1":
                self.mostrar_tipos_devoluciones()

    def mostrar_tipos_devoluciones(self):
        rows = self.dao_tipo_devoluciones.listar_todos()
        if not rows:
            print("No hay tipos de devolución registrados.")
            return
        print("\n--- Tipos de Devolución ---")
        print("ID | Tipo de Devolución")
        print("-"*30)
        for row in rows:
            print(f"{row[0]:<3} | {row[1]}")


    # Menu: Reportes

    def menu_reportes(self):
        while True:
            print("\n" + "-"*40)
            print("   Reportes")
            print("-"*40)
            print("1. Ver todas las ventas (detalle)")
            print("2. Ver clientes con historial de compras")
            print("3. Ver productos por proveedor")
            print("4. Ver productos por categoría")
            print("0. Volver")
            
            opcion = input("Seleccione: ")
            
            if opcion == "0":
                break
            elif opcion == "1":
                self.mostrar_ventas()
            elif opcion == "2":
                self.mostrar_historial_compras()
            elif opcion == "3":
                self.mostrar_productos_por_proveedor()
            elif opcion == "4":
                self.mostrar_productos_por_categoria()

if __name__ == "__main__":
    app = MenuFerreteria()
    if app.conectar():
        app.mostrar_menu()
    else:
        print("\nError: No se pudo conectar a la base de datos.")