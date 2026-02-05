import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Application configuration loaded from environment variables
class AppConfig {
  /// Get the API server URL from environment variables
  /// Defaults to 'http://127.0.0.1:8000' if not set
  static String get apiServerUrl {
    return dotenv.env['API_SERVER_URL'] ?? 'http://127.0.0.1:8000';
  }
}
