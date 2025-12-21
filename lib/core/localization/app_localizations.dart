import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static const supportedLocales = [
    Locale('en'),
    Locale('ar'),
  ];

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'app_name': 'SignGuard',
      'real_time_detection': 'Real-Time Detection',
      'learn_signs': 'Learn Traffic Signs',
      'settings': 'Settings',
      'server_url': 'Server URL',
      'capture_interval': 'Capture interval (seconds)',
      'test_connection': 'Test connection',
      'connection_ok': 'Connection successful',
      'connection_failed': 'Unable to reach server',
      'no_sign': 'No sign detected',
      'detection': 'Detection',
      'learn': 'Signs',
      'pronounce': 'Pronounce',
      'language': 'Language',
      'english': 'English',
      'arabic': 'Arabic',
      'first_sign_detected': 'First sign detected!',
      'retry': 'Retry',
      'stay_alert_follow_rules':
          'WARNING: Stay alert and follow traffic rules!',
      'server_unavailable': 'Cannot reach server (server error)',
    },
    'ar': {
      'app_name': 'ساين جارد',
      'real_time_detection': 'اكتشاف فوري',
      'learn_signs': 'تعلّم إشارات المرور',
      'settings': 'الإعدادات',
      'server_url': 'رابط الخادم',
      'capture_interval': 'فاصل الالتقاط (ثواني)',
      'test_connection': 'اختبار الاتصال',
      'connection_ok': 'تم الاتصال بنجاح',
      'connection_failed': 'تعذّر الوصول إلى الخادم',
      'no_sign': 'لا توجد إشارة',
      'detection': 'الاكتشاف',
      'learn': 'الإشارات',
      'pronounce': 'نطق',
      'language': 'اللغة',
      'english': 'الإنجليزية',
      'arabic': 'العربية',
      'first_sign_detected': 'تم اكتشاف أول إشارة!',
      'retry': 'إعادة المحاولة',
      'stay_alert_follow_rules': 'تحذير: ابق متيقظاً واتبع قواعد المرور!',
      'server_unavailable': 'لا يمكن الوصول إلى الخادم (خطأ في الخادم)',
    },
  };

  String _t(String key) {
    final lang = locale.languageCode;
    return _localizedValues[lang]?[key] ?? _localizedValues['en']![key] ?? key;
  }

  String get appName => _t('app_name');
  String get realTimeDetection => _t('real_time_detection');
  String get learnSigns => _t('learn_signs');
  String get settings => _t('settings');
  String get serverUrl => _t('server_url');
  String get captureInterval => _t('capture_interval');
  String get testConnection => _t('test_connection');
  String get connectionOk => _t('connection_ok');
  String get connectionFailed => _t('connection_failed');
  String get noSign => _t('no_sign');
  String get detection => _t('detection');
  String get learn => _t('learn');
  String get pronounce => _t('pronounce');
  String get language => _t('language');
  String get english => _t('english');
  String get arabic => _t('arabic');
  String get firstSignDetected => _t('first_sign_detected');
  String get retry => _t('retry');
  String get stayAlertFollowRules => _t('stay_alert_follow_rules');
  String get serverUnavailable => _t('server_unavailable');

  String formatSignDetected(String signName) {
    if (locale.languageCode == 'ar') {
      return 'تم اكتشاف إشارة $signName';
    }
    return '$signName detected';
  }

  String formatNumber(num value) {
    return NumberFormat('#0.0', locale.toLanguageTag()).format(value);
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) =>
      false;
}
