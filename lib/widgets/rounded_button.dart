import 'package:flutter/material.dart';
import 'package:trenstop/misc/palette.dart';

class ButtonColor {
  Color color;
  LinearGradient gradient;

  ButtonColor.fillColor(this.color);
  ButtonColor.fillGradient(this.gradient);
}

class RoundedButton extends StatelessWidget {
  final Widget child;
  final String text;
  final Function onPressed;
  final bool maxLength;
  final bool enabled;
  final ButtonColor buttonColor;
  final double fontSize;
  final Color textColor;
  final bool margin;
  final bool showShadow;

  RoundedButton({
    this.child,
    this.text,
    this.onPressed,
    this.maxLength: true,
    this.enabled: true,
    this.margin: true,
    this.buttonColor,
    this.textColor,
    this.fontSize,
    this.showShadow: true,
  });

  // Returns the button color or transparent if the button is a gradient
  Color get color {
    if (isEnabled) {
      if (buttonColor != null && buttonColor.color != null) {
        return buttonColor.color;
      } else if (buttonColor != null &&
          buttonColor.color == null &&
          buttonColor.gradient != null) {
        return Colors.transparent;
      } else {
        return Palette.primary;
      }
    } else {
      return Palette.disabled;
    }
  }

  bool get isEnabled => this.enabled && this.onPressed != null;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      clipBehavior: Clip.antiAlias,
      shape: StadiumBorder(),
      fillColor: isEnabled ? this.color : Palette.disabled,
      onPressed: this.onPressed,
      elevation: isEnabled && this.showShadow ? 4.0 : 0.0,
      child: Container(
        margin: null,
        padding: margin
            ? EdgeInsets.symmetric(horizontal: 32.0, vertical: 10.0)
            : null,
        decoration: BoxDecoration(
          gradient: buttonColor != null && buttonColor.gradient != null
              ? buttonColor.gradient
              : null,
        ),
        child: text != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize:
                    this.maxLength ? MainAxisSize.max : MainAxisSize.min,
                children: <Widget>[
                  Text(
                    this.text,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.button.copyWith(
                          color: this.textColor ?? Colors.white,
                          fontSize: this.fontSize ?? 14.0,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              )
            : child,
      ),
    );
  }
}

class SelectableRoundedButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  final bool maxLength;
  final bool enabled;
  final bool margin;
  final double fontSize;

  final bool isSelected;
  final ButtonColor selectedColor;
  final ButtonColor unselectedColor;
  final Color selectedTextColor;
  final Color unselectedTextColor;

  const SelectableRoundedButton(
      {@required this.text,
      @required this.isSelected,
      @required this.selectedColor,
      @required this.selectedTextColor,
      this.unselectedColor,
      this.unselectedTextColor,
      this.onPressed,
      this.maxLength: true,
      this.enabled: true,
      this.margin: true,
      this.fontSize})
      : assert(text != null);

  @override
  Widget build(BuildContext context) => isSelected != null && isSelected
      ? RoundedButton(
          text: text,
          onPressed: onPressed,
          maxLength: maxLength,
          margin: margin,
          buttonColor: selectedColor,
          textColor: selectedTextColor,
          enabled: enabled,
          fontSize: fontSize,
        )
      : RoundedButton(
          text: text,
          onPressed: onPressed,
          maxLength: maxLength,
          margin: margin,
          buttonColor: unselectedColor,
          textColor: unselectedTextColor ?? selectedTextColor,
          enabled: enabled,
          fontSize: fontSize,
        );
}
