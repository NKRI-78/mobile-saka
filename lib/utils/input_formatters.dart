import 'package:flutter/services.dart';

class CapitalizeWordsInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // Capitalize the first letter and each letter after a space
    String newText = newValue.text.toLowerCase().split(' ').map((word) {
      if (word.isNotEmpty) {
        return word[0].toUpperCase() + word.substring(1);
      }
      return word;
    }).join(' ');

    return newValue.copyWith(
      text: newText,
      selection: newValue.selection,
    );
  }
}
