Two tasks:

1. Wire friends_screen.dart to FriendsProvider (built in Prompt 3):
   - Replace all mock friend objects with data from provider.
   - Show accepted friends list.
   - Add a tab or section for incoming/outgoing friend requests.
   - Add a search bar that calls provider.searchCustomers(query) with 400ms debounce.
   - "Add friend" button on search results → provider.sendRequest(id).
   - Accept/Decline buttons on incoming requests.
   - Show LoadingWidget, AppErrorWidget with retry, empty state as needed.
   - Share button remains SnackBar('Coming soon') — bill splitting is a future feature.

2. Build the receipt submission data layer in scan feature:
   lib/features/scan/data/datasources/receipt_remote_datasource.dart
   - claimReceipt({venueId, pib, qrRaw, issuedAt, amount, currency, externalReceiptId})
     → POST /api/customer/receipts/claim (NOTE: no /v1 in this path)
     Returns: {receiptId, claimId, status, pointsEarned}

   lib/features/scan/data/repositories/receipt_repository_impl.dart
   lib/features/scan/presentation/providers/receipt_provider.dart
   - State: idle / submitting / success(pointsEarned) / error(message)
   - claimReceipt(parsedQrData) method

   Then wire scan_results_sheet.dart:
   - When the sheet opens, automatically call provider.claimReceipt() with
     the already-parsed QR fields (venueId, pib, qrRaw, issuedAt, amount, currency,
     externalReceiptId).
   - Show loading state while submitting.
   - On success: show pointsEarned prominently (e.g. "+X points earned!").
   - On error: show the backend error message with a retry button.
   - On 409 (DuplicateReceiptException): show "This receipt was already claimed"
     message — do not show retry.
   - Share points button stays SnackBar('Coming soon').