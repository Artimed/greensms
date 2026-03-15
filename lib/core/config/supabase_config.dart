abstract final class SupabaseConfig {
  static const String projectUrl = 'https://YOUR_PROJECT_ID.supabase.co';
  static const String anonKey = 'YOUR_SUPABASE_ANON_KEY';

  static const String activateEndpoint = '$projectUrl/functions/v1/activate';
  static const String fcmTokenEndpoint = '$projectUrl/functions/v1/fcm-token';
  static const String parserLatestEndpoint = '$projectUrl/functions/v1/parser/latest';
}
