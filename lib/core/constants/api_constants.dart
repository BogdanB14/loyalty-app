class ApiConstants {
  // Change to your server IP/domain
  static const String baseUrl = 'http://10.0.2.2:8080/api'; // Android emulator
  // static const String baseUrl = 'http://localhost:8080/api'; // iOS simulator
  // static const String baseUrl = 'https://api.yourdomain.com/api'; // Production

  // Auth
  static const String login = '/auth/login';
  static const String googleLogin = '/auth/google';

  // Venues
  static const String venues = '/venues';
  static const String venueById = '/venues/{id}';

  // Receipts / Scan
  static const String scanReceipt = '/receipts/scan';

  // Points
  static const String userPoints = '/points/me';
  static const String sharePoints = '/points/share';

  // Rewards
  static const String rewards = '/rewards';
  static const String claimReward = '/rewards/claim';

  // Friends
  static const String friends = '/friends';
}