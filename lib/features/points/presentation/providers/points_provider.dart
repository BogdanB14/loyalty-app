import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/loyalty_card_entity.dart';
import '../../data/datasources/points_remote_datasource.dart';
import '../../../../core/network/api_client.dart';

class PointsState {
  final List<LoyaltyCardEntity> cards;
  final bool isLoading;
  final String? error;

  const PointsState({
    this.cards = const [],
    this.isLoading = false,
    this.error,
  });

  PointsState copyWith({
    List<LoyaltyCardEntity>? cards,
    bool? isLoading,
    String? error,
  }) {
    return PointsState(
      cards: cards ?? this.cards,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  int get totalPoints => cards.fold(0, (sum, c) => sum + c.balance);
}

class PointsNotifier extends StateNotifier<PointsState> {
  final Ref _ref;
  PointsNotifier(this._ref) : super(const PointsState()) {
    loadPoints();
  }

  Future<void> loadPoints() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final ds = PointsRemoteDataSourceImpl(_ref.read(dioProvider));
      final cards = await ds.getPointsPerVenue();
      state = state.copyWith(cards: cards, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final pointsProvider = StateNotifierProvider<PointsNotifier, PointsState>(
  (ref) => PointsNotifier(ref),
);
