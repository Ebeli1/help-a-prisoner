import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../campaigns/models/campaign.dart';
import '../../campaigns/widgets/campaign_card.dart';
import '../../campaigns/screens/campaign_details_screen.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  String _selectedStatus = 'All';
  List<Campaign> _filteredCampaigns = [];

  // Sample categories
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

  // Sample campaigns (in real app, this would come from an API)
  final List<Campaign> _allCampaigns = Campaign.getSampleCampaigns();

  @override
  void initState() {
    super.initState();
    _filteredCampaigns = _allCampaigns;
  }

  void _applyFilters() {
    setState(() {
      _filteredCampaigns = _allCampaigns.where((campaign) {
        // Category filter
        if (_selectedCategory != 'All' &&
            campaign.category != _selectedCategory) {
          return false;
        }

        // Status filter
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

        // Search filter
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Explore',
          style: TextStyle(
            fontFamily: 'Georgia',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0D1B2A),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (_) => _applyFilters(),
                decoration: InputDecoration(
                  hintText: 'Search campaigns, projects...',
                  hintStyle: TextStyle(
                    color: Colors.grey[500],
                    fontFamily: 'Georgia',
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey[500],
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear, color: Colors.grey[500]),
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
      ),
      body: Column(
        children: [
          // Filters
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category filter
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ..._categories.map((category) {
                        final isSelected = _selectedCategory == category;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(
                              category,
                              style: TextStyle(
                                fontFamily: 'Georgia',
                                fontSize: 13,
                                color: isSelected
                                    ? Colors.white
                                    : const Color(0xFF0D1B2A),
                              ),
                            ),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                _selectedCategory = category;
                                _applyFilters();
                              });
                            },
                            backgroundColor: Colors.grey[200],
                            selectedColor: const Color(0xFFD4AF37),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                // Status filter
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ..._statuses.map((status) {
                        final isSelected = _selectedStatus == status;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(
                              status,
                              style: TextStyle(
                                fontFamily: 'Georgia',
                                fontSize: 13,
                                color: isSelected
                                    ? Colors.white
                                    : const Color(0xFF0D1B2A),
                              ),
                            ),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                _selectedStatus = status;
                                _applyFilters();
                              });
                            },
                            backgroundColor: Colors.grey[200],
                            selectedColor: const Color(0xFF0D1B2A),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Results count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_filteredCampaigns.length} campaigns found',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontFamily: 'Georgia',
                  ),
                ),
                if (_filteredCampaigns.length != _allCampaigns.length)
                  TextButton(
                    onPressed: () {
                      _searchController.clear();
                      _selectedCategory = 'All';
                      _selectedStatus = 'All';
                      _applyFilters();
                    },
                    child: const Text(
                      'Clear Filters',
                      style: TextStyle(
                        color: Color(0xFFD4AF37),
                        fontFamily: 'Georgia',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Results
          Expanded(
            child: _filteredCampaigns.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredCampaigns.length,
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

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 60,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            const Text(
              'No campaigns found',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Georgia',
                color: Color(0xFF0D1B2A),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your filters or search terms',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontFamily: 'Georgia',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                _searchController.clear();
                _selectedCategory = 'All';
                _selectedStatus = 'All';
                _applyFilters();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD4AF37),
                foregroundColor: const Color(0xFF0D1B2A),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Clear Filters',
                style: TextStyle(
                  fontSize: 16,
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
