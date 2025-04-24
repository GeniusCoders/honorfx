import 'package:intl/intl.dart';

extension DateTimeExtension on String {
  /// Converts a string date from "yyyy-MM-dd HH:mm:ss" format to "dd MMM yyyy h:mm a" format
  /// Example: "2024-08-22 16:52:16" -> "22 Aug 2024 4:52 PM"
  String toFormattedDateTime() {
    try {
      // Try to parse the ISO date format
      final parsedDate = DateTime.parse(this);

      // Format the DateTime object to the desired format
      final DateFormat formatter = DateFormat('dd MMM yyyy h:mm a');
      return formatter.format(parsedDate);
    } catch (e) {
      // If parsing fails, try another common format (yyyy-MM-dd HH:mm:ss)
      try {
        final DateFormat inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
        final DateTime parsedDate = inputFormat.parse(this);

        final DateFormat outputFormat = DateFormat('dd MMM yyyy h:mm a');
        return outputFormat.format(parsedDate);
      } catch (e) {
        // Return the original string if parsing fails
        return this;
      }
    }
  }

  /// Converts a string date to date only format (without time)
  /// Example: "2024-08-22 16:52:16" -> "22 Aug 2024"
  String toFormattedDate() {
    try {
      // Try to parse the ISO date format
      final parsedDate = DateTime.parse(this);

      // Format the DateTime object to the desired format
      final DateFormat formatter = DateFormat('dd MMM yyyy');
      return formatter.format(parsedDate);
    } catch (e) {
      // If parsing fails, try another common format
      try {
        final DateFormat inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
        final DateTime parsedDate = inputFormat.parse(this);

        final DateFormat outputFormat = DateFormat('dd MMM yyyy');
        return outputFormat.format(parsedDate);
      } catch (e) {
        // Return the original string if parsing fails
        return this;
      }
    }
  }

  /// Converts a string date to time only format
  /// Example: "2024-08-22 16:52:16" -> "4:52 PM"
  String toFormattedTime() {
    try {
      // Try to parse the ISO date format
      final parsedDate = DateTime.parse(this);

      // Format the DateTime object to the desired format
      final DateFormat formatter = DateFormat('h:mm a');
      return formatter.format(parsedDate);
    } catch (e) {
      // If parsing fails, try another common format
      try {
        final DateFormat inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
        final DateTime parsedDate = inputFormat.parse(this);

        final DateFormat outputFormat = DateFormat('h:mm a');
        return outputFormat.format(parsedDate);
      } catch (e) {
        // Return the original string if parsing fails
        return this;
      }
    }
  }
}
