import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/providers/auth_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _darkMode = false;
  bool _anonymousDonations = false;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            fontFamily: 'Georgia',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0D1B2A),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Account Section
          _buildSectionHeader('Account'),
          Card(
            child: ListTile(
              leading: const Icon(Icons.person, color: Color(0xFFD4AF37)),
              title: const Text(
                'Profile Information',
                style: TextStyle(
                  fontFamily: 'Georgia',
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                user?.email ?? 'Not signed in',
                style: const TextStyle(
                  fontFamily: 'Georgia',
                  color: Color(0xFF4A5A6A),
                ),
              ),
              trailing:
                  const Icon(Icons.chevron_right, color: Color(0xFF4A5A6A)),
              onTap: () {
                // Navigate to edit profile
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.lock, color: Color(0xFFD4AF37)),
              title: const Text(
                'Change Password',
                style: TextStyle(
                  fontFamily: 'Georgia',
                  fontWeight: FontWeight.w600,
                ),
              ),
              trailing:
                  const Icon(Icons.chevron_right, color: Color(0xFF4A5A6A)),
              onTap: () {
                // Navigate to change password
              },
            ),
          ),
          const SizedBox(height: 16),

          // Notifications Section
          _buildSectionHeader('Notifications'),
          Card(
            child: SwitchListTile(
              value: _pushNotifications,
              onChanged: (value) {
                setState(() {
                  _pushNotifications = value;
                });
              },
              title: const Text(
                'Push Notifications',
                style: TextStyle(
                  fontFamily: 'Georgia',
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: const Text(
                'Receive updates on campaigns and donations',
                style: TextStyle(
                  fontFamily: 'Georgia',
                  color: Color(0xFF4A5A6A),
                  fontSize: 13,
                ),
              ),
              activeThumbColor: const Color(0xFFD4AF37),
            ),
          ),
          Card(
            child: SwitchListTile(
              value: _emailNotifications,
              onChanged: (value) {
                setState(() {
                  _emailNotifications = value;
                });
              },
              title: const Text(
                'Email Notifications',
                style: TextStyle(
                  fontFamily: 'Georgia',
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: const Text(
                'Receive email updates and receipts',
                style: TextStyle(
                  fontFamily: 'Georgia',
                  color: Color(0xFF4A5A6A),
                  fontSize: 13,
                ),
              ),
              activeThumbColor: const Color(0xFFD4AF37),
            ),
          ),
          const SizedBox(height: 16),

          // Privacy Section
          _buildSectionHeader('Privacy'),
          Card(
            child: SwitchListTile(
              value: _anonymousDonations,
              onChanged: (value) {
                setState(() {
                  _anonymousDonations = value;
                });
              },
              title: const Text(
                'Anonymous Donations',
                style: TextStyle(
                  fontFamily: 'Georgia',
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: const Text(
                'Hide your name from public donation lists',
                style: TextStyle(
                  fontFamily: 'Georgia',
                  color: Color(0xFF4A5A6A),
                  fontSize: 13,
                ),
              ),
              activeThumbColor: const Color(0xFFD4AF37),
            ),
          ),
          Card(
            child: SwitchListTile(
              value: _darkMode,
              onChanged: (value) {
                setState(() {
                  _darkMode = value;
                });
              },
              title: const Text(
                'Dark Mode',
                style: TextStyle(
                  fontFamily: 'Georgia',
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: const Text(
                'Switch to dark theme',
                style: TextStyle(
                  fontFamily: 'Georgia',
                  color: Color(0xFF4A5A6A),
                  fontSize: 13,
                ),
              ),
              activeThumbColor: const Color(0xFFD4AF37),
            ),
          ),
          const SizedBox(height: 16),

          // Data Section
          _buildSectionHeader('Data'),
          Card(
            child: ListTile(
              leading: const Icon(Icons.download, color: Color(0xFFD4AF37)),
              title: const Text(
                'Export Data',
                style: TextStyle(
                  fontFamily: 'Georgia',
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: const Text(
                'Download your donation history and profile data',
                style: TextStyle(
                  fontFamily: 'Georgia',
                  color: Color(0xFF4A5A6A),
                  fontSize: 13,
                ),
              ),
              trailing:
                  const Icon(Icons.chevron_right, color: Color(0xFF4A5A6A)),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Data export feature coming soon'),
                    backgroundColor: Color(0xFF0D1B2A),
                  ),
                );
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text(
                'Delete Account',
                style: TextStyle(
                  fontFamily: 'Georgia',
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
              subtitle: const Text(
                'Permanently delete your account and data',
                style: TextStyle(
                  fontFamily: 'Georgia',
                  color: Color(0xFF4A5A6A),
                  fontSize: 13,
                ),
              ),
              trailing: const Icon(Icons.chevron_right, color: Colors.red),
              onTap: () {
                _showDeleteAccountDialog(context);
              },
            ),
          ),
          const SizedBox(height: 24),

          // Version
          Center(
            child: Text(
              'Version 1.0.0',
              style: TextStyle(
                fontFamily: 'Georgia',
                fontSize: 13,
                color: Colors.grey[400],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: 'Georgia',
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Delete Account',
          style: TextStyle(
            fontFamily: 'Georgia',
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'This action cannot be undone. All your data, donations, and history will be permanently removed.',
          style: TextStyle(
            fontFamily: 'Georgia',
            color: Color(0xFF4A5A6A),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontFamily: 'Georgia',
                color: Color(0xFF4A5A6A),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Account deletion is not yet implemented'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              'Delete',
              style: TextStyle(
                fontFamily: 'Georgia',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
