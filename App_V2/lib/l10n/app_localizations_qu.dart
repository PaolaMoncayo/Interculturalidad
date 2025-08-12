// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Quechua (`qu`).
class AppLocalizationsQu extends AppLocalizations {
  AppLocalizationsQu([String locale = 'qu']) : super(locale);

  @override
  String get appTitle => 'ESPE Yachana Wasi';

  @override
  String get welcome => 'Allin hamusqa';

  @override
  String hello(String email) {
    return '¡Napaykullayki, $email!';
  }

  @override
  String get login => 'Yaykuy';

  @override
  String get register => 'Shutichikuy';

  @override
  String get email => 'Correo Electrónico';

  @override
  String get password => 'Pakana rima';

  @override
  String get logout => 'Lluqsiy';

  @override
  String get sessionClosed => 'Sesión wichaysqa';

  @override
  String get interactiveMap => 'Puriyachina mapa';

  @override
  String get nearbyPlaces => 'Kaypi tiyan mama llaktakuna';

  @override
  String get qrScanner => 'QR ñawiriy';

  @override
  String get others => 'Huk ruranakuna';

  @override
  String get universityLocations => 'Yachana wasi maypi tiyan';

  @override
  String get loading => 'Apamushpa...';

  @override
  String get loadingLocations => 'Mama llaktakunata apamushpa...';

  @override
  String get yourLocation => 'Qam maypi kankri:';

  @override
  String get locationUnavailable => 'Maypi kasqanki mana rikusqa';

  @override
  String pointsOfInterestFound(int count) {
    return 'Interés puntukuna tarisqa: $count';
  }

  @override
  String get noPointsFound => 'Mana interés puntukuna tarisqa';

  @override
  String get addPointsFirestore => 'Firebase Firestoremanta wakin yapay';

  @override
  String get viewList => 'Lista qawana';

  @override
  String get viewMap => 'Mapa qawana';

  @override
  String changeView(String viewType) {
    return 'Qawana tikray: $viewType';
  }

  @override
  String get mapNormal => 'Normal';

  @override
  String get mapSatellite => 'Satélite';

  @override
  String get mapTerrain => 'Allpa';

  @override
  String get mapHybrid => 'Chaqrusqa';

  @override
  String get mapUnavailable => 'Mapa mana kachkanchu';

  @override
  String get googleMapsError => 'Google Maps mana kargasqachu';

  @override
  String get universityLocation => 'Yachana wasi chawpi maypi tiyan';

  @override
  String get close => 'Wichay';

  @override
  String get legend => 'Leyenda - Categorías';

  @override
  String get classrooms => 'Yachana ukukuna';

  @override
  String get library => 'Qillqa wasi';

  @override
  String get laboratories => 'Experimentay wasi';

  @override
  String get cafeteria => 'Mikuna wasi';

  @override
  String get bathrooms => 'Mayllay wasi';

  @override
  String get administration => 'Kamachiy';

  @override
  String get entrances => 'Yaykuna punku';

  @override
  String get parking => 'Antay kancha';

  @override
  String get general => 'Llapanpaq';

  @override
  String get description => 'Willay:';

  @override
  String get category => 'Categoria:';

  @override
  String get coordinates => 'Coordenadas:';

  @override
  String get distance => 'Karuyka:';

  @override
  String get meters => 'mitru';

  @override
  String functionality(String feature) {
    return '\"$feature\" llamkana manaraq wakichisqa';
  }
}
