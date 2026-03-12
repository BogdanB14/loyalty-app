class Validators {
  static String? email(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!regex.hasMatch(value)) return 'Invalid email';
    return null;
  }

  static String? required(String? value, [String field = 'Field']) {
    if (value == null || value.isEmpty) return '$field is required';
    return null;
  }
}
