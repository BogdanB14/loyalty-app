import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../widgets/venue_card.dart';

const _allVenues = [
  {
    'name': 'Kafana Zlatni Bor',
    'promotion': 'Double points!',
    'distance': '0.3 km',
    'category': 'restaurant'
  },
  {
    'name': 'Caffe Bar Lav',
    'promotion': 'Happy hour',
    'distance': '0.7 km',
    'category': 'bar'
  },
  {
    'name': 'Restoran Šaran',
    'promotion': 'Free dessert',
    'distance': '1.1 km',
    'category': 'restaurant'
  },
  {
    'name': 'McBurger Beograd',
    'promotion': '',
    'distance': '1.4 km',
    'category': 'fastfood'
  },
  {
    'name': 'Kafeterija Roma',
    'promotion': 'Loyalty x2',
    'distance': '1.8 km',
    'category': 'cafe'
  },
  {
    'name': 'Pivnica Kod Dragana',
    'promotion': '',
    'distance': '2.2 km',
    'category': 'bar'
  },
];

final _searchQueryProvider = StateProvider<String>((ref) => '');
final _selectedCategoryProvider = StateProvider<String?>((ref) => null);

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(_searchQueryProvider);
    final selectedCategory = ref.watch(_selectedCategoryProvider);

    final filtered = _allVenues.where((v) {
      final matchesQuery = query.isEmpty ||
          v['name']!.toLowerCase().contains(query.toLowerCase());
      final matchesCategory =
          selectedCategory == null || v['category'] == selectedCategory;
      return matchesQuery && matchesCategory;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              onChanged: (v) =>
                  ref.read(_searchQueryProvider.notifier).state = v,
              decoration: InputDecoration(
                hintText: 'Search venues...',
                prefixIcon: Icon(PhosphorIconsRegular.magnifyingGlass),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _FilterChip(
                  label: 'All',
                  selected: selectedCategory == null,
                  onTap: () =>
                      ref.read(_selectedCategoryProvider.notifier).state = null,
                ),
                const SizedBox(width: 8),
                for (final cat in ['restaurant', 'cafe', 'bar', 'fastfood'])
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _FilterChip(
                      label: cat[0].toUpperCase() + cat.substring(1),
                      selected: selectedCategory == cat,
                      onTap: () => ref
                          .read(_selectedCategoryProvider.notifier)
                          .state = cat,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Text('No venues found',
                        style: AppTextStyles.bodyMedium))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filtered.length,
                    itemBuilder: (context, i) {
                      final venueIndex = _allVenues.indexOf(filtered[i]);
                      return VenueCard(
                        name: filtered[i]['name']!,
                        promotion: filtered[i]['promotion']!,
                        distance: filtered[i]['distance']!,
                        category: filtered[i]['category']!,
                        onTap: () => context.push('/venue/$venueIndex'),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.accentGold : AppColors.backgroundTertiary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            color: selected ? AppColors.onPrimary : AppColors.textSecondary,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
