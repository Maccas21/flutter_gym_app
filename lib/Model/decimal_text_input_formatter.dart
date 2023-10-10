import 'dart:math';
import 'package:flutter/services.dart';

// Original code from website below. modified and added comments
// https://stackoverflow.com/questions/60390078/allow-upto-3-decimal-points-value-in-flutter-inputtexttype-number-in-flutter
class DecimalTextInputFormatter extends TextInputFormatter {
  final int decimalRange;
  final int digitsRange;
  bool cursorAtEnd = false;

  DecimalTextInputFormatter({this.decimalRange = 3, this.digitsRange = 3});

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
      nValue = removeDuplicateDecimalPoint(oldValue.text, nValue);

      // check for numbers after decimal point
      if (nValue.split('.')[1].isEmpty) {
        nValue = '0.';

        cursorAtEnd = true;
      }
    } else if (nValue.contains('.')) {
      // checks the length after the decimal point matches decimalRange
      if (nValue.substring(nValue.indexOf('.') + 1).length > decimalRange) {
        nValue = oldValue.text;

        cursorAtEnd = true;
      } else {
        nValue = removeDuplicateDecimalPoint(oldValue.text, nValue);
      }
    }

    nValue = limitDigits(oldValue.text, nValue);

    if (cursorAtEnd) {
      nSelection = moveCursorToEnd(newValue.selection, nValue);
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

  // Checks for multiple decimal points and remove the last
  String removeDuplicateDecimalPoint(String oldVal, String newVal) {
    String returnVal = newVal;

    if (newVal.split('.').length > 2) {
      returnVal = oldVal;
      cursorAtEnd = true;
    }

    return returnVal;
  }

  String limitDigits(String oldVal, String newVal) {
    String returnVal = newVal;

    if (newVal.contains('.')) {
      if (newVal.split('.')[0].length > digitsRange ||
          newVal.split('.')[1].length > decimalRange) {
        returnVal = oldVal;
        cursorAtEnd = true;
      }
    } else {
      if (newVal.length > digitsRange) {
        returnVal = oldVal;
        cursorAtEnd = true;
      }
    }

    return returnVal;
  }
}
