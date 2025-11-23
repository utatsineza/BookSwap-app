import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _swapOffers = true;
  bool _messages = true;
  bool _bookUpdates = false;
  bool _emailNotifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1a1a3e),
        foregroundColor: Colors.white,
        title: const Text('Notifications'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header
          const Text(
            'Manage your notification preferences',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 24),

          // Push Notifications Section
          _buildSectionTitle('Push Notifications'),
          _buildNotificationTile(
            icon: Icons.swap_horiz,
            title: 'Swap Offers',
            subtitle: 'Get notified when someone sends you a swap offer',
            value: _swapOffers,
            onChanged: (val) {
              setState(() => _swapOffers = val);
            },
          ),
          _buildNotificationTile(
            icon: Icons.message,
            title: 'Messages',
            subtitle: 'Get notified when you receive new messages',
            value: _messages,
            onChanged: (val) {
              setState(() => _messages = val);
            },
          ),
          _buildNotificationTile(
            icon: Icons.book,
            title: 'Book Updates',
            subtitle: 'Get notified when books you\'re interested in are updated',
            value: _bookUpdates,
            onChanged: (val) {
              setState(() => _bookUpdates = val);
            },
          ),

          const SizedBox(height: 24),

          // Email Notifications Section
          _buildSectionTitle('Email Notifications'),
          _buildNotificationTile(
            icon: Icons.email,
            title: 'Email Updates',
            subtitle: 'Receive important updates via email',
            value: _emailNotifications,
            onChanged: (val) {
              setState(() => _emailNotifications = val);
            },
          ),

          const SizedBox(height: 32),

          // Save Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                // TODO: Save preferences to database
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Notification preferences saved!'),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFf4c542),
                foregroundColor: const Color(0xFF1a1a3e),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Save Preferences',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
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

  Widget _buildNotificationTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SwitchListTile(
        secondary: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF1a1a3e).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFF1a1a3e)),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF1a1a3e),
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFFf4c542),
      ),
    );
  }
}