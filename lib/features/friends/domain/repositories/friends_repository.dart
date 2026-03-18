import '../entities/friend_entity.dart';

abstract class FriendsRepository {
  Future<List<FriendEntity>> getAcceptedFriends();
  Future<List<FriendEntity>> getIncomingRequests();
  Future<List<FriendEntity>> getOutgoingRequests();
  Future<FriendEntity> sendFriendRequest(String targetCustomerId);
  Future<FriendEntity> acceptRequest(String friendshipId);
  Future<FriendEntity> declineRequest(String friendshipId);
  Future<FriendEntity> cancelRequest(String friendshipId);
  Future<List<FriendEntity>> searchCustomers(String query);
}
