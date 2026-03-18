import '../../domain/entities/reward_entity.dart';
import '../../domain/entities/redemption_entity.dart';
import '../../domain/repositories/rewards_repository.dart';
import '../datasources/rewards_remote_datasource.dart';

class RewardsRepositoryImpl implements RewardsRepository {
  final RewardsRemoteDataSource remoteDataSource;
  RewardsRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<RewardEntity>> getRewardsForVenue(String venueId) =>
      remoteDataSource.getRewardsForVenue(venueId);

  @override
  Future<RedemptionEntity> createRedemption(
          String venueId, String rewardId) =>
      remoteDataSource.createRedemption(venueId, rewardId);

  @override
  Future<RedemptionEntity?> pollRedemptionStatus(String redemptionId) =>
      remoteDataSource.pollRedemptionStatus(redemptionId);
}
