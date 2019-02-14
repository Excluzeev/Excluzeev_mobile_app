import 'package:flutter/services.dart';

class LowerCaseFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;
    return newValue.copyWith(
      text: text.toLowerCase(),
    );
  }
}
