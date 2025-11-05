import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Helper {

  static String formatCurrency(int number, {bool useSymbol = true}) {
    final NumberFormat numberFormat = NumberFormat.currency(locale: 'id', symbol: useSymbol ? 'Rp ' : '');
    String val = numberFormat.format(number);
    String format = val.toString().replaceAll(RegExp(r"([,]*00)(?!.*\d)"), "");
    return format;
  }

  static String gramsToKilograms(double grams) {
    return "${grams / 1000} Kg";
  }

  static String censorName(String name) {
    if (name.length <= 2) {
      return name;
    }

    String start = name.substring(0, 2);
    String end = name.substring(name.length - 1);
    
    String censoredPart = '*' * (name.length - 3);

    return start + censoredPart + end;
  }

  static String formatDate(DateTime dateTime) {
    initializeDateFormatting("id");
    return DateFormat("EEEE, d MMMM yyyy HH:mm", "id").format(dateTime);
  }

  static createUniqueId() {
    return DateTime.now().millisecondsSinceEpoch.remainder(100000);
  }

  static SharedPreferences? prefs;

  static Future initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

}