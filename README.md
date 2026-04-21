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

## Solución recomendada con GitHub Pages (paso a paso)

Si quieres resolver el error de verificación de AdMob usando GitHub Pages:

1. En GitHub abre **Settings → Pages** y selecciona **Deploy from a branch**.
2. Selecciona la rama `main` y carpeta `/ (root)`.
3. Si usas un repositorio de proyecto en Pages, tu URL quedará con prefijo de ruta (por ejemplo):
   - `https://TU_USUARIO.github.io/motoapp/`
   y el archivo se debe servir en:
   - `https://TU_USUARIO.github.io/motoapp/app-ads.txt`
4. Asegura que `app-ads.txt` exista en la raíz del repo con esta línea:

   ```txt
   google.com, pub-1049551382567997, DIRECT, f08c47fec0942fa0
   ```

5. En Play Console, dentro de la app Android, configura el **Sitio web del desarrollador** con esa misma URL pública.
6. Comprueba públicamente:
   - `https://TU_USUARIO.github.io/motoapp/app-ads.txt` (este repo)
7. Luego en AdMob pulsa **Buscar actualizaciones**.

Caso actual de este proyecto:

- Sitio activo: `https://luissuarez89.github.io/motoapp/`
- Archivo esperado por AdMob: `https://luissuarez89.github.io/motoapp/app-ads.txt`
