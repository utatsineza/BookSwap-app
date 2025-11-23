import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _bioController;
  
  bool _isEditing = false;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: 'Student Name'); // TODO: Get from database
    _phoneController = TextEditingController(text: '');
    _bioController = TextEditingController(text: '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    if (mounted) {
      setState(() => _loading = true);
    }

    // TODO: Save to Firestore/Supabase
    await Future.delayed(const Duration(seconds: 1)); // Simulate save

    if (mounted) {
      setState(() {
        _loading = false;
        _isEditing = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1a1a3e),
        foregroundColor: Colors.white,
        title: const Text('My Profile'),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                setState(() => _isEditing = true);
              },
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFf4c542)))
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Profile Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: const BoxDecoration(
                      color: Color(0xFF1a1a3e),
                    ),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundColor: const Color(0xFFf4c542),
                              child: Text(
                                auth.email?.substring(0, 1).toUpperCase() ?? 'U',
                                style: const TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1a1a3e),
                                ),
                              ),
                            ),
                            if (_isEditing)
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFf4c542),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    size: 20,
                                    color: Color(0xFF1a1a3e),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          auth.email ?? 'Unknown',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: auth.isVerified ? Colors.green : Colors.orange,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                auth.isVerified ? Icons.verified : Icons.warning,
                                size: 16,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                auth.isVerified ? 'Verified' : 'Not Verified',
                                style: const TextStyle(color: Colors.white, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Profile Form
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Personal Information',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1a1a3e),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Name Field
                          TextFormField(
                            controller: _nameController,
                            enabled: _isEditing,
                            decoration: InputDecoration(
                              labelText: 'Full Name',
                              prefixIcon: const Icon(Icons.person, color: Color(0xFF1a1a3e)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: !_isEditing,
                              fillColor: _isEditing ? null : Colors.grey[100],
                            ),
                            validator: (val) => val?.trim().isEmpty ?? true ? 'Name is required' : null,
                          ),
                          const SizedBox(height: 16),

                          // Phone Field
                          TextFormField(
                            controller: _phoneController,
                            enabled: _isEditing,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              labelText: 'Phone Number',
                              prefixIcon: const Icon(Icons.phone, color: Color(0xFF1a1a3e)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: !_isEditing,
                              fillColor: _isEditing ? null : Colors.grey[100],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Bio Field
                          TextFormField(
                            controller: _bioController,
                            enabled: _isEditing,
                            maxLines: 4,
                            decoration: InputDecoration(
                              labelText: 'Bio',
                              prefixIcon: const Icon(Icons.edit_note, color: Color(0xFF1a1a3e)),
                              hintText: 'Tell us about yourself...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: !_isEditing,
                              fillColor: _isEditing ? null : Colors.grey[100],
                            ),
                            maxLength: 200,
                          ),

                          if (_isEditing) ...[
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () {
                                      setState(() => _isEditing = false);
                                      // Reset values
                                      _nameController.text = 'Student Name';
                                      _phoneController.text = '';
                                      _bioController.text = '';
                                    },
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      side: const BorderSide(color: Colors.grey),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: _saveProfile,
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      backgroundColor: const Color(0xFFf4c542),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text(
                                      'Save Changes',
                                      style: TextStyle(
                                        color: Color(0xFF1a1a3e),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],

                          const SizedBox(height: 32),

                          // Account Stats
                          const Text(
                            'Account Statistics',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1a1a3e),
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          Row(
                            children: [
                              Expanded(
                                child: _buildStatCard(
                                  icon: Icons.menu_book,
                                  label: 'Books Listed',
                                  value: '5', // TODO: Get from database
                                  color: Colors.blue,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildStatCard(
                                  icon: Icons.swap_horiz,
                                  label: 'Swaps Made',
                                  value: '3', // TODO: Get from database
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 32, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}