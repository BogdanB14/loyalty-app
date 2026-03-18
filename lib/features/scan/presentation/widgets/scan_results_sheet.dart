import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/receipt_models.dart';
import '../providers/receipt_provider.dart';

class ScanResultsSheet extends ConsumerStatefulWidget {
  final ParsedReceiptData receiptData;

  const ScanResultsSheet({super.key, required this.receiptData});

  @override
  ConsumerState<ScanResultsSheet> createState() => _ScanResultsSheetState();
}

class _ScanResultsSheetState extends ConsumerState<ScanResultsSheet> {
  @override
  void initState() {
    super.initState();
    ref.read(receiptProvider.notifier).reset();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(receiptProvider.notifier).claimReceipt(widget.receiptData);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(receiptProvider);

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          _buildContent(context, state),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, ReceiptState state) {
    switch (state.status) {
      case ReceiptClaimStatus.idle:
      case ReceiptClaimStatus.submitting:
        return _buildLoading(context);
      case ReceiptClaimStatus.success:
        return _buildSuccess(context, state.pointsEarned ?? 0);
      case ReceiptClaimStatus.error:
        return _buildError(context, state.errorMessage ?? 'Unknown error');
      case ReceiptClaimStatus.duplicate:
        return _buildDuplicate(context);
    }
  }

  Widget _buildLoading(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircularProgressIndicator(color: AppColors.accentGold),
        const SizedBox(height: 16),
        Text('Claiming receipt...',
            style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildSuccess(BuildContext context, int points) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: const BoxDecoration(
            color: Color.fromRGBO(255, 107, 53, 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(PhosphorIconsRegular.check,
              size: 40, color: AppColors.primary),
        ),
        const SizedBox(height: 16),
        Text('Receipt Claimed!',
            style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(
          '+$points pts',
          style: const TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: AppColors.secondary,
          ),
        ),
        const SizedBox(height: 8),
        TextButton.icon(
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Coming soon')),
          ),
          icon: Icon(PhosphorIconsRegular.usersThree, size: 18),
          label: const Text('Share points with friends'),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Done'),
          ),
        ),
      ],
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.error_outline, size: 64, color: AppColors.error),
        const SizedBox(height: 16),
        Text(
          message,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => ref
                .read(receiptProvider.notifier)
                .claimReceipt(widget.receiptData),
            child: const Text('Retry'),
          ),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    );
  }

  Widget _buildDuplicate(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.info_outline, size: 64, color: AppColors.textSecondary),
        const SizedBox(height: 16),
        Text(
          'This receipt was already claimed',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ),
      ],
    );
  }
}
