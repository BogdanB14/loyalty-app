import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../providers/venue_provider.dart';
import '../widgets/venue_card.dart';

final _selectedCategoryProvider = StateProvider<String?>((ref) => null);

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onQueryChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      ref.read(venueProvider.notifier).searchVenues(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(venueProvider);
    final selectedCategory = ref.watch(_selectedCategoryProvider);

    final venues = selectedCategory == null
        ? state.venues
        : state.venues
            .where((v) => v.type.toLowerCase() == selectedCategory)
            .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              controller: _controller,
              onChanged: _onQueryChanged,
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
                      onTap: () =>
                          ref.read(_selectedCategoryProvider.notifier).state =
                              cat,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(child: _buildResults(state, venues)),
        ],
      ),
    );
  }

  Widget _buildResults(VenueState state, List venues) {
    if (state.isLoading) return const LoadingWidget();

    if (state.error != null) {
      return AppErrorWidget(
        message: 'Failed to load venues',
        onRetry: () =>
            ref.read(venueProvider.notifier).searchVenues(_controller.text),
      );
    }

    if (venues.isEmpty) {
      return Center(
        child: Text('No venues found', style: AppTextStyles.bodyMedium),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: venues.length,
      itemBuilder: (context, i) {
        final v = venues[i];
        return VenueCard(
          name: v.name,
          category: v.type.toLowerCase(),
          onTap: () => context.push('/venue/${v.id}'),
        );
      },
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
