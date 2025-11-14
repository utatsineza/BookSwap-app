import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/listings_provider.dart';
import 'presentation/screens/browse_screen.dart';
import 'presentation/screens/my_listings_screen.dart';
import 'presentation/screens/settings_screen.dart';
import 'presentation/screens/auth/login_screen.dart';
import 'presentation/screens/auth/signup_screen.dart';

// Toggle this to true when enabling Firebase
const bool useFirebase = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // if (useFirebase) {
  //   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // }
  runApp(const BookSwapApp());
}


class BookSwapApp extends StatelessWidget {
  const BookSwapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (ctx) => ListingsProvider(useFirebase: useFirebase, auth: ctx.read<AuthProvider>())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'BookSwap',
        theme: ThemeData(primarySwatch: Colors.deepPurple, useMaterial3: true),
        home: const MainNavigation(),
      ),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});
  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selected = 0;
  static const _screens = [
    BrowseScreen(),
    MyListingsScreen(),
    ChatsPlaceholder(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selected],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selected,
        onTap: (i) => setState(() => _selected = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Browse'),
          BottomNavigationBarItem(icon: Icon(Icons.library_books), label: 'My Listings'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chats'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}

class ChatsPlaceholder extends StatelessWidget {
  const ChatsPlaceholder({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text('Chats - (optional)'));
}
