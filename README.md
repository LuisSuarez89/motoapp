# MotoApp

Aplicación Flutter para moteros en Colombia con selección de moto, revisiones por kilometraje, recursos útiles y una base para diagnóstico OBD2/ELM327.

## Características

- Catálogo configurable por JSON para marcas, modelos y contenido por país.
- Pantalla inicial para seleccionar país, marca y modelo.
- Vista de revisiones por kilometraje de la moto seleccionada.
- Secciones dinámicas: clima, talleres, repuestos, videos, redes sociales y recursos generales.
- Pantalla base para escáner Bluetooth ELM327 / OBD2.

## Ejecutar

```bash
flutter pub get
flutter run
```

## Verificación de `app-ads.txt` (AdMob)

Este proyecto mantiene el archivo en dos ubicaciones para evitar despliegues incompletos:

- `app-ads.txt` (raíz del repositorio)
- `web/app-ads.txt` (se publica en la raíz del sitio al compilar Flutter Web)

Validación local:

```bash
./scripts/check_app_ads.sh
```

> Nota importante para Google Play: además del archivo correcto, la app Android debe tener un **sitio web de desarrollador** configurado en la ficha de Play Console, y ese dominio debe servir `https://TU_DOMINIO/app-ads.txt`.
