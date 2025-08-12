import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'app_translations.dart';

class TriviaScreen extends StatefulWidget {
  final String qrData;
  final AccessibilityProvider? accessibilityProvider;
  
  const TriviaScreen({
    super.key, 
    required this.qrData,
    this.accessibilityProvider,
  });

  @override
  State<TriviaScreen> createState() => _TriviaScreenState();
}

class _TriviaScreenState extends State<TriviaScreen> {
  late Future<List<Map<String, dynamic>>> _questionsFuture;

  int currentQuestion = 0;
  int score = 0;
  bool answered = false;
  String? selectedOption;

  @override
  void initState() {
    super.initState();
    _questionsFuture = fetchQuestions(widget.qrData);
  }

  Future<List<Map<String, dynamic>>> fetchQuestions(String qr) async {
    try {
      print('🔍 Intentando cargar trivia para QR: $qr');
      
      // Timeout de 10 segundos para evitar bucles infinitos
      final doc = await FirebaseFirestore.instance
          .collection('trivias')
          .doc(qr)
          .get()
          .timeout(const Duration(seconds: 10));
      
      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        print('✅ Datos encontrados en Firebase: ${data.keys}');
        
        final questions = List<Map<String, dynamic>>.from(data['questions'] ?? []);
        if (questions.isNotEmpty) {
          print('🎯 ${questions.length} preguntas cargadas exitosamente');
          return questions;
        } else {
          print('⚠️ El documento existe pero no tiene preguntas válidas');
        }
      } else {
        print('❌ Documento no existe para QR: $qr');
      }
    } catch (e) {
      print('💥 Error cargando trivia de Firebase: $e');
      
      // Agregar información específica del error
      if (e.toString().contains('permission-denied')) {
        print('🔐 Error de permisos - Revisar reglas de Firestore');
      } else if (e.toString().contains('network')) {
        print('🌐 Error de red - Verificar conexión a internet');
      }
    }
    
    print('📝 Mostrando mensaje de no disponible para QR: $qr');
    
    // Si llegamos aquí, no hay datos disponibles
    return [
      {
        'question': 'No hay trivia disponible para este código QR: "$qr"',
        'options': ['Entendido', 'Volver'],
        'answer': 'Entendido',
      }
    ];
  }

  void checkAnswer(String option, List<Map<String, dynamic>> questions) {
    setState(() {
      answered = true;
      selectedOption = option;
      if (option == questions[currentQuestion]['answer']) {
        score++;
      }
    });
  }

  void nextQuestion() {
    setState(() {
      currentQuestion++;
      answered = false;
      selectedOption = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final AccessibilityProvider? accessibilityProvider = widget.accessibilityProvider;
    final bool usePatterns = accessibilityProvider?.patternsEnabled ?? false;
    final bool highContrast = accessibilityProvider?.highContrastMode ?? false;
    
    final Color primaryGreen = accessibilityProvider?.getPrimaryColor(highContrast) ?? const Color(0xFF2E7D32);
    final Color lightGreen = accessibilityProvider?.getSecondaryColor(highContrast) ?? const Color(0xFF4CAF50);
    final Color accessibleRed = highContrast ? const Color(0xFFE57373) : const Color(0xFFD32F2F);

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _questionsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Colors.grey[50],
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [primaryGreen.withOpacity(0.1), Colors.white],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: primaryGreen.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(primaryGreen),
                        strokeWidth: 3,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Cargando trivia...',
                      style: TextStyle(
                        fontSize: 18,
                        color: primaryGreen,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: Colors.grey[50],
            appBar: AppBar(
              title: const Text(
                'Error',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              backgroundColor: accessibleRed,
              elevation: 0,
              centerTitle: true,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: accessibleRed,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error al cargar la trivia',
                    style: TextStyle(
                      fontSize: 18,
                      color: accessibleRed,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${snapshot.error}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Volver',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Scaffold(
            backgroundColor: Colors.grey[50],
            appBar: AppBar(
              title: const Text(
                'Sin Datos',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              backgroundColor: primaryGreen,
              elevation: 0,
              centerTitle: true,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.quiz_outlined,
                    size: 64,
                    color: primaryGreen,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No hay preguntas disponibles',
                    style: TextStyle(
                      fontSize: 18,
                      color: primaryGreen,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Volver',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final questions = snapshot.data!;
        if (currentQuestion >= questions.length) {
          return Scaffold(
            backgroundColor: Colors.grey[50],
            appBar: AppBar(
              title: const Text(
                'Trivia Completada',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              backgroundColor: primaryGreen,
              elevation: 0,
              centerTitle: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
              ),
            ),
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [primaryGreen.withOpacity(0.1), Colors.white],
                ),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Card(
                    elevation: 15,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(40),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        gradient: LinearGradient(
                          colors: [Colors.white, lightGreen.withOpacity(0.1)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: score >= questions.length * 0.7 ? primaryGreen : lightGreen,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              score >= questions.length * 0.7 ? Icons.stars : Icons.emoji_events,
                              size: 50,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            '¡Trivia finalizada!',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: primaryGreen,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Tu puntaje',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$score/${questions.length}',
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: primaryGreen,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            score >= questions.length * 0.7 
                                ? '¡Excelente trabajo!' 
                                : score >= questions.length * 0.5 
                                    ? '¡Bien hecho!' 
                                    : '¡Sigue practicando!',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[700],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(height: 32),
                          Container(
                            width: double.infinity,
                            height: 56,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              gradient: LinearGradient(
                                colors: [primaryGreen, lightGreen],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: primaryGreen.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: const Text(
                                'Volver',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        final question = questions[currentQuestion];
        final progress = (currentQuestion + 1) / questions.length;

        return Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            title: Text(
              'Trivia ESPE',
              style: TextStyle(
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
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [primaryGreen.withOpacity(0.1), Colors.white],
              ),
            ),
            child: Column(
              children: [
                // Progress Header
                Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: primaryGreen.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Pregunta ${currentQuestion + 1}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: primaryGreen,
                            ),
                          ),
                          Text(
                            'de ${questions.length}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(lightGreen),
                        minHeight: 8,
                      ),
                    ],
                  ),
                ),
                
                // Question Card
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Card(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                colors: [Colors.white, lightGreen.withOpacity(0.05)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.quiz,
                                  color: primaryGreen,
                                  size: 32,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  question['question'],
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[800],
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        
                        // Options
                        Expanded(
                          child: ListView.builder(
                            itemCount: question['options'].length,
                            itemBuilder: (context, index) {
                              final option = question['options'][index];
                              final isCorrect = option == question['answer'];
                              final isSelected = option == selectedOption;
                              
                              Color backgroundColor = Colors.white;
                              Color borderColor = Colors.grey.shade300;
                              Color textColor = Colors.grey.shade800;
                              IconData? icon;
                              
                              if (answered) {
                                if (isSelected && isCorrect) {
                                  backgroundColor = lightGreen;
                                  borderColor = primaryGreen;
                                  textColor = Colors.white;
                                  icon = Icons.check_circle;
                                } else if (isSelected && !isCorrect) {
                                  backgroundColor = accessibleRed.withOpacity(0.9);
                                  borderColor = accessibleRed;
                                  textColor = Colors.white;
                                  icon = Icons.cancel;
                                } else if (isCorrect) {
                                  backgroundColor = lightGreen.withOpacity(0.3);
                                  borderColor = primaryGreen;
                                  textColor = primaryGreen;
                                  icon = Icons.check_circle_outline;
                                }
                              }
                              
                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 5,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Material(
                                  color: backgroundColor,
                                  borderRadius: BorderRadius.circular(15),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(15),
                                    onTap: answered ? null : () => checkAnswer(option, questions),
                                    child: Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(color: borderColor, width: 2),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: answered 
                                                  ? backgroundColor 
                                                  : primaryGreen.withOpacity(0.1),
                                            ),
                                            child: Center(
                                              child: icon != null 
                                                  ? Icon(icon, color: textColor, size: 20)
                                                  : Text(
                                                      String.fromCharCode(65 + index), // A, B, C, D
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        color: answered ? textColor : primaryGreen,
                                                      ),
                                                    ),
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          _buildPatternIndicator(index, usePatterns),
                                          Expanded(
                                            child: Text(
                                              option,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: textColor,
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
                          ),
                        ),
                        
                        // Next Button
                        if (answered)
                          Container(
                            width: double.infinity,
                            height: 56,
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              gradient: LinearGradient(
                                colors: [primaryGreen, lightGreen],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: primaryGreen.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: nextQuestion,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: Text(
                                currentQuestion < questions.length - 1 ? 'Siguiente' : 'Finalizar',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  // Widget helper para patrones visuales de accesibilidad
  Widget _buildPatternIndicator(int optionIndex, bool usePatterns) {
    if (!usePatterns) return const SizedBox.shrink();
    
    final List<IconData> patternIcons = [
      Icons.circle,
      Icons.square,
      Icons.change_history, // triángulo
      Icons.star,
    ];
    
    return Container(
      padding: const EdgeInsets.only(right: 8),
      child: Icon(
        patternIcons[optionIndex % patternIcons.length],
        size: 16,
        color: Colors.grey[600],
      ),
    );
  }
}