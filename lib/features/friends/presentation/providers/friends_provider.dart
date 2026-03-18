import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/friend_entity.dart';
import '../../data/datasources/friends_remote_datasource.dart';
import '../../data/repositories/friends_repository_impl.dart';
import '../../../../core/network/api_client.dart';

class FriendsState {
  final List<FriendEntity> accepted;
  final List<FriendEntity> incoming;
  final List<FriendEntity> outgoing;
  final List<FriendEntity> searchResults;
  final bool isLoading;
  final String? error;

  const FriendsState({
    this.accepted = const [],
    this.incoming = const [],
    this.outgoing = const [],
    this.searchResults = const [],
    this.isLoading = false,
    this.error,
  });

  FriendsState copyWith({
    List<FriendEntity>? accepted,
    List<FriendEntity>? incoming,
    List<FriendEntity>? outgoing,
    List<FriendEntity>? searchResults,
    bool? isLoading,
    String? error,
  }) {
    return FriendsState(
      accepted: accepted ?? this.accepted,
      incoming: incoming ?? this.incoming,
      outgoing: outgoing ?? this.outgoing,
      searchResults: searchResults ?? this.searchResults,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class FriendsNotifier extends StateNotifier<FriendsState> {
  final Ref _ref;
  FriendsNotifier(this._ref) : super(const FriendsState());

  FriendsRepositoryImpl _repo() => FriendsRepositoryImpl(
        FriendsRemoteDataSourceImpl(_ref.read(dioProvider)),
      );

  Future<void> loadFriends() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final accepted = await _repo().getAcceptedFriends();
      state = state.copyWith(accepted: accepted, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadRequests() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final repo = _repo();
      final incoming = await repo.getIncomingRequests();
      final outgoing = await repo.getOutgoingRequests();
      state = state.copyWith(
          incoming: incoming, outgoing: outgoing, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> sendRequest(String targetCustomerId) async {
    try {
      await _repo().sendFriendRequest(targetCustomerId);
      await loadRequests();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> acceptRequest(String friendshipId) async {
    try {
      await _repo().acceptRequest(friendshipId);
      await loadFriends();
      await loadRequests();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> declineRequest(String friendshipId) async {
    try {
      await _repo().declineRequest(friendshipId);
      await loadRequests();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> searchCustomers(String query) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final results = await _repo().searchCustomers(query);
      state = state.copyWith(searchResults: results, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final friendsProvider =
    StateNotifierProvider<FriendsNotifier, FriendsState>(
  (ref) => FriendsNotifier(ref),
);
