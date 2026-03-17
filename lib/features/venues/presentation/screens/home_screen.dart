import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../providers/venue_provider.dart';
import '../widgets/venue_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(venueProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(PhosphorIconsRegular.seal,
                color: AppColors.primary, size: 22),
            const SizedBox(width: 8),
            const Text('LoyApp'),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(PhosphorIconsRegular.bell),
            onPressed: () {},
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nearby Venues',
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 2),
                  Text('Scan a receipt to earn loyalty points',
                      style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
          ),
          if (state.isLoading)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, _) => const _ShimmerCard(),
                  childCount: 3,
                ),
              ),
            )
          else if (state.error != null)
            SliverFillRemaining(
              child: AppErrorWidget(
                message: 'Failed to load venues',
                onRetry: () =>
                    ref.read(venueProvider.notifier).loadVenues(),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) {
                    final v = state.venues[i];
                    return VenueCard(
                      name: v.name,
                      promotion: '',
                      distance: '',
                      // TODO: update UI
                      category: v.type.toLowerCase(),
                      onTap: () => context.push('/venue/${v.id}'),
                    );
                  },
                  childCount: state.venues.length,
                ),
              ),
            ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 16)),
        ],
      ),
    );
  }
}

class _ShimmerCard extends StatelessWidget {
  const _ShimmerCard();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.backgroundSecondary,
      highlightColor: AppColors.backgroundTertiary,
      child: Container(
        height: 88,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.backgroundSecondary,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
