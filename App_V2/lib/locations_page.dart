import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'app_translations.dart';

class LocationsPage extends StatefulWidget {
  final AccessibilityProvider? accessibilityProvider;
  
  const LocationsPage({Key? key, this.accessibilityProvider}) : super(key: key);

  @override
  State<LocationsPage> createState() => _LocationsPageState();
}

class _LocationsPageState extends State<LocationsPage> {
  List<Map<String, dynamic>> _pointsOfInterest = [];
  bool _isLoading = true;
  Position? _currentPosition;
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  bool _showMap = false;
  MapType _currentMapType = MapType.normal;
  
  // Coordenadas centrales de la universidad
  static const LatLng _universityCenter = LatLng(-0.31466006956477127, -78.44251930378469);

  @override
  void initState() {
    super.initState();
    _initializeScreen();
  }

  Future<void> _initializeScreen() async {
    await _getCurrentLocation();
    await _loadPointsOfInterest();
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Permisos de ubicación denegados');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print('Permisos de ubicación denegados permanentemente');
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      
      if (mounted) {
        setState(() {
          _currentPosition = position;
        });
      }
    } catch (e) {
      print('Error obteniendo ubicación: $e');
    }
  }

  Future<void> _loadPointsOfInterest() async {
    try {
      print('Intentando cargar puntos de interés de Firebase...');
      
      // Primero intentamos cargar desde Firebase
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('points_of_interest')
          .get();

      List<Map<String, dynamic>> points = [];
      
      for (QueryDocumentSnapshot doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>?;
        
        if (data != null && 
            data.containsKey('latitude') && 
            data.containsKey('longitude') && 
            data.containsKey('title') &&
            data['latitude'] != null && 
            data['longitude'] != null && 
            data['title'] != null) {
          
          try {
            final double lat = (data['latitude'] is int) 
                ? (data['latitude'] as int).toDouble() 
                : data['latitude'] as double;
            final double lng = (data['longitude'] is int) 
                ? (data['longitude'] as int).toDouble() 
                : data['longitude'] as double;
            
            points.add({
              'id': doc.id,
              'title': data['title']?.toString() ?? 'Punto de interés',
              'description': data['description']?.toString() ?? '',
              'category': data['category']?.toString() ?? 'default',
              'latitude': lat,
              'longitude': lng,
              'distance': _currentPosition != null 
                  ? Geolocator.distanceBetween(
                      _currentPosition!.latitude,
                      _currentPosition!.longitude,
                      lat,
                      lng,
                    ).round()
                  : 0,
            });
          } catch (pointError) {
            print('Error procesando punto ${doc.id}: $pointError');
          }
        }
      }

      print('Puntos cargados desde Firebase: ${points.length}');
      
      // Si no hay puntos en Firebase, usar datos de ejemplo
      if (points.isEmpty) {
        print('No se encontraron puntos en Firebase, usando datos de ejemplo...');
        points = _getExamplePoints();
      }

      // Ordenar por distancia si tenemos ubicación
      if (_currentPosition != null) {
        points.sort((a, b) => (a['distance'] as int).compareTo(b['distance'] as int));
      }

      // No crear marcadores personalizados - dejar que Google Maps muestre sus propios puntos

      if (mounted) {
        setState(() {
          _pointsOfInterest = points;
          _markers = {}; // Vacío para no mostrar marcadores personalizados
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error cargando puntos de interés: $e');
      
      // Si falla Firebase, usar datos de ejemplo
      print('Firebase falló, usando datos de ejemplo...');
      List<Map<String, dynamic>> examplePoints = _getExamplePoints();
      
      // No crear marcadores personalizados - dejar que Google Maps muestre sus propios puntos
      
      if (mounted) {
        setState(() {
          _pointsOfInterest = examplePoints;
          _markers = {}; // Vacío para no mostrar marcadores personalizados
          _isLoading = false;
        });
      }
    }
  }

  List<Map<String, dynamic>> _getExamplePoints() {
    // Datos basados en las ubicaciones reales de la Universidad ESPE
    return [
      {
        'id': 'entrada_principal',
        'title': 'Entrada Principal ESPE',
        'description': 'Acceso principal al campus universitario',
        'category': 'entrada',
        'latitude': -0.3137,
        'longitude': -78.4425,
        'distance': _currentPosition != null 
            ? Geolocator.distanceBetween(
                _currentPosition!.latitude,
                _currentPosition!.longitude,
                -0.3137,
                -78.4425,
              ).round()
            : 0,
      },
      {
        'id': 'bloque_c_espe',
        'title': 'Bloque C - ESPE',
        'description': 'Edificio académico principal',
        'category': 'aula',
        'latitude': -0.3142,
        'longitude': -78.4420,
        'distance': _currentPosition != null 
            ? Geolocator.distanceBetween(
                _currentPosition!.latitude,
                _currentPosition!.longitude,
                -0.3142,
                -78.4420,
              ).round()
            : 50,
      },
      {
        'id': 'laboratorios_computacion',
        'title': 'Laboratorios de Computación ESPE',
        'description': 'Laboratorios de sistemas y programación',
        'category': 'laboratorio',
        'latitude': -0.3140,
        'longitude': -78.4418,
        'distance': _currentPosition != null 
            ? Geolocator.distanceBetween(
                _currentPosition!.latitude,
                _currentPosition!.longitude,
                -0.3140,
                -78.4418,
              ).round()
            : 75,
      },
      {
        'id': 'departamento_ciencias',
        'title': 'Departamento de Ciencias de la Energía',
        'description': 'Facultad de Ciencias de la Energía',
        'category': 'administracion',
        'latitude': -0.3145,
        'longitude': -78.4422,
        'distance': _currentPosition != null 
            ? Geolocator.distanceBetween(
                _currentPosition!.latitude,
                _currentPosition!.longitude,
                -0.3145,
                -78.4422,
              ).round()
            : 100,
      },
      {
        'id': 'biblioteca_espe',
        'title': 'Biblioteca ESPE',
        'description': 'Biblioteca central de la universidad',
        'category': 'biblioteca',
        'latitude': -0.3143,
        'longitude': -78.4424,
        'distance': _currentPosition != null 
            ? Geolocator.distanceBetween(
                _currentPosition!.latitude,
                _currentPosition!.longitude,
                -0.3143,
                -78.4424,
              ).round()
            : 80,
      },
      {
        'id': 'gimnasio_espe',
        'title': 'Gimnasio ESPE',
        'description': 'Instalaciones deportivas y gimnasio',
        'category': 'default',
        'latitude': -0.3148,
        'longitude': -78.4415,
        'distance': _currentPosition != null 
            ? Geolocator.distanceBetween(
                _currentPosition!.latitude,
                _currentPosition!.longitude,
                -0.3148,
                -78.4415,
              ).round()
            : 120,
      },
      {
        'id': 'coliseo_general',
        'title': 'Coliseo General Miguel Iturralde',
        'description': 'Instalaciones deportivas y eventos',
        'category': 'default',
        'latitude': -0.3155,
        'longitude': -78.4430,
        'distance': _currentPosition != null 
            ? Geolocator.distanceBetween(
                _currentPosition!.latitude,
                _currentPosition!.longitude,
                -0.3155,
                -78.4430,
              ).round()
            : 150,
      },
      {
        'id': 'centro_investigaciones',
        'title': 'Centro de Investigaciones ESPE',
        'description': 'Centro de investigación y desarrollo',
        'category': 'laboratorio',
        'latitude': -0.3152,
        'longitude': -78.4438,
        'distance': _currentPosition != null 
            ? Geolocator.distanceBetween(
                _currentPosition!.latitude,
                _currentPosition!.longitude,
                -0.3152,
                -78.4438,
              ).round()
            : 180,
      },
      {
        'id': 'estacionamiento_principal',
        'title': 'Estacionamiento Principal',
        'description': 'Área de parqueadero principal',
        'category': 'estacionamiento',
        'latitude': -0.3135,
        'longitude': -78.4428,
        'distance': _currentPosition != null 
            ? Geolocator.distanceBetween(
                _currentPosition!.latitude,
                _currentPosition!.longitude,
                -0.3135,
                -78.4428,
              ).round()
            : 60,
      },
      {
        'id': 'cafeteria_espe',
        'title': 'Cafetería ESPE',
        'description': 'Comedor y cafetería universitaria',
        'category': 'cafeteria',
        'latitude': -0.3144,
        'longitude': -78.4421,
        'distance': _currentPosition != null 
            ? Geolocator.distanceBetween(
                _currentPosition!.latitude,
                _currentPosition!.longitude,
                -0.3144,
                -78.4421,
              ).round()
            : 85,
      },
    ];
  }

  String _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'aula':
        return '🏫';
      case 'biblioteca':
        return '📚';
      case 'laboratorio':
        return '🔬';
      case 'cafeteria':
        return '☕';
      case 'baño':
        return '🚻';
      case 'administracion':
        return '🏢';
      case 'entrada':
        return '🚪';
      case 'estacionamiento':
        return '🅿️';
      default:
        return '📍';
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'aula':
        return Colors.blue;
      case 'biblioteca':
        return Colors.green;
      case 'laboratorio':
        return Colors.orange;
      case 'cafeteria':
        return Colors.amber;
      case 'baño':
        return Colors.cyan;
      case 'administracion':
        return Colors.purple;
      case 'entrada':
        return Colors.pink;
      case 'estacionamiento':
        return Colors.teal;
      default:
        return Colors.red;
    }
  }

  void _changeMapType() {
    setState(() {
      switch (_currentMapType) {
        case MapType.normal:
          _currentMapType = MapType.satellite;
          break;
        case MapType.satellite:
          _currentMapType = MapType.terrain;
          break;
        case MapType.terrain:
          _currentMapType = MapType.hybrid;
          break;
        case MapType.hybrid:
          _currentMapType = MapType.normal;
          break;
        case MapType.none:
          _currentMapType = MapType.normal;
          break;
      }
    });
  }

  String _getMapTypeName() {
    switch (_currentMapType) {
      case MapType.normal:
        return 'Normal';
      case MapType.satellite:
        return 'Satélite';
      case MapType.terrain:
        return 'Terreno';
      case MapType.hybrid:
        return 'Híbrido';
      default:
        return 'Normal';
    }
  }

  IconData _getMapTypeIcon() {
    switch (_currentMapType) {
      case MapType.normal:
        return Icons.map_outlined;
      case MapType.satellite:
        return Icons.satellite;
      case MapType.terrain:
        return Icons.terrain;
      case MapType.hybrid:
        return Icons.layers;
      default:
        return Icons.map_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final AccessibilityProvider? accessibilityProvider = widget.accessibilityProvider;
    final bool highContrast = accessibilityProvider?.highContrastMode ?? false;
    final Color primaryGreen = accessibilityProvider?.getPrimaryColor(highContrast) ?? const Color(0xFF2E7D32);
    final Color secondaryGreen = accessibilityProvider?.getSecondaryColor(highContrast) ?? const Color(0xFF4CAF50);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ubicaciones Universidad'),
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(_showMap ? Icons.list : Icons.map),
            onPressed: () {
              setState(() {
                _showMap = !_showMap;
              });
            },
            tooltip: _showMap ? 'Ver lista' : 'Ver mapa',
          ),
          if (_showMap) // Solo mostrar cuando esté en vista de mapa
            IconButton(
              icon: Icon(_getMapTypeIcon()),
              onPressed: _changeMapType,
              tooltip: 'Cambiar vista: ${_getMapTypeName()}',
            ),
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _getCurrentLocation,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPointsOfInterest,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Cargando ubicaciones...'),
                ],
              ),
            )
          : _showMap 
              ? _buildMapView(primaryGreen, secondaryGreen)
              : _buildListView(primaryGreen, secondaryGreen),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showLegend(),
        backgroundColor: primaryGreen,
        child: const Icon(Icons.info, color: Colors.white),
      ),
    );
  }

  Widget _buildMapView(Color primaryGreen, Color secondaryGreen) {
    try {
      return Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: _universityCenter,
              zoom: 16.0,
            ),
            mapType: _currentMapType,
            markers: _markers,
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
          ),
          // Indicador de tipo de mapa
          Positioned(
            bottom: 20,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getMapTypeIcon(),
                    size: 16,
                    color: primaryGreen,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _getMapTypeName(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: primaryGreen,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    } catch (e) {
      print('Error inicializando Google Maps: $e');
      // Si Google Maps falla, mostrar un mapa alternativo simple
      return Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          border: Border.all(color: Colors.grey[400]!),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.map_outlined,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            const Text(
              'Mapa no disponible',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Google Maps no se pudo cargar',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green[200]!),
              ),
              child: Column(
                children: [
                  Text(
                    'Ubicación Central Universidad',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Latitud: -0.31466006956477127',
                    style: TextStyle(fontSize: 12),
                  ),
                  const Text(
                    'Longitud: -78.44251930378469',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _showMap = false;
                });
              },
              icon: const Icon(Icons.list),
              label: const Text('Ver Lista'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryGreen,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildListView(Color primaryGreen, Color secondaryGreen) {
    return Column(
      children: [
        // Header con información de ubicación
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          color: primaryGreen.withOpacity(0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tu ubicación:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: primaryGreen,
                ),
              ),
              Text(
                _currentPosition != null
                    ? 'Lat: ${_currentPosition!.latitude.toStringAsFixed(4)}, Lng: ${_currentPosition!.longitude.toStringAsFixed(4)}'
                    : 'Ubicación no disponible',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Text(
                'Puntos de interés encontrados: ${_pointsOfInterest.length}',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        // Lista de puntos de interés
        Expanded(
          child: _pointsOfInterest.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_off, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No se encontraron puntos de interés',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Agrega algunos en Firebase Firestore',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _pointsOfInterest.length,
                  itemBuilder: (context, index) {
                    final point = _pointsOfInterest[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 2,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: _getCategoryColor(point['category']),
                          child: Text(
                            _getCategoryIcon(point['category']),
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                        title: Text(
                          point['title'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (point['description'].isNotEmpty)
                              Text(point['description']),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: 16,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${point['latitude'].toStringAsFixed(4)}, ${point['longitude'].toStringAsFixed(4)}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                if (_currentPosition != null) ...[
                                  const SizedBox(width: 12),
                                  Icon(
                                    Icons.straighten,
                                    size: 16,
                                    color: Colors.grey[600],
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${point['distance']}m',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                        trailing: Chip(
                          label: Text(
                            point['category'],
                            style: const TextStyle(fontSize: 10),
                          ),
                          backgroundColor: _getCategoryColor(point['category']).withOpacity(0.2),
                        ),
                        onTap: () {
                          _showLocationDetails(point);
                        },
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  void _showLocationDetails(Map<String, dynamic> point) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: _getCategoryColor(point['category']),
              child: Text(
                _getCategoryIcon(point['category']),
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                point['title'],
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (point['description'].isNotEmpty) ...[
              const Text(
                'Descripción:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(point['description']),
              const SizedBox(height: 12),
            ],
            const Text(
              'Categoría:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(point['category']),
            const SizedBox(height: 12),
            const Text(
              'Coordenadas:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('${point['latitude'].toStringAsFixed(6)}, ${point['longitude'].toStringAsFixed(6)}'),
            if (_currentPosition != null) ...[
              const SizedBox(height: 12),
              const Text(
                'Distancia:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('${point['distance']} metros'),
            ],
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

  void _showLegend() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Leyenda - Categorías'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _legendItem('🏫', 'Aulas'),
            _legendItem('📚', 'Biblioteca'),
            _legendItem('🔬', 'Laboratorios'),
            _legendItem('☕', 'Cafetería'),
            _legendItem('🚻', 'Baños'),
            _legendItem('🏢', 'Administración'),
            _legendItem('🚪', 'Entradas'),
            _legendItem('🅿️', 'Estacionamiento'),
            _legendItem('📍', 'General'),
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

  Widget _legendItem(String icon, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 10),
          Text(label),
        ],
      ),
    );
  }
}
