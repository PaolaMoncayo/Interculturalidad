import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
  String _currentLanguage = 'es';
  
  String get currentLanguage => _currentLanguage;
  
  void setLanguage(String languageCode) {
    _currentLanguage = languageCode;
    notifyListeners();
  }
}

class AccessibilityProvider extends ChangeNotifier {
  bool _highContrastMode = false;
  bool _patternsEnabled = false;
  String _colorBlindnessType = 'none'; // 'none', 'protanopia', 'deuteranopia', 'tritanopia'
  
  bool get highContrastMode => _highContrastMode;
  bool get patternsEnabled => _patternsEnabled;
  String get colorBlindnessType => _colorBlindnessType;
  
  void setHighContrastMode(bool enabled) {
    _highContrastMode = enabled;
    notifyListeners();
  }
  
  void setPatternsEnabled(bool enabled) {
    _patternsEnabled = enabled;
    notifyListeners();
  }
  
  void setColorBlindnessType(String type) {
    _colorBlindnessType = type;
    notifyListeners();
  }
  
  // Colores principales según el tipo de daltonismo
  Color getPrimaryColor(bool isHighContrast) {
    switch (_colorBlindnessType) {
      case 'protanopia': // Dificultad con rojo-verde (más común)
        return isHighContrast 
          ? const Color(0xFF1565C0) // Azul oscuro
          : const Color(0xFF1976D2); // Azul
      
      case 'deuteranopia': // Dificultad con verde-rojo
        return isHighContrast 
          ? const Color(0xFF6A1B9A) // Púrpura oscuro
          : const Color(0xFF7B1FA2); // Púrpura
      
      case 'tritanopia': // Dificultad con azul-amarillo (menos común)
        return isHighContrast 
          ? const Color(0xFFE65100) // Naranja oscuro
          : const Color(0xFFFF9800); // Naranja
      
      default: // Sin daltonismo
        return isHighContrast 
          ? const Color(0xFF1B5E20) // Verde muy oscuro
          : const Color(0xFF2E7D32); // Verde estándar
    }
  }
  
  Color getSecondaryColor(bool isHighContrast) {
    switch (_colorBlindnessType) {
      case 'protanopia': 
        return isHighContrast 
          ? const Color(0xFF1E88E5) // Azul claro
          : const Color(0xFF42A5F5);
      
      case 'deuteranopia':
        return isHighContrast 
          ? const Color(0xFF8E24AA) // Púrpura claro
          : const Color(0xFFAB47BC);
      
      case 'tritanopia':
        return isHighContrast 
          ? const Color(0xFFFF6F00) // Naranja claro
          : const Color(0xFFFFA726);
      
      default:
        return isHighContrast 
          ? const Color(0xFF2E7D32) // Verde oscuro
          : const Color(0xFF4CAF50); // Verde claro
    }
  }
  
  Color getAccentColor(bool isHighContrast) {
    switch (_colorBlindnessType) {
      case 'protanopia': 
        return isHighContrast 
          ? const Color(0xFF0277BD) // Azul muy oscuro
          : const Color(0xFF0288D1);
      
      case 'deuteranopia':
        return isHighContrast 
          ? const Color(0xFF7B1FA2) // Púrpura muy oscuro
          : const Color(0xFF9C27B0);
      
      case 'tritanopia':
        return isHighContrast 
          ? const Color(0xFFEF6C00) // Naranja muy oscuro
          : const Color(0xFFFF9800);
      
      default:
        return isHighContrast 
          ? const Color(0xFF388E3C) // Verde medio oscuro
          : const Color(0xFF66BB6A); // Verde medio
    }
  }
  
  // Método para obtener colores de error/éxito accesibles
  Color getErrorColor(bool isHighContrast) {
    // El rojo es problemático para protanopia y deuteranopia
    if (_colorBlindnessType == 'protanopia' || _colorBlindnessType == 'deuteranopia') {
      return isHighContrast 
        ? const Color(0xFF5D4037) // Marrón oscuro
        : const Color(0xFF8D6E63); // Marrón
    }
    return isHighContrast 
      ? const Color(0xFFB71C1C) // Rojo oscuro
      : const Color(0xFFD32F2F); // Rojo estándar
  }
  
  Color getSuccessColor(bool isHighContrast) {
    // Usar el color secundario para éxito en lugar de verde puro
    return getSecondaryColor(isHighContrast);
  }
  
  // Métodos de compatibilidad con el código existente
  Color getAccessibleGreen(bool isHighContrast) => getPrimaryColor(isHighContrast);
  Color getAccessibleLightGreen(bool isHighContrast) => getSecondaryColor(isHighContrast);
  Color getAccessibleRed(bool isHighContrast) => getErrorColor(isHighContrast);
  Color getAccessibleBlue(bool isHighContrast) => const Color(0xFF1976D2);
  Color getAccessibleOrange(bool isHighContrast) => const Color(0xFFFF9800);
}

class AppTranslations {
  static const Map<String, Map<String, String>> _translations = {
    'es': {
      'app_title': 'Universidad ESPE',
      'welcome': 'Bienvenido',
      'hello': '¡Hola, {email}!',
      'login': 'Iniciar Sesión',
      'register': 'Registrarse',
      'email': 'Correo Electrónico',
      'password': 'Contraseña',
      'logout': 'Cerrar Sesión',
      'session_closed': 'Sesión cerrada',
      'interactive_map': 'Mapa Interactivo',
      'nearby_places': 'Lugares Cercanos',
      'qr_scanner': 'Lectura de QR',
      'others': 'Otros',
      'university_locations': 'Ubicaciones Universidad',
      'loading': 'Cargando...',
      'loading_locations': 'Cargando ubicaciones...',
      'your_location': 'Tu ubicación:',
      'location_unavailable': 'Ubicación no disponible',
      'points_found': 'Puntos de interés encontrados: {count}',
      'no_points_found': 'No se encontraron puntos de interés',
      'add_points_firestore': 'Agrega algunos en Firebase Firestore',
      'view_list': 'Ver lista',
      'view_map': 'Ver mapa',
      'change_view': 'Cambiar vista: {viewType}',
      'map_normal': 'Normal',
      'map_satellite': 'Satélite',
      'map_terrain': 'Terreno',
      'map_hybrid': 'Híbrido',
      'map_unavailable': 'Mapa no disponible',
      'google_maps_error': 'Google Maps no se pudo cargar',
      'university_location': 'Ubicación Central Universidad',
      'close': 'Cerrar',
      'legend': 'Leyenda - Categorías',
      'classrooms': 'Aulas',
      'library': 'Biblioteca',
      'laboratories': 'Laboratorios',
      'cafeteria': 'Cafetería',
      'bathrooms': 'Baños',
      'administration': 'Administración',
      'entrances': 'Entradas',
      'parking': 'Estacionamiento',
      'general': 'General',
      'description': 'Descripción:',
      'category': 'Categoría:',
      'coordinates': 'Coordenadas:',
      'distance': 'Distancia:',
      'meters': 'metros',
      'functionality_not_available': 'Funcionalidad "{feature}" aún no disponible',
      'language': 'Idioma',
      'spanish': 'Español',
      'english': 'English',
      'kichwa': 'Kichwa',
      'settings': 'Configuración',
      'available_services': 'Servicios Disponibles',
      'accessibility': 'Accesibilidad',
      'high_contrast_mode': 'Modo Alto Contraste',
      'colorblind_support': 'Soporte Daltonismo',
      'enable_patterns': 'Habilitar Patrones',
      'accessibility_help': 'Opciones para mejorar la experiencia visual',
      'contrast_enabled': 'Modo de alto contraste activado',
      'contrast_disabled': 'Modo de alto contraste desactivado',
      'patterns_enabled': 'Patrones visuales activados',
      'patterns_disabled': 'Patrones visuales desactivados',
      'colorblind_type': 'Tipo de Daltonismo',
      'colorblind_none': 'Sin Daltonismo',
      'colorblind_protanopia': 'Protanopia (Rojo-Verde)',
      'colorblind_deuteranopia': 'Deuteranopia (Verde-Rojo)',
      'colorblind_tritanopia': 'Tritanopia (Azul-Amarillo)',
      'colorblind_changed': 'Tipo de daltonismo cambiado a: {type}',
    },
    'en': {
      'app_title': 'ESPE University',
      'welcome': 'Welcome',
      'hello': 'Hello, {email}!',
      'login': 'Login',
      'register': 'Register',
      'email': 'Email',
      'password': 'Password',
      'logout': 'Logout',
      'session_closed': 'Session closed',
      'interactive_map': 'Interactive Map',
      'nearby_places': 'Nearby Places',
      'qr_scanner': 'QR Scanner',
      'others': 'Others',
      'university_locations': 'University Locations',
      'loading': 'Loading...',
      'loading_locations': 'Loading locations...',
      'your_location': 'Your location:',
      'location_unavailable': 'Location unavailable',
      'points_found': 'Points of interest found: {count}',
      'no_points_found': 'No points of interest found',
      'add_points_firestore': 'Add some in Firebase Firestore',
      'view_list': 'View list',
      'view_map': 'View map',
      'change_view': 'Change view: {viewType}',
      'map_normal': 'Normal',
      'map_satellite': 'Satellite',
      'map_terrain': 'Terrain',
      'map_hybrid': 'Hybrid',
      'map_unavailable': 'Map unavailable',
      'google_maps_error': 'Google Maps could not load',
      'university_location': 'Central University Location',
      'close': 'Close',
      'legend': 'Legend - Categories',
      'classrooms': 'Classrooms',
      'library': 'Library',
      'laboratories': 'Laboratories',
      'cafeteria': 'Cafeteria',
      'bathrooms': 'Bathrooms',
      'administration': 'Administration',
      'entrances': 'Entrances',
      'parking': 'Parking',
      'general': 'General',
      'description': 'Description:',
      'category': 'Category:',
      'coordinates': 'Coordinates:',
      'distance': 'Distance:',
      'meters': 'meters',
      'functionality_not_available': 'Feature "{feature}" not yet available',
      'language': 'Language',
      'spanish': 'Español',
      'english': 'English',
      'kichwa': 'Kichwa',
      'settings': 'Settings',
      'available_services': 'Available Services',
      'accessibility': 'Accessibility',
      'high_contrast_mode': 'High Contrast Mode',
      'colorblind_support': 'Colorblind Support',
      'enable_patterns': 'Enable Patterns',
      'accessibility_help': 'Options to improve visual experience',
      'contrast_enabled': 'High contrast mode enabled',
      'contrast_disabled': 'High contrast mode disabled',
      'patterns_enabled': 'Visual patterns enabled',
      'patterns_disabled': 'Visual patterns disabled',
      'colorblind_type': 'Colorblindness Type',
      'colorblind_none': 'No Colorblindness',
      'colorblind_protanopia': 'Protanopia (Red-Green)',
      'colorblind_deuteranopia': 'Deuteranopia (Green-Red)',
      'colorblind_tritanopia': 'Tritanopia (Blue-Yellow)',
      'colorblind_changed': 'Colorblindness type changed to: {type}',
    },
    'qu': {
      'app_title': 'ESPE Yachana Wasi',
      'welcome': 'Allin hamusqa',
      'hello': '¡Napaykullayki, {email}!',
      'login': 'Yaykuy',
      'register': 'Shutichikuy',
      'email': 'Correo Electrónico',
      'password': 'Pakana rima',
      'logout': 'Lluqsiy',
      'session_closed': 'Sesión wichaysqa',
      'interactive_map': 'Puriyachina mapa',
      'nearby_places': 'Kaypi tiyan mama llaktakuna',
      'qr_scanner': 'QR ñawiriy',
      'others': 'Huk ruranakuna',
      'university_locations': 'Yachana wasi maypi tiyan',
      'loading': 'Apamushpa...',
      'loading_locations': 'Mama llaktakunata apamushpa...',
      'your_location': 'Qam maypi kankri:',
      'location_unavailable': 'Maypi kasqanki mana rikusqa',
      'points_found': 'Interés puntukuna tarisqa: {count}',
      'no_points_found': 'Mana interés puntukuna tarisqa',
      'add_points_firestore': 'Firebase Firestoremanta wakin yapay',
      'view_list': 'Lista qawana',
      'view_map': 'Mapa qawana',
      'change_view': 'Qawana tikray: {viewType}',
      'map_normal': 'Normal',
      'map_satellite': 'Satélite',
      'map_terrain': 'Allpa',
      'map_hybrid': 'Chaqrusqa',
      'map_unavailable': 'Mapa mana kachkanchu',
      'google_maps_error': 'Google Maps mana kargasqachu',
      'university_location': 'Yachana wasi chawpi maypi tiyan',
      'close': 'Wichay',
      'legend': 'Leyenda - Categorías',
      'classrooms': 'Yachana ukukuna',
      'library': 'Qillqa wasi',
      'laboratories': 'Experimentay wasi',
      'cafeteria': 'Mikuna wasi',
      'bathrooms': 'Mayllay wasi',
      'administration': 'Kamachiy',
      'entrances': 'Yaykuna punku',
      'parking': 'Antay kancha',
      'general': 'Llapanpaq',
      'description': 'Willay:',
      'category': 'Categoria:',
      'coordinates': 'Coordenadas:',
      'distance': 'Karuyka:',
      'meters': 'mitru',
      'functionality_not_available': '"{feature}" llamkana manaraq wakichisqa',
      'language': 'Rimay',
      'spanish': 'Español',
      'english': 'English',
      'kichwa': 'Kichwa',
      'settings': 'Wakichiy',
      'available_services': 'Wakichi llamkanakuna',
      'accessibility': 'Rikana yanapay',
      'high_contrast_mode': 'Sumaq rikana',
      'colorblind_support': 'Llimpi mana rikaqkunapaq yanapay',
      'enable_patterns': 'Rikchikunata churay',
      'accessibility_help': 'Aswan allin rikanaypaq aklllanakuna',
      'contrast_enabled': 'Sumaq rikana churasqa',
      'contrast_disabled': 'Sumaq rikana chinkachisqa',
      'patterns_enabled': 'Rikchikuna churasqa',
      'patterns_disabled': 'Rikchikuna chinkachisqa',
      'colorblind_type': 'Llimpi mana rikay laya',
      'colorblind_none': 'Mana llimpi sasachakuy',
      'colorblind_protanopia': 'Protanopia (Puka-Qumir)',
      'colorblind_deuteranopia': 'Deuteranopia (Qumir-Puka)',
      'colorblind_tritanopia': 'Tritanopia (Ankas-Qillu)',
      'colorblind_changed': 'Llimpi mana rikay tikrasqa: {type}',
    },
  };
  
  static String get(String key, String languageCode, {Map<String, dynamic>? params}) {
    String text = _translations[languageCode]?[key] ?? key;
    
    if (params != null) {
      params.forEach((key, value) {
        text = text.replaceAll('{$key}', value.toString());
      });
    }
    
    return text;
  }
}
