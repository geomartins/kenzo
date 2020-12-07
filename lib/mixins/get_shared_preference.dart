import 'package:shared_preferences/shared_preferences.dart';

class GetSharedPreference {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  void setActive(String value) {
    _prefs.then((SharedPreferences prefs) {
      prefs.setString('active_page', value);
    });
  }

  Future<String> getActive() async {
    String result = '';
    final prefs = await _prefs;
    result = prefs.getString('active_page');
    return result;
  }
}
