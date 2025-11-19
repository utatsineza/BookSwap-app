# BookSwap App

A Flutter mobile application for students to exchange textbooks with Firebase backend.

## Features

- **Authentication**: Email/password signup and login with email verification
- **Book Listings**: Create, read, update, and delete book listings
- **Swap System**: Initiate swap offers with pending/accepted/rejected states
- **Real-time Updates**: Firestore listeners for instant UI updates
- **Chat**: Real-time messaging between users after swap acceptance
- **State Management**: Provider pattern for reactive state management

## Architecture

```
lib/
├── models/          # Data models (Book, Swap)
├── providers/       # State management (Auth, Book, Swap, Chat)
├── presentation/    # UI screens
│   └── screens/
│       ├── auth/    # Login & Signup
│       ├── browse_screen.dart
│       ├── my_listings_screen.dart
│       ├── my_offers_screen.dart
│       ├── chat_screen.dart
│       └── settings_screen.dart
└── main.dart
```

## Firebase Setup

### 1. Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project
3. Add Android/iOS app

### 2. Configure Firebase
```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase for your project
flutterfire configure
```

### 3. Firestore Database Structure

**Collections:**

```
users/
  {userId}/
    - email: string
    - name: string
    - createdAt: timestamp

books/
  {bookId}/
    - title: string
    - author: string
    - condition: string (New, Like New, Good, Used)
    - ownerId: string
    - coverUrl: string (optional)
    - status: string (available, pending, swapped)
    - createdAt: timestamp

swaps/
  {swapId}/
    - bookId: string
    - bookTitle: string
    - senderId: string
    - senderName: string
    - receiverId: string
    - status: string (pending, accepted, rejected)
    - createdAt: timestamp

chats/
  {chatId}/
    messages/
      {messageId}/
        - senderId: string
        - text: string
        - timestamp: timestamp
```

### 4. Firestore Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth.uid == userId;
    }
    
    match /books/{bookId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
      allow update, delete: if request.auth.uid == resource.data.ownerId;
    }
    
    match /swaps/{swapId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
      allow update: if request.auth.uid == resource.data.receiverId;
    }
    
    match /chats/{chatId}/messages/{messageId} {
      allow read, write: if request.auth != null;
    }
  }
}
```

## Installation

### Prerequisites
- Flutter SDK (>=2.18.0)
- Android Studio / Xcode
- Firebase account

### Steps

1. **Clone the repository**
```bash
git clone <your-repo-url>
cd book_swap_app
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Configure Firebase**
```bash
flutterfire configure
```

4. **Run the app**
```bash
# For Android emulator
flutter run

# For iOS simulator
flutter run -d ios

# For specific device
flutter devices
flutter run -d <device-id>
```

## State Management

This app uses **Provider** for state management:

- **AuthProvider**: Manages user authentication state
- **BookProvider**: Handles book CRUD operations
- **SwapProvider**: Manages swap offers with real-time listeners
- **ChatProvider**: Handles real-time messaging

### Example Usage:

```dart
// Access provider
final auth = context.read<AuthProvider>();

// Watch for changes
final books = context.watch<BookProvider>().books;

// Perform action
await auth.login(email, password);
```

## Key Features Implementation

### 1. Email Verification
```dart
// Signup sends verification email
await auth.signup(email, password, name);

// Login checks verification status
if (!user.emailVerified) {
  return 'Please verify your email';
}
```

### 2. Real-time Swap Updates
```dart
// Listen to swap offers
swapProvider.listenToMyOffers(userId);

// Firestore automatically updates UI when data changes
```

### 3. Chat System
```dart
// Messages stored in Firestore with real-time sync
await chatProvider.sendMessage(chatId, userId, text);
```

## Running Dart Analyzer

```bash
flutter analyze
```

## Testing

```bash
flutter test
```

## Build for Release

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

## Troubleshooting

### Common Issues

1. **Firebase not initialized**
   - Ensure `flutterfire configure` was run
   - Check `firebase_options.dart` exists

2. **Email verification not working**
   - Check Firebase Authentication settings
   - Verify email templates are configured

3. **Firestore permission denied**
   - Update security rules in Firebase Console
   - Ensure user is authenticated

## Design Trade-offs

1. **Provider vs Bloc**: Chose Provider for simplicity and less boilerplate
2. **Real-time vs Polling**: Used Firestore listeners for instant updates
3. **Image Storage**: Firebase Storage for scalability
4. **Chat Structure**: Separate collection per chat for better performance

## Contributors

[Your Name]

## License

MIT License
