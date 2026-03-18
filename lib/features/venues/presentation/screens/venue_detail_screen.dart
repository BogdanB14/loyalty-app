import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/network/api_client.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../../data/datasources/venue_remote_datasource.dart';
import '../../data/models/venue_model.dart';
import '../../../rewards/data/models/reward_model.dart';

class VenueDetailScreen extends ConsumerStatefulWidget {
  final String venueId;
  const VenueDetailScreen({super.key, required this.venueId});

  @override
  ConsumerState<VenueDetailScreen> createState() => _VenueDetailScreenState();
}

class _VenueDetailScreenState extends ConsumerState<VenueDetailScreen> {
  bool _isLoading = true;
  String? _error;
  VenueModel? _venue;
  List<RewardModel> _rewards = [];
  int _pointBalance = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final ds = VenueRemoteDataSourceImpl(ref.read(dioProvider));
      final data = await ds.getVenueWithRewards(widget.venueId);

      // Venue fields — flat object at root
      final venue = VenueModel.fromJson(data);

      // Rewards — direct List at root
      final rawRewards = data['rewards'];
      final rewardList = rawRewards is List ? rawRewards : <dynamic>[];
      final rewards = rewardList.map((e) {
        final r = Map<String, dynamic>.from(e as Map);
        r['venueId'] = widget.venueId;
        return RewardModel.fromJson(r);
      }).toList();

      final pointBalance = (data['pointBalance'] as int?) ?? 0;

      setState(() {
        _venue = venue;
        _rewards = rewards;
        _pointBalance = pointBalance;
        _isLoading = false;
      });
    } catch (e, stackTrace) {
      print('VENUE DETAIL ERROR: $e');
      print('VENUE DETAIL STACK: $stackTrace');
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: LoadingWidget(),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Venue Details')),
        body: AppErrorWidget(
          message: 'Failed to load venue',
          onRetry: _load,
        ),
      );
    }

    final venue = _venue!;

    return Scaffold(
      appBar: AppBar(title: Text(venue.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(PhosphorIconsRegular.forkKnife,
                    size: 72, color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 20),
            Text(venue.name, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(PhosphorIconsRegular.mapPin,
                    size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    [venue.address, venue.city]
                        .where((s) => s.isNotEmpty)
                        .join(', '),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
            if (venue.type.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(venue.type,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: AppColors.textSecondary)),
            ],
            const SizedBox(height: 16),
            _PointsBalanceCard(pointBalance: _pointBalance),
            const SizedBox(height: 20),
            Text('Rewards', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            if (_rewards.isEmpty)
              Text('No rewards available',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: AppColors.textSecondary))
            else
              for (final reward in _rewards) _RewardCard(reward: reward),
          ],
        ),
      ),
    );
  }
}

class _PointsBalanceCard extends StatelessWidget {
  final int pointBalance;
  const _PointsBalanceCard({required this.pointBalance});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.accentGold),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(PhosphorIconsRegular.star,
                  color: AppColors.accentGold, size: 20),
              const SizedBox(width: 8),
              Text('Your points here',
                  style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
          Text(
            '$pointBalance pts',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.accentGold,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}

class _RewardCard extends StatelessWidget {
  final RewardModel reward;
  const _RewardCard({required this.reward});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(reward.title,
                      style: Theme.of(context).textTheme.titleMedium),
                ),
                Text(
                  '${reward.pointsCost} pts',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.accentGold,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(reward.description,
                style: Theme.of(context).textTheme.bodySmall),
            if (reward.quantity != null) ...[
              const SizedBox(height: 4),
              Text('Stock: ${reward.quantity}',
                  style: Theme.of(context).textTheme.bodySmall),
            ],
            if (reward.expiresAt != null) ...[
              const SizedBox(height: 4),
              Text(
                'Valid until: ${_formatDate(reward.expiresAt!)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Coming soon')),
                ),
                child: const Text('Claim'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')}.${dt.year}';
}
