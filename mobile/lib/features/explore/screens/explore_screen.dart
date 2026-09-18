import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../campaigns/models/campaign.dart';
import '../../campaigns/widgets/campaign_card.dart';
import '../../campaigns/screens/campaign_details_screen.dart';

class _Palette {
  static const navy = Color(0xFF0D1B2A);
  static const gold = Color(0xFFD4AF37);
  static const bg = Color(0xFFF7F8FA);
  static const surface = Color(0xFFFDFBF6);
}

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _selectedCategory = 'All';
  String _selectedStatus = 'All';
  List<Campaign> _filteredCampaigns = [];
  bool _hasQuery = false;

  final List<String> _categories = [
    'All',
    'Welfare',
    'Education',
    'Training',
    'Infrastructure',
    'Medical',
    'Rehabilitation',
  ];

  final List<String> _statuses = [
    'All',
    'Active',
    'Funded',
    'Completed',
  ];

  final List<Campaign> _allCampaigns = Campaign.getSampleCampaigns();

  @override
  void initState() {
    super.initState();
    _filteredCampaigns = _allCampaigns;
    _searchController.addListener(() {
      final hasQuery = _searchController.text.isNotEmpty;
      if (hasQuery != _hasQuery) setState(() => _hasQuery = hasQuery);
    });
    _searchFocusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  bool get _hasActiveFilters =>
      _selectedCategory != 'All' ||
      _selectedStatus != 'All' ||
      _searchController.text.isNotEmpty;

  void _applyFilters() {
    setState(() {
      _filteredCampaigns = _allCampaigns.where((campaign) {
        if (_selectedCategory != 'All' &&
            campaign.category != _selectedCategory) {
          return false;
        }

        if (_selectedStatus != 'All') {
          final statusMap = {
            'Active': 'active',
            'Funded': 'funded',
            'Completed': 'completed',
          };
          if (campaign.status != statusMap[_selectedStatus]) {
            return false;
          }
        }

        if (_searchController.text.isNotEmpty) {
          final query = _searchController.text.toLowerCase();
          return campaign.title.toLowerCase().contains(query) ||
              campaign.organizationName.toLowerCase().contains(query) ||
              campaign.description.toLowerCase().contains(query);
        }

        return true;
      }).toList();
    });
  }

  void _clearAllFilters() {
    _searchController.clear();
    setState(() {
      _selectedCategory = 'All';
      _selectedStatus = 'All';
    });
    _applyFilters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _Palette.bg,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildFilterSection(),
          _buildResultsHeader(),
          const SizedBox(height: 4),
          Expanded(
            child: _filteredCampaigns.isEmpty
                ? _buildEmptyState()
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    itemCount: _filteredCampaigns.length,
                    separatorBuilder: (context, _) =>
                        const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      final campaign = _filteredCampaigns[index];
                      return CampaignCard(
                        campaign: campaign,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CampaignDetailsScreen(
                                campaign: campaign,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------
  // App bar with embedded search field
  // ---------------------------------------------------------------------
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        'Explore',
        style: TextStyle(
          fontFamily: 'Georgia',
          fontWeight: FontWeight.bold,
          color: _Palette.navy,
        ),
      ),
      centerTitle: false,
      backgroundColor: _Palette.surface,
      surfaceTintColor: Colors.transparent,
      foregroundColor: _Palette.navy,
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(72),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _searchFocusNode.hasFocus
                    ? _Palette.gold.withValues(alpha: 0.6)
                    : Colors.grey.withValues(alpha: 0.15),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              onChanged: (_) => _applyFilters(),
              style: const TextStyle(fontFamily: 'Georgia', fontSize: 14.5),
              decoration: InputDecoration(
                hintText: 'Search campaigns, projects...',
                hintStyle: TextStyle(
                  color: Colors.grey[500],
                  fontFamily: 'Georgia',
                  fontSize: 14.5,
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: _Palette.gold,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                suffixIcon: _hasQuery
                    ? IconButton(
                        icon: Icon(Icons.close_rounded,
                            color: Colors.grey[500], size: 20),
                        onPressed: () {
                          _searchController.clear();
                          _applyFilters();
                        },
                      )
                    : null,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------
  // Filter chips
  // ---------------------------------------------------------------------
  Widget _buildFilterSection() {
    return Container(
      color: _Palette.surface,
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildChipRow(
            options: _categories,
            selected: _selectedCategory,
            selectedColor: _Palette.gold,
            selectedTextColor: _Palette.navy,
            onSelected: (value) {
              setState(() => _selectedCategory = value);
              _applyFilters();
            },
          ),
          const SizedBox(height: 8),
          _buildChipRow(
            options: _statuses,
            selected: _selectedStatus,
            selectedColor: _Palette.navy,
            selectedTextColor: Colors.white,
            onSelected: (value) {
              setState(() => _selectedStatus = value);
              _applyFilters();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildChipRow({
    required List<String> options,
    required String selected,
    required Color selectedColor,
    required Color selectedTextColor,
    required ValueChanged<String> onSelected,
  }) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: options.length,
        separatorBuilder: (context, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final option = options[index];
          final isSelected = selected == option;
          return GestureDetector(
            onTap: () => onSelected(option),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected ? selectedColor : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? Colors.transparent
                      : Colors.grey.withValues(alpha: 0.2),
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: selectedColor.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : null,
              ),
              alignment: Alignment.center,
              child: Text(
                option,
                style: TextStyle(
                  fontFamily: 'Georgia',
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? selectedTextColor : _Palette.navy,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ---------------------------------------------------------------------
  // Results header
  // ---------------------------------------------------------------------
  Widget _buildResultsHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                '${_filteredCampaigns.length}',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: _Palette.navy,
                  fontFamily: 'Georgia',
                ),
              ),
              Text(
                ' campaigns found',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontFamily: 'Georgia',
                ),
              ),
            ],
          ),
          if (_hasActiveFilters)
            GestureDetector(
              onTap: _clearAllFilters,
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.filter_alt_off_rounded,
                      size: 15, color: _Palette.gold),
                  SizedBox(width: 4),
                  Text(
                    'Clear Filters',
                    style: TextStyle(
                      color: _Palette.gold,
                      fontFamily: 'Georgia',
                      fontWeight: FontWeight.w600,
                      fontSize: 13.5,
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
  // Empty state
  // ---------------------------------------------------------------------
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 96,
              width: 96,
              decoration: BoxDecoration(
                color: _Palette.navy.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search_off_rounded,
                size: 42,
                color: _Palette.navy,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'No campaigns found',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                fontFamily: 'Georgia',
                color: _Palette.navy,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your filters or search terms',
              style: TextStyle(
                fontSize: 14.5,
                color: Colors.grey[600],
                fontFamily: 'Georgia',
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _clearAllFilters,
              style: ElevatedButton.styleFrom(
                backgroundColor: _Palette.gold,
                foregroundColor: _Palette.navy,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 13,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Clear Filters',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Georgia',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
