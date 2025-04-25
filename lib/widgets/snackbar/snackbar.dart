import 'package:flutter/material.dart';
import 'package:honorfx/utils/colors.dart';

SnackBar buildSnackBar({
  required String message,
  bool isError = false,
  Duration duration = const Duration(seconds: 3),
}) {
  return SnackBar(
    content: Text(
      message,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
    ),
    backgroundColor: isError ? Colors.red.shade700 : AppColors.primary,
    duration: duration,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  );
}
