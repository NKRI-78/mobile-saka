import 'package:intl/intl.dart';

class CurrencyHelper {
  static String formatCurrency(int number, {bool useSymbol = true}) {
    final NumberFormat fmt = NumberFormat.currency(locale: 'id', symbol: useSymbol ? 'Rp ' : '');
    String s = fmt.format(number);
    String f = s.toString().replaceAll(RegExp(r"([,]*00)(?!.*\d)"), "");
    return f;
  }
}