import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:honorfx/utils/colors.dart';

class SnackBars {
  static SnackBar errorSnackBar({required String title}) {
    return SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(title, style: const TextStyle(color: AppColors.white)),
          ),
          const Icon(Icons.error, color: AppColors.white),
        ],
      ),
      duration: const Duration(milliseconds: 1500),
      backgroundColor: Colors.red,
    );
  }

  static SnackBar noInternetSnackBar({
    required Function onRefresh,
    String title = 'No Internet Connection',
  }) {
    return SnackBar(
      content: Text(title, style: const TextStyle(fontSize: 14)),
      action: SnackBarAction(
        textColor: AppColors.primary,
        label: 'RETRY',
        onPressed: onRefresh as void Function(),
      ),
      backgroundColor: AppColors.black,
      duration: const Duration(seconds: 100),
    );
  }

  static SnackBar commonSnackBar({required String title}) {
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(
        title,
        style: const TextStyle(fontSize: 14, color: AppColors.white),
      ),
      backgroundColor: AppColors.black,
      duration: const Duration(milliseconds: 800),
    );
  }

  static SnackBar successSnackBar({required String title}) {
    return SnackBar(
      duration: const Duration(milliseconds: 2000),
      behavior: SnackBarBehavior.floating,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(title, style: const TextStyle(color: AppColors.white)),
          ),
          const Icon(Icons.check_circle, color: AppColors.white),
        ],
      ),
      backgroundColor: Colors.green,
    );
  }

  static toast({required String str}) {
    Fluttertoast.showToast(
      msg: str,
      timeInSecForIosWeb: 4,
      backgroundColor: Colors.black,
      textColor: AppColors.white,
    );
  }
}
