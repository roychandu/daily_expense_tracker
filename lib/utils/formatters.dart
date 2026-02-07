import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class AppFormatters {
  static String formatCurrency(
    double amount,
    String currencyCode,
    Locale locale,
  ) {
    final format = NumberFormat.simpleCurrency(
      locale: locale.toString(),
      name: currencyCode,
    );
    return format.format(amount);
  }

  static String formatDate(DateTime date, Locale locale) {
    // Standard formats based on locale
    // US: MM/dd/yyyy
    // EU: dd/MM/yyyy
    // Asia: yyyy/MM/dd

    String pattern;
    if (locale.languageCode == 'en' && locale.countryCode == 'US') {
      pattern = 'MM/dd/yyyy';
    } else if (['ja', 'zh', 'ko'].contains(locale.languageCode)) {
      pattern = 'yyyy/MM/dd';
    } else {
      pattern = 'dd/MM/yyyy';
    }

    return DateFormat(pattern, locale.toString()).format(date);
  }

  static String formatNumber(double number, Locale locale) {
    return NumberFormat.decimalPattern(locale.toString()).format(number);
  }
}
