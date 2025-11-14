// lib/presentation/screens/auth/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/auth/auth_bloc.dart';
import '../../../blocs/auth/auth_event.dart';
import '../../../blocs/auth/auth_state.dart';
import 'signup_screen.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtl = TextEditingController();
  final _passCtl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign in')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
            }
            if (state is AuthAuthenticated) {
              Navigator.of(context).popUntil((r) => r.isFirst);
            }
            if (state is AuthEmailNotVerified) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email not verified — check your inbox.')));
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                TextField(controller: _emailCtl, decoration: const InputDecoration(labelText: 'Email')),
                TextField(controller: _passCtl, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(SignInRequested(_emailCtl.text.trim(), _passCtl.text));
                  },
                  child: state is AuthLoading ? const CircularProgressIndicator() : const Text('Sign in'),
                ),
                TextButton(onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SignupScreen()));
                }, child: const Text('Create account')),
              ],
            );
          },
        ),
      ),
    );
  }
}
