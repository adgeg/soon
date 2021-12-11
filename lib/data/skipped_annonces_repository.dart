import 'package:shared_preferences/shared_preferences.dart';
import 'package:soon/core/annonce.dart';

const String _key = "skipped";

class SkippedAnnoncesRepository {
  static late SharedPreferences _preferences;

  static void setPreferences(SharedPreferences preferences) => _preferences = preferences;

  static void skipAnnonce(Annonce annonce) {
    _preferences.setStringList("skipped", skippedAnnoncesUrl()..add(annonce.url));
  }

  static List<String> skippedAnnoncesUrl() {
    final urls = _preferences.getStringList(_key);
    return urls ?? [];
  }
}
