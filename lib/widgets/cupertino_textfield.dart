import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CupertinoTextField extends StatelessWidget {
  final String title;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final bool enabled;
  final bool isTextFormField;
  final String hintText;
  final EdgeInsets margin;
  final Function onChanged;
  final Function onSubmitted;
  final Function(String) onValidate;

  CupertinoTextField(
    this.title, {
    this.controller,
    this.obscureText: false,
    this.keyboardType: TextInputType.text,
    this.onChanged,
    this.onSubmitted,
    this.enabled: true,
    this.isTextFormField: false,
    this.onValidate,
    this.hintText,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final color = enabled ? Colors.black : Colors.grey;
    return Container(
      margin: margin ?? EdgeInsets.all(0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            this.title,
            style: TextStyle(
              fontSize: 24.0,
              color: color,
            ),
          ),
          SizedBox(width: 10.0),
          Flexible(
            child: Material(
              child: isTextFormField
                  ? TextFormField(
                      validator: (text) => this.onValidate?.call(text),
                      controller: this.controller,
                      obscureText: this.obscureText,
                      keyboardType: this.keyboardType,
                      enabled: this.enabled,
                      decoration: InputDecoration.collapsed(
                        hintText: this.hintText,
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.w300,
                        color: color,
                      ),
                    )
                  : TextField(
                      onChanged: (text) => this.onChanged?.call(),
                      onSubmitted: (text) => this.onSubmitted?.call(),
                      controller: this.controller,
                      obscureText: this.obscureText,
                      keyboardType: this.keyboardType,
                      enabled: this.enabled,
                      decoration: InputDecoration.collapsed(
                        hintText: this.title,
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.w300,
                        color: color,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
