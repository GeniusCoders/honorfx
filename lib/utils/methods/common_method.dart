import 'package:url_launcher/url_launcher.dart';

class CommonMethod {
  static onUrl(String url, {String? fallbackUrl}) async {
    try {
      bool launched = await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        await launchUrl(
          Uri.parse(fallbackUrl ?? url),
          mode: LaunchMode.externalApplication,
        );
      }
    } catch (e) {
      await launchUrl(
        Uri.parse(fallbackUrl ?? url),
        mode: LaunchMode.externalApplication,
      );
    }
  }
}
