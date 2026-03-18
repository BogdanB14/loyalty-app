import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../../domain/entities/friend_entity.dart';
import '../providers/friends_provider.dart';

class FriendsScreen extends ConsumerStatefulWidget {
  const FriendsScreen({super.key});

  @override
  ConsumerState<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends ConsumerState<FriendsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    Future.microtask(() {
      ref.read(friendsProvider.notifier).loadFriends();
      ref.read(friendsProvider.notifier).loadRequests();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      ref.read(friendsProvider.notifier).searchCustomers(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(friendsProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/profile'),
        ),
        title: const Text('Friends'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Friends'),
            Tab(text: 'Requests'),
            Tab(text: 'Search'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFriendsTab(context, state),
          _buildRequestsTab(context, state),
          _buildSearchTab(context, state),
        ],
      ),
    );
  }

  // ── Tab 1: Accepted friends ──────────────────────────────────────────────

  Widget _buildFriendsTab(BuildContext context, FriendsState state) {
    if (state.isLoading && state.accepted.isEmpty) return const LoadingWidget();
    if (state.error != null && state.accepted.isEmpty) {
      return AppErrorWidget(
        message: 'Failed to load friends',
        onRetry: () => ref.read(friendsProvider.notifier).loadFriends(),
      );
    }
    if (state.accepted.isEmpty) {
      return const Center(child: Text('No friends yet'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.accepted.length,
      itemBuilder: (_, i) => _FriendTile(friend: state.accepted[i]),
    );
  }

  // ── Tab 2: Incoming + outgoing requests ─────────────────────────────────

  Widget _buildRequestsTab(BuildContext context, FriendsState state) {
    if (state.isLoading && state.incoming.isEmpty && state.outgoing.isEmpty) {
      return const LoadingWidget();
    }
    if (state.error != null &&
        state.incoming.isEmpty &&
        state.outgoing.isEmpty) {
      return AppErrorWidget(
        message: 'Failed to load requests',
        onRetry: () => ref.read(friendsProvider.notifier).loadRequests(),
      );
    }
    if (state.incoming.isEmpty && state.outgoing.isEmpty) {
      return const Center(child: Text('No pending requests'));
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (state.incoming.isNotEmpty) ...[
          Text('Incoming', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          for (final f in state.incoming)
            _RequestTile(
              friend: f,
              onAccept: () =>
                  ref.read(friendsProvider.notifier).acceptRequest(f.id),
              onDecline: () =>
                  ref.read(friendsProvider.notifier).declineRequest(f.id),
            ),
          const SizedBox(height: 16),
        ],
        if (state.outgoing.isNotEmpty) ...[
          Text('Sent', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          for (final f in state.outgoing)
            _OutgoingTile(friend: f),
        ],
      ],
    );
  }

  // ── Tab 3: Search ────────────────────────────────────────────────────────

  Widget _buildSearchTab(BuildContext context, FriendsState state) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: TextField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Search by username...',
              prefixIcon: Icon(PhosphorIconsRegular.magnifyingGlass),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(child: _buildSearchResults(context, state)),
      ],
    );
  }

  Widget _buildSearchResults(BuildContext context, FriendsState state) {
    if (state.isLoading && _searchController.text.isNotEmpty) {
      return const LoadingWidget();
    }
    if (state.error != null && _searchController.text.isNotEmpty) {
      return AppErrorWidget(
        message: 'Search failed',
        onRetry: () => ref
            .read(friendsProvider.notifier)
            .searchCustomers(_searchController.text),
      );
    }
    if (_searchController.text.isEmpty) {
      return const Center(child: Text('Type to search for people'));
    }
    if (state.searchResults.isEmpty) {
      return const Center(child: Text('No results found'));
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: state.searchResults.length,
      itemBuilder: (_, i) {
        final result = state.searchResults[i];
        return _SearchResultTile(
          friend: result,
          onAdd: () => ref
              .read(friendsProvider.notifier)
              .sendRequest(result.otherCustomerId),
        );
      },
    );
  }
}

// ── Tile widgets ─────────────────────────────────────────────────────────────

class _FriendTile extends StatelessWidget {
  final FriendEntity friend;
  const _FriendTile({required this.friend});

  @override
  Widget build(BuildContext context) {
    final name = friend.otherDisplayName.isNotEmpty
        ? friend.otherDisplayName
        : friend.otherUsername;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Color.fromRGBO(255, 107, 53, 0.2),
          child: Text(
            name.isNotEmpty ? name[0].toUpperCase() : '?',
            style: const TextStyle(
                color: AppColors.primary, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(name),
        subtitle: Text('@${friend.otherUsername}'),
        trailing: TextButton(
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Coming soon')),
          ),
          child: const Text('Share'),
        ),
      ),
    );
  }
}

class _RequestTile extends StatelessWidget {
  final FriendEntity friend;
  final VoidCallback onAccept;
  final VoidCallback onDecline;
  const _RequestTile(
      {required this.friend,
      required this.onAccept,
      required this.onDecline});

  @override
  Widget build(BuildContext context) {
    final name = friend.otherDisplayName.isNotEmpty
        ? friend.otherDisplayName
        : friend.otherUsername;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Color.fromRGBO(255, 107, 53, 0.2),
          child: Text(
            name.isNotEmpty ? name[0].toUpperCase() : '?',
            style: const TextStyle(
                color: AppColors.primary, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(name),
        subtitle: Text('@${friend.otherUsername}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: onAccept,
              child: const Text('Accept'),
            ),
            TextButton(
              onPressed: onDecline,
              style: TextButton.styleFrom(
                  foregroundColor: AppColors.textSecondary),
              child: const Text('Decline'),
            ),
          ],
        ),
      ),
    );
  }
}

class _OutgoingTile extends StatelessWidget {
  final FriendEntity friend;
  const _OutgoingTile({required this.friend});

  @override
  Widget build(BuildContext context) {
    final name = friend.otherDisplayName.isNotEmpty
        ? friend.otherDisplayName
        : friend.otherUsername;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Color.fromRGBO(255, 107, 53, 0.1),
          child: Text(
            name.isNotEmpty ? name[0].toUpperCase() : '?',
            style: const TextStyle(color: AppColors.textSecondary),
          ),
        ),
        title: Text(name),
        subtitle: Text('@${friend.otherUsername}'),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.backgroundTertiary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text('Pending',
              style: TextStyle(
                  fontSize: 12, color: AppColors.textSecondary)),
        ),
      ),
    );
  }
}

class _SearchResultTile extends StatelessWidget {
  final FriendEntity friend;
  final VoidCallback onAdd;
  const _SearchResultTile({required this.friend, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final name = friend.otherDisplayName.isNotEmpty
        ? friend.otherDisplayName
        : friend.otherUsername;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Color.fromRGBO(255, 107, 53, 0.2),
          child: Text(
            name.isNotEmpty ? name[0].toUpperCase() : '?',
            style: const TextStyle(
                color: AppColors.primary, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(name),
        subtitle: Text('@${friend.otherUsername}'),
        trailing: IconButton(
          icon: Icon(PhosphorIconsRegular.userPlus,
              color: AppColors.primary),
          onPressed: onAdd,
          tooltip: 'Add friend',
        ),
      ),
    );
  }
}
