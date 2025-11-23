import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import 'my_offers_screen.dart';
import 'profile_screen.dart';
import 'notifications_screen.dart';
import 'help_support_screen.dart';
import 'privacy_policy_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1a1a3e),
        foregroundColor: Colors.white,
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          // Profile Section
          Container(
            padding: const EdgeInsets.all(20),
            color: const Color(0xFF1a1a3e),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: const Color(0xFFf4c542),
                  child: Text(
                    auth.email?.substring(0, 1).toUpperCase() ?? 'U',
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1a1a3e),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  auth.email ?? 'Not logged in',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: auth.isVerified ? Colors.green : Colors.orange,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    auth.isVerified ? 'Verified' : 'Not Verified',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          
          // Account Section
          _buildSectionTitle('Account'),
          _buildSettingsTile(
            icon: Icons.person,
            title: 'Profile',
            subtitle: 'View and edit your profile',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
          ),
          _buildSettingsTile(
            icon: Icons.swap_horiz,
            title: 'Swap Offers',
            subtitle: 'View your swap offers',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MyOffersScreen()),
              );
            },
          ),
          
          const Divider(height: 32),
          
          // Preferences Section
          _buildSectionTitle('Preferences'),
          _buildSettingsTile(
            icon: Icons.notifications,
            title: 'Notifications',
            subtitle: 'Manage notification preferences',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationsScreen()),
              );
            },
          ),
          
          const Divider(height: 32),
          
          // Support Section
          _buildSectionTitle('Support & Information'),
          _buildSettingsTile(
            icon: Icons.help,
            title: 'Help & Support',
            subtitle: 'Get help and contact support',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HelpSupportScreen()),
              );
            },
          ),
          _buildSettingsTile(
            icon: Icons.info,
            title: 'About',
            subtitle: 'App version and information',
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1a1a3e),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.menu_book,
                          color: Color(0xFFf4c542),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text('About BookSwap'),
                    ],
                  ),
                  content: const SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'BookSwap',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Color(0xFF1a1a3e),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Version 1.0.0',
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'A mobile application for students to exchange textbooks with each other.',
                          style: TextStyle(height: 1.5),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Features:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text('📚 Browse book listings'),
                        Text('➕ Post your books'),
                        Text('🔄 Send swap offers'),
                        Text('💬 Real-time chat'),
                        Text('✅ Email verification'),
                        SizedBox(height: 20),
                        Text(
                          '© 2024 BookSwap. All rights reserved.',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
          ),
          _buildSettingsTile(
            icon: Icons.privacy_tip,
            title: 'Privacy Policy',
            subtitle: 'Read our privacy policy',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()),
              );
            },
          ),
          
          const Divider(height: 32),
          
          // Logout Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Logout'),
                      content: const Text('Are you sure you want to logout?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            auth.logout();
                          },
                          child: const Text(
                            'Logout',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.logout),
                label: const Text(
                  'Logout',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
  
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
  
  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF1a1a3e).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: const Color(0xFF1a1a3e)),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
}