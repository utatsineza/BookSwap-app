import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1a1a3e),
        foregroundColor: Colors.white,
        title: const Text('Privacy Policy'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'BookSwap Privacy Policy',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1a1a3e),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Last updated: November 2024',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),

            _buildSection(
              title: '1. Information We Collect',
              content:
                  'We collect information you provide directly to us, including:\n\n'
                  '• Email address and password for authentication\n'
                  '• Book listings you create (title, author, condition, images)\n'
                  '• Messages and swap offers you send\n'
                  '• Profile information you choose to share',
            ),

            _buildSection(
              title: '2. How We Use Your Information',
              content:
                  'We use the information we collect to:\n\n'
                  '• Provide, maintain, and improve our services\n'
                  '• Send you technical notices and support messages\n'
                  '• Respond to your comments and questions\n'
                  '• Facilitate book swaps between users\n'
                  '• Protect against fraud and abuse',
            ),

            _buildSection(
              title: '3. Information Sharing',
              content:
                  'We do not sell your personal information. We may share your information:\n\n'
                  '• With other users when you list books or send swap offers\n'
                  '• With service providers who help us operate our platform\n'
                  '• When required by law or to protect our rights',
            ),

            _buildSection(
              title: '4. Data Security',
              content:
                  'We take reasonable measures to protect your information from unauthorized access, use, or disclosure. However, no internet transmission is ever fully secure or error-free.',
            ),

            _buildSection(
              title: '5. Your Rights',
              content:
                  'You have the right to:\n\n'
                  '• Access and update your personal information\n'
                  '• Delete your account and associated data\n'
                  '• Opt out of promotional communications\n'
                  '• Request a copy of your data',
            ),

            _buildSection(
              title: '6. Children\'s Privacy',
              content:
                  'BookSwap is intended for users aged 13 and above. We do not knowingly collect information from children under 13.',
            ),

            _buildSection(
              title: '7. Changes to This Policy',
              content:
                  'We may update this privacy policy from time to time. We will notify you of any changes by posting the new policy on this page.',
            ),

            _buildSection(
              title: '8. Contact Us',
              content:
                  'If you have questions about this privacy policy, please contact us at:\n\n'
                  'Email: privacy@bookswap.com',
            ),

            const SizedBox(height: 32),

            // Accept Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Privacy policy acknowledged'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFf4c542),
                  foregroundColor: const Color(0xFF1a1a3e),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
),
),
child: const Text(
'I Understand',
style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
),
),
),
],
),
),
);
}
Widget _buildSection({required String title, required String content}) {
return Padding(
padding: const EdgeInsets.only(bottom: 24),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
title,
style: const TextStyle(
fontSize: 18,
fontWeight: FontWeight.bold,
color: Color(0xFF1a1a3e),
),
),
const SizedBox(height: 12),
Text(
content,
style: const TextStyle(
fontSize: 15,
color: Colors.black87,
height: 1.6,
),
),
],
),
);
}
}