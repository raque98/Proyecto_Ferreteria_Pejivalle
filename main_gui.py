# main_gui.py
# Descripción: Interfaz gráfica para el sistema de gestión de Ferretería Pejivalle

import os
import tkinter as tk
from tkinter import ttk, messagebox, scrolledtext
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

class FerreteriaGUI:
    def __init__(self, root):
        self.root = root
        self.root.title("Ferretería Pejivalle - Sistema de Gestión")
        self.root.geometry("1000x700")
        self.root.resizable(True, True)
        
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
        
        self.conectar()
        self.crear_menu_principal()
    
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
            messagebox.showinfo("Conexión", "Conexión exitosa a Oracle Cloud")
            return True
        except Exception as e:
            messagebox.showerror("Error de conexión", f"No se pudo conectar: {e}")
            self.root.destroy()
            return False
    
    def crear_menu_principal(self):
        # Frame principal con padding
        main_frame = ttk.Frame(self.root, padding="10")
        main_frame.pack(fill=tk.BOTH, expand=True)
        
        # Título
        titulo = ttk.Label(main_frame, text="Ferreteria Pejivalle - Sistema de Gestion", 
                          font=("Arial", 16, "bold"))
        titulo.pack(pady=10)
        
        # Frame para los botones del menú
        botones_frame = ttk.Frame(main_frame)
        botones_frame.pack(pady=20)
        
        botones = [
            ("1. Métodos de Pago", self.menu_tipo_pagos),
            ("2. Clientes", self.menu_clientes),
            ("3. Proveedores", self.menu_proveedores),
            ("4. Productos", self.menu_productos),
            ("5. Sucursales", self.menu_sucursales),
            ("6. Trabajadores", self.menu_trabajadores),
            ("7. Ventas", self.menu_ventas),
            ("8. Devoluciones", self.menu_devoluciones),
            ("9. Reportes", self.menu_reportes)
        ]
        
        for i, (texto, comando) in enumerate(botones):
            btn = ttk.Button(botones_frame, text=texto, command=comando, width=25)
            fila = i // 3
            columna = i % 3
            btn.grid(row=fila, column=columna, padx=5, pady=5, sticky="ew")
        
        # Botón Salir
        ttk.Button(main_frame, text="0. Salir", command=self.root.quit, width=25).pack(pady=10)
        
        # Área de resultados
        frame_resultados = ttk.LabelFrame(main_frame, text="Resultados", padding="5")
        frame_resultados.pack(fill=tk.BOTH, expand=True, pady=10)
        
        self.text_resultados = scrolledtext.ScrolledText(frame_resultados, height=15)
        self.text_resultados.pack(fill=tk.BOTH, expand=True)
    
    # Metodos Auxiliares
    
    def mostrar_resultados(self, texto, limpiar=True):
        if limpiar:
            self.text_resultados.delete(1.0, tk.END)
        self.text_resultados.insert(tk.END, texto)
    
    def mostrar_tabla(self, columnas, datos, titulo=""):
        """Muestra datos en formato tabla dentro del área de resultados."""
        texto = titulo + "\n" + "-"*80 + "\n"
        # Encabezados
        for col in columnas:
            texto += f"{col:<20} "
        texto += "\n" + "-"*80 + "\n"
        
        for fila in datos:
            for item in fila:
                texto += f"{str(item):<20} "
            texto += "\n"
        texto += "-"*80 + "\n"
        self.mostrar_resultados(texto)
    
    def limpiar_resultados(self):
        self.text_resultados.delete(1.0, tk.END)

    # Menu: Metodos de Pago
    
    def menu_tipo_pagos(self):
        ventana = tk.Toplevel(self.root)
        ventana.title("Métodos de Pago")
        ventana.geometry("500x400")
        ventana.resizable(True, True)
        
        frame = ttk.Frame(ventana, padding="10")
        frame.pack(fill=tk.BOTH, expand=True)
        
        ttk.Label(frame, text="Métodos de Pago", font=("Arial", 14, "bold")).pack(pady=5)
        
        ttk.Button(frame, text="Ver todos", command=self.ver_tipo_pagos, width=20).pack(pady=5)
        ttk.Button(frame, text="Registrar nuevo", command=self.registrar_tipo_pago, width=20).pack(pady=5)
        ttk.Button(frame, text="Cerrar", command=ventana.destroy, width=20).pack(pady=10)
    
    def ver_tipo_pagos(self):
        rows = self.dao_tipo_pagos.listar_todos()
        if not rows:
            self.mostrar_resultados("No hay métodos de pago registrados.")
            return
        self.mostrar_tabla(["ID", "Metodo de Pago"], rows, "--- Metodos de Pago ---")
    
    def registrar_tipo_pago(self):
        ventana = tk.Toplevel(self.root)
        ventana.title("Registrar Método de Pago")
        ventana.geometry("400x200")
        ventana.resizable(False, False)
        
        frame = ttk.Frame(ventana, padding="10")
        frame.pack(fill=tk.BOTH, expand=True)
        
        ttk.Label(frame, text="Nombre del método de pago:").pack(pady=5)
        entry = ttk.Entry(frame, width=40)
        entry.pack(pady=5)
        
        def guardar():
            nombre = entry.get()
            if nombre.strip():
                self.dao_tipo_pagos.registrar(nombre)
                messagebox.showinfo("Exito", "Metodo de pago registrado con exito")
                ventana.destroy()
            else:
                messagebox.showwarning("Advertencia", "Ingrese un nombre válido")
        
        ttk.Button(frame, text="Guardar", command=guardar, width=15).pack(pady=10)
        ttk.Button(frame, text="Cancelar", command=ventana.destroy, width=15).pack(pady=5)

    # Menu: Clientes
    
    def menu_clientes(self):
        ventana = tk.Toplevel(self.root)
        ventana.title("Clientes")
        ventana.geometry("500x450")
        ventana.resizable(True, True)
        
        frame = ttk.Frame(ventana, padding="10")
        frame.pack(fill=tk.BOTH, expand=True)
        
        ttk.Label(frame, text="Gestión de Clientes", font=("Arial", 14, "bold")).pack(pady=5)
        
        ttk.Button(frame, text="Ver todos", command=self.ver_clientes, width=25).pack(pady=3)
        ttk.Button(frame, text="Registrar nuevo", command=self.registrar_cliente_gui, width=25).pack(pady=3)
        ttk.Button(frame, text="Editar correo/teléfono", command=self.editar_cliente_gui, width=25).pack(pady=3)
        ttk.Button(frame, text="Eliminar cliente", command=self.eliminar_cliente_gui, width=25).pack(pady=3)
        ttk.Button(frame, text="Ver historial de compras", command=self.historial_compras, width=25).pack(pady=3)
        ttk.Button(frame, text="Verificar si existe", command=self.verificar_cliente_gui, width=25).pack(pady=3)
        ttk.Button(frame, text="Cerrar", command=ventana.destroy, width=25).pack(pady=10)
    
    def ver_clientes(self):
        rows = self.dao_clientes.consultar_todos()
        if not rows:
            self.mostrar_resultados("No hay clientes registrados.")
            return
        self.mostrar_tabla(["Cédula", "Nombre", "Apellido1", "Apellido2", "Correo", "Teléfono"], 
                          rows, "--- LISTA DE CLIENTES ---")
    
    def registrar_cliente_gui(self):
        ventana = tk.Toplevel(self.root)
        ventana.title("Registrar Cliente")
        ventana.geometry("400x450")
        ventana.resizable(False, False)
        
        frame = ttk.Frame(ventana, padding="10")
        frame.pack(fill=tk.BOTH, expand=True)
        
        ttk.Label(frame, text="Registrar Cliente", font=("Arial", 12, "bold")).pack(pady=5)
        
        campos = [
            ("Cédula:", "cedula"),
            ("Nombre:", "nombre"),
            ("Primer apellido:", "apellido1"),
            ("Segundo apellido:", "apellido2"),
            ("Correo electrónico:", "correo"),
            ("Teléfono:", "telefono")
        ]
        
        entries = {}
        for label, key in campos:
            ttk.Label(frame, text=label).pack(anchor="w", pady=2)
            entry = ttk.Entry(frame, width=40)
            entry.pack(anchor="w", pady=2)
            entries[key] = entry
        
        def guardar():
            try:
                self.dao_clientes.registrar(
                    entries["cedula"].get(),
                    entries["nombre"].get(),
                    entries["apellido1"].get(),
                    entries["apellido2"].get(),
                    entries["correo"].get(),
                    entries["telefono"].get()
                )
                messagebox.showinfo("Exito", "Cliente registrado con exito")
                ventana.destroy()
            except Exception as e:
                messagebox.showerror("Error", f"No se pudo registrar: {e}")
        
        ttk.Button(frame, text="Guardar", command=guardar, width=15).pack(pady=10)
        ttk.Button(frame, text="Cancelar", command=ventana.destroy, width=15).pack(pady=5)
    
    def editar_cliente_gui(self):
        ventana = tk.Toplevel(self.root)
        ventana.title("Editar Cliente")
        ventana.geometry("400x300")
        ventana.resizable(False, False)
        
        frame = ttk.Frame(ventana, padding="10")
        frame.pack(fill=tk.BOTH, expand=True)
        
        ttk.Label(frame, text="Editar Cliente", font=("Arial", 12, "bold")).pack(pady=5)
        
        ttk.Label(frame, text="Cédula del cliente:").pack(anchor="w", pady=2)
        entry_cedula = ttk.Entry(frame, width=40)
        entry_cedula.pack(anchor="w", pady=2)
        
        ttk.Label(frame, text="Nuevo correo:").pack(anchor="w", pady=2)
        entry_correo = ttk.Entry(frame, width=40)
        entry_correo.pack(anchor="w", pady=2)
        
        ttk.Label(frame, text="Nuevo teléfono:").pack(anchor="w", pady=2)
        entry_telefono = ttk.Entry(frame, width=40)
        entry_telefono.pack(anchor="w", pady=2)
        
        def guardar():
            try:
                self.dao_clientes.editar_correo_telefono(
                    entry_cedula.get(),
                    entry_correo.get(),
                    entry_telefono.get()
                )
                messagebox.showinfo("Exito", "Cliente actualizado con exito")
                ventana.destroy()
            except Exception as e:
                messagebox.showerror("Error", f"No se pudo actualizar: {e}")
        
        ttk.Button(frame, text="Guardar", command=guardar, width=15).pack(pady=10)
        ttk.Button(frame, text="Cancelar", command=ventana.destroy, width=15).pack(pady=5)
    
    def eliminar_cliente_gui(self):
        ventana = tk.Toplevel(self.root)
        ventana.title("Eliminar Cliente")
        ventana.geometry("400x180")
        ventana.resizable(False, False)
        
        frame = ttk.Frame(ventana, padding="10")
        frame.pack(fill=tk.BOTH, expand=True)
        
        ttk.Label(frame, text="Eliminar Cliente", font=("Arial", 12, "bold")).pack(pady=5)
        
        ttk.Label(frame, text="Cédula del cliente a eliminar:").pack(anchor="w", pady=2)
        entry_cedula = ttk.Entry(frame, width=40)
        entry_cedula.pack(anchor="w", pady=2)
        
        def guardar():
            if messagebox.askyesno("Confirmar", "¿Esta seguro de eliminar este cliente?"):
                try:
                    self.dao_clientes.eliminar(entry_cedula.get())
                    messagebox.showinfo("Exito", "Cliente eliminado con exito")
                    ventana.destroy()
                except Exception as e:
                    messagebox.showerror("Error", f"No se pudo eliminar: {e}")
        
        ttk.Button(frame, text="Eliminar", command=guardar, width=15).pack(pady=10)
        ttk.Button(frame, text="Cancelar", command=ventana.destroy, width=15).pack(pady=5)
    
    def historial_compras(self):
        rows = self.dao_clientes.mostrar_historial_compras()
        if not rows:
            self.mostrar_resultados("No hay datos de compras.")
            return
        self.mostrar_tabla(["Cédula", "Nombre", "Compras", "Total Comprado"], 
                          rows, "--- Historial de Compras ---")
    
    def verificar_cliente_gui(self):
        ventana = tk.Toplevel(self.root)
        ventana.title("Verificar Cliente")
        ventana.geometry("400x180")
        ventana.resizable(False, False)
        
        frame = ttk.Frame(ventana, padding="10")
        frame.pack(fill=tk.BOTH, expand=True)
        
        ttk.Label(frame, text="Verificar Cliente", font=("Arial", 12, "bold")).pack(pady=5)
        
        ttk.Label(frame, text="Cédula del cliente:").pack(anchor="w", pady=2)
        entry_cedula = ttk.Entry(frame, width=40)
        entry_cedula.pack(anchor="w", pady=2)
        
        def verificar():
            try:
                existe = self.dao_clientes.existe(entry_cedula.get())
                if existe:
                    messagebox.showinfo("Resultado", "El cliente existe en la base de datos.")
                else:
                    messagebox.showinfo("Resultado", "El cliente no existe.")
            except Exception as e:
                messagebox.showerror("Error", f"No se pudo verificar: {e}")
        
        ttk.Button(frame, text="Verificar", command=verificar, width=15).pack(pady=10)
        ttk.Button(frame, text="Cerrar", command=ventana.destroy, width=15).pack(pady=5)


    # Menu: Proveedores
    
    def menu_proveedores(self):
        ventana = tk.Toplevel(self.root)
        ventana.title("Proveedores")
        ventana.geometry("500x450")
        ventana.resizable(True, True)
        
        frame = ttk.Frame(ventana, padding="10")
        frame.pack(fill=tk.BOTH, expand=True)
        
        ttk.Label(frame, text="Gestión de Proveedores", font=("Arial", 14, "bold")).pack(pady=5)
        
        ttk.Button(frame, text="Ver todos", command=self.ver_proveedores, width=25).pack(pady=3)
        ttk.Button(frame, text="Registrar nuevo", command=self.registrar_proveedor_gui, width=25).pack(pady=3)
        ttk.Button(frame, text="Editar contacto", command=self.editar_proveedor_gui, width=25).pack(pady=3)
        ttk.Button(frame, text="Eliminar proveedor", command=self.eliminar_proveedor_gui, width=25).pack(pady=3)
        ttk.Button(frame, text="Cambiar estado", command=self.cambiar_estado_proveedor_gui, width=25).pack(pady=3)
        ttk.Button(frame, text="Ver productos por proveedor", command=self.productos_por_proveedor, width=25).pack(pady=3)
        ttk.Button(frame, text="Ver estado de proveedor", command=self.ver_estado_proveedor_gui, width=25).pack(pady=3)
        ttk.Button(frame, text="Cerrar", command=ventana.destroy, width=25).pack(pady=10)
    
    def ver_proveedores(self):
        rows = self.dao_proveedores.consultar_todos()
        if not rows:
            self.mostrar_resultados("No hay proveedores registrados.")
            return
        self.mostrar_tabla(["Proveedor", "Contacto", "Apellido1", "Apellido2", "Correo", "Teléfono", "Estado"], 
                          rows, "--- Lista de Proveedores ---")
    
    def registrar_proveedor_gui(self):
        ventana = tk.Toplevel(self.root)
        ventana.title("Registrar Proveedor")
        ventana.geometry("400x450")
        ventana.resizable(False, False)
        
        frame = ttk.Frame(ventana, padding="10")
        frame.pack(fill=tk.BOTH, expand=True)
        
        ttk.Label(frame, text="Registrar Proveedor", font=("Arial", 12, "bold")).pack(pady=5)
        
        campos = [
            ("Nombre del proveedor:", "nombre_proveedor"),
            ("Nombre de contacto:", "nombre_contacto"),
            ("Primer apellido:", "apellido1"),
            ("Segundo apellido:", "apellido2"),
            ("Correo electrónico:", "correo"),
            ("Teléfono:", "telefono")
        ]
        
        entries = {}
        for label, key in campos:
            ttk.Label(frame, text=label).pack(anchor="w", pady=2)
            entry = ttk.Entry(frame, width=40)
            entry.pack(anchor="w", pady=2)
            entries[key] = entry
        
        def guardar():
            try:
                self.dao_proveedores.registrar(
                    entries["nombre_proveedor"].get(),
                    entries["nombre_contacto"].get(),
                    entries["apellido1"].get(),
                    entries["apellido2"].get(),
                    entries["correo"].get(),
                    entries["telefono"].get()
                )
                messagebox.showinfo("Exito", "Proveedor registrado con exito")
                ventana.destroy()
            except Exception as e:
                messagebox.showerror("Error", f"No se pudo registrar: {e}")
        
        ttk.Button(frame, text="Guardar", command=guardar, width=15).pack(pady=10)
        ttk.Button(frame, text="Cancelar", command=ventana.destroy, width=15).pack(pady=5)
    
    def editar_proveedor_gui(self):
        ventana = tk.Toplevel(self.root)
        ventana.title("Editar Contacto de Proveedor")
        ventana.geometry("400x400")
        ventana.resizable(False, False)
        
        frame = ttk.Frame(ventana, padding="10")
        frame.pack(fill=tk.BOTH, expand=True)
        
        ttk.Label(frame, text="Editar Contacto de Proveedor", font=("Arial", 12, "bold")).pack(pady=5)
        
        campos = [
            ("ID del proveedor:", "id_proveedor"),
            ("Nuevo nombre de contacto:", "nombre_contacto"),
            ("Nuevo primer apellido:", "apellido1"),
            ("Nuevo segundo apellido:", "apellido2"),
            ("Nuevo correo:", "correo"),
            ("Nuevo teléfono:", "telefono")
        ]
        
        entries = {}
        for label, key in campos:
            ttk.Label(frame, text=label).pack(anchor="w", pady=2)
            entry = ttk.Entry(frame, width=40)
            entry.pack(anchor="w", pady=2)
            entries[key] = entry
        
        def guardar():
            try:
                self.dao_proveedores.editar_contacto(
                    int(entries["id_proveedor"].get()),
                    entries["nombre_contacto"].get(),
                    entries["apellido1"].get(),
                    entries["apellido2"].get(),
                    entries["correo"].get(),
                    entries["telefono"].get()
                )
                messagebox.showinfo("Exito", "Contacto actualizado con exito")
                ventana.destroy()
            except Exception as e:
                messagebox.showerror("Error", f"No se pudo actualizar: {e}")
        
        ttk.Button(frame, text="Guardar", command=guardar, width=15).pack(pady=10)
        ttk.Button(frame, text="Cancelar", command=ventana.destroy, width=15).pack(pady=5)
    
    def eliminar_proveedor_gui(self):
        ventana = tk.Toplevel(self.root)
        ventana.title("Eliminar Proveedor")
        ventana.geometry("400x180")
        ventana.resizable(False, False)
        
        frame = ttk.Frame(ventana, padding="10")
        frame.pack(fill=tk.BOTH, expand=True)
        
        ttk.Label(frame, text="Eliminar Proveedor", font=("Arial", 12, "bold")).pack(pady=5)
        
        ttk.Label(frame, text="ID del proveedor a eliminar:").pack(anchor="w", pady=2)
        entry_id = ttk.Entry(frame, width=40)
        entry_id.pack(anchor="w", pady=2)
        
        def guardar():
            if messagebox.askyesno("Confirmar", "¿Está seguro de eliminar este proveedor?"):
                try:
                    self.dao_proveedores.eliminar(int(entry_id.get()))
                    messagebox.showinfo("Exito", "Proveedor eliminado con exito")
                    ventana.destroy()
                except Exception as e:
                    messagebox.showerror("Error", f"No se pudo eliminar: {e}")
        
        ttk.Button(frame, text="Eliminar", command=guardar, width=15).pack(pady=10)
        ttk.Button(frame, text="Cancelar", command=ventana.destroy, width=15).pack(pady=5)
    
    def cambiar_estado_proveedor_gui(self):
        ventana = tk.Toplevel(self.root)
        ventana.title("Cambiar Estado de Proveedor")
        ventana.geometry("400x200")
        ventana.resizable(False, False)
        
        frame = ttk.Frame(ventana, padding="10")
        frame.pack(fill=tk.BOTH, expand=True)
        
        ttk.Label(frame, text="Cambiar Estado de Proveedor", font=("Arial", 12, "bold")).pack(pady=5)
        
        ttk.Label(frame, text="ID del proveedor:").pack(anchor="w", pady=2)
        entry_id = ttk.Entry(frame, width=40)
        entry_id.pack(anchor="w", pady=2)
        
        ttk.Label(frame, text="Nuevo estado (Activo/Inactivo):").pack(anchor="w", pady=2)
        entry_estado = ttk.Entry(frame, width=40)
        entry_estado.pack(anchor="w", pady=2)
        
        def guardar():
            try:
                self.dao_proveedores.cambiar_estado(int(entry_id.get()), entry_estado.get())
                messagebox.showinfo("Éxito", "Estado actualizado con éxito")
                ventana.destroy()
            except Exception as e:
                messagebox.showerror("Error", f"No se pudo actualizar: {e}")
        
        ttk.Button(frame, text="Guardar", command=guardar, width=15).pack(pady=10)
        ttk.Button(frame, text="Cancelar", command=ventana.destroy, width=15).pack(pady=5)
    
    def productos_por_proveedor(self):
        rows = self.dao_proveedores.mostrar_productos_por_proveedor()
        if not rows:
            self.mostrar_resultados("No hay datos de productos por proveedor.")
            return
        self.mostrar_tabla(["ID Producto", "Producto", "Proveedor", "Contacto"], 
                          rows, "--- Productos por Proveedor ---")
    
    def ver_estado_proveedor_gui(self):
        ventana = tk.Toplevel(self.root)
        ventana.title("Ver Estado de Proveedor")
        ventana.geometry("400x180")
        ventana.resizable(False, False)
        
        frame = ttk.Frame(ventana, padding="10")
        frame.pack(fill=tk.BOTH, expand=True)
        
        ttk.Label(frame, text="Ver Estado de Proveedor", font=("Arial", 12, "bold")).pack(pady=5)
        
        ttk.Label(frame, text="ID del proveedor:").pack(anchor="w", pady=2)
        entry_id = ttk.Entry(frame, width=40)
        entry_id.pack(anchor="w", pady=2)
        
        def verificar():
            try:
                estado = self.dao_proveedores.ver_estado(int(entry_id.get()))
                messagebox.showinfo("Estado", f"El estado del proveedor es: {estado}")
            except Exception as e:
                messagebox.showerror("Error", f"No se pudo verificar: {e}")
        
        ttk.Button(frame, text="Verificar", command=verificar, width=15).pack(pady=10)
        ttk.Button(frame, text="Cerrar", command=ventana.destroy, width=15).pack(pady=5)

    # ===========================================
    # MENU: PRODUCTOS
    # ===========================================
    
    def menu_productos(self):
        ventana = tk.Toplevel(self.root)
        ventana.title("Productos")
        ventana.geometry("500x400")
        ventana.resizable(True, True)
        
        frame = ttk.Frame(ventana, padding="10")
        frame.pack(fill=tk.BOTH, expand=True)
        
        ttk.Label(frame, text="Gestión de Productos", font=("Arial", 14, "bold")).pack(pady=5)
        
        ttk.Button(frame, text="Ver todos", command=self.ver_productos, width=25).pack(pady=3)
        ttk.Button(frame, text="Buscar por ID", command=self.buscar_producto_gui, width=25).pack(pady=3)
        ttk.Button(frame, text="Registrar nuevo", command=self.registrar_producto_gui, width=25).pack(pady=3)
        ttk.Button(frame, text="Ver categorías", command=self.ver_categorias, width=25).pack(pady=3)
        ttk.Button(frame, text="Cerrar", command=ventana.destroy, width=25).pack(pady=10)
    
    def ver_productos(self):
        rows = self.dao_productos.listar_todos()
        if not rows:
            self.mostrar_resultados("No hay productos registrados.")
            return
        self.mostrar_tabla(["ID", "Nombre", "Precio Venta", "Precio Costo"], 
                          rows, "--- Lista de Productos ---")
    
    def buscar_producto_gui(self):
        ventana = tk.Toplevel(self.root)
        ventana.title("Buscar Producto")
        ventana.geometry("400x180")
        ventana.resizable(False, False)
        
        frame = ttk.Frame(ventana, padding="10")
        frame.pack(fill=tk.BOTH, expand=True)
        
        ttk.Label(frame, text="Buscar Producto", font=("Arial", 12, "bold")).pack(pady=5)
        
        ttk.Label(frame, text="ID del producto:").pack(anchor="w", pady=2)
        entry_id = ttk.Entry(frame, width=40)
        entry_id.pack(anchor="w", pady=2)
        
        def buscar():
            try:
                row = self.dao_productos.buscar_por_id(int(entry_id.get()))
                if row:
                    texto = f"--- PRODUCTO ---\n"
                    texto += f"ID: {row[0]}\n"
                    texto += f"Nombre: {row[1]}\n"
                    texto += f"Descripción: {row[2]}\n"
                    texto += f"Precio Venta: {row[3]:,.2f}\n"
                    texto += f"Precio Costo: {row[4]:,.2f}\n"
                    texto += f"Categoría ID: {row[5]}"
                    self.mostrar_resultados(texto)
                else:
                    self.mostrar_resultados("No se encontró el producto.")
            except Exception as e:
                messagebox.showerror("Error", f"No se pudo buscar: {e}")
        
        ttk.Button(frame, text="Buscar", command=buscar, width=15).pack(pady=10)
        ttk.Button(frame, text="Cerrar", command=ventana.destroy, width=15).pack(pady=5)
    
    def registrar_producto_gui(self):
        ventana = tk.Toplevel(self.root)
        ventana.title("Registrar Producto")
        ventana.geometry("400x500")
        ventana.resizable(False, False)
        
        frame = ttk.Frame(ventana, padding="10")
        frame.pack(fill=tk.BOTH, expand=True)
        
        ttk.Label(frame, text="Registrar Producto", font=("Arial", 12, "bold")).pack(pady=5)
        
        campos = [
            ("Nombre:", "nombre"),
            ("Descripción:", "descripcion"),
            ("Precio venta:", "precio_venta"),
            ("Precio costo:", "precio_costo"),
            ("Fecha entrada (YYYY-MM-DD):", "fecha"),
            ("ID Proveedor:", "id_proveedor"),
            ("ID Categoría:", "id_categoria")
        ]
        
        entries = {}
        for label, key in campos:
            ttk.Label(frame, text=label).pack(anchor="w", pady=2)
            entry = ttk.Entry(frame, width=40)
            entry.pack(anchor="w", pady=2)
            entries[key] = entry
        
        def guardar():
            try:
                self.dao_productos.registrar(
                    entries["nombre"].get(),
                    entries["descripcion"].get(),
                    float(entries["precio_venta"].get()),
                    float(entries["precio_costo"].get()),
                    entries["fecha"].get(),
                    int(entries["id_proveedor"].get()),
                    int(entries["id_categoria"].get())
                )
                messagebox.showinfo("Éxito", "Producto registrado con éxito")
                ventana.destroy()
            except Exception as e:
                messagebox.showerror("Error", f"No se pudo registrar: {e}")
        
        ttk.Button(frame, text="Guardar", command=guardar, width=15).pack(pady=10)
        ttk.Button(frame, text="Cancelar", command=ventana.destroy, width=15).pack(pady=5)
    
    def ver_categorias(self):
        rows = self.dao_categorias.listar_todas()
        if not rows:
            self.mostrar_resultados("No hay categorías registradas.")
            return
        self.mostrar_tabla(["ID", "Categoría"], rows, "--- Categorias ---")

    # Menu: Sucursales
    
    def menu_sucursales(self):
        ventana = tk.Toplevel(self.root)
        ventana.title("Sucursales")
        ventana.geometry("500x350")
        ventana.resizable(True, True)
        
        frame = ttk.Frame(ventana, padding="10")
        frame.pack(fill=tk.BOTH, expand=True)
        
        ttk.Label(frame, text="Gestión de Sucursales", font=("Arial", 14, "bold")).pack(pady=5)
        
        ttk.Button(frame, text="Ver todas", command=self.ver_sucursales, width=25).pack(pady=3)
        ttk.Button(frame, text="Ver con dirección", command=self.ver_sucursales_direccion, width=25).pack(pady=3)
        ttk.Button(frame, text="Registrar inventario", command=self.registrar_inventario_gui, width=25).pack(pady=3)
        ttk.Button(frame, text="Ver inventario", command=self.ver_inventario_gui, width=25).pack(pady=3)
        ttk.Button(frame, text="Cerrar", command=ventana.destroy, width=25).pack(pady=10)
    
    def ver_sucursales(self):
        rows = self.dao_sucursales.listar_todas()
        if not rows:
            self.mostrar_resultados("No hay sucursales registradas.")
            return
        self.mostrar_tabla(["ID", "Nombre", "Estado"], rows, "--- Sucursales ---")
    
    def ver_sucursales_direccion(self):
        rows = self.dao_sucursales.listar_todas_con_direccion()
        if not rows:
            self.mostrar_resultados("No hay sucursales con dirección.")
            return
        self.mostrar_tabla(["ID", "Nombre", "Estado", "Dirección"], rows, "--- Sucursales con Direccion ---")
    
    def registrar_inventario_gui(self):
        ventana = tk.Toplevel(self.root)
        ventana.title("Registrar Inventario")
        ventana.geometry("400x300")
        ventana.resizable(False, False)
        
        frame = ttk.Frame(ventana, padding="10")
        frame.pack(fill=tk.BOTH, expand=True)
        
        ttk.Label(frame, text="Registrar Inventario", font=("Arial", 12, "bold")).pack(pady=5)
        
        ttk.Label(frame, text="ID Sucursal:").pack(anchor="w", pady=2)
        entry_sucursal = ttk.Entry(frame, width=40)
        entry_sucursal.pack(anchor="w", pady=2)
        
        ttk.Label(frame, text="ID Producto:").pack(anchor="w", pady=2)
        entry_producto = ttk.Entry(frame, width=40)
        entry_producto.pack(anchor="w", pady=2)
        
        ttk.Label(frame, text="Cantidad:").pack(anchor="w", pady=2)
        entry_cantidad = ttk.Entry(frame, width=40)
        entry_cantidad.pack(anchor="w", pady=2)
        
        def guardar():
            try:
                self.dao_sucursales.registrar_inventario(
                    int(entry_cantidad.get()),
                    int(entry_sucursal.get()),
                    int(entry_producto.get())
                )
                messagebox.showinfo("Exito", "Inventario registrado con exito")
                ventana.destroy()
            except Exception as e:
                messagebox.showerror("Error", f"No se pudo registrar: {e}")
        
        ttk.Button(frame, text="Guardar", command=guardar, width=15).pack(pady=10)
        ttk.Button(frame, text="Cancelar", command=ventana.destroy, width=15).pack(pady=5)
    
    def ver_inventario_gui(self):
        ventana = tk.Toplevel(self.root)
        ventana.title("Ver Inventario")
        ventana.geometry("400x200")
        ventana.resizable(False, False)
        
        frame = ttk.Frame(ventana, padding="10")
        frame.pack(fill=tk.BOTH, expand=True)
        
        ttk.Label(frame, text="Ver Inventario", font=("Arial", 12, "bold")).pack(pady=5)
        
        ttk.Label(frame, text="ID de la sucursal:").pack(anchor="w", pady=2)
        entry_id = ttk.Entry(frame, width=40)
        entry_id.pack(anchor="w", pady=2)
        
        def ver():
            try:
                rows = self.dao_sucursales.listar_inventario_por_sucursal(int(entry_id.get()))
                if not rows:
                    self.mostrar_resultados("No hay inventario en esta sucursal.")
                    return
                self.mostrar_tabla(["ID", "Cantidad", "Producto"], rows, "--- Inventario ---")
                ventana.destroy()
            except Exception as e:
                messagebox.showerror("Error", f"No se pudo listar: {e}")
        
        ttk.Button(frame, text="Ver", command=ver, width=15).pack(pady=10)
        ttk.Button(frame, text="Cancelar", command=ventana.destroy, width=15).pack(pady=5)

    # Menu: Trabajadores
    
    def menu_trabajadores(self):
        ventana = tk.Toplevel(self.root)
        ventana.title("Trabajadores")
        ventana.geometry("500x400")
        ventana.resizable(True, True)
        
        frame = ttk.Frame(ventana, padding="10")
        frame.pack(fill=tk.BOTH, expand=True)
        
        ttk.Label(frame, text="Gestión de Trabajadores", font=("Arial", 14, "bold")).pack(pady=5)
        
        ttk.Button(frame, text="Ver todos", command=self.ver_trabajadores, width=25).pack(pady=3)
        ttk.Button(frame, text="Buscar por ID", command=self.buscar_trabajador_gui, width=25).pack(pady=3)
        ttk.Button(frame, text="Ver por sucursal", command=self.ver_trabajadores_sucursal, width=25).pack(pady=3)
        ttk.Button(frame, text="Ver roles", command=self.ver_roles, width=25).pack(pady=3)
        ttk.Button(frame, text="Ver turnos", command=self.ver_turnos, width=25).pack(pady=3)
        ttk.Button(frame, text="Cerrar", command=ventana.destroy, width=25).pack(pady=10)
    
    def ver_trabajadores(self):
        rows = self.dao_trabajadores.listar_todos()
        if not rows:
            self.mostrar_resultados("No hay trabajadores registrados.")
            return
        self.mostrar_tabla(["ID", "Nombre", "Apellido1", "Apellido2", "Correo", "Sucursal"], 
                          rows, "--- Trabajadores ---")
    
    def buscar_trabajador_gui(self):
        ventana = tk.Toplevel(self.root)
        ventana.title("Buscar Trabajador")
        ventana.geometry("400x200")
        ventana.resizable(False, False)
        
        frame = ttk.Frame(ventana, padding="10")
        frame.pack(fill=tk.BOTH, expand=True)
        
        ttk.Label(frame, text="Buscar Trabajador", font=("Arial", 12, "bold")).pack(pady=5)
        
        ttk.Label(frame, text="ID del trabajador:").pack(anchor="w", pady=2)
        entry_id = ttk.Entry(frame, width=40)
        entry_id.pack(anchor="w", pady=2)
        
        def buscar():
            try:
                row = self.dao_trabajadores.buscar_por_id(int(entry_id.get()))
                if row:
                    texto = f"--- TRABAJADOR ---\n"
                    texto += f"ID: {row[0]}\n"
                    texto += f"Nombre: {row[1]} {row[2]} {row[3]}\n"
                    texto += f"Correo: {row[4]}\n"
                    texto += f"Estado: {row[5]}\n"
                    texto += f"Sucursal ID: {row[6]}\n"
                    texto += f"Turno ID: {row[7]}\n"
                    texto += f"Rol ID: {row[8]}"
                    self.mostrar_resultados(texto)
                else:
                    self.mostrar_resultados("No se encontró el trabajador.")
            except Exception as e:
                messagebox.showerror("Error", f"No se pudo buscar: {e}")
        
        ttk.Button(frame, text="Buscar", command=buscar, width=15).pack(pady=10)
        ttk.Button(frame, text="Cerrar", command=ventana.destroy, width=15).pack(pady=5)
    
    def ver_trabajadores_sucursal(self):
        ventana = tk.Toplevel(self.root)
        ventana.title("Trabajadores por Sucursal")
        ventana.geometry("400x200")
        ventana.resizable(False, False)
        
        frame = ttk.Frame(ventana, padding="10")
        frame.pack(fill=tk.BOTH, expand=True)
        
        ttk.Label(frame, text="Trabajadores por Sucursal", font=("Arial", 12, "bold")).pack(pady=5)
        
        ttk.Label(frame, text="ID de la sucursal:").pack(anchor="w", pady=2)
        entry_id = ttk.Entry(frame, width=40)
        entry_id.pack(anchor="w", pady=2)
        
        def ver():
            try:
                rows = self.dao_trabajadores.listar_por_sucursal(int(entry_id.get()))
                if not rows:
                    self.mostrar_resultados("No hay trabajadores en esta sucursal.")
                    return
                self.mostrar_tabla(["ID", "Nombre", "Apellido1", "Apellido2", "Correo", "Estado"], 
                                  rows, "--- Trabajadores en Sucursal ---")
                ventana.destroy()
            except Exception as e:
                messagebox.showerror("Error", f"No se pudo listar: {e}")
        
        ttk.Button(frame, text="Ver", command=ver, width=15).pack(pady=10)
        ttk.Button(frame, text="Cancelar", command=ventana.destroy, width=15).pack(pady=5)
    
    def ver_roles(self):
        rows = self.dao_roles.listar_todos()
        if not rows:
            self.mostrar_resultados("No hay roles registrados.")
            return
        self.mostrar_tabla(["ID", "Rol"], rows, "--- ROLES ---")
    
    def ver_turnos(self):
        rows = self.dao_turnos.listar_todos()
        if not rows:
            self.mostrar_resultados("No hay turnos registrados.")
            return
        self.mostrar_tabla(["ID", "Turno"], rows, "--- TURNOS ---")


    # Menu: Ventas
    
    def menu_ventas(self):
        ventana = tk.Toplevel(self.root)
        ventana.title("Ventas")
        ventana.geometry("500x400")
        ventana.resizable(True, True)
        
        frame = ttk.Frame(ventana, padding="10")
        frame.pack(fill=tk.BOTH, expand=True)
        
        ttk.Label(frame, text="Gestión de Ventas", font=("Arial", 14, "bold")).pack(pady=5)
        
        ttk.Button(frame, text="Registrar venta", command=self.registrar_venta_gui, width=25).pack(pady=3)
        ttk.Button(frame, text="Ver todas las ventas", command=self.ver_ventas, width=25).pack(pady=3)
        ttk.Button(frame, text="Ver inventario por sucursal", command=self.ver_inventario_venta, width=25).pack(pady=3)
        ttk.Button(frame, text="Ver métodos de pago", command=self.ver_metodos_pago, width=25).pack(pady=3)
        ttk.Button(frame, text="Cerrar", command=ventana.destroy, width=25).pack(pady=10)
    
    def ver_ventas(self):
        rows = self.dao_ventas.consultar_todas()
        if not rows:
            self.mostrar_resultados("No hay ventas registradas.")
            return
        self.mostrar_tabla(["ID", "Fecha", "Cédula", "Cliente", "Trabajador", "Método", "Total"], 
                          rows, "--- Ventas ---")
    
    def ver_metodos_pago(self):
        rows = self.dao_tipo_pagos.listar_todos()
        if not rows:
            self.mostrar_resultados("No hay métodos de pago.")
            return
        self.mostrar_tabla(["ID", "Metodo de Pago"], rows, "--- Metodos de Pago ---")
    
    def ver_inventario_venta(self):
        ventana = tk.Toplevel(self.root)
        ventana.title("Inventario para Ventas")
        ventana.geometry("400x200")
        ventana.resizable(False, False)
        
        frame = ttk.Frame(ventana, padding="10")
        frame.pack(fill=tk.BOTH, expand=True)
        
        ttk.Label(frame, text="Inventario por Sucursal", font=("Arial", 12, "bold")).pack(pady=5)
        
        ttk.Label(frame, text="ID de la sucursal:").pack(anchor="w", pady=2)
        entry_id = ttk.Entry(frame, width=40)
        entry_id.pack(anchor="w", pady=2)
        
        def ver():
            try:
                rows = self.dao_ventas.listar_inventario(int(entry_id.get()))
                if not rows:
                    self.mostrar_resultados("No hay productos en esta sucursal.")
                    return
                self.mostrar_tabla(["ID", "Producto", "Precio", "Stock"], 
                                  rows, "--- Inventario para Ventas ---")
                ventana.destroy()
            except Exception as e:
                messagebox.showerror("Error", f"No se pudo listar: {e}")
        
        ttk.Button(frame, text="Ver", command=ver, width=15).pack(pady=10)
        ttk.Button(frame, text="Cancelar", command=ventana.destroy, width=15).pack(pady=5)
    
    def registrar_venta_gui(self):
        ventana = tk.Toplevel(self.root)
        ventana.title("Registrar Venta")
        ventana.geometry("400x400")
        ventana.resizable(False, False)
        
        frame = ttk.Frame(ventana, padding="10")
        frame.pack(fill=tk.BOTH, expand=True)
        
        ttk.Label(frame, text="Registrar Venta", font=("Arial", 12, "bold")).pack(pady=5)
        
        campos = [
            ("Cédula del cliente:", "cedula"),
            ("ID del trabajador:", "trabajador"),
            ("ID del método de pago:", "tipo_pago"),
            ("ID del producto:", "producto"),
            ("Cantidad:", "cantidad"),
            ("ID de la sucursal:", "sucursal")
        ]
        
        entries = {}
        for label, key in campos:
            ttk.Label(frame, text=label).pack(anchor="w", pady=2)
            entry = ttk.Entry(frame, width=40)
            entry.pack(anchor="w", pady=2)
            entries[key] = entry
        
        def guardar():
            try:
                resultado = self.dao_ventas.registrar(
                    entries["cedula"].get(),
                    int(entries["trabajador"].get()),
                    int(entries["tipo_pago"].get()),
                    int(entries["producto"].get()),
                    int(entries["cantidad"].get()),
                    int(entries["sucursal"].get())
                )
                
                if resultado["ok"]:
                    mensaje = f"--- Venta Registrada ---\n"
                    mensaje += f"ID Venta: {resultado['id_venta']}\n"
                    mensaje += f"Total: {resultado['total']:,.2f}\n"
                    mensaje += f"Mensaje: {resultado['mensaje']}"
                    self.mostrar_resultados(mensaje)
                    messagebox.showinfo("Éxito", "Venta registrada con éxito")
                    ventana.destroy()
                else:
                    messagebox.showerror("Error", resultado['mensaje'])
            except Exception as e:
                messagebox.showerror("Error", f"No se pudo registrar: {e}")
        
        ttk.Button(frame, text="Guardar", command=guardar, width=15).pack(pady=10)
        ttk.Button(frame, text="Cancelar", command=ventana.destroy, width=15).pack(pady=5)

    # Menu: Devoluciones
    
    def menu_devoluciones(self):
        ventana = tk.Toplevel(self.root)
        ventana.title("Devoluciones")
        ventana.geometry("400x250")
        ventana.resizable(True, True)
        
        frame = ttk.Frame(ventana, padding="10")
        frame.pack(fill=tk.BOTH, expand=True)
        
        ttk.Label(frame, text="Gestión de Devoluciones", font=("Arial", 14, "bold")).pack(pady=5)
        
        ttk.Button(frame, text="Ver tipos de devolución", command=self.ver_tipos_devolucion, width=30).pack(pady=5)
        ttk.Button(frame, text="Cerrar", command=ventana.destroy, width=30).pack(pady=10)
    
    def ver_tipos_devolucion(self):
        rows = self.dao_tipo_devoluciones.listar_todos()
        if not rows:
            self.mostrar_resultados("No hay tipos de devolución registrados.")
            return
        self.mostrar_tabla(["ID", "Tipo de Devolución"], rows, "--- Tipos de Devolución ---")

    # Menu: Reportes
    
    def menu_reportes(self):
        ventana = tk.Toplevel(self.root)
        ventana.title("Reportes")
        ventana.geometry("400x300")
        ventana.resizable(True, True)
        
        frame = ttk.Frame(ventana, padding="10")
        frame.pack(fill=tk.BOTH, expand=True)
        
        ttk.Label(frame, text="Reportes", font=("Arial", 14, "bold")).pack(pady=5)
        
        ttk.Button(frame, text="Historial de compras", command=self.historial_compras, width=30).pack(pady=5)
        ttk.Button(frame, text="Productos por proveedor", command=self.productos_por_proveedor, width=30).pack(pady=5)
        ttk.Button(frame, text="Productos por categoría", command=self.ver_productos_por_categoria, width=30).pack(pady=5)
        ttk.Button(frame, text="Cerrar", command=ventana.destroy, width=30).pack(pady=10)
    
    def ver_productos_por_categoria(self):
        ventana = tk.Toplevel(self.root)
        ventana.title("Productos por Categoría")
        ventana.geometry("400x200")
        ventana.resizable(False, False)
        
        frame = ttk.Frame(ventana, padding="10")
        frame.pack(fill=tk.BOTH, expand=True)
        
        ttk.Label(frame, text="Productos por Categoría", font=("Arial", 12, "bold")).pack(pady=5)
        
        ttk.Label(frame, text="ID de la categoría:").pack(anchor="w", pady=2)
        entry_id = ttk.Entry(frame, width=40)
        entry_id.pack(anchor="w", pady=2)
        
        def ver():
            try:
                rows = self.dao_productos.listar_por_categoria(int(entry_id.get()))
                if not rows:
                    self.mostrar_resultados("No hay productos en esta categoría.")
                    return
                self.mostrar_tabla(["ID", "Producto", "Precio Venta", "Precio Costo"], 
                                  rows, "--- Productos por Categoría ---")
                ventana.destroy()
            except Exception as e:
                messagebox.showerror("Error", f"No se pudo listar: {e}")
        
        ttk.Button(frame, text="Ver", command=ver, width=15).pack(pady=10)
        ttk.Button(frame, text="Cancelar", command=ventana.destroy, width=15).pack(pady=5)

if __name__ == "__main__":
    root = tk.Tk()
    app = FerreteriaGUI(root)
    root.mainloop()