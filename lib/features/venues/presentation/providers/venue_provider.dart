import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/venue_entity.dart';
import '../../data/datasources/venue_remote_datasource.dart';
import '../../../../core/network/api_client.dart';

class VenueState {
  final List<VenueEntity> venues;
  final bool isLoading;
  final String? error;
  final String searchQuery;

  const VenueState({
    this.venues = const [],
    this.isLoading = false,
    this.error,
    this.searchQuery = '',
  });

  VenueState copyWith({
    List<VenueEntity>? venues,
    bool? isLoading,
    String? error,
    String? searchQuery,
  }) {
    return VenueState(
      venues: venues ?? this.venues,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class VenueNotifier extends StateNotifier<VenueState> {
  final Ref _ref;

  VenueNotifier(this._ref) : super(const VenueState()) {
    loadVenues();
  }

  Future<void> loadVenues() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final ds = VenueRemoteDataSourceImpl(_ref.read(dioProvider));
      final venues = await ds.getVenues();
      state = state.copyWith(venues: venues, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> searchVenues(String query) async {
    if (query.isEmpty) {
      loadVenues();
      return;
    }
    state = state.copyWith(isLoading: true, error: null, searchQuery: query);
    try {
      final ds = VenueRemoteDataSourceImpl(_ref.read(dioProvider));
      final venues = await ds.searchVenues(query);
      state = state.copyWith(venues: venues, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final venueProvider = StateNotifierProvider<VenueNotifier, VenueState>(
  (ref) => VenueNotifier(ref),
);
