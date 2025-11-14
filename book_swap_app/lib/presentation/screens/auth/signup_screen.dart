// lib/presentation/screens/auth/signup_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/auth/auth_bloc.dart';
import '../../../blocs/auth/auth_event.dart';
import '../../../blocs/auth/auth_state.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);
  @override State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _emailCtl = TextEditingController();
  final _passCtl = TextEditingController();
  final _nameCtl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create account')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthEmailNotVerified) {
              showDialog(context: context, builder: (_) => AlertDialog(
                title: const Text('Verify your email'),
                content: Text('A verification link was sent to ${state.email}. Please verify then sign in.'),
                actions: [
                  TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('OK'))
                ],
              ));
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                TextField(controller: _nameCtl, decoration: const InputDecoration(labelText: 'Full name')),
                TextField(controller: _emailCtl, decoration: const InputDecoration(labelText: 'Email')),
                TextField(controller: _passCtl, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(SignUpRequested(_emailCtl.text.trim(), _passCtl.text, _nameCtl.text.trim()));
                  },
                  child: state is AuthLoading ? const CircularProgressIndicator() : const Text('Create account'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
