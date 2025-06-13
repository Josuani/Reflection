class Constants {
  // Sentry
  static const String sentryDsn = 'TU_DSN_DE_SENTRY'; // Reemplazar con tu DSN de Sentry
  static const String environment = 'development';
  static const String appVersion = '1.0.0';

  // Firebase
  static const String currentUserId = 'local_user'; // Temporal, reemplazar con el ID real del usuario

  // Storage
  static const int maxFileSize = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedImageTypes = ['image/jpeg', 'image/png', 'image/gif'];
  static const int maxImageWidth = 1920;
  static const int maxImageHeight = 1080;
  static const int imageQuality = 85;

  // User Profile
  static const int maxDisplayNameLength = 50;
  static const int maxDescriptionLength = 500;
  static const int xpPerLevel = 100;

  // Sync
  static const Duration syncInterval = Duration(minutes: 15);
  static const int maxRetryAttempts = 3;
  static const Duration retryDelay = Duration(seconds: 5);
} 