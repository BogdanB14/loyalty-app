Build the complete data layer for rewards and friends. No UI changes needed —
only the data/domain layers so we are ready to wire up when backend is available.

REWARDS:
1. lib/features/rewards/data/datasources/rewards_remote_datasource.dart
    - getRewardsForVenue(venueId) → GET /api/v1/customer/venues/{venueId}/rewards
      with pageable params (page=0, size=50). Parse response['rewards'] array.
    - createRedemption(venueId, rewardId) → POST /api/v1/customer/redemptions/venues/{venueId}/create
      Body: {rewardId, idempotencyKey: uuid_v4(), customerNote: null}
      Returns RedemptionRequestDto: {id, status, pointsCostSnapshot, expiresAt}
    - pollRedemptionStatus(redemptionId) → not a real endpoint yet; return the
      last known RedemptionRequestDto from local state for now.

2. lib/features/rewards/domain/repositories/rewards_repository.dart — abstract interface
3. lib/features/rewards/data/repositories/rewards_repository_impl.dart — implementation
4. lib/features/rewards/presentation/providers/rewards_provider.dart — StateNotifier
   with: loadRewardsForVenue(venueId), redeemReward(venueId, rewardId),
   currentRedemption getter, error state.

FRIENDS:
5. lib/features/friends/data/models/friend_model.dart
   Fields from FriendshipDto: id, otherCustomerId, otherUsername,
   otherDisplayName, status (PENDING/ACCEPTED/DECLINED/CANCELLED),
   requestedByMe, respondedAt. Add fromJson/toJson.

6. lib/features/friends/domain/entities/friend_entity.dart — same fields

7. lib/features/friends/data/datasources/friends_remote_datasource.dart
    - getAcceptedFriends() → GET /api/v1/customer/me/friends/accepted
    - getIncomingRequests() → GET /api/v1/customer/me/friends/requests/incoming
    - getOutgoingRequests() → GET /api/v1/customer/me/friends/requests/outgoing
    - sendFriendRequest(targetCustomerId) → POST /api/v1/customer/me/friends/requests
    - acceptRequest(friendshipId) → POST /api/v1/customer/me/friends/requests/{id}/accept
    - declineRequest(friendshipId) → POST /api/v1/customer/me/friends/requests/{id}/decline
    - cancelRequest(friendshipId) → POST /api/v1/customer/me/friends/requests/{id}/cancel
    - searchCustomers(query) → GET /api/v1/customer/me/friends/search?q={query}&page=0&size=20

8. lib/features/friends/domain/repositories/friends_repository.dart — abstract
9. lib/features/friends/data/repositories/friends_repository_impl.dart
10. lib/features/friends/presentation/providers/friends_provider.dart — StateNotifier
    with: loadFriends(), loadRequests(), sendRequest(id), acceptRequest(id),
    declineRequest(id), searchCustomers(query).

All datasources must handle errors using the existing exceptions.dart classes.