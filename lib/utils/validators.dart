class Validators {
  static String? requiredText(String? value, {String message = 'Required'}) {
    if (value == null || value.trim().isEmpty) return message;
    return null;
  }

  static String? email(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return 'Email is required';
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(trimmed)) return 'Enter a valid email';
    return null;
  }

  static String? phone(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return 'Phone is required';
    final phoneRegex = RegExp(r'^[+0-9][0-9\s-]{6,}$');
    if (!phoneRegex.hasMatch(trimmed)) return 'Enter a valid phone number';
    return null;
  }
}
