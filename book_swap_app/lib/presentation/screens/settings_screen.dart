// lib/presentation/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, dynamic>(
      builder: (context, state) {
        String email = '';
        if (state is AuthAuthenticated) email = state.user.email ?? '';
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Profile', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text('Email: $email'),
              const SizedBox(height: 20),
              SwitchListTile(
                value: true,
                onChanged: (v) {/* local simulation */},
                title: const Text('Notifications (simulated)'),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => context.read<AuthBloc>().add(SignOutRequested()),
                icon: const Icon(Icons.logout),
                label: const Text('Log out'),
              ),
            ],
          ),
        );
      },
    );
  }
}
