import 'dart:math';
import 'package:flutter/services.dart';

// Original code from website below. mofidified slightly and added comments
// https://stackoverflow.com/questions/60390078/allow-upto-3-decimal-points-value-in-flutter-inputtexttype-number-in-flutter
class DecimalTextInputFormatter extends TextInputFormatter {
  final int decimalRange;

  DecimalTextInputFormatter({this.decimalRange = 3});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String nValue = newValue.text;
    TextSelection nSelection = newValue.selection;

    // regex pattern to filter for numbers and decimal only
    Pattern p = RegExp(r'(\d+\.?)|(\.?\d+)|(\.?)');
    nValue = p
        .allMatches(nValue)
        .map<String?>((Match match) => match.group(0))
        .join();

    // add zero in front if starting with decimal point
    if (nValue.startsWith('.')) {
      nValue = '0.';

      nSelection = moveCursorToEnd(newValue.selection, nValue);
    } else if (nValue.contains('.')) {
      // checks the length after the decimal point matches decimalRange
      if (nValue.substring(nValue.indexOf('.') + 1).length > decimalRange) {
        nValue = oldValue.text;

        nSelection = moveCursorToEnd(newValue.selection, nValue);
      } else {
        // checks for multiple decimal points and remove the last
        if (nValue.split('.').length > 2) {
          List<String> split = nValue.split('.');
          nValue = '${split[0]}.${split.getRange(1, split.length).join()}';

          nSelection = moveCursorToEnd(newValue.selection, nValue);
        }
      }
    }

    return TextEditingValue(
        text: nValue, selection: nSelection, composing: TextRange.empty);
  }

  // Move cursor to the end
  TextSelection moveCursorToEnd(TextSelection textSelect, String text) {
    return textSelect.copyWith(
      baseOffset: min(text.length, text.length + 1),
      extentOffset: min(text.length, text.length + 1),
    );
  }
}
