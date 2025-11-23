import 'package:book_swap_app/presentation/screens/auth/signup_screen.dart';
import 'package:book_swap_app/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthProvider>();
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1a1a3e), Color(0xFF0f0f1e)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.menu_book, size: 80, color: Color(0xFFf4c542)),
                const SizedBox(height: 40),
                const Text(
                  'BookSwap',
                  style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passCtrl,
                  obscureText: true,
                  autofillHints: const [AutofillHints.password],
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                loading
                    ? const CircularProgressIndicator(color: Color(0xFFf4c542))
                    : SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () async {
                            if(mounted){
                              setState(() => loading = true);
                            }
                            final error = await auth.login(_emailCtrl.text, _passCtrl.text);
                            if(mounted){
                              setState(() => loading = false);
                                if (error != null) {
                                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
                                }
                              }
                            },  
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFf4c542),
                            foregroundColor: const Color(0xFF1a1a3e),
                          ),
                          child: const Text('Login', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                        ),
                      ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SignupScreen())),
                  child: const Text('Don\'t have an account? Sign up', style: TextStyle(color: Color(0xFFf4c542))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
