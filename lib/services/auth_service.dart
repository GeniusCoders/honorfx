import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@injectable
class AuthService {
  final SharedPreferences _prefs;

  AuthService(this._prefs);

  Future<bool> isLoggedIn() async {
    final token = _prefs.getString('token');
    return token != null;
  }

  Future<void> logout() async {
    await _prefs.remove('token');
  }
}
