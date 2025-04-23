import 'package:get/get.dart';
import 'package:honorfx/models/login_model.dart';

class DashboardController extends GetxController {
  Rx<TokenResponse?> tokenResponse = Rx<TokenResponse?>(null);

  // Convenience getter for the user's name
  String get userName {
    if (tokenResponse.value != null) {
      return tokenResponse.value!.name ?? "User";
    }
    return "User";
  }
}
