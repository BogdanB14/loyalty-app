import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../providers/points_provider.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pointsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Progress')),
      body: RefreshIndicator(
        color: AppColors.accentGold,
        onRefresh: () => ref.read(pointsProvider.notifier).loadPoints(),
        child: _buildBody(context, ref, state),
      ),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, PointsState state) {
    if (state.isLoading) {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _shimmerHeader(),
          const SizedBox(height: 16),
          for (var i = 0; i < 3; i++) _shimmerCard(),
        ],
      );
    }

    if (state.error != null) {
      return AppErrorWidget(
        message: 'Failed to load points',
        onRetry: () => ref.read(pointsProvider.notifier).loadPoints(),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _TotalPointsCard(totalPoints: state.totalPoints),
        const SizedBox(height: 24),
        Text('Venue Progress',
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        for (final card in state.cards)
          _VenuePointsCard(
            venueName: card.venueName,
            balance: card.balance,
          ),
      ],
    );
  }

  Widget _shimmerHeader() {
    return Shimmer.fromColors(
      baseColor: AppColors.backgroundSecondary,
      highlightColor: AppColors.backgroundTertiary,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: AppColors.backgroundSecondary,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Widget _shimmerCard() {
    return Shimmer.fromColors(
      baseColor: AppColors.backgroundSecondary,
      highlightColor: AppColors.backgroundTertiary,
      child: Container(
        height: 90,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.backgroundSecondary,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}

class _TotalPointsCard extends StatelessWidget {
  final int totalPoints;
  const _TotalPointsCard({required this.totalPoints});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        border: Border.all(color: AppColors.accentGold, width: 1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            'Total Points',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          Text(
            '$totalPoints',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: AppColors.accentGold,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}

class _VenuePointsCard extends StatelessWidget {
  final String venueName;
  final int balance;
  const _VenuePointsCard({required this.venueName, required this.balance});

  @override
  Widget build(BuildContext context) {
    const tierThreshold = 500;
    final progress = (balance / tierThreshold).clamp(0.0, 1.0);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  venueName,
                  style: Theme.of(context).textTheme.titleMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '$balance pts',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.accentGold,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: AppColors.backgroundTertiary,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.accentGold,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '$balance / $tierThreshold pts to next tier',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
