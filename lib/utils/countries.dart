import 'package:honorfx/models/country_model.dart';
import 'package:flutter/material.dart';

class Countries {
  static List<CountryModel> getCountries() {
    return [
      CountryModel(
        name: 'United States',
        code: 'US',
        phoneCode: '1',
        flag: '🇺🇸',
      ),
      CountryModel(
        name: 'United Kingdom',
        code: 'GB',
        phoneCode: '44',
        flag: '🇬🇧',
      ),
      CountryModel(name: 'India', code: 'IN', phoneCode: '91', flag: '🇮🇳'),
      CountryModel(
        name: 'United Arab Emirates',
        code: 'UAE',
        phoneCode: '971',
        flag: '🇦🇪',
      ),
      CountryModel(
        name: 'Australia',
        code: 'AU',
        phoneCode: '61',
        flag: '🇦🇺',
      ),
      CountryModel(name: 'Canada', code: 'CA', phoneCode: '1', flag: '🇨🇦'),
      CountryModel(
        name: 'Singapore',
        code: 'SG',
        phoneCode: '65',
        flag: '🇸🇬',
      ),
      CountryModel(name: 'Malaysia', code: 'MY', phoneCode: '60', flag: '🇲🇾'),
      CountryModel(name: 'China', code: 'CN', phoneCode: '86', flag: '🇨🇳'),
      CountryModel(name: 'Japan', code: 'JP', phoneCode: '81', flag: '🇯🇵'),
    ];
  }

  static CountryModel getDefaultCountry() {
    return getCountries().firstWhere((country) => country.code == 'US');
  }

  static CountryModel getCountryByCode(String code) {
    return getCountries().firstWhere(
      (country) => country.code == code,
      orElse: () => getDefaultCountry(),
    );
  }

  /// Get country from device settings and SIM card
  static Future<CountryModel> getDeviceCountry() async {
    try {
      final String? currentCountry =
          WidgetsBinding.instance.platformDispatcher.locale.countryCode;

      if (currentCountry != null && currentCountry.isNotEmpty) {
        return getCountryByCode(currentCountry);
      }

      return getDefaultCountry();
    } catch (e) {
      // Fallback to default country if any error occurs
      debugPrint('Error getting device country: $e');
      return getDefaultCountry();
    }
  }
}
