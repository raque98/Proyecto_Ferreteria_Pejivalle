"""
Punto de entrada del sistema. Este es el archivo que se ejecuta con el "play" (como el debugger de NetBeans, pero en consola).
"""

from dao.dao_tipo_pagos import registrar_tipo_pago, listar_tipos_pago


def menu_tipos_pago():
    while True:
        print("\n--- Modulo: Metodos de Pago ---")
        print("1. Ver métodos de pago registrados")
        print("2. Registrar un nuevo método de pago")
        print("3. Volver al menú principal")

        opcion = input("Elegí una opción: ")

        if opcion == "1":
            print("\n>> Ejecutando SP_LISTAR_TIPOS_PAGO en la base de datos...")
            try:
                metodos = listar_tipos_pago()
                if not metodos:
                    print("No hay métodos de pago registrados todavía.")
                else:
                    for id_metodo, nombre in metodos:
                        print(f"  [{id_metodo}] {nombre}")
            except Exception as error:
                print("Ocurrió un error consultando la base de datos:")
                print(error)

        elif opcion == "2":
            nombre = input("Nombre del nuevo método de pago (ej. SINPE Móvil): ")
            print("\n>> Ejecutando SP_REGISTRAR_TIPO_PAGO en la base de datos...")
            try:
                registrar_tipo_pago(nombre)
                print("Método de pago registrado con éxito.")
            except Exception as error:
                print("Ocurrió un error registrando el método de pago:")
                print(error)

        elif opcion == "3":
            break

        else:
            print("Opción inválida, intentá de nuevo.")


def menu_principal():
    while True:
        print("\n=== SISTEMA FERRETERÍA PEJIVALLE ===")
        print("1. Métodos de Pago")
        print("2. Salir")

        opcion = input("Elegí una opción: ")

        if opcion == "1":
            menu_tipos_pago()
        elif opcion == "2":
            print("Hasta luego.")
            break
        else:
            print("Opción inválida, intentá de nuevo.")


if __name__ == "__main__":
    menu_principal()