import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/reward_entity.dart';
import '../../domain/entities/redemption_entity.dart';
import '../../data/datasources/rewards_remote_datasource.dart';
import '../../data/repositories/rewards_repository_impl.dart';
import '../../../../core/network/api_client.dart';

class RewardsState {
  final List<RewardEntity> rewards;
  final bool isLoading;
  final String? error;
  final RedemptionEntity? currentRedemption;
  final bool isRedeeming;
  final String? redeemError;

  const RewardsState({
    this.rewards = const [],
    this.isLoading = false,
    this.error,
    this.currentRedemption,
    this.isRedeeming = false,
    this.redeemError,
  });

  RewardsState copyWith({
    List<RewardEntity>? rewards,
    bool? isLoading,
    String? error,
    RedemptionEntity? currentRedemption,
    bool? isRedeeming,
    String? redeemError,
  }) {
    return RewardsState(
      rewards: rewards ?? this.rewards,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentRedemption: currentRedemption ?? this.currentRedemption,
      isRedeeming: isRedeeming ?? this.isRedeeming,
      redeemError: redeemError,
    );
  }
}

class RewardsNotifier extends StateNotifier<RewardsState> {
  final Ref _ref;
  RewardsNotifier(this._ref) : super(const RewardsState());

  RewardsRepositoryImpl _repo() => RewardsRepositoryImpl(
        RewardsRemoteDataSourceImpl(_ref.read(dioProvider)),
      );

  Future<void> loadRewardsForVenue(String venueId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final rewards = await _repo().getRewardsForVenue(venueId);
      state = state.copyWith(rewards: rewards, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> redeemReward(String venueId, String rewardId) async {
    state = state.copyWith(isRedeeming: true, redeemError: null);
    try {
      final redemption = await _repo().createRedemption(venueId, rewardId);
      state = state.copyWith(
          currentRedemption: redemption, isRedeeming: false);
    } catch (e) {
      state = state.copyWith(isRedeeming: false, redeemError: e.toString());
    }
  }
}

final rewardsProvider =
    StateNotifierProvider<RewardsNotifier, RewardsState>(
  (ref) => RewardsNotifier(ref),
);
