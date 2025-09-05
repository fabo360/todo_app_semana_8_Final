# To-Do App (Flutter)

Aplicación de lista de tareas con **estado global (Provider)**, **persistencia local (SharedPreferences)** y **UX con AnimatedList + SnackBar**.  
Entrega final – Semana 8.

## 🧰 Tecnologías
Flutter (Material 3) · Provider · SharedPreferences · AnimatedList/SnackBar · Botón de tema claro/oscuro

## ✨ Funcionalidades
- Agregar tareas (validación de título).
- Marcar como completadas (checkbox, texto tachado).
- Detalle con **notas** y guardar cambios.
- Eliminar + **DESHACER**.
- Persistencia al cerrar/abrir la app.
- Alternar **tema claro/oscuro** desde el AppBar.

## 📦 APK (entrega)

- Descarga directa: [apk/app-debug.apk](apk/app-debug.apk)  
  *(Generado con `flutter build apk --debug`)*

### Cómo instalar el APK
1. Copia `apk/app-debug.apk` al teléfono (o descárgalo desde GitHub).
2. Ábrelo y permite “Instalar apps desconocidas” si lo solicita.

### Estructura

lib/
  models/ task.dart
  providers/ tasks_provider.dart, theme_provider.dart
  screens/ home_screen.dart, add_task_screen.dart, task_detail_screen.dart
apk/ app-debug.apk
docs/img/ *.jpg
pubspec.yaml

## 📹 Video (demo)

Enlace: https://drive.google.com/file/d/1Pwv8o7qOQu9iRXbJ8lrS_q2caKQzkhmx/view?usp=drive_link

## 🖼️ Capturas

<table>
  <tr>
    <td align="center">Home</td>
    <td align="center">Agregar</td>
    <td align="center">Detalle</td>
  </tr>
  <tr>
    <td><img src="docs/img/home.jpg" alt="Home" width="250"/></td>
    <td><img src="docs/img/add.jpg" alt="Agregar" width="250"/></td>
    <td><img src="docs/img/detail.jpg" alt="Detalle" width="250"/></td>
  </tr>
  <tr>
    <td align="center">SnackBar + Undo</td>
    <td align="center">Tema oscuro</td>
    <td></td>
  </tr>
  <tr>
    <td><img src="docs/img/undo.jpg" alt="Undo" width="250"/></td>
    <td><img src="docs/img/dark.jpg" alt="Dark mode" width="250"/></td>
    <td></td>
  </tr>
</table>

## ▶️ Ejecución
```bash
flutter pub get
flutter run -d <ID_DISPOSITIVO>