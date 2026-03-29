import 'package:shared_preferences/shared_preferences.dart';

class DraftService {
  static Future<void> saveDraft(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('draft_$key', value);
  }

  static Future<String?> getDraft(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('draft_$key');
  }

  static Future<void> clearDrafts() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('draft_title');
    await prefs.remove('draft_desc');
  }
}