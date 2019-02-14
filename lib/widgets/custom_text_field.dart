import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final bool enabled;
  final EdgeInsets padding;
  final String label;
  final String hintText;
  final String errorText;
  final TextInputType keyboardType;
  final Function(String) onChanged;
  final List<TextInputFormatter> inputFormatters;
  final bool obscureText;

  const CustomTextField({
    Key key,
    this.controller,
    this.padding,
    this.label,
    this.hintText,
    this.errorText,
    this.onChanged,
    this.obscureText,
    this.inputFormatters = const [],
    this.enabled = true,
    this.keyboardType,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  TextTheme textTheme;
  @override
  Widget build(BuildContext context) {
    if (textTheme == null) textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: widget.padding ??
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextField(
        enabled: widget.enabled,
        controller: widget.controller,
        onChanged: widget.onChanged,
        keyboardType: widget.keyboardType,
        inputFormatters: widget.inputFormatters,
        textInputAction: TextInputAction.done,
        obscureText: widget.obscureText != null ? true : false,
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.hintText,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
          border: OutlineInputBorder(
            borderSide: BorderSide(),
            borderRadius: BorderRadius.circular(20.0),
          ),
          errorText: widget.errorText,
          filled: true,
          fillColor: Colors.white,
        ),
        style: textTheme.body2.copyWith(
          fontSize: 18.0,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }
}
