// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'ESPE University';

  @override
  String get welcome => 'Welcome';

  @override
  String hello(String email) {
    return 'Hello, $email!';
  }

  @override
  String get login => 'Login';

  @override
  String get register => 'Register';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get logout => 'Logout';

  @override
  String get sessionClosed => 'Session closed';

  @override
  String get interactiveMap => 'Interactive Map';

  @override
  String get nearbyPlaces => 'Nearby Places';

  @override
  String get qrScanner => 'QR Scanner';

  @override
  String get others => 'Others';

  @override
  String get universityLocations => 'University Locations';

  @override
  String get loading => 'Loading...';

  @override
  String get loadingLocations => 'Loading locations...';

  @override
  String get yourLocation => 'Your location:';

  @override
  String get locationUnavailable => 'Location unavailable';

  @override
  String pointsOfInterestFound(int count) {
    return 'Points of interest found: $count';
  }

  @override
  String get noPointsFound => 'No points of interest found';

  @override
  String get addPointsFirestore => 'Add some in Firebase Firestore';

  @override
  String get viewList => 'View list';

  @override
  String get viewMap => 'View map';

  @override
  String changeView(String viewType) {
    return 'Change view: $viewType';
  }

  @override
  String get mapNormal => 'Normal';

  @override
  String get mapSatellite => 'Satellite';

  @override
  String get mapTerrain => 'Terrain';

  @override
  String get mapHybrid => 'Hybrid';

  @override
  String get mapUnavailable => 'Map unavailable';

  @override
  String get googleMapsError => 'Google Maps could not load';

  @override
  String get universityLocation => 'Central University Location';

  @override
  String get close => 'Close';

  @override
  String get legend => 'Legend - Categories';

  @override
  String get classrooms => 'Classrooms';

  @override
  String get library => 'Library';

  @override
  String get laboratories => 'Laboratories';

  @override
  String get cafeteria => 'Cafeteria';

  @override
  String get bathrooms => 'Bathrooms';

  @override
  String get administration => 'Administration';

  @override
  String get entrances => 'Entrances';

  @override
  String get parking => 'Parking';

  @override
  String get general => 'General';

  @override
  String get description => 'Description:';

  @override
  String get category => 'Category:';

  @override
  String get coordinates => 'Coordinates:';

  @override
  String get distance => 'Distance:';

  @override
  String get meters => 'meters';

  @override
  String functionality(String feature) {
    return 'Feature \"$feature\" not yet available';
  }
}
