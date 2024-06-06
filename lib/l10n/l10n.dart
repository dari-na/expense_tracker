import 'dart:ui';

class L10n {
  static final all = [
    const Locale('en'),
    const Locale('bg'),
  ];

  static String getFlag(String code) {
    switch (code) {
      case 'bg':
        return '🇧🇬';
      case 'en':
      default:
        return '🇬🇧';
    }
  }
}
