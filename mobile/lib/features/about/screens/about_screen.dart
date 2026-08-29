import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'About',
          style: TextStyle(
            fontFamily: 'Georgia',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0D1B2A),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFFD4AF37),
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.handshake,
                size: 50,
                color: Color(0xFF0D1B2A),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Help A Prisoner',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: 'Georgia',
                color: Color(0xFF0D1B2A),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFD4AF37).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Version 1.0.0',
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'Georgia',
                  color: Color(0xFFD4AF37),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),

            // Mission Section
            _buildSection(
              icon: Icons.rocket_launch,
              title: 'Our Mission',
              content:
                  'To support rehabilitation, education, and opportunity for prisoners by connecting verified programmes with donors and volunteers through transparent fundraising and impact reporting.',
            ),
            const SizedBox(height: 20),

            // Vision Section
            _buildSection(
              icon: Icons.visibility,
              title: 'Our Vision',
              content:
                  'A world where every person, regardless of their past, has the opportunity to rebuild their life with dignity, purpose, and hope.',
            ),
            const SizedBox(height: 20),

            // Core Values
            _buildSection(
              icon: Icons.star,
              title: 'Core Values',
              content: '',
              children: [
                _buildValueItem('🤝 Transparency',
                    'Every donation is tracked and impact is reported.'),
                _buildValueItem('💚 Dignity',
                    'People are more than their mistakes. We treat everyone with respect.'),
                _buildValueItem('📚 Education',
                    'We believe in the power of knowledge and skills to transform lives.'),
                _buildValueItem('🔗 Collaboration',
                    'We work with trusted partners to maximize impact.'),
              ],
            ),
            const SizedBox(height: 20),

            // Partners Section
            _buildSection(
              icon: Icons.handshake,
              title: 'Our Partners',
              content: '',
              children: [
                _buildPartnerItem(
                  name: 'Dominion City Prisons Ministry',
                  role: 'Ministry & Field Operations',
                  logoAsset: 'assets/logos/Dc_Prison_Min_logo.png',
                ),
                _buildPartnerItem(
                  name: 'Discipleship Leadership Institution (DLI)',
                  role: 'Training & Discipleship',
                  logoAsset: null,
                ),
                _buildPartnerItem(
                  name: 'Golden Heart Foundation',
                  role: 'Charity & Funding',
                  logoAsset: 'assets/logos/Golden_Heart_logo.jpg',
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Impact Section
            _buildSection(
              icon: Icons.insights,
              title: 'Our Impact',
              content:
                  'Together, we\'re making a difference in the lives of prisoners and communities across Nigeria.',
              children: [
                _buildImpactStat('1,250+', 'People Supported'),
                _buildImpactStat('380', 'People Trained'),
                _buildImpactStat('12', 'Projects Completed'),
                _buildImpactStat('8', 'Facilities Supported'),
              ],
            ),
            const SizedBox(height: 20),

            // Links
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Material(
                color: Colors.transparent,
                child: Column(
                  children: [
                    _buildLinkItem(
                      icon: Icons.privacy_tip,
                      title: 'Privacy Policy',
                      onTap: () {
                        _launchURL('https://helpaprisoner.com/privacy-policy');
                      },
                    ),
                    const Divider(),
                    _buildLinkItem(
                      icon: Icons.description,
                      title: 'Terms of Service',
                      onTap: () {
                        _launchURL(
                            'https://helpaprisoner.com/terms-of-service');
                      },
                    ),
                    const Divider(),
                    _buildLinkItem(
                      icon: Icons.contact_support,
                      title: 'Contact Us',
                      onTap: () {
                        _launchURL('mailto:support@helpaprisoner.com');
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Copyright
            Center(
              child: Text(
                '© 2024 Help A Prisoner. All rights reserved.',
                style: TextStyle(
                  fontFamily: 'Georgia',
                  fontSize: 12,
                  color: Colors.grey[400],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    String content = '',
    List<Widget> children = const [],
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFFD4AF37), size: 24),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Georgia',
                  color: Color(0xFF0D1B2A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (content.isNotEmpty)
            Text(
              content,
              style: const TextStyle(
                fontSize: 15,
                fontFamily: 'Georgia',
                color: Color(0xFF4A5A6A),
                height: 1.6,
              ),
            ),
          if (children.isNotEmpty) ...children,
        ],
      ),
    );
  }

  Widget _buildValueItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Georgia',
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0D1B2A),
            ),
          ),
          Text(
            description,
            style: const TextStyle(
              fontFamily: 'Georgia',
              fontSize: 14,
              color: Color(0xFF4A5A6A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPartnerItem({
    required String name,
    required String role,
    String? logoAsset,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Logo
          if (logoAsset != null)
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(4),
              child: Image.asset(
                logoAsset,
                fit: BoxFit.contain,
              ),
            )
          else
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFD4AF37).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.business,
                color: Color(0xFFD4AF37),
                size: 28,
              ),
            ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontFamily: 'Georgia',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0D1B2A),
                  ),
                ),
                Text(
                  role,
                  style: const TextStyle(
                    fontFamily: 'Georgia',
                    fontSize: 12,
                    color: Color(0xFF4A5A6A),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImpactStat(String value, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Georgia',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFFD4AF37),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Georgia',
              fontSize: 14,
              color: Color(0xFF4A5A6A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFFD4AF37), size: 22),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Georgia',
          fontWeight: FontWeight.w600,
          color: Color(0xFF0D1B2A),
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Color(0xFF4A5A6A)),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }
}
