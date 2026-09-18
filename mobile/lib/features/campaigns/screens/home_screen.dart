import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/campaign.dart';
import '../models/impact_stats.dart';
import '../widgets/campaign_card.dart';
import '../widgets/featured_campaign_card.dart';
import 'campaign_details_screen.dart';
import '../../explore/screens/explore_screen.dart';

/// Brand palette — unchanged from the original design.
class _Palette {
  static const navy = Color(0xFF0D1B2A);
  static const navyLight = Color(0xFF1B2A3A);
  static const gold = Color(0xFFD4AF37);
  static const bg = Color(0xFFF7F8FA);
}

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

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _Palette.bg,
      body: RefreshIndicator(
        color: _Palette.gold,
        onRefresh: () async {
          setState(() {}); // Hook up real refresh logic here.
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            _buildAppBar(context),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildWelcomeSection(),
                  const SizedBox(height: 28),
                  if (_featuredCampaign != null) ...[
                    const _SectionHeader(title: 'Featured Campaign'),
                    const SizedBox(height: 14),
                    FeaturedCampaignCard(
                      campaign: _featuredCampaign!,
                      onTap: () => _showCampaignDetails(_featuredCampaign!),
                    ),
                    const SizedBox(height: 28),
                  ],
                  _SectionHeader(
                    title: 'Active Campaigns',
                    action: TextButton.icon(
                      onPressed: () => _goToExplore(context),
                      style: TextButton.styleFrom(
                        foregroundColor: _Palette.gold,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                      ),
                      icon: const Text(
                        'See All',
                        style: TextStyle(
                          fontFamily: 'Georgia',
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      label: const Icon(Icons.arrow_forward_ios, size: 12),
                    ),
                  ),
                  const SizedBox(height: 14),
                  ..._otherCampaigns.map(
                    (campaign) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: CampaignCard(
                        campaign: campaign,
                        onTap: () => _showCampaignDetails(campaign),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildImpactSection(),
                  const SizedBox(height: 32),
                  _buildSupportersCard(),
                  const SizedBox(height: 32),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------
  // App Bar
  // ---------------------------------------------------------------------
  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      floating: true,
      snap: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      backgroundColor: const Color(0xFFFDFBF6), // warm off-white, not navy
      foregroundColor: _Palette.navy,
      titleSpacing: 16,
      title: Row(
        children: [
          // Gold-ringed emblem — a signet-style mark rather than a
          // solid navy/gold block, so it feels distinct from the
          // welcome banner underneath.
          Container(
            height: 40,
            width: 40,
            padding: const EdgeInsets.all(2.5),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [_Palette.gold, Color(0xFFE9CE7A)],
              ),
            ),
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFFDFBF6),
              ),
              child: const Icon(
                Icons.handshake_rounded,
                size: 19,
                color: _Palette.navy,
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'Help A Prisoner',
            style: TextStyle(
              fontFamily: 'Georgia',
              fontWeight: FontWeight.bold,
              fontSize: 18,
              letterSpacing: 0.2,
              color: _Palette.navy,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search_rounded, color: _Palette.navy),
          tooltip: 'Search',
          onPressed: () => _goToExplore(context),
        ),
        Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              icon: const Icon(
                Icons.notifications_none_rounded,
                color: _Palette.navy,
              ),
              tooltip: 'Notifications',
              onPressed: () {
                // Navigate to notifications
              },
            ),
            Positioned(
              right: 10,
              top: 10,
              child: Container(
                height: 8,
                width: 8,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: _Palette.gold,
                  border: Border.fromBorderSide(
                    BorderSide(color: Color(0xFFFDFBF6), width: 1.5),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 4),
      ],
      // A slim gold gradient hairline instead of a hard shadow line —
      // a quiet brand accent that separates the bar from the content
      // without boxing it in navy.
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(2),
        child: Container(
          height: 2,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                _Palette.gold.withValues(alpha: 0.0),
                _Palette.gold.withValues(alpha: 0.55),
                _Palette.gold.withValues(alpha: 0.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _goToExplore(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ExploreScreen()),
    );
  }

  // ---------------------------------------------------------------------
  // Welcome banner
  // ---------------------------------------------------------------------
  Widget _buildWelcomeSection() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_Palette.navy, _Palette.navyLight],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _Palette.navy.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -18,
            top: -18,
            child: Icon(
              Icons.favorite_rounded,
              size: 90,
              color: Colors.white.withValues(alpha: 0.06),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$_greeting 👋',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Georgia',
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Support rehabilitation, education and opportunity.',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white.withValues(alpha: 0.82),
                  fontFamily: 'Georgia',
                  height: 1.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------
  // Impact section
  // ---------------------------------------------------------------------
  Widget _buildImpactSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              _IconBadge(icon: Icons.insights_rounded),
              SizedBox(width: 10),
              Text(
                'Our Impact',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _Palette.navy,
                  fontFamily: 'Georgia',
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Two flexible rows instead of a fixed-aspect-ratio GridView:
          // each tile sizes to its own text, so larger system font
          // scales (accessibility) or longer numbers never overflow.
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _ImpactStat(
                  icon: Icons.groups_rounded,
                  value: _impactStats.peopleSupported.toString(),
                  label: 'People Supported',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ImpactStat(
                  icon: Icons.school_rounded,
                  value: _impactStats.peopleTrained.toString(),
                  label: 'People Trained',
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _ImpactStat(
                  icon: Icons.task_alt_rounded,
                  value: _impactStats.projectsCompleted.toString(),
                  label: 'Projects Completed',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ImpactStat(
                  icon: Icons.apartment_rounded,
                  value: _impactStats.facilitiesSupported.toString(),
                  label: 'Facilities Supported',
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _Palette.gold.withValues(alpha: 0.16),
                  _Palette.gold.withValues(alpha: 0.06),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _Palette.gold.withValues(alpha: 0.25),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Raised',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _Palette.navy,
                    fontFamily: 'Georgia',
                  ),
                ),
                Text(
                  '₦${(_impactStats.totalRaised / 1000000).toStringAsFixed(1)}M',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _Palette.gold,
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

  // ---------------------------------------------------------------------
  // Supporters / logos card (combines Golden Heart + Powered by)
  // ---------------------------------------------------------------------
  Widget _buildSupportersCard() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Text(
            'PROUDLY SUPPORTED BY',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.grey[500],
              fontFamily: 'Georgia',
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 18),
          Image.asset(
            'assets/logos/Golden_Heart_logo.jpg',
            height: 110,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Icon(
              Icons.image_not_supported_outlined,
              size: 64,
              color: Colors.grey[300],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: Divider(color: Colors.grey[200])),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'Powered by',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[500],
                    fontFamily: 'Georgia',
                  ),
                ),
              ),
              Expanded(child: Divider(color: Colors.grey[200])),
            ],
          ),
          const SizedBox(height: 16),
          Image.asset(
            'assets/logos/Dc_Prison_Min_logo.png',
            height: 60,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Icon(
              Icons.image_not_supported_outlined,
              size: 48,
              color: Colors.grey[300],
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 14,
          offset: const Offset(0, 4),
        ),
      ],
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

// ---------------------------------------------------------------------
// Reusable pieces
// ---------------------------------------------------------------------

class _SectionHeader extends StatelessWidget {
  final String title;
  final Widget? action;

  const _SectionHeader({required this.title, this.action});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: _Palette.navy,
            fontFamily: 'Georgia',
          ),
        ),
        if (action != null) action!,
      ],
    );
  }
}

class _IconBadge extends StatelessWidget {
  final IconData icon;

  const _IconBadge({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: _Palette.gold.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: _Palette.gold, size: 20),
    );
  }
}

class _ImpactStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _ImpactStat({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 42,
          width: 42,
          decoration: BoxDecoration(
            color: _Palette.navy.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: _Palette.navy, size: 20),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _Palette.navy,
                  fontFamily: 'Georgia',
                ),
              ),
              Text(
                label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11.5,
                  color: Colors.grey[600],
                  fontFamily: 'Georgia',
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
