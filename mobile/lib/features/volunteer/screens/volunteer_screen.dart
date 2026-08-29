import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/volunteer_opportunity.dart';
import '../widgets/volunteer_opportunity_card.dart';
import 'volunteer_details_screen.dart';

class VolunteerScreen extends ConsumerStatefulWidget {
  const VolunteerScreen({super.key});

  @override
  ConsumerState<VolunteerScreen> createState() => _VolunteerScreenState();
}

class _VolunteerScreenState extends ConsumerState<VolunteerScreen> {
  final List<VolunteerOpportunity> _opportunities =
      VolunteerOpportunity.getSampleOpportunities();
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Teaching',
    'Mentoring',
    'Vocational Training',
    'Administration',
    'Other',
  ];

  List<VolunteerOpportunity> get _filteredOpportunities {
    if (_selectedCategory == 'All') return _opportunities;
    return _opportunities
        .where((o) => o.category == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Volunteer',
          style: TextStyle(
            fontFamily: 'Georgia',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0D1B2A),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Hero Section - FIXED
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0D1B2A), Color(0xFF1B2A3A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(24),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Make a Difference with Your Skills',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Georgia',
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Volunteer your time and expertise to support rehabilitation programmes.',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white70,
                    fontFamily: 'Georgia',
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                // Skill chips - FIXED with SingleChildScrollView
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildStatChip('Teaching', Icons.school),
                      const SizedBox(width: 8),
                      _buildStatChip('Mentoring', Icons.people),
                      const SizedBox(width: 8),
                      _buildStatChip('Skills', Icons.build),
                      const SizedBox(width: 8),
                      _buildStatChip('Training', Icons.handyman),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Category Filter
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == category;
                return FilterChip(
                  label: Text(
                    category,
                    style: TextStyle(
                      fontFamily: 'Georgia',
                      fontSize: 13,
                      color:
                          isSelected ? Colors.white : const Color(0xFF0D1B2A),
                    ),
                  ),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                  backgroundColor: Colors.grey[200],
                  selectedColor: const Color(0xFFD4AF37),
                );
              },
            ),
          ),
          // Opportunities List
          Expanded(
            child: _filteredOpportunities.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredOpportunities.length,
                    itemBuilder: (context, index) {
                      final opportunity = _filteredOpportunities[index];
                      return VolunteerOpportunityCard(
                        opportunity: opportunity,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VolunteerDetailsScreen(
                                opportunity: opportunity,
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

  Widget _buildStatChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontFamily: 'Georgia',
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
              Icons.volunteer_activism,
              size: 60,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            const Text(
              'No opportunities found',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Georgia',
                color: Color(0xFF0D1B2A),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try selecting a different category or check back later.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontFamily: 'Georgia',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
