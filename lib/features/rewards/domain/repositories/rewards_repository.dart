import '../entities/reward_entity.dart';
import '../entities/redemption_entity.dart';

abstract class RewardsRepository {
  Future<List<RewardEntity>> getRewardsForVenue(String venueId);
  Future<RedemptionEntity> createRedemption(String venueId, String rewardId);
  Future<RedemptionEntity?> pollRedemptionStatus(String redemptionId);
}
