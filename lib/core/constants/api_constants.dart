class ApiConstants {
  static const String baseUrl = 'http://10.0.2.2:8080/api'; // Android emulator
  // static const String baseUrl = 'http://localhost:8080/api'; // iOS simulator

  // Auth — /v1/auth/*
  static const String customerLogin = '/v1/auth/customer/login';
  static const String googleLogin   = '/v1/auth/google';
  static const String staffLogin    = '/v1/auth/staff/login';

  // Customer — /v1/customer/*
  static const String customerMe       = '/v1/customer/me';
  static const String pointsPerVenue   = '/v1/customer/points-per-venue';

  // Customer Redemption
  // Usage: '/v1/customer/redemptions/venues/$venueId/create'
  static const String redemptionBase   = '/v1/customer/redemptions/venues';
  static const String redemptionSuffix = '/create';

  // Customer Venues — /v1/customer/venues/*
  static const String customerVenues       = '/v1/customer/venues';
  static const String customerVenueSearch  = '/v1/customer/venues/search';
  // Usage: '/v1/customer/venues/$venueId/rewards'
  static const String venueRewardsSuffix   = '/rewards';

  // Receipt Claim — NOTE: no /v1 in this path
  static const String receiptClaim = '/customer/receipts/claim';

  // Friends — /v1/customer/me/friends/*
  static const String friendsAccepted        = '/v1/customer/me/friends/accepted';
  static const String friendsRequests        = '/v1/customer/me/friends/requests';
  static const String friendsSearch          = '/v1/customer/me/friends/search';
  // Usage: '/v1/customer/me/friends/requests/$friendshipId/accept'
  // Usage: '/v1/customer/me/friends/requests/$friendshipId/cancel'
  // Usage: '/v1/customer/me/friends/requests/$friendshipId/decline'
  static const String friendsRequestsIncoming = '/v1/customer/me/friends/requests/incoming';
  static const String friendsRequestsOutgoing = '/v1/customer/me/friends/requests/outgoing';
}
