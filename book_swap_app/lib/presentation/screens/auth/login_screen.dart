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
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: _emailCtrl, decoration: const InputDecoration(labelText: 'Email')),
            TextField(controller: _passCtrl, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
            const SizedBox(height: 20),
            loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      setState(() => loading = true);
                      final ok = await auth.login(_emailCtrl.text, _passCtrl.text);
                      setState(() => loading = false);
                      if (!ok) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Login failed')));
                      }
                    },
                    child: const Text('Login'),
                  ),
            TextButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SignupScreen())),
                child: const Text('Signup'))
          ],
        ),
      ),
    );
  }
}
