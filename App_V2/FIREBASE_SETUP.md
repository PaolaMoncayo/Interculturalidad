# Configuración de Firebase para Login App

## 1. Firebase Console - Reglas de Firestore

Ve a Firebase Console > Firestore Database > Rules y reemplaza las reglas con:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Permitir lectura pública de trivias
    match /trivias/{document=**} {
      allow read: if true;
      allow write: if request.auth != null;
    }
    
    // Permitir lectura pública de puntos de interés
    match /points_of_interest/{document=**} {
      allow read: if true;
      allow write: if request.auth != null;
    }
    
    // Reglas para usuarios autenticados
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

## 2. Crear Colección de Trivias

En Firestore Database > Data, crea una colección llamada `trivias` con un documento de prueba:

**Documento ID:** `test_qr`

```json
{
  "questions": [
    {
      "question": "¿Qué significa interculturalidad?",
      "options": ["Una cultura", "Respeto entre culturas", "Mezcla", "Eliminación"],
      "answer": "Respeto entre culturas"
    },
    {
      "question": "¿Cuál es la importancia de la diversidad?",
      "options": ["No importante", "Enriquece", "Causa problemas", "Innecesaria"],
      "answer": "Enriquece"
    }
  ]
}
```

## 3. Verificación de Conexión

- Asegúrate de que el proyecto está correctamente conectado
- Verifica que Authentication esté habilitado
- Comprueba que Firestore esté en modo producción (no test)

## 4. Códigos QR de Prueba

Una vez configurado, puedes crear QRs con estos valores:
- `test_qr` - Trivia de prueba básica
- `cultura_espe` - (agrega tu propia trivia sobre ESPE)
- `ecuador_cultura` - (agrega trivia sobre Ecuador)

## 5. Solución Temporal

Si Firebase sigue dando problemas, la app mostrará "No hay trivia disponible para este código QR" con un botón "Entendido", lo cual es mejor que crashearse.
