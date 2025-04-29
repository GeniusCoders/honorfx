import 'package:get/get.dart';
import 'package:honorfx/models/dashboard/account_details_response.dart';
import 'package:honorfx/models/dashboard/account_listing_type_model.dart';
import 'package:honorfx/models/login_model.dart';

class DashboardController extends GetxController {
  Rx<TokenResponse?> tokenResponse = Rx<TokenResponse?>(null);

  // Account data that should persist
  RxList<AccountListingTypeData> accounts = <AccountListingTypeData>[].obs;
  Rx<AccountDetailsData?> accountBalanceDetails = Rx<AccountDetailsData?>(null);
  RxInt selectedAccountIndex = 0.obs;

  // Navigation index
  RxInt selectedIndex = 0.obs;

  // Convenience getter for the user's name
  String get userName {
    if (tokenResponse.value != null) {
      return tokenResponse.value!.name ?? "User";
    }
    return "User";
  }

  // Methods to update stored data
  void updateAccounts(
    List<AccountListingTypeData> newAccounts, {
    int? newSelectedIndex,
  }) {
    accounts.value = newAccounts;
    if (newSelectedIndex != null) {
      selectedAccountIndex.value = newSelectedIndex;
    }
  }

  void updateAccountDetails(AccountDetailsData details) {
    accountBalanceDetails.value = details;
  }

  // Method to update navigation index
  void updateSelectedIndex(int index) {
    selectedIndex.value = index;
  }
}
