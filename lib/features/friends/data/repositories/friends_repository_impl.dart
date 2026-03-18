import '../../domain/entities/friend_entity.dart';
import '../../domain/repositories/friends_repository.dart';
import '../datasources/friends_remote_datasource.dart';

class FriendsRepositoryImpl implements FriendsRepository {
  final FriendsRemoteDataSource remoteDataSource;
  FriendsRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<FriendEntity>> getAcceptedFriends() =>
      remoteDataSource.getAcceptedFriends();

  @override
  Future<List<FriendEntity>> getIncomingRequests() =>
      remoteDataSource.getIncomingRequests();

  @override
  Future<List<FriendEntity>> getOutgoingRequests() =>
      remoteDataSource.getOutgoingRequests();

  @override
  Future<FriendEntity> sendFriendRequest(String targetCustomerId) =>
      remoteDataSource.sendFriendRequest(targetCustomerId);

  @override
  Future<FriendEntity> acceptRequest(String friendshipId) =>
      remoteDataSource.acceptRequest(friendshipId);

  @override
  Future<FriendEntity> declineRequest(String friendshipId) =>
      remoteDataSource.declineRequest(friendshipId);

  @override
  Future<FriendEntity> cancelRequest(String friendshipId) =>
      remoteDataSource.cancelRequest(friendshipId);

  @override
  Future<List<FriendEntity>> searchCustomers(String query) =>
      remoteDataSource.searchCustomers(query);
}
