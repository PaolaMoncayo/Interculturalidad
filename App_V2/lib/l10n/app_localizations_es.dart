// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Universidad ESPE';

  @override
  String get welcome => 'Bienvenido';

  @override
  String hello(String email) {
    return '¡Hola, $email!';
  }

  @override
  String get login => 'Iniciar Sesión';

  @override
  String get register => 'Registrarse';

  @override
  String get email => 'Correo Electrónico';

  @override
  String get password => 'Contraseña';

  @override
  String get logout => 'Cerrar Sesión';

  @override
  String get sessionClosed => 'Sesión cerrada';

  @override
  String get interactiveMap => 'Mapa Interactivo';

  @override
  String get nearbyPlaces => 'Lugares Cercanos';

  @override
  String get qrScanner => 'Lectura de QR';

  @override
  String get others => 'Otros';

  @override
  String get universityLocations => 'Ubicaciones Universidad';

  @override
  String get loading => 'Cargando...';

  @override
  String get loadingLocations => 'Cargando ubicaciones...';

  @override
  String get yourLocation => 'Tu ubicación:';

  @override
  String get locationUnavailable => 'Ubicación no disponible';

  @override
  String pointsOfInterestFound(int count) {
    return 'Puntos de interés encontrados: $count';
  }

  @override
  String get noPointsFound => 'No se encontraron puntos de interés';

  @override
  String get addPointsFirestore => 'Agrega algunos en Firebase Firestore';

  @override
  String get viewList => 'Ver lista';

  @override
  String get viewMap => 'Ver mapa';

  @override
  String changeView(String viewType) {
    return 'Cambiar vista: $viewType';
  }

  @override
  String get mapNormal => 'Normal';

  @override
  String get mapSatellite => 'Satélite';

  @override
  String get mapTerrain => 'Terreno';

  @override
  String get mapHybrid => 'Híbrido';

  @override
  String get mapUnavailable => 'Mapa no disponible';

  @override
  String get googleMapsError => 'Google Maps no se pudo cargar';

  @override
  String get universityLocation => 'Ubicación Central Universidad';

  @override
  String get close => 'Cerrar';

  @override
  String get legend => 'Leyenda - Categorías';

  @override
  String get classrooms => 'Aulas';

  @override
  String get library => 'Biblioteca';

  @override
  String get laboratories => 'Laboratorios';

  @override
  String get cafeteria => 'Cafetería';

  @override
  String get bathrooms => 'Baños';

  @override
  String get administration => 'Administración';

  @override
  String get entrances => 'Entradas';

  @override
  String get parking => 'Estacionamiento';

  @override
  String get general => 'General';

  @override
  String get description => 'Descripción:';

  @override
  String get category => 'Categoría:';

  @override
  String get coordinates => 'Coordenadas:';

  @override
  String get distance => 'Distancia:';

  @override
  String get meters => 'metros';

  @override
  String functionality(String feature) {
    return 'Funcionalidad \"$feature\" aún no disponible';
  }
}
