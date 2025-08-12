import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'app_translations.dart';
import 'main.dart';

class SettingsScreen extends StatelessWidget {
  final LanguageProvider languageProvider;
  final AccessibilityProvider accessibilityProvider;

  const SettingsScreen({
    super.key, 
    required this.languageProvider,
    required this.accessibilityProvider,
  });

  String _t(String key) {
    return AppTranslations.get(key, languageProvider.currentLanguage);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([languageProvider, accessibilityProvider]),
      builder: (context, child) {
        final Color primaryGreen = accessibilityProvider.getPrimaryColor(accessibilityProvider.highContrastMode);
        final Color lightGreen = accessibilityProvider.getSecondaryColor(accessibilityProvider.highContrastMode);

        return Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            title: Text(
              _t('settings'),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            backgroundColor: primaryGreen,
            elevation: 0,
            centerTitle: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [primaryGreen.withOpacity(0.1), Colors.white],
                stops: const [0.0, 0.3],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header con información del usuario
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [primaryGreen, lightGreen],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: primaryGreen.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  FirebaseAuth.instance.currentUser?.email ?? 'Usuario',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Universidad ESPE',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Secciones de configuración
                    Expanded(
                      child: ListView(
                        children: [
                          // Sección de Idioma
                          _buildSectionHeader(_t('language')),
                          _buildLanguageCard(context, primaryGreen, lightGreen),
                          
                          const SizedBox(height: 24),
                          
                          // Sección de Accesibilidad
                          _buildSectionHeader(_t('accessibility')),
                          _buildAccessibilityCard(context, primaryGreen),
                          
                          const SizedBox(height: 24),
                          
                          // Sección de Aplicación
                          _buildSectionHeader('Aplicación'),
                          _buildSettingCard(
                            icon: Icons.info_outline,
                            title: 'Acerca de',
                            subtitle: 'Versión 1.0.0',
                            gradient: LinearGradient(
                              colors: [Colors.blue.shade400, Colors.blue.shade600],
                            ),
                            onTap: () => _showAboutDialog(context),
                          ),
                          
                          const SizedBox(height: 12),
                          
                          _buildSettingCard(
                            icon: Icons.help_outline,
                            title: 'Ayuda y Soporte',
                            subtitle: 'Guías y preguntas frecuentes',
                            gradient: LinearGradient(
                              colors: [Colors.orange.shade400, Colors.orange.shade600],
                            ),
                            onTap: () => _showHelpDialog(context),
                          ),
                          
                          const SizedBox(height: 12),
                          
                          _buildSettingCard(
                            icon: Icons.privacy_tip_outlined,
                            title: 'Política de Privacidad',
                            subtitle: 'Términos y condiciones',
                            gradient: LinearGradient(
                              colors: [Colors.purple.shade400, Colors.purple.shade600],
                            ),
                            onTap: () => _showPrivacyDialog(context),
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Sección de Cuenta
                          _buildSectionHeader('Cuenta'),
                          _buildSettingCard(
                            icon: Icons.logout,
                            title: 'Cerrar Sesión',
                            subtitle: 'Salir de la aplicación',
                            gradient: LinearGradient(
                              colors: [Colors.red.shade400, Colors.red.shade600],
                            ),
                            onTap: () => _showLogoutDialog(context),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.grey[700],
        ),
      ),
    );
  }

  Widget _buildLanguageCard(BuildContext context, Color primaryGreen, Color lightGreen) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildLanguageOption(
            context,
            '🇪🇸',
            'Español',
            'es',
            primaryGreen,
          ),
          Divider(height: 1, color: Colors.grey.shade200),
          _buildLanguageOption(
            context,
            '🇺🇸',
            'English',
            'en',
            primaryGreen,
          ),
          Divider(height: 1, color: Colors.grey.shade200),
          _buildLanguageOption(
            context,
            '🏔️',
            'Kichwa',
            'qu',
            primaryGreen,
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(BuildContext context, String flag, String name, String code, Color primaryColor) {
    bool isSelected = languageProvider.currentLanguage == code;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          languageProvider.setLanguage(code);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Idioma cambiado a $name'),
              backgroundColor: primaryColor,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text(flag, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? primaryColor : Colors.grey[700],
                  ),
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: primaryColor,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildColorBlindnessSelector(BuildContext context, Color primaryColor) {
    final colorBlindnessOptions = ['none', 'protanopia', 'deuteranopia', 'tritanopia'];
    
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.color_lens, color: primaryColor, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _t('colorblindness_type'),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _t('colorblindness_help'),
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey.shade50,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: accessibilityProvider.colorBlindnessType,
                icon: Icon(Icons.arrow_drop_down, color: primaryColor),
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                ),
                items: colorBlindnessOptions.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: _getColorForType(type),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(_getDisplayNameForType(type)),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (String? newType) {
                  if (newType != null) {
                    accessibilityProvider.setColorBlindnessType(newType);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(_t('colorblindness_changed')),
                        backgroundColor: accessibilityProvider.getPrimaryColor(
                          accessibilityProvider.highContrastMode,
                        ),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getColorForType(String type) {
    switch (type) {
      case 'none':
        return const Color(0xFF4CAF50);
      case 'protanopia':
        return const Color(0xFF2196F3);
      case 'deuteranopia':
        return const Color(0xFF9C27B0);
      case 'tritanopia':
        return const Color(0xFFFF9800);
      default:
        return const Color(0xFF4CAF50);
    }
  }

  String _getDisplayNameForType(String type) {
    switch (type) {
      case 'none':
        return _t('colorblind_none');
      case 'protanopia':
        return _t('colorblind_protanopia');
      case 'deuteranopia':
        return _t('colorblind_deuteranopia');
      case 'tritanopia':
        return _t('colorblind_tritanopia');
      default:
        return _t('colorblind_none');
    }
  }

  Widget _buildAccessibilityCard(BuildContext context, Color primaryColor) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Tipo de Daltonismo
          _buildColorBlindnessSelector(context, primaryColor),
          Divider(height: 1, color: Colors.grey.shade200),
          
          // Alto Contraste
          _buildAccessibilityOption(
            context,
            Icons.contrast,
            _t('high_contrast_mode'),
            _t('accessibility_help'),
            accessibilityProvider.highContrastMode,
            (value) {
              accessibilityProvider.setHighContrastMode(value);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(value ? _t('contrast_enabled') : _t('contrast_disabled')),
                  backgroundColor: primaryColor,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
            primaryColor,
          ),
          Divider(height: 1, color: Colors.grey.shade200),
          
          // Patrones Visuales
          _buildAccessibilityOption(
            context,
            Icons.pattern,
            _t('enable_patterns'),
            'Agregar patrones para diferenciar elementos',
            accessibilityProvider.patternsEnabled,
            (value) {
              accessibilityProvider.setPatternsEnabled(value);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(value ? _t('patterns_enabled') : _t('patterns_disabled')),
                  backgroundColor: primaryColor,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
            primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildAccessibilityOption(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
    Color primaryColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: primaryColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required LinearGradient gradient,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: gradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(Icons.info, color: Colors.blue.shade600),
            const SizedBox(width: 8),
            const Text('Acerca de la App'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Universidad ESPE - App de Interculturalidad',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Versión: 1.0.0'),
            SizedBox(height: 4),
            Text('Desarrollado para promover la interculturalidad y el aprendizaje interactivo en la Universidad ESPE.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(Icons.help, color: Colors.orange.shade600),
            const SizedBox(width: 8),
            const Text('Ayuda y Soporte'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('¿Cómo usar la app?', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('• Usa el mapa interactivo para explorar la universidad'),
            Text('• Escanea códigos QR para acceder a trivias'),
            Text('• Cambia el idioma en configuración'),
            SizedBox(height: 16),
            Text('¿Necesitas más ayuda?'),
            Text('Contacta al soporte técnico de la Universidad ESPE.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(Icons.privacy_tip, color: Colors.purple.shade600),
            const SizedBox(width: 8),
            const Text('Política de Privacidad'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Protección de Datos', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('• Tus datos están protegidos'),
            Text('• Solo recopilamos información necesaria'),
            Text('• No compartimos datos con terceros'),
            SizedBox(height: 16),
            Text('Esta aplicación cumple con las políticas de privacidad de la Universidad ESPE.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(Icons.logout, color: Colors.red.shade600),
            const SizedBox(width: 8),
            Text(_t('logout')),
          ],
        ),
        content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginScreen(
                  languageProvider: languageProvider,
                  accessibilityProvider: accessibilityProvider,
                )),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
            ),
            child: Text(_t('logout')),
          ),
        ],
      ),
    );
  }
}
