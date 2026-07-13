# RF-05 y RF-06 — Ventas y método de pago

## Archivos agregados

- `Pejivalle/RF05_RF06_Ventas.sql`: vista, procedimientos almacenados y bloques de prueba.
- `dao/dao_ventas.py`: acceso desde Python a Oracle.
- `main.py`: integración de la opción **7. Gestionar Ventas**.

## Orden de ejecución

1. Ejecutar `Pejivalle/PejivalleScript.sql` si la base aún no está creada.
2. Ejecutar `Pejivalle/objetosdeprueba.sql` para los objetos existentes del grupo.
3. Ejecutar `Pejivalle/RF05_RF06_Ventas.sql` con **Run Script / F5**.
4. Revisar que los objetos aparezcan sin errores:
   - `VW_DETALLE_VENTAS`
   - `SP_REGISTRAR_VENTA`
   - `SP_LISTAR_VENTAS`
   - `SP_LISTAR_INVENTARIO_VENTA`
5. Ejecutar `python main.py` y seleccionar **7. Gestionar Ventas**.

## Evidencias sugeridas

1. Compilación de la vista y los tres procedimientos.
2. Consulta de `Tipo_Pagos` para RF-06.
3. Bloque anónimo de `SP_REGISTRAR_VENTA` mostrando ID, total y mensaje.
4. Consulta de `VW_DETALLE_VENTAS` donde se observe el método de pago.
5. Ejecución en Python del menú de ventas.

## Nota sobre la prueba SQL

El bloque de prueba utiliza valores de ejemplo (`cedula`, trabajador, producto y sucursal). Antes de ejecutarlo, revise las consultas previas del mismo archivo y sustituya los valores si los identificadores existentes en Oracle son diferentes.
