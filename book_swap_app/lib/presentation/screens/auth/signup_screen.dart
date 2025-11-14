import 'package:book_swap_app/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Signup')),
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
                      await auth.signup(_emailCtrl.text, _passCtrl.text);
                      await auth.verifyEmail(); // auto-verified in mock
                      setState(() => loading = false);
                      Navigator.of(context).pop();
                    },
                    child: const Text('Signup & Verify')),
          ],
        ),
      ),
    );
  }
}
