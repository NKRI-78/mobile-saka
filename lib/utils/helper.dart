import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Helper {

  static String formatCurrency(double number, {bool useSymbol = true}) {
    final NumberFormat _fmt = NumberFormat.currency(locale: 'id', symbol: useSymbol ? 'Rp ' : '');
    String s = _fmt.format(number);
    String _format = s.toString().replaceAll(RegExp(r"([,]*00)(?!.*\d)"), "");
    return _format;
  }

  static String formatDate(DateTime dateTime) {
    initializeDateFormatting("id");
    return DateFormat.yMMMMEEEEd("id").format(dateTime);
  }

  static createUniqueId() {
    return DateTime.now().millisecondsSinceEpoch.remainder(100000);
  }

  static SharedPreferences? prefs;

  static Future initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

}

