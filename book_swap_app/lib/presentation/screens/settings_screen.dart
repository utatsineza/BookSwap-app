import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Profile', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            Text('Email: ${auth.email ?? "Not logged in"}'),
            Text('Verified: ${auth.isVerified}'),
            const Divider(height: 40),
            ElevatedButton(onPressed: auth.isLoggedIn ? auth.logout : null, child: const Text('Logout')),
          ],
        ),
      ),
    );
  }
}
