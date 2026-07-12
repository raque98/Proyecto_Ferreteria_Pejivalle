# main.py
# Descripción: Menú principal del sistema de gestión

import os
from dotenv import load_dotenv
import oracledb

# Importar DAOs
from dao.dao_tipo_pagos import DAOTipoPagos
from dao.dao_clientes import DAOClientes
from dao.dao_proveedores import DAOProveedores

load_dotenv()

class MenuFerreteria:
    def __init__(self):
        self.connection = None
        self.dao_tipo_pagos = None
        self.dao_clientes = None
        self.dao_proveedores = None
        
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
            print("5.  Gestionar Trabajadores")
            print("6.  Gestionar Sucursales")
            print("7.  Gestionar Ventas")
            print("8.  Reportes")
            print("0.  Salir")
            print("="*55)
            
            try:
                opcion = int(input("Seleccione una opción: "))
                
                if opcion == 0:
                    print("\n Hasta luego!")
                    break
                elif opcion == 1:
                    self.menu_tipo_pagos()
                elif opcion == 2:
                    self.menu_clientes()
                elif opcion == 3:
                    self.menu_proveedores()
                else:
                    print("\nOpción no disponible aún. Próximamente...")
                    
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
            print(f"{row[0]:<11} | {row[1]:<20} | {row[2]:<7} | ₡{row[3]:,.2f}")

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
        print("\n--- PRODUCTOS POR PROVEEDOR ---")
        print("ID Producto | Producto              | Proveedor             | Contacto")
        print("-"*75)
        for row in rows:
            print(f"{row[0]:<11} | {row[1]:<22} | {row[2]:<22} | {row[3]}")

    def contar_productos_proveedor(self):
        print("\n--- CONTAR PRODUCTOS DE PROVEEDOR ---")
        id_proveedor = int(input("ID del proveedor: "))
        cantidad = self.dao_proveedores.contar_productos(id_proveedor)
        print(f"Este proveedor tiene {cantidad} producto(s) registrado(s).")

    def ver_estado_proveedor(self):
        print("\n--- VER ESTADO DE PROVEEDOR ---")
        id_proveedor = int(input("ID del proveedor: "))
        estado = self.dao_proveedores.ver_estado(id_proveedor)
        print(f"El estado del proveedor es: {estado}")

if __name__ == "__main__":
    app = MenuFerreteria()
    if app.conectar():
        app.mostrar_menu()
    else:
        print("\nError: No se pudo conectar a la base de datos.")