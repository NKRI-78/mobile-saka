import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo {
  final SharedPreferences sp;
  AuthRepo({required this.sp});

  String? getUserfullname() {
    return sp.getString("fullname");
  }

  Future<void> saveUserAvatar(String avatar) async {
    await sp.setString("avatar", avatar);
  }

  String? getUserAvatar() {
    return sp.getString("avatar");
  }

  String? getUserToken() {
    return sp.getString("token")!;
  }

  String? getUserPhoneNumber() {
    return sp.getString("phoneNumber");
  }

  String? getUserId() {
    return sp.getString("userId");
  }

  String? getUserEmail() {
    return sp.getString("emailAddress");
  }

  bool isLoggedIn() {
    return sp.containsKey("token");
  }
}