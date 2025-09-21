# ClarityGov - Flutter Version

Sistema de Fiscalización de Transporte para la Municipalidad Distrital de La Joya.

## Descripción

ClarityGov es una aplicación móvil desarrollada en Flutter para la fiscalización de transporte público. Permite a los inspectores municipales crear boletas de fiscalización, gestionar impresoras y mantener un historial de boletas emitidas.

## Características

### 🚗 Nueva Fiscalización
- Formulario completo con 3 secciones organizadas:
  - **Datos del Vehículo**: Placa y empresa de transporte
  - **Información del Conductor**: Nombre, licencia y foto de licencia
  - **Detalles de Fiscalización**: Motivo, conformidad, descripciones y observaciones
- Toma de fotos de licencias de conducir
- Validación de campos requeridos
- Guardado automático en Firebase Firestore

### 🖨️ Configuración de Impresoras
- Búsqueda automática de impresoras Bluetooth y WiFi
- Conexión y configuración de dispositivos
- Guardado de preferencias de impresora
- Indicadores de estado de conexión

### 📋 Historial de Boletas
- Lista de boletas ordenadas por fecha
- Búsqueda en tiempo real por placa, empresa o conductor
- Vista detallada de cada boleta
- Generación de PDFs
- Reimpresión de boletas

### 🎨 Diseño
- Tema personalizado con colores de "La Joya Avanza"
- Interfaz moderna con gradientes y animaciones
- Responsive design para diferentes tamaños de pantalla
- Iconografía consistente con Material Design

## Tecnologías Utilizadas

- **Flutter**: Framework principal
- **Firebase Firestore**: Base de datos en la nube
- **Firebase Auth**: Autenticación de usuarios
- **PDF Generation**: Generación de documentos PDF
- **Image Picker**: Captura de fotos
- **Shared Preferences**: Almacenamiento local
- **Material Design 3**: Sistema de diseño

## Estructura del Proyecto

```
lib/
├── main.dart                    # Punto de entrada de la aplicación
├── theme/
│   └── app_theme.dart          # Tema y colores de la aplicación
├── screens/
│   ├── login_screen.dart       # Pantalla de inicio de sesión
│   ├── home_screen.dart        # Pantalla principal con opciones
│   ├── inspection_form_screen.dart # Formulario de fiscalización
│   ├── printer_screen.dart     # Configuración de impresoras
│   └── history_screen.dart     # Historial de boletas
├── models/
│   └── boleta_model.dart       # Modelo de datos de boletas
└── services/
    ├── pdf_service.dart        # Servicio de generación de PDFs
    └── print_service.dart      # Servicio de impresión
```

## Instalación

### Prerrequisitos
- Flutter SDK (>= 3.10.0)
- Dart SDK (>= 3.0.0)
- Android Studio / VS Code
- Cuenta de Firebase

### Configuración

1. **Clonar el repositorio**
   ```bash
   git clone [URL_DEL_REPOSITORIO]
   cd clarity_gov/flutter
   ```

2. **Instalar dependencias**
   ```bash
   flutter pub get
   ```

3. **Configurar Firebase**
   - Crear un proyecto en [Firebase Console](https://console.firebase.google.com/)
   - Añadir aplicación Android/iOS
   - Descargar `google-services.json` (Android) y/o `GoogleService-Info.plist` (iOS)
   - Colocar los archivos en las carpetas correspondientes
   - Habilitar Firestore Database

4. **Configurar fuentes**
   - Añadir las fuentes Inter en `assets/fonts/`
   - Las fuentes se pueden descargar desde [Google Fonts](https://fonts.google.com/specimen/Inter)

5. **Ejecutar la aplicación**
   ```bash
   flutter run
   ```

## Configuración de Firebase

### Firestore Database

Crear las siguientes colecciones:

1. **boletas**
   ```json
   {
     "id": "string",
     "placa": "string",
     "empresa": "string",
     "conductor": "string",
     "numeroLicencia": "string",
     "codigoFiscalizador": "string",
     "motivo": "string",
     "conforme": "string",
     "descripciones": "string?",
     "observaciones": "string?",
     "fecha": "timestamp",
     "inspectorId": "string",
     "inspectorEmail": "string?",
     "licensePhotoPath": "string?"
   }
   ```

### Reglas de Firestore

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /boletas/{document} {
      allow read, write: if request.auth != null;
    }
  }
}
```

## Funcionalidades Avanzadas

### Generación de PDFs
Los PDFs se generan con el diseño oficial de la municipalidad incluyendo:
- Header con logo y datos municipales
- Información completa de la boleta
- Formato profesional para impresión

### Impresión Bluetooth
El sistema soporta impresoras térmicas Bluetooth:
- Búsqueda automática de dispositivos
- Formato optimizado para impresoras de 58mm
- Texto con saltos de línea automáticos

### Sincronización en la Nube
- Guardado automático en Firebase
- Sincronización en tiempo real
- Acceso desde múltiples dispositivos

## Paleta de Colores

La aplicación utiliza la paleta oficial de "La Joya Avanza":

- **Rojo Principal**: `#DC143C`
- **Rojo Accent**: `#E11D48`
- **Fondo Claro**: `#F8F9FA`
- **Gris Secundario**: `#6B7280`
- **Gris Mutado**: `#64748B`

## Contribución

1. Fork el proyecto
2. Crear una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abrir un Pull Request

## Licencia

Este proyecto está bajo la Licencia MIT. Ver `LICENSE` para más detalles.

## Contacto

Municipalidad Distrital de La Joya
- Email: sistemas@lajoya.gob.pe
- Teléfono: +51 XXX XXX XXX

---

**Desarrollado con ❤️ para la Municipalidad Distrital de La Joya**