# BookSwap App - Design Summary

## Database Schema (Firestore)

### Entity Relationship Diagram

```
┌─────────────┐         ┌─────────────┐         ┌─────────────┐
│    Users    │         │    Books    │         │    Swaps    │
├─────────────┤         ├─────────────┤         ├─────────────┤
│ userId (PK) │◄───────┤ ownerId (FK)│         │ swapId (PK) │
│ email       │         │ bookId (PK) │◄───────┤ bookId (FK) │
│ name        │         │ title       │         │ senderId(FK)│
│ createdAt   │         │ author      │         │ receiverId  │
└─────────────┘         │ condition   │         │ status      │
                        │ coverUrl    │         │ createdAt   │
                        │ status      │         └─────────────┘
                        │ createdAt   │
                        └─────────────┘
                               │
                               │
                        ┌──────▼──────┐
                        │    Chats    │
                        ├─────────────┤
                        │ chatId (PK) │
                        │  messages/  │
                        │  ├─messageId│
                        │  ├─senderId │
                        │  ├─text     │
                        │  └─timestamp│
                        └─────────────┘
```

### Collections Detail

#### 1. **users** Collection
```
users/{userId}
  - email: string
  - name: string
  - createdAt: timestamp
```
**Purpose**: Store user profile information
**Access**: Read by all authenticated users, write only by owner

#### 2. **books** Collection
```
books/{bookId}
  - title: string
  - author: string
  - condition: string (enum: "New", "Like New", "Good", "Used")
  - ownerId: string (reference to users)
  - coverUrl: string (optional, Firebase Storage URL)
  - status: string (enum: "available", "pending", "swapped")
  - createdAt: timestamp
```
**Purpose**: Store book listings
**Access**: Read by all, write only by owner
**Indexes**: ownerId (for querying user's books)

#### 3. **swaps** Collection
```
swaps/{swapId}
  - bookId: string (reference to books)
  - bookTitle: string (denormalized for quick access)
  - senderId: string (user initiating swap)
  - senderName: string (denormalized)
  - receiverId: string (book owner)
  - status: string (enum: "pending", "accepted", "rejected")
  - createdAt: timestamp
```
**Purpose**: Track swap offers between users
**Access**: Read by all authenticated, create by any, update only by receiver
**Indexes**: 
  - senderId (for "My Offers" sent)
  - receiverId (for "My Offers" received)

#### 4. **chats** Collection
```
chats/{chatId}/messages/{messageId}
  - senderId: string
  - text: string
  - timestamp: timestamp
```
**Purpose**: Store chat messages between users
**Access**: Read/write by authenticated users
**chatId Format**: `{userId1}_{userId2}` (sorted alphabetically)

## Swap State Modeling

### State Machine

```
┌──────────┐
│Available │
└────┬─────┘
     │ User clicks "Swap"
     ▼
┌──────────┐
│ Pending  │
└────┬─────┘
     │
     ├──► Accept ──► ┌──────────┐
     │               │ Accepted │ ──► Chat Enabled
     │               └──────────┘
     │
     └──► Reject ──► ┌──────────┐
                     │ Rejected │
                     └──────────┘
```

### Implementation Details

1. **Initiating Swap**:
   - User clicks "Swap" button on a book
   - Creates document in `swaps` collection with status="pending"
   - Updates book status to "pending"
   - Real-time listener notifies both users

2. **Accepting/Rejecting**:
   - Receiver sees offer in "Received Offers" tab
   - Can accept or reject
   - Updates swap status in Firestore
   - Updates book status accordingly
   - Real-time listeners update UI instantly

3. **Real-time Sync**:
```dart
// Firestore listener automatically updates UI
_db.collection('swaps')
   .where('senderId', isEqualTo: userId)
   .snapshots()
   .listen((snapshot) {
     // UI updates automatically
   });
```

## State Management Implementation

### Architecture: Provider Pattern

**Why Provider?**
- Simple and intuitive
- Less boilerplate than Bloc
- Built-in to Flutter ecosystem
- Perfect for this app's complexity level

### Provider Structure

```
MultiProvider
├── AuthProvider (Authentication state)
├── BookProvider (Book CRUD operations)
├── SwapProvider (Swap offers management)
├── ChatProvider (Real-time messaging)
└── ListingsProvider (Legacy support)
```

### Key Providers

#### 1. **AuthProvider**
```dart
class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth;
  User? _user;
  
  // Listens to auth state changes
  AuthProvider() {
    _auth.authStateChanges().listen((user) {
      _user = user;
      notifyListeners(); // Updates all listeners
    });
  }
}
```
**Responsibilities**:
- User signup with email verification
- Login with verification check
- Logout
- Auth state management

#### 2. **SwapProvider**
```dart
class SwapProvider extends ChangeNotifier {
  List<SwapOffer> _myOffers = [];
  List<SwapOffer> _receivedOffers = [];
  
  void listenToMyOffers(String userId) {
    _db.collection('swaps')
       .where('senderId', isEqualTo: userId)
       .snapshots()
       .listen((snapshot) {
         _myOffers = snapshot.docs.map(...).toList();
         notifyListeners(); // Real-time update
       });
  }
}
```
**Responsibilities**:
- Create swap offers
- Listen to real-time updates
- Update swap status
- Manage sent/received offers

#### 3. **ChatProvider**
```dart
class ChatProvider extends ChangeNotifier {
  void listenToMessages(String chatId) {
    _db.collection('chats')
       .doc(chatId)
       .collection('messages')
       .orderBy('timestamp', descending: true)
       .snapshots()
       .listen((snapshot) {
         _messages = snapshot.docs.map(...).toList();
         notifyListeners();
       });
  }
}
```
**Responsibilities**:
- Send messages
- Listen to real-time chat updates
- Generate unique chat IDs

### Data Flow

```
User Action
    ↓
UI Widget (calls provider method)
    ↓
Provider (updates Firestore)
    ↓
Firestore (stores data)
    ↓
Firestore Listener (detects change)
    ↓
Provider (calls notifyListeners())
    ↓
UI Widget (rebuilds with new data)
```

## Design Trade-offs & Challenges

### 1. **State Management Choice**

**Decision**: Provider over Bloc/Riverpod

**Pros**:
- Simpler learning curve
- Less boilerplate code
- Sufficient for app complexity
- Good community support

**Cons**:
- Less structured than Bloc
- Can become messy in very large apps
- No built-in event/state separation

**Rationale**: For this assignment's scope, Provider provides the best balance of simplicity and functionality.

### 2. **Real-time vs Polling**

**Decision**: Firestore real-time listeners

**Pros**:
- Instant UI updates
- No manual refresh needed
- Better user experience
- Efficient (only sends changes)

**Cons**:
- More complex to implement
- Potential for more reads (cost)
- Need to manage listener lifecycle

**Rationale**: Real-time updates are essential for swap offers and chat functionality.

### 3. **Data Denormalization**

**Decision**: Store bookTitle and senderName in swaps collection

**Pros**:
- Faster reads (no joins needed)
- Simpler queries
- Better performance

**Cons**:
- Data duplication
- Potential inconsistency if book/user updated
- More storage space

**Rationale**: Firestore is optimized for reads over writes. Denormalization improves query performance significantly.

### 4. **Chat ID Generation**

**Decision**: Deterministic chat IDs (`userId1_userId2`)

**Pros**:
- No need to store chat metadata
- Easy to find existing chats
- Prevents duplicate chats

**Cons**:
- Exposes user IDs in document path
- Limited to two-person chats

**Rationale**: Simple and effective for peer-to-peer messaging.

### 5. **Image Storage**

**Decision**: Firebase Storage with URL references

**Pros**:
- Scalable storage
- CDN delivery
- Easy integration

**Cons**:
- Additional setup required
- Storage costs
- Need to manage upload/delete

**Rationale**: Industry standard for mobile apps with media.

## Challenges Encountered

### 1. **Email Verification Flow**
**Challenge**: Ensuring users verify email before full access
**Solution**: Check `user.emailVerified` on login and block unverified users

### 2. **Real-time Listener Management**
**Challenge**: Memory leaks from unmanaged listeners
**Solution**: Properly dispose listeners in provider/widget lifecycle

### 3. **Swap State Consistency**
**Challenge**: Keeping book status in sync with swap status
**Solution**: Update both in same transaction when possible

### 4. **Chat Ordering**
**Challenge**: Displaying messages in correct order
**Solution**: Firestore query with `orderBy('timestamp', descending: true)`

### 5. **Provider Context Issues**
**Challenge**: Accessing providers before they're initialized
**Solution**: Use `context.read<>()` for actions, `context.watch<>()` for UI updates

## Performance Optimizations

1. **Indexed Queries**: Created indexes for ownerId, senderId, receiverId
2. **Pagination**: Can be added for large book lists
3. **Image Caching**: Network images cached automatically by Flutter
4. **Listener Scoping**: Only listen to relevant data per screen

## Security Considerations

1. **Firestore Rules**: Restrict write access to document owners
2. **Email Verification**: Required before full app access
3. **User Data**: Minimal PII stored, no passwords in Firestore
4. **Chat Privacy**: Only participants can read messages

## Future Enhancements

1. **Search & Filters**: Add book search and condition filters
2. **Notifications**: Push notifications for swap updates
3. **Ratings**: User rating system after swaps
4. **Multiple Images**: Support multiple book photos
5. **Location**: Filter books by proximity
6. **Swap History**: Track completed swaps

---

**Total Development Time**: ~8-10 hours
**Lines of Code**: ~1500
**Firebase Collections**: 4
**Screens**: 8
**Providers**: 4
