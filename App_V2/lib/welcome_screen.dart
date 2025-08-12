import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';
import 'qr_screen.dart';
import 'locations_page.dart'; 
import 'settings_screen.dart';
import 'app_translations.dart'; 


class WelcomeScreen extends StatelessWidget {
  final String email;
  final LanguageProvider languageProvider;
  final AccessibilityProvider accessibilityProvider;

  const WelcomeScreen({
    super.key, 
    required this.email, 
    required this.languageProvider,
    required this.accessibilityProvider,
  });

  String _t(String key) {
    return AppTranslations.get(key, languageProvider.currentLanguage, params: {'email': email});
  }

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(_t('session_closed'))));
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginScreen(
        languageProvider: languageProvider,
        accessibilityProvider: accessibilityProvider,
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([languageProvider, accessibilityProvider]),
      builder: (context, child) {
        final Color primaryGreen = accessibilityProvider.getPrimaryColor(accessibilityProvider.highContrastMode);
        final Color secondaryGreen = accessibilityProvider.getSecondaryColor(accessibilityProvider.highContrastMode);
        
        return Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            backgroundColor: primaryGreen,
            foregroundColor: Colors.white,
            title: Text(
              _t('welcome'),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            elevation: 0,
            centerTitle: true,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryGreen, secondaryGreen],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
            actions: [
              PopupMenuButton<String>(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.language, color: Colors.white),
                ),
                tooltip: _t('language'),
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onSelected: (String languageCode) {
                  languageProvider.setLanguage(languageCode);
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'es',
                    child: Row(
                      children: [
                        const Text('🇪🇸', style: TextStyle(fontSize: 20)),
                        const SizedBox(width: 12),
                        Text(_t('spanish'), style: const TextStyle(fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'en',
                    child: Row(
                      children: [
                        const Text('🇺🇸', style: TextStyle(fontSize: 20)),
                        const SizedBox(width: 12),
                        Text(_t('english'), style: const TextStyle(fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'qu',
                    child: Row(
                      children: [
                        const Text('🏔️', style: TextStyle(fontSize: 20)),
                        const SizedBox(width: 12),
                        Text(_t('kichwa'), style: const TextStyle(fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(right: 16, left: 8),
                child: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.logout, color: Colors.white),
                  ),
                  onPressed: () => _logout(context),
                ),
              ),
            ],
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  primaryGreen.withOpacity(0.1),
                  Colors.white,
                ],
                stops: const [0.0, 0.3],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header con saludo
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            primaryGreen.withOpacity(0.9),
                            secondaryGreen.withOpacity(0.8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: primaryGreen.withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.person,
                              size: 32,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _t('hello'),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _t('app_title'),
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Título de funcionalidades
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        _t('available_services'),
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: primaryGreen,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Lista de funcionalidades centradas
                    Expanded(
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 400),
                          child: Column(
                            children: [
                              // Mapa Interactivo
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  child: ModernFeatureCard(
                                    icon: Icons.map_outlined,
                                    label: _t('interactive_map'),
                                    translator: _t,
                                    gradient: LinearGradient(
                                      colors: [primaryGreen, secondaryGreen],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => LocationsPage(
                                            accessibilityProvider: accessibilityProvider,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              // QR Scanner
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  child: ModernFeatureCard(
                                    icon: Icons.qr_code_scanner_outlined,
                                    label: _t('qr_scanner'),
                                    translator: _t,
                                    gradient: LinearGradient(
                                      colors: [Colors.teal.shade400, Colors.teal.shade600],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => QRViewExample(
                                            accessibilityProvider: accessibilityProvider,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Configuración
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  child: ModernFeatureCard(
                                    icon: Icons.settings_outlined,
                                    label: _t('settings'),
                                    translator: _t,
                                    gradient: LinearGradient(
                                      colors: [Colors.blueGrey.shade400, Colors.blueGrey.shade600],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SettingsScreen(
                                            languageProvider: languageProvider,
                                            accessibilityProvider: accessibilityProvider,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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
}

class ModernFeatureCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final String Function(String)? translator;
  final Gradient gradient;

  const ModernFeatureCard({
    super.key,
    required this.icon,
    required this.label,
    required this.gradient,
    this.onTap,
    this.translator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        borderRadius: BorderRadius.circular(20),
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap ??
              () {
                String message = translator != null 
                  ? translator!('functionality_not_available').replaceAll('{feature}', label)
                  : 'Funcionalidad "$label" aún no disponible';
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(message),
                    backgroundColor: Theme.of(context).primaryColor,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              },
          child: Container(
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    icon,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
