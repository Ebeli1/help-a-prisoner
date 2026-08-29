import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/campaign.dart';
import '../models/impact_stats.dart';
import '../widgets/campaign_card.dart';
import '../widgets/featured_campaign_card.dart';
import 'campaign_details_screen.dart';
import '../../explore/screens/explore_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final List<Campaign> _campaigns = Campaign.getSampleCampaigns();
  final ImpactStats _impactStats = ImpactStats.getSample();

  Campaign? get _featuredCampaign {
    try {
      return _campaigns.firstWhere((c) => c.isFeatured);
    } catch (e) {
      return _campaigns.isNotEmpty ? _campaigns.first : null;
    }
  }

  List<Campaign> get _otherCampaigns {
    return _campaigns.where((c) => !c.isFeatured).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // App Bar with search and notifications
          SliverAppBar(
            floating: true,
            backgroundColor: const Color(0xFF0D1B2A),
            foregroundColor: Colors.white,
            title: Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFD4AF37),
                  ),
                  child: const Icon(
                    Icons.handshake,
                    size: 24,
                    color: Color(0xFF0D1B2A),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Help A Prisoner',
                  style: TextStyle(
                    fontFamily: 'Georgia',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ExploreScreen(),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {
                  // Navigate to notifications
                },
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Welcome Section
                _buildWelcomeSection(),
                const SizedBox(height: 24),

                // Featured Campaign
                if (_featuredCampaign != null) ...[
                  const Text(
                    'Featured Campaign',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0D1B2A),
                      fontFamily: 'Georgia',
                    ),
                  ),
                  const SizedBox(height: 12),
                  FeaturedCampaignCard(
                    campaign: _featuredCampaign!,
                    onTap: () => _showCampaignDetails(_featuredCampaign!),
                  ),
                  const SizedBox(height: 24),
                ],

                // Campaigns Section with "See All" button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Active Campaigns',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0D1B2A),
                        fontFamily: 'Georgia',
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ExploreScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'See All',
                        style: TextStyle(
                          color: Color(0xFFD4AF37),
                          fontFamily: 'Georgia',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Campaigns List
                ..._otherCampaigns.map((campaign) => CampaignCard(
                      campaign: campaign,
                      onTap: () => _showCampaignDetails(campaign),
                    )),

                const SizedBox(height: 24),

                // Impact Section
                _buildImpactSection(),
                const SizedBox(height: 40),

                // --- ADDED: Golden Heart Foundation Logo ---
                _buildGoldenHeartLogo(),
                const SizedBox(height: 20),

                // --- ADDED: Powered by Dominion City Prison Ministry ---
                _buildPoweredBySection(),
                const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  // --- NEW WIDGET: Golden Heart Foundation Logo ---
  Widget _buildGoldenHeartLogo() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Proudly Supported By',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
              fontFamily: 'Georgia',
            ),
          ),
          const SizedBox(height: 16),
          Image.asset(
            'assets/logos/Golden_Heart_logo.jpg',
            height: 120,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }

  // --- NEW WIDGET: Powered by Dominion City ---
  Widget _buildPoweredBySection() {
    return Column(
      children: [
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Powered by',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF4A5A6A),
                fontFamily: 'Georgia',
              ),
            ),
            const SizedBox(width: 12),
            Image.asset(
              'assets/logos/Dc_Prison_Min_logo.png',
              height: 70,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0D1B2A), Color(0xFF1B2A3A)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '👋 Welcome back!',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Georgia',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Support rehabilitation, education and opportunity.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withValues(alpha: 0.8),
              fontFamily: 'Georgia',
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImpactSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          const Row(
            children: [
              Icon(Icons.insights, color: Color(0xFFD4AF37), size: 24),
              SizedBox(width: 8),
              Text(
                'Our Impact',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0D1B2A),
                  fontFamily: 'Georgia',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildImpactStat(
                value: _impactStats.peopleSupported.toString(),
                label: 'People Supported',
              ),
              _buildImpactStat(
                value: _impactStats.peopleTrained.toString(),
                label: 'People Trained',
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildImpactStat(
                value: _impactStats.projectsCompleted.toString(),
                label: 'Projects Completed',
              ),
              _buildImpactStat(
                value: _impactStats.facilitiesSupported.toString(),
                label: 'Facilities Supported',
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFD4AF37).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Raised',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0D1B2A),
                    fontFamily: 'Georgia',
                  ),
                ),
                Text(
                  '₦${(_impactStats.totalRaised / 1000000).toStringAsFixed(1)}M',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFD4AF37),
                    fontFamily: 'Georgia',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImpactStat({
    required String value,
    required String label,
  }) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0D1B2A),
              fontFamily: 'Georgia',
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontFamily: 'Georgia',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showCampaignDetails(Campaign campaign) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CampaignDetailsScreen(campaign: campaign),
      ),
    );
  }
}
