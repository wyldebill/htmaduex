import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const String _loginTimestampKey = 'login_timestamp_ms';
  static const Duration _sessionDuration = Duration(days: 30);

  Future<void> saveLoginTime() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
      _loginTimestampKey,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  Future<bool> isSessionValid() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? timestampMs = prefs.getInt(_loginTimestampKey);
    if (timestampMs == null) return false;
    final DateTime loginTime =
        DateTime.fromMillisecondsSinceEpoch(timestampMs);
    return DateTime.now().difference(loginTime) < _sessionDuration;
  }

  Future<void> clearSession() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_loginTimestampKey);
  }
}
