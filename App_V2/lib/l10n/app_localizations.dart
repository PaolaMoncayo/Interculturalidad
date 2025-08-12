import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_qu.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('qu'),
  ];

  /// Título de la aplicación
  ///
  /// In es, this message translates to:
  /// **'Universidad ESPE'**
  String get appTitle;

  /// Mensaje de bienvenida
  ///
  /// In es, this message translates to:
  /// **'Bienvenido'**
  String get welcome;

  /// Saludo personalizado
  ///
  /// In es, this message translates to:
  /// **'¡Hola, {email}!'**
  String hello(String email);

  /// Botón de login
  ///
  /// In es, this message translates to:
  /// **'Iniciar Sesión'**
  String get login;

  /// Botón de registro
  ///
  /// In es, this message translates to:
  /// **'Registrarse'**
  String get register;

  /// Campo de email
  ///
  /// In es, this message translates to:
  /// **'Correo Electrónico'**
  String get email;

  /// Campo de contraseña
  ///
  /// In es, this message translates to:
  /// **'Contraseña'**
  String get password;

  /// Botón de logout
  ///
  /// In es, this message translates to:
  /// **'Cerrar Sesión'**
  String get logout;

  /// Mensaje de sesión cerrada
  ///
  /// In es, this message translates to:
  /// **'Sesión cerrada'**
  String get sessionClosed;

  /// Título del mapa
  ///
  /// In es, this message translates to:
  /// **'Mapa Interactivo'**
  String get interactiveMap;

  /// Lugares cercanos
  ///
  /// In es, this message translates to:
  /// **'Lugares Cercanos'**
  String get nearbyPlaces;

  /// Escáner QR
  ///
  /// In es, this message translates to:
  /// **'Lectura de QR'**
  String get qrScanner;

  /// Otros elementos
  ///
  /// In es, this message translates to:
  /// **'Otros'**
  String get others;

  /// Título de ubicaciones
  ///
  /// In es, this message translates to:
  /// **'Ubicaciones Universidad'**
  String get universityLocations;

  /// Mensaje de carga
  ///
  /// In es, this message translates to:
  /// **'Cargando...'**
  String get loading;

  /// Cargando ubicaciones
  ///
  /// In es, this message translates to:
  /// **'Cargando ubicaciones...'**
  String get loadingLocations;

  /// Tu ubicación actual
  ///
  /// In es, this message translates to:
  /// **'Tu ubicación:'**
  String get yourLocation;

  /// Ubicación no disponible
  ///
  /// In es, this message translates to:
  /// **'Ubicación no disponible'**
  String get locationUnavailable;

  /// Número de puntos encontrados
  ///
  /// In es, this message translates to:
  /// **'Puntos de interés encontrados: {count}'**
  String pointsOfInterestFound(int count);

  /// No hay puntos de interés
  ///
  /// In es, this message translates to:
  /// **'No se encontraron puntos de interés'**
  String get noPointsFound;

  /// Instrucción para agregar puntos
  ///
  /// In es, this message translates to:
  /// **'Agrega algunos en Firebase Firestore'**
  String get addPointsFirestore;

  /// Ver en formato lista
  ///
  /// In es, this message translates to:
  /// **'Ver lista'**
  String get viewList;

  /// Ver en formato mapa
  ///
  /// In es, this message translates to:
  /// **'Ver mapa'**
  String get viewMap;

  /// Cambiar tipo de vista del mapa
  ///
  /// In es, this message translates to:
  /// **'Cambiar vista: {viewType}'**
  String changeView(String viewType);

  /// Vista normal del mapa
  ///
  /// In es, this message translates to:
  /// **'Normal'**
  String get mapNormal;

  /// Vista satélite
  ///
  /// In es, this message translates to:
  /// **'Satélite'**
  String get mapSatellite;

  /// Vista de terreno
  ///
  /// In es, this message translates to:
  /// **'Terreno'**
  String get mapTerrain;

  /// Vista híbrida
  ///
  /// In es, this message translates to:
  /// **'Híbrido'**
  String get mapHybrid;

  /// Mapa no disponible
  ///
  /// In es, this message translates to:
  /// **'Mapa no disponible'**
  String get mapUnavailable;

  /// Error de Google Maps
  ///
  /// In es, this message translates to:
  /// **'Google Maps no se pudo cargar'**
  String get googleMapsError;

  /// Ubicación central
  ///
  /// In es, this message translates to:
  /// **'Ubicación Central Universidad'**
  String get universityLocation;

  /// Botón cerrar
  ///
  /// In es, this message translates to:
  /// **'Cerrar'**
  String get close;

  /// Leyenda de categorías
  ///
  /// In es, this message translates to:
  /// **'Leyenda - Categorías'**
  String get legend;

  /// Aulas de clase
  ///
  /// In es, this message translates to:
  /// **'Aulas'**
  String get classrooms;

  /// Biblioteca
  ///
  /// In es, this message translates to:
  /// **'Biblioteca'**
  String get library;

  /// Laboratorios
  ///
  /// In es, this message translates to:
  /// **'Laboratorios'**
  String get laboratories;

  /// Cafetería
  ///
  /// In es, this message translates to:
  /// **'Cafetería'**
  String get cafeteria;

  /// Baños
  ///
  /// In es, this message translates to:
  /// **'Baños'**
  String get bathrooms;

  /// Administración
  ///
  /// In es, this message translates to:
  /// **'Administración'**
  String get administration;

  /// Entradas
  ///
  /// In es, this message translates to:
  /// **'Entradas'**
  String get entrances;

  /// Estacionamiento
  ///
  /// In es, this message translates to:
  /// **'Estacionamiento'**
  String get parking;

  /// Categoría general
  ///
  /// In es, this message translates to:
  /// **'General'**
  String get general;

  /// Etiqueta descripción
  ///
  /// In es, this message translates to:
  /// **'Descripción:'**
  String get description;

  /// Etiqueta categoría
  ///
  /// In es, this message translates to:
  /// **'Categoría:'**
  String get category;

  /// Etiqueta coordenadas
  ///
  /// In es, this message translates to:
  /// **'Coordenadas:'**
  String get coordinates;

  /// Etiqueta distancia
  ///
  /// In es, this message translates to:
  /// **'Distancia:'**
  String get distance;

  /// Unidad metros
  ///
  /// In es, this message translates to:
  /// **'metros'**
  String get meters;

  /// Mensaje de funcionalidad no disponible
  ///
  /// In es, this message translates to:
  /// **'Funcionalidad \"{feature}\" aún no disponible'**
  String functionality(String feature);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'qu'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'qu':
      return AppLocalizationsQu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
